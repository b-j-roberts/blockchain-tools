#!/bin/bash
#

GIT_BASE_DIR=$(git rev-parse --show-toplevel)
REPOS_DIR=$GIT_BASE_DIR/setup/repos
L2_DATA_DIR=$HOME/l2-op-node

cd $REPOS_DIR/optimism/op-proposer

./bin/op-proposer \
    --poll-interval=12s \
    --rpc.port=8560 \
    --rollup-rpc=http://localhost:8547 \
    --l2oo-address=$L2OO_ADDR \
    --private-key=$PROPOSER_KEY \
    --l1-eth-rpc=$L1_RPC
