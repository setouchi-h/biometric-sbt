// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "base64-sol/base64.sol";

error SBT__NotTransferable();
error SBT__AlreadyMinted();
error ERC721Metadata__URI_QueryFor_NonExistentToken();

abstract contract Soulbound is ERC721 {

    uint256 private s_tokenCounter;
    uint256 private s_sbtName;
    mapping(address => uint256) private s_tokenMinted;

    event CreatedSBT(uint256 indexed tokenId);

    constructor() ERC721("BiometricSBT", "BSBT") {
        s_tokenCounter = 1;
    }

    function mintSBT() public {
        if (s_tokenMinted[msg.sender] != 0) {
            revert SBT__AlreadyMinted();
        }
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenMinted[msg.sender] = s_tokenCounter;
        emit CreatedSBT(s_tokenCounter);
        s_tokenCounter += 1;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (!_exists(tokenId)) {
            revert ERC721Metadata__URI_QueryFor_NonExistentToken();
        }
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name(), // You can add whatever name here
                                '", "description":"An biometric SBT", ',
                                '"attributes": [{"trait_type": "coolness", "value": 100}], "image":"',
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    // Non transferable

    // all transfer functions
    function _transfer(address from, address to, uint256 tokenId) internal pure override {
        revert SBT__NotTransferable();
    }

    // approve functions

    function approve(address to, uint256 tokenId) public pure override {
        revert SBT__NotTransferable();
    }

    function setApprovalForAll(address operator, bool approved) public pure override {
        revert SBT__NotTransferable();
    }
}
