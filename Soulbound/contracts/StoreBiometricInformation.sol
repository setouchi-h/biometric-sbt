// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

error SBT__AlreadyMinted();

contract StoreBiometricInformation {

    uint256 private s_tokenCounter;
    struct SBT {
        uint256 id;
        uint256 hashValue;
        address sbtAddress;
        uint256 biometricInformation;
    }
    mapping(address => uint256) private s_addressToId;

    event CreatedSBT(uint256 indexed tokenId);

    SBT[] private s_sbt;

    constructor() {
        s_tokenCounter = 1;
    }

    function store(uint256 _biometricInformation) public {
        if (s_addressToId[msg.sender] != 0) {
            revert SBT__AlreadyMinted();
        }
        s_sbt.push(SBT(s_tokenCounter, hashing(_biometricInformation), msg.sender, _biometricInformation));
        s_tokenCounter += 1;
    }

    function hashing(uint256 _biometricInformation) private view returns (uint256) {
        return uint(keccak256(abi.encodePacked(_biometricInformation, msg.sender)));
    }
}