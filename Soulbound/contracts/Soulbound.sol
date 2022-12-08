// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "base64-sol/base64.sol";
import "./StoreBiometricSbt.sol";

error SBT__NotTransferable();
error ERC721Metadata__URI_QueryFor_NonExistentToken();

contract Soulbound is ERC721, StoreBiometricSbt {

    constructor() ERC721("BiometricSBT", "BSBT") {}

    function mintSBT(uint256 _biometricInfo) public {
        address _msgSender = msg.sender;
        super.store(_biometricInfo, _msgSender);
        (uint256 id, , ) = super.getSbtFromAddress(_msgSender);
        _safeMint(_msgSender, id);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (!_exists(tokenId)) {
            revert ERC721Metadata__URI_QueryFor_NonExistentToken();
        }
        (uint256 id, uint256 hashValue, ) = super.getSbtFromId(tokenId);
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "BiometricSBT ID:',
                                id,
                                '",',
                                '"description": "An biometric SBT", ',
                                '"attributes": [{"id": ',
                                id,
                                '"hashValue": ',
                                hashValue,
                                '}], "image": "ipfs://bafybeibgklnn4qp7wlmgqktwxvr3jjh3wgit2cgsh4mq25mtxpwcq7nm44/biometric%20card%202.jpeg"}'
                            )
                        )
                    )
                )
            );
    }

    function burnSBT(uint256 tokenId) public {
        super.burn(tokenId, msg.sender);
        _burn(tokenId);
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
