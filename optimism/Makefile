PRIV_KEY ?= $(shell node scripts/private_keys.js ${HOME}/l1-op-node/ $(shell cat ${HOME}/l1-op-node/keystore/UTC* | jq -r '.address'))
L1_RPC ?= http://localhost:8545
RPC_KIND ?= any
L2OO_ADDR ?= $(shell cat ../setup/repos/optimism/packages/contracts-bedrock/deployments/getting-started/L2OutputOracleProxy.json | jq -r .address)

op-geth:
	L1_RPC=${L1_RPC} RPC_KIND=${RPC_KIND} L2OO_ADDR=${L2OO_ADDR} SEQ_KEY=${PRIV_KEY} BATCHER_KEY=${PRIV_KEY} PROPOSER_KEY=${PRIV_KEY} ./scripts/start-op-geth.sh
	
op-node:
	L1_RPC=${L1_RPC} RPC_KIND=${RPC_KIND} L2OO_ADDR=${L2OO_ADDR} SEQ_KEY=${PRIV_KEY} BATCHER_KEY=${PRIV_KEY} PROPOSER_KEY=${PRIV_KEY} ./scripts/start-op-node.sh

op-batcher:
	L1_RPC=${L1_RPC} RPC_KIND=${RPC_KIND} L2OO_ADDR=${L2OO_ADDR} SEQ_KEY=${PRIV_KEY} BATCHER_KEY=${PRIV_KEY} PROPOSER_KEY=${PRIV_KEY} ./scripts/start-op-batcher.sh

op-proposer:
	L1_RPC=${L1_RPC} RPC_KIND=${RPC_KIND} L2OO_ADDR=${L2OO_ADDR} SEQ_KEY=${PRIV_KEY} BATCHER_KEY=${PRIV_KEY} PROPOSER_KEY=${PRIV_KEY} ./scripts/start-op-proposer.sh
