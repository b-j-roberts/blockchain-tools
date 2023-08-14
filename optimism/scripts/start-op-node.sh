#!/bin/bash
#

GIT_BASE_DIR=$(git rev-parse --show-toplevel)
REPOS_DIR=$GIT_BASE_DIR/setup/repos
L2_DATA_DIR=$HOME/l2-op-node

cd $REPOS_DIR/optimism/op-node

echo "Running ./bin/op-node --l2=http://localhost:8552 --l2.jwt-secret=./jwt.txt --sequencer.enabled --sequencer.l1-confs=3 --verifier.l1-confs=3 --rollup.config=./rollup.json --rpc.addr=0.0.0.0 --rpc.port=8547 --p2p.disable --rpc.enable-admin --p2p.sequencer.key=$SEQ_KEY --l1=$L1_RPC --l1.rpckind=$RPC_KIND"
./bin/op-node \
	--l2=http://localhost:8552 \
	--l2.jwt-secret=./jwt.txt \
	--sequencer.enabled \
	--sequencer.l1-confs=3 \
	--verifier.l1-confs=3 \
	--rollup.config=./rollup.json \
	--rpc.addr=0.0.0.0 \
	--rpc.port=8547 \
	--p2p.disable \
	--rpc.enable-admin \
	--p2p.sequencer.key=$SEQ_KEY \
	--l1=$L1_RPC \
	--l1.rpckind=$RPC_KIND
