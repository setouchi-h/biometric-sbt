// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

error SBT__NotTransferable();
error SBT__AlreadyMinted();

abstract contract Soulbound is ERC721 {

    uint256 private s_tokenCounter;
    mapping(address => uint256) private s_tokenMinted;

    constructor() ERC721("BiometricSBT", "BSBT") {
        s_tokenCounter = 1;
    }

    function mintSBT() public returns (uint256) {
        if (s_tokenMinted[msg.sender] != 0) {
            revert SBT__AlreadyMinted();
        }
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenMinted[msg.sender] = s_tokenCounter;
        s_tokenCounter += 1;
        return s_tokenCounter;
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
