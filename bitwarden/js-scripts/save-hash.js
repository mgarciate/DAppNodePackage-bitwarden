const process = require('process')
const { ethers } = require('ethers')
const BigNumber = require('bignumber.js')
const { JsonRpcProvider } = require('@ethersproject/providers')
require('dotenv').config({path: './process.env'})
const { CONTRACT_ADDRESS, RPC } = process.env
const bitwardenBackupManagerAbi = require('./BitwardenBackupManagerAbi.json')

async function main() {
    const args = process.argv.slice(2)
    const hash = args[0]
    const pk = args[1]
    const provider = new JsonRpcProvider(RPC)

    // Wallet instance
    let wallet = new ethers.Wallet(pk, provider)
    wallet = wallet.connect(provider)

    // Contract instance
    const contract = new ethers.Contract(CONTRACT_ADDRESS, bitwardenBackupManagerAbi, wallet)

    // Call the function
    // const nonce = await provider.send("Filecoin.MpoolGetNonce", [wallet.address])
    const nonce = await provider.getTransactionCount(wallet.address)
    const eth_maxPriorityFeePerGas = await provider.send("eth_maxPriorityFeePerGas", [])
    const maxPriorityFeePerGas = ethers.BigNumber.from(eth_maxPriorityFeePerGas)
    const tx = await contract.saveHash(hash, {
        gasLimit: 1000000000,
        maxPriorityFeePerGas: maxPriorityFeePerGas,
        nonce: nonce,
    })
    const { status } = await tx.wait()
    console.log(status)
}

main()
