//SPDX-License-Identifier: GPL-3.0

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

pragma solidity ^0.8.20;

contract Cattie is ERC721  {
    uint256 public tokenCounter = 0;
    uint256 public maxSupply;
    bool minted;
    uint256 amount = 1;
    string CatA = "whiteCat";
    string CatB = "blackCat";
    string whiteCaTokenURI = "https://ipfs.io/ipfs/QmQfXRk7gy2WYx5y23XRb6CLZwF3LRoiSQ2vr2DY9oLPYJ";
    string blackCaTokenURI = "https://ipfs.io/ipfs/QmU4rwXth8TXxGWHmDPXNAcSpJxQKyt6tz9KFm1VmsJgH2z";

    //Enum
    enum NFTColour {
        whiteCat,
        blackCat
    }


    //Errors
    error Catties_canOnlyMintOnce();
    error Cattie_mintCapReached(uint256 maxSupply);

    // Modifier
    modifier mintedAlready() {
        if (mintedUser[msg.sender]) revert Catties_canOnlyMintOnce();
        _;
    }

    modifier limitedSupply() {
        if(tokenCounter >= maxSupply) revert Cattie_mintCapReached(maxSupply);
        _;
    }

    mapping(uint256 cattieID => string tokenURI) public s_cattieMinted;
    mapping(address user => bool) public mintedUser;

    constructor(uint256 _maxSupply) ERC721("catties", "CAT") {
        maxSupply = _maxSupply;
    }

    function mintCattie(NFTColour catColour) public limitedSupply mintedAlready {
        if (catColour == NFTColour.whiteCat) {
            s_cattieMinted[tokenCounter] = whiteCaTokenURI;
        } else if (catColour == NFTColour.blackCat) {
            s_cattieMinted[tokenCounter] = blackCaTokenURI;
        }
        _safeMint(msg.sender, tokenCounter);
        mintedUser[msg.sender] = true;
        tokenCounter++;
    }
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 cattieId) public view override returns(string memory){
        string memory imageURL;
        if(keccak256(abi.encodePacked(s_cattieMinted[cattieId])) == keccak256(abi.encodePacked(whiteCaTokenURI))) { imageURL = whiteCaTokenURI;} else if (keccak256(abi.encodePacked(s_cattieMinted[cattieId])) == keccak256(abi.encodePacked(blackCaTokenURI)))
        {imageURL = blackCaTokenURI;} 
        return string(abi.encodePacked(_baseURI(),Base64.encode(bytes(abi.encodePacked('{"name":"', name(),'", "description": "A tokenized cat image dedicated for cat lovers", ','"attributes":[{"trait_type": "cuteness"}], "imageURL"', imageURL,'"}')))));
    }

    function getBalance(address user) public view returns (uint256) {
        return balanceOf(user);
    }
     function getMaxSupply() external view returns(uint256){
        return maxSupply;
     }

}
//data:application/json;base64,eyJuYW1lIjoiY2F0dGllcyIsICJkZXNjcmlwdGlvbiI6ICJBIHRva2VuaXplZCBjYXQgaW1hZ2UgZGVkaWNhdGVkIGZvciBjYXQgbG92ZXJzIiwgImF0dHJpYnV0ZXMiOlt7InRyYWl0X3R5cGUiOiAiY3V0ZW5lc3MifV0sICJpbWFnZVVSTCJodHRwczovL2lwZnMuaW8vaXBmcy9RbVFmWFJrN2d5MldZeDV5MjNYUmI2Q0xad0YzTFJvaVNRMnZyMkRZOW9MUFlKIn0=
//data:application/json;base64,eyJuYW1lIjoiY2F0dGllcyIsICJkZXNjcmlwdGlvbiI6ICJBIHRva2VuaXplZCBjYXQgaW1hZ2UgZGVkaWNhdGVkIGZvciBjYXQgbG92ZXJzIiwgImF0dHJpYnV0ZXMiOlt7InRyYWl0X3R5cGUiOiAiY3V0ZW5lc3MifV0sICJpbWFnZVVSTCJodHRwczovL2lwZnMuaW8vaXBmcy9RbVU0cndYdGg4VFh4R1dIbURQWE5BY1NwSnhRS3l0NnR6OUtGbTFWbXNKZ0gyeiJ9