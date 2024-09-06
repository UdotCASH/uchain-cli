#!/bin/bash

# Function definitions for different commands
run_geth() {
    case $1 in
        1)
            cd devnet &&
            ./geth --http --http.api eth,net,web3,admin,txpool \
                   --ws --ws.api eth,net,web3 \
                   --authrpc.jwtsecret jwt.hex --datadir gethdata \
                   --syncmode full --allow-insecure-unlock \
                   --unlock 0x123463a4b065722e99115d6c222f267d9cabb524
            ;;
        2)
            cd devnet &&
            ./geth --datadir=gethdata2 init genesis.json &&
            ./geth --http --http.api eth,net,web3,admin,txpool \
                   --ws --ws.api eth,net,web3 \
                   --authrpc.jwtsecret jwt.hex --datadir gethdata2 \
                   --syncmode full --discovery.port 30304 --port 30304 \
                   --http.port 8547 --ws.port 8548 --authrpc.port 8552
            ;;
        3)
            cd devnet &&
            ./geth --datadir=gethdata3 init genesis.json &&
            ./geth --http --http.api eth,net,web3,admin,txpool \
                   --ws --ws.api eth,net,web3 \
                   --authrpc.jwtsecret jwt.hex --datadir gethdata3 \
                   --syncmode full --discovery.port 30305 --port 30305 \
                   --http.port 8647 --ws.port 8648 --authrpc.port 8652
            ;;
        *)
            echo "Invalid geth command number"
            exit 1
            ;;
    esac
}

run_beacon() {
    case $1 in
        1)
            cd devnet &&
            ./beacon-chain --datadir beacondata --min-sync-peers 0 \
                           --genesis-state genesis.ssz --chain-config-file config.yml \
                           --execution-endpoint gethdata/geth.ipc --accept-terms-of-use \
                           --jwt-secret jwt.hex --suggested-fee-recipient 0x123463a4b065722e99115d6c222f267d9cabb524 \
                           --enable-debug-rpc-endpoints --p2p-host-ip 172.81.179.112 \
                           --chain-id 32382
            ;;
        2|3)
            cd devnet &&
            curl_result=$(curl -s localhost:8080/p2p) &&
            peer_info=$(echo "$curl_result" | grep -oE '\/ip4\/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\/tcp\/[0-9]+\/p2p\/[a-zA-Z0-9]+' | head -n 1) &&
            export PEER=$peer_info &&
            ./beacon-chain --datadir "beacondata$1" --min-sync-peers 1 \
                           --genesis-state genesis.ssz --chain-config-file config.yml \
                           --execution-endpoint gethdata2/geth.ipc --peer=$PEER \
                           --p2p-udp-port "1200$1" --p2p-tcp-port "1300$1" \
                           --grpc-gateway-port "350$1" --rpc-port "400$1" \
                           --clear-db --enable-upnp --p2p-host-ip 172.81.182.135 \
                           --chain-id 32382

            ;;
        *)
            echo "Invalid beacon command number"
            exit 1
            ;;
    esac
}

run_validator() {
    case $1 in
        1)
            cd devnet &&
            ./validator --datadir validatordata --accept-terms-of-use \
                        --interop-num-validators 64 --chain-config-file config.yml
            ;;
        *)
            echo "Invalid validator command number"
            exit 1
            ;;
    esac
}

# Check for valid arguments
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Available Commands:"
    echo "uchain run geth 1"
    echo "uchain run beacon 1"
    echo "uchain run validator 1"
    exit 1
fi

# Main execution block
case $1 in
    run)
        case $2 in
            geth) run_geth $3 ;;
            beacon) run_beacon $3 ;;
            validator) run_validator $3 ;;
            *) echo "Unknown command"; exit 1 ;;
        esac
        ;;
    *)
        echo "Invalid syntax"; exit 1
        ;;
esac