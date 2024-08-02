#!/bin/bash

# Check if a command is provided
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Available Commands"
    echo "uchain run geth 1"
    echo "uchain beacon 1"
    echo "uchain run validator 1"
    exit 1
fi

# Run the specified command
if [ "$1" = "run" ]; then
    if [ "$2" = "geth" ]; then
        if [ "$3" = "1" ]; then
            # Run geth command 1
            cd devnet &&
	    ./geth --http --http.api eth,net,web3,admin,txpool --ws --ws.api eth,net,web3 --authrpc.jwtsecret jwt.hex --datadir gethdata --syncmode full --allow-insecure-unlock --unlock 0x123463a4b065722e99115d6c222f267d9cabb524 --verbosity 3

            echo "Running geth command 1"
        elif [ "$3" = "2" ]; then
            # Run geth command 2
            cd devnet &&
            ./geth --datadir=gethdata2 init genesis.json &&
            ./geth --http --http.api eth,net,web3,admin,txpool --ws --ws.api eth,net,web3 --authrpc.jwtsecret jwt.hex --datadir gethdata2 --syncmode full --discovery.port 30304 --port 30304 --http.port 8547 --ws.port 8548 --authrpc.port 8552

        elif [ "$3" = "3" ]; then
            # Run geth command 3
            cd devnet &&
            ./geth --datadir=gethdata3 init genesis.json &&
            ./geth --http --http.api eth,net,web3,admin,txpool --ws --ws.api eth,net,web3 --authrpc.jwtsecret jwt.hex --datadir gethdata3 --syncmode full --discovery.port 30305 --port 30305 --http.port 8647 --ws.port 8648 --authrpc.port 8652

            echo "Running geth command 3"
        else
            echo "Invalid geth command number"
            exit 1
        fi
    elif [ "$2" = "beacon" ]; then
        if [ "$3" = "1" ]; then
            export PEER="/ip4/172.81.179.112/tcp/13000/p2p/16Uiu2HAmBVw7TvT3r5VgpvuVHcPfABSySaFExhswMAFob7caT8KE"
            cd devnet &&
            ./beacon-chain --datadir beacondata --min-sync-peers 1 --genesis-state genesis.ssz --bootstrap-node= --interop-eth1data-votes --chain-config-file config.yml --contract-deployment-block 0 --chain-id 32382 --accept-terms-of-use --jwt-secret jwt.hex --suggested-fee-recipient 0x123463a4B065722E99115D6c222f267d9cABb524 --minimum-peers-per-subnet 0 --enable-debug-rpc-endpoints --execution-endpoint gethdata/geth.ipc  --enable-upnp --p2p-host-ip $(curl icanhazip.com) --peer=$PEER
            echo "Running beacon command 1"
        elif [ "$3" = "2" ]; then
            cd devnet && 
            # Run beacon command 2
            echo "Running beacon command 2"
            # Execute the curl command
            curl_result=$(curl -s localhost:8080/p2p)
            echo "Result of curl command:"
            echo "$curl_result"
            # Extract and export the peer information
            peer_info=$(echo "$curl_result" | grep -oE '\/ip4\/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]\/tcp\/[0-9]+\/p2p\/[a-zA-Z0-9]+')
            export PEER=$peer_info
            ./beacon-chain --datadir beacondata2 --min-sync-peers 1 --genesis-state genesis.ssz --bootstrap-node= --interop-eth1data-votes --chain-config-file config.yml --contract-deployment-block 0 --chain-id 32382 --accept-terms-of-use --jwt-secret jwt.hex --suggested-fee-recipient 0x123463a4B065722E99115D6c222f267d9cABb524 --minimum-peers-per-subnet 0 --enable-debug-rpc-endpoints --execution-endpoint gethdata2/geth.ipc --peer=$PEER --p2p-udp-port 12001 --p2p-tcp-port 13001 --grpc-gateway-port 3501 --rpc-port 4001 --enable-upnp --p2p-host-ip 172.81.182.135
            echo "Exported PEER: $PEER"
        elif [ "$3" = "3" ]; then
            cd devnet && 
            # Run beacon command 3
            echo "Running beacon command 3"
             # Execute the curl command
            curl_result=$(curl -s localhost:8080/p2p)
            echo "Result of curl command:"
            echo "$curl_result"
            # Extract and export the peer information
            peer_info=$(echo "$curl_result" | grep -oE '\/ip4\/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]\/tcp\/[0-9]+\/p2p\/[a-zA-Z0-9]+' | head -n 1)
            export PEER=$peer_info
            ./beacon-chain --datadir beacondata3 --min-sync-peers 1 --genesis-state genesis.ssz --bootstrap-node= --interop-eth1data-votes --chain-config-file config.yml --contract-deployment-block 0 --chain-id 32382 --accept-terms-of-use --jwt-secret jwt.hex --suggested-fee-recipient 0x123463a4B065722E99115D6c222f267d9cABb524 --minimum-peers-per-subnet 0 --enable-debug-rpc-endpoints --execution-endpoint gethdata2/geth.ipc --peer=$PEER --p2p-udp-port 12002 --p2p-tcp-port 13002 --grpc-gateway-port 3502 --rpc-port 4002 --clear-db --enable-upnp --p2p-host-ip 172.81.182.135
            echo "Exported PEER: $PEER"
        else
            echo "Invalid beacon command number"
            exit 1
        fi
    elif [ "$2" = "validator" ]; then
        if [ "$3" = "1" ]; then
            # Run validator command 1
            cd devnet &&
            ./validator --datadir validatordata --accept-terms-of-use --interop-num-validators 64 --chain-config-file config.yml
            echo "Running vaildator command 1"
        else
            echo "Invalid validator command number"
            exit 1
        fi
    else
        echo "Unknown command"
        exit 1
    fi
else
    echo "Invalid syntax"
    exit 1
fi
