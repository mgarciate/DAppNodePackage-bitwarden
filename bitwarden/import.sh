#!/bin/bash

currentHash=$(cd /app/js-scripts && node get-hash.js 0xBeaDbCB67a9918b98796d180e5D6bb1458616862)
cd /tmp

# Login
/bw config server http://bitwarden.public.dappnode
/bw login $ACCOUNT_EMAIL $ACCOUNT_PASSWORD
sessionId=$(/bw unlock whatever1 --raw)

/bw sync

curl -o manifest.json.crypted https://$currentHash.ipfs.w3s.link

openssl aes-128-cbc -d -out manifest.json -in manifest.json.crypted -pass pass:$FILE_PASSWORD
jq -r '.cids[]' manifest.json | while read cid; do
    curl -o chunk.crypted https://$cid.ipfs.w3s.link
    openssl aes-128-cbc -d -out chunk -in chunk.crypted -pass pass:$FILE_PASSWORD
    cat chunk.??? >> myvault.json.crypted
done

openssl aes-128-cbc -d -out myvault.json -in myvault.json.crypted -pass pass:$FILE_PASSWORD

/bw import bitwardenjson myvault.json --session $sessionId

/bw sync
/bw logout
