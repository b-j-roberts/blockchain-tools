import { deploy } from './deploy-deps.js'
import fs from 'fs'

(async () => {
  try {
      console.log("Deploying Curl Contract onto l2 at", "http://localhost:5055, from address", process.env.FROM_ADDRESS)
     // const result =
      await deploy('CurlContract', [], "http://localhost:5055", '0x' + process.env.FROM_ADDRESS)
      //console.log(result)
      //console.log("Deployed Curl contract to : ", result.address)
      //var jsonOutput = "{\"address\": \"" + result.address + "\"}"
      // Write the contract address to a file
      //fs.writeFileSync('./builds/curl-contract.txt', jsonOutput)
  } catch (e) {
      console.log(e.message)
  }

  process.exit(0)
})()

