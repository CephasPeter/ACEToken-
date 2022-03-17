// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";
import "https://github.com/0xcert/ethereum-erc721/src/contracts/ownership/ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";

contract NFTMetadata {
    mapping (uint256 => string)  text;  
}

contract newNFT is NFTokenMetadata, Ownable, NFTMetadata{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    constructor() {
        nftName = "Block Games Heart";
        nftSymbol = "BHN";
    }
    
    function mint(address _to, string memory name, string memory description, string memory url) external returns (uint256){
        _tokenIds.increment();
        uint256 _tokenId = _tokenIds.current();

        text[_tokenId] = string(abi.encodePacked("{name : ", name, ",image : ", url, ",description:",description," }"));

        super._mint(_to, _tokenId);

        return _tokenId;
    }

    function getMetadata(uint256 id) external view returns (string memory) {
        return text[id];
    }

}