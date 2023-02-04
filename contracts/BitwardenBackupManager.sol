// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

/**
 * @title BitwardenBackupManager
 * @dev Set & change last hash by address
 */
contract BitwardenBackupManager {
    mapping (address => string) hashes;

    constructor() {}

    /**
     * @dev Save hash
     * @param hash refers to the most recent backup
     */
    function saveHash(string memory hash) public {
        hashes[msg.sender] = hash;
    }

    /**
     * @dev Return backup hash
     * @param addr address 
     * @return hash assigned to the address
     */
    function getHash(address addr) external view returns (string memory) {
        return hashes[addr];
    }
}