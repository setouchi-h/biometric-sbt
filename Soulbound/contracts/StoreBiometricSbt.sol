// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

error SBT__AlreadyMinted();
error SBT__NotMinted();

contract StoreBiometricSbt {

    struct SBT {
        uint256 id;
        uint256 hashValue;
        address ownerAddress;
    }

    uint256 private s_tokenCounter;
    mapping(address => SBT) private s_addressToSbt;
    mapping(uint256 => SBT) private s_idToSbt;
    event CreatedSBT(uint256 indexed tokenId);
    SBT[] private s_sbt;

    constructor() {
        s_tokenCounter = 1;
    }

    function store(uint256 _biometricInfo, address _address) internal {
        if (s_addressToSbt[_address].id != 0) {
            revert SBT__AlreadyMinted();
        }
        SBT memory _sbt = SBT(s_tokenCounter, hashing(_biometricInfo, _address), _address);
        s_sbt.push(_sbt);
        s_addressToSbt[_address] = _sbt;
        s_idToSbt[s_tokenCounter] = _sbt;
        emit CreatedSBT(s_tokenCounter);
        s_tokenCounter += 1;
    }

    function compare(uint256 _biometricInfo) public view returns (bool) {
        address _msgSender = msg.sender;
        if (s_addressToSbt[_msgSender].id == 0) {
            revert SBT__NotMinted();
        }
        uint256 _hashValue = hashing(_biometricInfo, _msgSender);
        if (s_addressToSbt[_msgSender].hashValue == _hashValue) {
            return true;
        } else {
            return false;
        }
    }

    function hashing(uint256 _biometricInfo, address _address) private pure returns (uint256) {
        return uint(keccak256(abi.encodePacked(_biometricInfo, _address)));
    }

    function getSbtFromAddress(address _address) public view returns (uint256, uint256, address) {
        return (s_addressToSbt[_address].id, s_addressToSbt[_address].hashValue, s_addressToSbt[_address].ownerAddress);
    }

    function getSbtFromId(uint256 _id) public view returns (uint256, uint256, address) {
        return (s_idToSbt[_id].id, s_idToSbt[_id].hashValue, s_idToSbt[_id].ownerAddress);
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}