#!/bin/bash
#
# This script is used to setup the L1 private network used by L2.

GIT_BASE_DIR=$(git rev-parse --show-toplevel)
REPOS_DIR=$GIT_BASE_DIR/setup/repos
L1_DATA_DIR=$HOME/l1-op-node

# Build L1 eth-private-network
cd $REPOS_DIR/MyBlockchains/eth-private-network
make build

# Run L1 eth-private-network
cd $REPOS_DIR/MyBlockchains/eth-private-network
./scripts/generate-account.sh -d $L1_DATA_DIR -x
./scripts/run-miner.sh -d $L1_DATA_DIR -x -p 3
