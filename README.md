
# uchain Command Script

This script is designed to run various commands related to `geth`, `beacon`, and `validator` based on the provided parameters.

## Usage

```sh
uchain run <command> <command_number>
```

## Available Commands

### Geth Commands

#### Run geth command 1

```sh
uchain run geth 1
```

Runs a `geth` node with specific HTTP, WebSocket APIs, and other configurations.

```bash
cd devnet &&
./geth --http --http.api eth,net,web3,admin,txpool --ws --ws.api eth,net,web3 --authrpc.jwtsecret jwt.hex --datadir gethdata --syncmode full --allow-insecure-unlock --unlock 0x123463a4b065722e99115d6c222f267d9cabb524 --verbosity 3
```

#### Run geth command 2

```sh
uchain run geth 2
```

Initializes and runs a `geth` node with a different data directory and port configurations.

```bash
cd devnet &&
./geth --datadir=gethdata2 init genesis.json &&
./geth --http --http.api eth,net,web3,admin,txpool --ws --ws.api eth,net,web3 --authrpc.jwtsecret jwt.hex --datadir gethdata2 --syncmode full --discovery.port 30304 --port 30304 --http.port 8547 --ws.port 8548 --authrpc.port 8552
```

#### Run geth command 3

```sh
uchain run geth 3
```

Initializes and runs another `geth` node with a different data directory and port configurations.

```bash
cd devnet &&
./geth --datadir=gethdata3 init genesis.json &&
./geth --http --http.api eth,net,web3,admin,txpool --ws --ws.api eth,net,web3 --authrpc.jwtsecret jwt.hex --datadir gethdata3 --syncmode full --discovery.port 30305 --port 30305 --http.port 8647 --ws.port 8648 --authrpc.port 8652
```

### Beacon Commands

#### Run beacon command 1

```sh
uchain run beacon 1
```

Runs a `beacon-chain` node with specific configurations.

```bash
cd devnet &&
./beacon-chain --datadir beacondata --min-sync-peers 0 --genesis-state genesis.ssz --bootstrap-node= --interop-eth1data-votes --chain-config-file config.yml --contract-deployment-block 0 --chain-id 32382 --accept-terms-of-use --jwt-secret jwt.hex --suggested-fee-recipient 0x123463a4B065722E99115D6c222f267d9cABb524 --minimum-peers-per-subnet 0 --enable-debug-rpc-endpoints --execution-endpoint gethdata/geth.ipc --enable-upnp --p2p-host-ip 172.81.182.135
```

#### Run beacon command 2

```sh
uchain run beacon 2
```

Fetches peer information using curl, exports it, and runs another `beacon-chain` node with specific configurations.

```bash
cd devnet
curl_result=$(curl -s localhost:8080/p2p)
peer_info=$(echo "$curl_result" | grep -oE '\/ip4\/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\/tcp\/[0-9]+\/p2p\/[a-zA-Z0-9]+')
export PEER=$peer_info
./beacon-chain --datadir beacondata2 --min-sync-peers 1 --genesis-state genesis.ssz --bootstrap-node= --interop-eth1data-votes --chain-config-file config.yml --contract-deployment-block 0 --chain-id 32382 --accept-terms-of-use --jwt-secret jwt.hex --suggested-fee-recipient 0x123463a4B065722E99115D6c222f267d9cABb524 --minimum-peers-per-subnet 0 --enable-debug-rpc-endpoints --execution-endpoint gethdata2/geth.ipc --peer=$PEER --p2p-udp-port 12001 --p2p-tcp-port 13001 --grpc-gateway-port 3501 --rpc-port 4001 --enable-upnp --p2p-host-ip 172.81.182.135
```

#### Run beacon command 3

```sh
uchain run beacon 3
```

Fetches peer information using curl, exports it, and runs another `beacon-chain` node with specific configurations.

```bash
cd devnet
curl_result=$(curl -s localhost:8080/p2p)
peer_info=$(echo "$curl_result" | grep -oE '\/ip4\/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\/tcp\/[0-9]+\/p2p\/[a-zA-Z0-9]+' | head -n 1)
export PEER=$peer_info
./beacon-chain --datadir beacondata3 --min-sync-peers 1 --genesis-state genesis.ssz --bootstrap-node= --interop-eth1data-votes --chain-config-file config.yml --contract-deployment-block 0 --chain-id 32382 --accept-terms-of-use --jwt-secret jwt.hex --suggested-fee-recipient 0x123463a4B065722E99115D6c222f267d9cABb524 --minimum-peers-per-subnet 0 --enable-debug-rpc-endpoints --execution-endpoint gethdata2/geth.ipc --peer=$PEER --p2p-udp-port 12002 --p2p-tcp-port 13002 --grpc-gateway-port 3502 --rpc-port 4002 --clear-db --enable-upnp --p2p-host-ip 172.81.182.135
```

### Validator Commands

#### Run validator command 1

```sh
uchain run validator 1
```

Runs a `validator` node with specific configurations.

```bash
cd devnet &&
./validator --datadir validatordata --accept-terms-of-use --interop-num-validators 64 --chain-config-file config.yml
```

## Summary

This script helps manage and execute various Ethereum-related commands by simplifying the process into predefined command sets. Ensure the `devnet` directory and all the required files (e.g., `genesis.json`, `config.yml`, `jwt.hex`) are correctly set up before running the commands.
