#!/bin/bash


# setting up git submodules
git submodule update --init --recursive

docker build -t spheron-powerloom-snapshotter-lite .

echo "building...";

if ! [ -x "$(command -v docker-compose)" ]; then
    echo 'docker compose not found, trying to see if compose exists within docker';
    if [ "$IPFS_URL" == "/dns/ipfs/tcp/5001" ]; then
        docker compose -f docker-compose-dev.yaml --profile ipfs up -V --abort-on-container-exit
    else
        docker compose -f docker-compose-dev.yaml up --no-deps -V --abort-on-container-exit
    fi
else
    if [ "$IPFS_URL" == "/dns/ipfs/tcp/5001" ]; then
        docker-compose -f docker-compose-dev.yaml --profile ipfs up -V --abort-on-container-exit
    else
        docker-compose -f docker-compose-dev.yaml up --no-deps -V --abort-on-container-exit
    fi
fi