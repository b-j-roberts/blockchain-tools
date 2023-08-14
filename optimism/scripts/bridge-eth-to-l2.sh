#!/bin/bash
#

GIT_BASE_DIR=$(git rev-parse --show-toplevel)
REPOS_DIR=$GIT_BASE_DIR/setup/repos
L1_RPC=http://localhost:8545
L1_DATA_DIR=$HOME/l1-op-node
ACCOUNT=$(cat $L1_DATA_DIR/keystore/UTC* | jq -r .address)
AMOUNT=100000000000

cd $REPOS_DIR/optimism/packages/contracts-bedrock

BRIDGE_ADDR=$(cat deployments/getting-started/L1StandardBridgeProxy.json | jq -r .address)
geth attach --exec "eth.sendTransaction({from: '$ACCOUNT', to: '$BRIDGE_ADDR', value: '$AMOUNT'})" $L1_RPC
