build-contracts:
	solcjs --base-path . --bin --abi --optimize -o ./builds/ *.sol

ACCOUNT_ADDR ?= $(shell cat ${HOME}/l1-op-node/keystore/UTC* | jq -r '.address')
PRIV_KEY ?= $(shell node ${HOME}/workspace/blockchain/blockchain-tools/optimism/scripts/private_keys.js ${HOME}/l1-op-node/ $(shell cat ${HOME}/l1-op-node/keystore/UTC* | jq -r '.address'))

deploy-curl-contracts:
	PRIVATE_KEY=${PRIV_KEY} FROM_ADDRESS=${ACCOUNT_ADDR} npm run deploy-curl-contracts

clean:
	rm -rf builds
