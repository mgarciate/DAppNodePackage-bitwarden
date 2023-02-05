#!/bin/bash

# Get all data from the previous backup

# Create a variable from an environment variable or use a default value

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
# Declare array of strings
file_crypted_cids=()
for f in /tmp/chunk.???; do 
    file_crypted = $f.crypted
    openssl aes-128-cbc -in $f -out file_crypted -pass pass:$FILE_PASSWORD;
    file_crypted_cid=$(curl -X POST -H "Authorization: Bearer $WEB3STORAGE_API_TOKEN" -F "file=@$file_crypted" https://api.web3.storage/upload | jq '.cid' --raw-output)
    echo "new $file_crypted: $file_crypted_cid"
    file_crypted_cids+=( "$file_crypted_cid" )
done
# Create manifest.json with all hashes that are in file_crypted_cids strings array


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

strings=( "string1" "string2" "string3" )
array_of_strings=$(jq -n --argjson strings "${strings[@]}" '{"cid": $strings | map({"value": .})}')
echo "$array_of_strings" > array_of_strings.json
