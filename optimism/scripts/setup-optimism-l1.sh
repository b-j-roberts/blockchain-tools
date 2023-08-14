#!/bin/bash
#
# This script is used to setup the Optimism repos

GIT_BASE_DIR=$(git rev-parse --show-toplevel)
REPOS_DIR=$GIT_BASE_DIR/setup/repos
L1_DATA_DIR=$HOME/l1-op-node
L1_NODE_URL=http://localhost:8545
L1_BLOCK_TIME=3

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $REPOS_DIR/optimism
pnpm install
make op-node op-batcher op-proposer
pnpm build

cd $REPOS_DIR/op-geth
make geth

cd $REPOS_DIR/optimism/packages/contracts-bedrock
rm .envrc
touch .envrc
echo "export ETH_RPC_URL=$L1_NODE_URL" >> .envrc

L1_ACCOUNT=0x$(cat $L1_DATA_DIR/keystore/UTC* | jq -r '.address')
PRIVATE_KEY=$(node $SCRIPT_DIR/private_keys.js $L1_DATA_DIR $L1_ACCOUNT)
echo "export PRIVATE_KEY=$PRIVATE_KEY" >> .envrc

echo "export DEPLOYMENT_CONTEXT=getting-started" >> .envrc

#TODO: direnv allow .

cd $REPOS_DIR/optimism/packages/contracts-bedrock/deploy-config/
git checkout -- getting-started.json

# Use sed to replace ADMIN with L1_ACCOUNT
sed -i "s/ADMIN/$L1_ACCOUNT/g" getting-started.json
sed -i "s/PROPOSER/$L1_ACCOUNT/g" getting-started.json
sed -i "s/BATCHER/$L1_ACCOUNT/g" getting-started.json
sed -i "s/SEQUENCER/$L1_ACCOUNT/g" getting-started.json

L1_STARTING_BLOCK=$(geth attach --exec 'eth.getBlock("latest")' $L1_NODE_URL 2> /dev/null | yq -r ".")
L1_STARTING_BLOCK_NUMBER=$(echo $L1_STARTING_BLOCK | yq -r ".number")
L1_STARTING_BLOCKHASH=$(echo $L1_STARTING_BLOCK | yq -r ".hash")
L1_STARTING_TIMESTAMP=$(echo $L1_STARTING_BLOCK | yq -r ".timestamp")
sed -i "s/BLOCKHASH/$L1_STARTING_BLOCKHASH/g" getting-started.json
sed -i "s/TIMESTAMP/$L1_STARTING_TIMESTAMP/g" getting-started.json
sed -i "s/\"l1ChainID\":\ 5/\"l1ChainID\":\ 505/g" getting-started.json
yq -i '. += {"systemConfigStartBlock": '$L1_STARTING_BLOCK_NUMBER'}' getting-started.json
yq -i '. += {"l1BlockTime": '$L1_BLOCK_TIME'}' getting-started.json
yq -i '. += {"l1UseClique": true}' getting-started.json
yq -i '. += {"cliqueSignerAddress": "'$L1_ACCOUNT'"}' getting-started.json

cd $REPOS_DIR/optimism/packages/contracts-bedrock
rm -rf deployments/getting-started
mkdir -p deployments/getting-started

DEPLOYMENT_CONTEXT=getting-started forge script scripts/Deploy.s.sol:Deploy --private-key $PRIVATE_KEY --broadcast --rpc-url $L1_NODE_URL
DEPLOYMENT_CONTEXT=getting-started forge script scripts/Deploy.s.sol:Deploy --sig 'sync()' --private-key $PRIVATE_KEY --broadcast --rpc-url $L1_NODE_URL
