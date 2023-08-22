import fs from 'fs'
import Web3 from 'web3'
import web3_contract from 'web3-eth-contract'
import net from 'net'
import * as ethjs_tx from 'ethereumjs-tx'
import _EthCommon from 'ethereumjs-common'
const EthCommon = _EthCommon.default
//import ethjs_tx from 'ethereumjs-tx'
//const { Tx } = ethjs_tx
const { Contract, ContractSendMethod, Options } = web3_contract
//import HDWalletProvider from "truffle-hdwallet-provider"
//import { Contract, ContractSendMethod, Options } from 'web3-eth-contract'

/**
 * Deploy the given contract
 * @param {string} contractName name of the contract to deploy
 * @param {Array<any>} args list of constructor' parameters
 * @param {string} from account used to send the transaction
 * @param {number} gas gas limit
 * @return {Options} deployed contract
 */
export const deploy = async (contractName, args, url, from, gas) => {
  console.log('deploying', contractName, 'with args', args, 'from', from, 'gas', gas)

  const customCommon = EthCommon.forCustomChain(
    'mainnet',
    {
      name: 'optimism',
      networkId: 42069,
      chainId: 42069,
      url: url
    },
    'petersburg');

  // if url starts with http, use http provider else use ipc provider
  var web3
  if (url.startsWith('http')) {
    web3 = new Web3(new Web3.providers.HttpProvider(url))
  } else {
    web3 = new Web3(new Web3.providers.IpcProvider(url, net))
  }
  console.log(`deploying ${contractName}`)

  // Load contract from builds folder using grep to find the right file with contract name
  const abiPath = fs.readdirSync('./builds').filter(file => file.match(new RegExp(`${contractName}_sol_${contractName}.abi`)))

  //const abiPath = `./builds/contracts_${contractName}_sol_${contractName}.abi`
  const abi = JSON.parse(fs.readFileSync("./builds/" + abiPath[0], 'utf8'))
  //const bytecodePath = `./builds/contracts_${contractName}_sol_${contractName}.bin`
  const bytecodePath = fs.readdirSync('./builds').filter(file => file.match(new RegExp(`${contractName}_sol_${contractName}.bin`)))
  const bytecode = fs.readFileSync("./builds/" + bytecodePath[0], 'utf8')
  console.log('bytecode', bytecode)

  const contract = new web3.eth.Contract(abi)
  console.log('contract', contract)
  const accounts = []
  //const accounts = await web3.eth.getAccounts()
  console.log('accounts', accounts)

  const contractSend = contract.deploy({
    data: bytecode,
    arguments: args
  })

  var txInfo = {
    from: from || accounts[0],
    gas: gas || 1000000,
    gasPrice: 100000,
    data: contractSend.encodeABI(),
    chainId: 42069
  }
  console.log(txInfo)

  const fromHexString = (hexString) => Uint8Array.from(hexString.match(/.{1,2}/g).map((byte) => parseInt(byte, 16)));

  console.log("Signed tx w/ private key ", process.env.PRIVATE_KEY)
  let tx = new ethjs_tx.Transaction(txInfo, { common: customCommon });
  tx.sign(fromHexString(process.env.PRIVATE_KEY))
  let serializedTx = tx.serialize()
  console.log("Serialized tx ", serializedTx.toString('hex'))

  let receipt = null
  //web3.eth.sendTransaction(tx.toJSON(), function(err, hash) {
  //  console.log('sendSignedTransaction', err, hash)
  //})
  await web3.eth.sendSignedTransaction('0x' + serializedTx.toString('hex'), function(err, hash) {
    console.log('sendSignedTransaction', err, hash)
    if (err) {
      console.log(err)
      return
    }

    console.log('hash', hash)

    while (receipt == null) {
      console.log('waiting for receipt')
      receipt = web3.eth.getTransactionReceipt(hash)

      sleep(1000).wait()
//      Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, 1000);
    }
    console.log('receipt', receipt)
  })

  //web3.eth.accounts.signTransaction(tx, '0x' + process.env.PRIVATE_KEY).then(signed => {
  //  web3.eth.sendSignedTransaction(signed.rawTransaction).on('receipt', console.log).error(console.log)
  //})

  //const newContractInstance = await contractSend.send({
  //  from: from || accounts[0],
  //  gas: gas || 300000000,
  //})

  //return newContractInstance.options
}

