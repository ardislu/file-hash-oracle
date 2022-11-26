// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Ownable.sol";

/// @title A simple proof of concept oracle to store arbitrary 32 byte file hashes.
contract FileHashOracle is Ownable {
    mapping(bytes32 => bool) private fileHashList;

    event HashesAdded(bytes32[] indexed hashes);
    event HashesRemoved(bytes32[] indexed hashes);

    /// @notice Add new file hashes to the file hash list.
    /// @param newHashes The file hashes to add to the file hash list.
    function addToHashList(bytes32[] calldata newHashes) external onlyOwner {
        uint256 len = newHashes.length;
        require(len != 0);
        for (uint256 i; i < len; ) {
            fileHashList[newHashes[i]] = true;
            unchecked { ++i; }
        }
        emit HashesAdded(newHashes);
    }

    /// @notice Remove file hashes from the file hash list.
    /// @param removeHashes The file hashes to remove from the file hash list.
    function removeFromHashList(bytes32[] calldata removeHashes) external onlyOwner {
        uint256 len = removeHashes.length;
        require(len != 0);
        for (uint256 i; i < len; ) {
            fileHashList[removeHashes[i]] = false;
            unchecked { ++i; }
        }
        emit HashesRemoved(removeHashes);
    }

    /// @notice Check if a file hash is in the file hash list. 
    /// @param fileHash The file hash to check in the file hash list.
    /// @return Boolean indicating if a file hash is in the file hash list.
    function isValid(bytes32 fileHash) external view returns (bool) {
        return fileHashList[fileHash];
    }
}
