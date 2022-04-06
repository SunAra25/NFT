//SPDX-License-Identifier : MIT

pragma solidity ^0.8.0;

import "MintNFT.sol";

contract SaleNFTtoken {
    MintNFT public NFT_Address;

    constructor (address _NFT_Address) {
        NFT_Address = MintNFT(_NFT_Address);
    }

    mapping(uint256 => uint256) public NFTprices;

    uint256[] public onSaleTokenArray;

    function set_saleNFT(uint256 _NFTtokenID, uint256 _price) public {
        address NFTowner = NFT_Address.ownerOf(_NFTtokenID);

        require(NFTowner == msg.sender, "CALLER IS NOT NFT OWNER");
        require(_price > 0, "PRICE IS ZERO OR LOWER");
        require(NFTprices[_NFTtokenID]==0, "THIS NFT IS ALREADY ON SALE");
        require(NFT_Address.isApprovedForAll(NFTowner,address(this)),"NFT OWNER DID NOT APPROVE TOKEN");

        NFTprices[_NFTtokenID] = _price;

        onSaleTokenArray.push(_NFTtokenID);
    }

    function purchaseNFT(uint256 _NFTtokenID) public payable {
        uint256 price = NFTprices[_NFTtokenID];
        address NFTowner = NFT_Address.ownerOf(_NFTtokenID);

        require(price > 0, "NFT TOKEN NOT SALE");
        require(price <= msg.value, "CALLER SENT LOWER THAN PRICE");
        require(NFTowner != msg.sender, "CALLER IS NFT TOKEN OWNER");

        payable(NFTowner).transfer(msg.value);
        NFT_Address.safeTransferFrom(NFTowner, msg.sender, _NFTtokenID);

        NFTprices[_NFTtokenID] = 0;

        for(uint256 i = 0 ; i<onSaleTokenArray.length; i++){
            if(NFTprices[onSaleTokenArray[i]] == 0){
                onSaleTokenArray[i] = onSaleTokenArray[onSaleTokenArray.length - 1];
                onSaleTokenArray.pop();
            }
        }
    }

    function getOnSaleTokenArrayLength() view public returns (uint256){
        return onSaleTokenArray.length;
    }
}