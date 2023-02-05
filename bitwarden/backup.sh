#!/bin/bash

# Get all data from the previous backup

# Create a variable from an environment variable or use a default value

cd /tmp

# Login
/bw config server http://bitwarden.public.dappnode
/bw login $ACCOUNT_EMAIL $ACCOUNT_PASSWORD
sessionId=$(/bw unlock whatever1 --raw)

/bw sync
# /bw export --output /tmp/myvault.json --format encrypted_json --password whatever1
/bw export --output /tmp/myvault.json --format encrypted_json --session $sessionId
openssl aes-128-cbc -in myvault.json -out myvault.json.crypted -pass pass:$FILE_PASSWORD
split -a $SUFFIX_SIZE -n $N_PARTS myvault.json.crypted chunk.
# Declare array of strings
file_crypted_cids=()
for f in /tmp/chunk.???; do 
    file_crypted=$f.crypted
    echo "openssl aes-128-cbc -in $f -out $file_crypted -pass pass:$FILE_PASSWORD"
    openssl aes-128-cbc -in $f -out $file_crypted -pass pass:$FILE_PASSWORD
    # Upload file with curl command
    file_crypted_cid=$(curl -X POST -H "Authorization: Bearer $WEB3STORAGE_API_TOKEN" -F "file=@$file_crypted" https://api.web3.storage/upload | jq '.cid' --raw-output)
    echo "new $file_crypted: $file_crypted_cid"
    file_crypted_cids+=( "$file_crypted_cid" )
done

# Improve the json file with a json array in cids object and a new object called version with value "1"
json_array=$(printf '%s\n' "${file_crypted_cids[@]}" | jq -R . | jq -s .)
echo $json_array > manifest.json
jq -n --argjson cids "$(cat manifest.json)" '{"cids": $cids,"version": "1"}' > manifest.json
openssl aes-128-cbc -in manifest.json -out manifest.json.crypted -pass pass:$FILE_PASSWORD
file_crypted=$(realpath manifest.json.crypted)
file_crypted_cid=$(curl -X POST -H "Authorization: Bearer $WEB3STORAGE_API_TOKEN" -F "file=@$file_crypted" https://api.web3.storage/upload | jq '.cid' --raw-output)
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
