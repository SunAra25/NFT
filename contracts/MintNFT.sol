//SPDX-License-Identifier : MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MintNFT is ERC721Enumerable{

    constructor() ERC721("userName","USER"){}

    mapping(uint256 => uint256) public NFTtypes;

    function mintNFTtoken() public { 
        uint256 NFTtokenID = totalSupply() + 1;

        uint256 NFT_type = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, NFTtokenID))) % 5 + 1;

        NFTtypes[NFTtokenID] = NFT_type;
 
        _mint(msg.sender, NFTtokenID); 
    }
}