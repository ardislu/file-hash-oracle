// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./FileHashOracle.sol";

/// @title Template contract to set up scenarios for Echidna to run tests against.
/// @dev See https://github.com/crytic/echidna for more information.
contract Echidna {
    FileHashOracle fileHashOracle;

    constructor() {
        fileHashOracle = new FileHashOracle();
    }

    function testAdd(bytes32[] calldata hashes) public {
        // Pre-condition: hashes must not be empty list
        uint256 len = hashes.length;
        require(len != 0);

        // Action: add the hashes to the file hash list
        fileHashOracle.addToHashList(hashes);

        // Assertion: .isValid returns true for these hashes
        for (uint256 i; i < len; ) {
            assert(fileHashOracle.isValid(hashes[i]));
            unchecked { ++i; }
        }
    }

    function testRemove(bytes32[] calldata hashes) public {
        // Pre-condition: hashes must not be empty list
        uint256 len = hashes.length;
        require(len != 0);

        // Action: remove the hashes from the file hash list
        fileHashOracle.removeFromHashList(hashes);

        // Assertion: .isValid returns false for these hashes
        for (uint256 i; i < len; ) {
            assert(!fileHashOracle.isValid(hashes[i]));
            unchecked { ++i; }
        }
    }
}
