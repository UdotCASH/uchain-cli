#!/bin/bash

# Create the devnet directory
mkdir devnet

# Copy the required files to the devnet directory
cp genesis.json config.yml jwt.hex secret.txt genesis.ssz devnet/

# Change to the devnet directory
cd devnet

# Clone the prysm repository and build the necessary binaries
git clone --branch release-v5.0.4 https://github.com/prysmaticlabs/prysm.git && cd prysm
CGO_CFLAGS="-O2 -D__BLST_PORTABLE__" go build -o=../beacon-chain ./cmd/beacon-chain
CGO_CFLAGS="-O2 -D__BLST_PORTABLE__" go build -o=../validator ./cmd/validator
CGO_CFLAGS="-O2 -D__BLST_PORTABLE__" go build -o=../prysmctl ./cmd/prysmctl
cd ..

# Clone the go-ethereum repository and build the geth binary
git clone https://github.com/ethereum/go-ethereum && cd go-ethereum
make geth
cp ./build/bin/geth ../geth
cd ..

echo -e "yay\nyay" | ./geth --datadir=gethdata account import secret.txt

# Initialize the datadir with the genesis file
./geth --datadir=gethdata init genesis.json

# echo "yay" | ./geth --http --http.api eth,net,web3 --ws --ws.api eth,net,web3 --authrpc.jwtsecret jwt.hex --datadir gethdata --syncmode full --allow-insecure-unlock --unlock 0x123463a4b065722e99115d6c222f267d9cabb524 --bootnodes "enode://1eb5d4f39ab4da4d95f553d242163e5cf5dad35faf704c294759f87d4cad592e861d5a9572243608814e34ed410af51e554030d1cdc4ecf829aef6d0b1aa9988@172.81.179.112:30303"
