#!/bin/bash
#

GIT_BASE_DIR=$(git rev-parse --show-toplevel)
REPOS_DIR=$GIT_BASE_DIR/setup/repos
L2_DATA_DIR=$HOME/l2-op-node

cd $HOME/workspace/blockchain/op-curl-geth

./build/bin/geth \
        --datadir $L2_DATA_DIR \
        --port 30313 \
        --http \
        --http.corsdomain="*" \
        --http.vhosts="*" \
        --http.addr=0.0.0.0 \
        --http.api=web3,debug,eth,txpool,net,engine \
        --http.port=5055 \
        --ws \
        --ws.addr=0.0.0.0 \
        --ws.port=8546 \
        --ws.origins="*" \
        --ws.api=debug,eth,txpool,net,engine \
        --syncmode=full \
        --gcmode=archive \
        --nodiscover \
        --maxpeers=0 \
        --sequencer \
        --networkid=42069 \
        --authrpc.vhosts="*" \
        --authrpc.addr=0.0.0.0 \
        --authrpc.port=8552 \
        --authrpc.jwtsecret=./jwt.txt \
        --rollup.disabletxpoolgossip=true
