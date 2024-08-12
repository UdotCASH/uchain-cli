#!/bin/bash

create_files () {
    mkdir devnet
    # Copy the required files to the devnet directory
    cp genesis.json config.yml jwt.hex secret.txt devnet/
}

# Clone the go-ethereum repository and build the geth binary
install_geth () {
    git clone https://github.com/ethereum/go-ethereum
    (
    cd go-ethereum
    make geth
    cp ./build/bin/geth ../geth
    )
}

# Clone the prysm repository and build the necessary binaries
install_prysm () {
    git clone --branch release-v5.0.4 https://github.com/prysmaticlabs/prysm.git 
    ( 
    cd prysm
    CGO_CFLAGS="-O2 -D__BLST_PORTABLE__" go build -o=../beacon-chain ./cmd/beacon-chain
    CGO_CFLAGS="-O2 -D__BLST_PORTABLE__" go build -o=../validator ./cmd/validator
    CGO_CFLAGS="-O2 -D__BLST_PORTABLE__" go build -o=../prysmctl ./cmd/prysmctl
    )
}

# Install both dependencies
install_dependencies () {
   install_prysm
   install_geth
}

if [ -d devnet ] ; then
    cd devnet
    if ! [ -d prysm ]; then
        install_prysm
    fi
    if ! [ -d go-ethereum ]; then
        install_geth
    fi
    echo "Removed data for all nodes."
    rm -rf beacondata validatordata gethdata
else
    create_files
    cd devnet
    install_dependencies
fi

# Generate the genesis file using prysmctl
./prysmctl testnet generate-genesis --fork deneb --num-validators 64 --genesis-time-delay 30 --chain-config-file config.yml --geth-genesis-json-in genesis.json  --geth-genesis-json-out genesis.json --output-ssz genesis.ssz

# Call the geth command and import the account with the password "yay"
echo -e "yay\nyay" | ./geth --datadir=gethdata account import secret.txt
