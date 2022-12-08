// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

error SBT__AlreadyMinted();
error SBT__NotMinted();
error SBT__Unauthorized();

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
    event BurnedSBT(uint256 indexed tokenId);

    constructor() {
        s_tokenCounter = 1;
    }

    function store(uint256 _biometricInfo, address _address) internal {
        if (s_addressToSbt[_address].id != 0) {
            revert SBT__AlreadyMinted();
        }
        SBT memory _sbt = SBT(s_tokenCounter, hashing(_biometricInfo, _address), _address);
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

    function burn(uint256 _tokenId, address _address) internal {
        if (s_idToSbt[_tokenId].ownerAddress != _address) {
            revert SBT__Unauthorized();
        }
        if (s_idToSbt[_tokenId].id == 0) {
            revert SBT__NotMinted();
        }
        SBT memory _nullSbt = SBT(0, 0, address(0));
        s_addressToSbt[_address] = _nullSbt;
        s_idToSbt[_tokenId] = _nullSbt;
        emit BurnedSBT(_tokenId);
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