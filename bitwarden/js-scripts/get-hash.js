const process = require('process')
const ethers = require('ethers')
const { JsonRpcProvider } = require('@ethersproject/providers')
require('dotenv').config({path: './process.env'})
const { CONTRACT_ADDRESS, RPC } = process.env
const bitwardenBackupManagerAbi = require('./BitwardenBackupManagerAbi.json')

async function main() {
    const provider = new JsonRpcProvider(RPC)

    // Contract instance
    const contract = new ethers.Contract(CONTRACT_ADDRESS, bitwardenBackupManagerAbi, provider)

    // Call the function
    const address = process.argv.slice(2)[0]
    const result = await contract.getHash(address)
    console.log(result)
}

main()
