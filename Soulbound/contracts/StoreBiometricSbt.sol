// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

error SBT__AlreadyMinted();
error SBT__NotMinted();

contract StoreBiometricSbt {

    uint256 private s_tokenCounter;
    struct SBT {
        uint256 id;
        uint256 hashValue;
        address sbtAddress;
    }
    mapping(address => SBT) private s_addressToSbt;

    event CreatedSBT(uint256 indexed tokenId);

    SBT[] private s_sbt;

    constructor() {
        s_tokenCounter = 1;
    }

    function store(uint256 _biometricInformation) public {
        address _msgSender = msg.sender;
        if (s_addressToSbt[_msgSender].id != 0) {
            revert SBT__AlreadyMinted();
        }
        s_sbt.push(SBT(s_tokenCounter, hashing(_biometricInformation, _msgSender), _msgSender));
        emit CreatedSBT(s_tokenCounter);
        s_tokenCounter += 1;
    }

    function compare(uint256 _biometricInformation) private view returns (bool) {
        address _msgSender = msg.sender;
        if (s_addressToSbt[_msgSender].id == 0) {
            revert SBT__NotMinted();
        }
        uint256 _hashValue = hashing(_biometricInformation, _msgSender);
        if (s_addressToSbt[_msgSender].hashValue == _hashValue) {
            return true;
        } else {
            return false;
        }
    }

    function hashing(uint256 _biometricInformation, address _address) private pure returns (uint256) {
        return uint(keccak256(abi.encodePacked(_biometricInformation, _address)));
    }

    function getSbt(address _address) public view returns (SBT memory) {
        return s_addressToSbt[_address];
    }
}