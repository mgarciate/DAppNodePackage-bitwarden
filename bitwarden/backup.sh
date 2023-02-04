#!/bin/bash

# Get all data from the previous backup

# Login
/bw config server http://bitwarden.public.dappnode
/bw login $ACCOUNT_EMAIL $ACCOUNT_PASSWORD
sessionId=$(/bw unlock whatever1 --raw)
# get the sessionId from here

/bw sync
# /bw export --output /tmp/myvault.json --format encrypted_json --password whatever1
/bw export --output /tmp/myvault.json --format encrypted_json --session $sessionId
openssl aes-128-cbc -in myvault.json -out myvault.json.crypted -pass pass:$FILE_PASSWORD
split -a 3 -n 32 myvault.json.crypted chunk.
for f in /tmp/chunk.???; do 
    openssl aes-128-cbc -in $f -out $f.crypted -pass pass:$FILE_PASSWORD;
    # Upload $f.crypted to web3.storage
    # Store the hash from web3.storage
done
# Create manifest.json with all hashes (.json)
# Encrypt manifest.json to manifest.json.crypted
# Upload manifest.json.crypted to web3.storage
# Store the hash from web3.storage
# Encrypt the hash with my ETH public key
# Update the contract

# Success -> Remove the previous backup files from web3.storage

# Import
# openssl aes-128-cbc -d -out myvault2.json -in myvault.json.crypted -pass pass:$FILE_PASSWORD
# /bw import bitwardenjson myvault.json --session $sessionId

# Logout
/bw logout
