// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

///@notice Importing ERC721 standard from Openzeppelin with URI storage functionality
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

///@notice Importing Ownable from Openzeppelin
import "openzeppelin-contracts/contracts/access/Ownable.sol";

///@notice Import a Counter contract from Openzeppelin
import "openzeppelin-contracts/contracts/utils/Counters.sol";

///@title ERC721 contract
///@author John Nguyen | jooohn.eth
///@notice An NFT contract of 100 NFTs
///@dev Tested using Foundry, see test/NFTContract.t.sol
contract NFTContract is ERC721URIStorage, Ownable{
    
    ///@notice Number of NFTs in a collection
    using Counters for Counters.Counter;
    Counters.Counter public tokenIds;

    ///@notice Max Supply of Collection
    uint public constant MAX_SUPPLY = 100;

    ///@notice Mint price of one NFT in ETH
    uint public constant MINT_PRICE = 0.01 ether;

    ///@notice Number of NFTs a user can buy in one transaction
    uint public constant MAX_AMOUNT_PER_TRANSACTION = 5;

    string private constant TOKEN_URI = "ipfs://QmYEhCEARig7Ur1Qkf5YwJtTZmfjTyXWbcDTzi5axqjLaU"; //token uri, metadata uploaded to ipfs using pinata

    ///@notice Name and Sybmbol of the collection
    ///@dev The owner is set to deployer address, according to Ownable contract
    constructor() ERC721("King Street Analytics", "KSA"){}

    ///@notice Function to buy NFTs
    ///@param amount Amount of NFTs a user wants to mint in a single transactio
    ///@dev _safeMint,_setToTokenURI inherited from ERC721URIStorage contract
    function mint(uint amount) public payable {

        require(tokenIds.current() < MAX_SUPPLY, "No NFTs left!");
        require(amount <= MAX_AMOUNT_PER_TRANSACTION, "Not allowed to mint more than 5 NFTs per transaction!");
        require(msg.value == MINT_PRICE * amount, "Not enough ETH!");

        for(uint i = 0; i < amount; i++){

            uint tokenID = tokenIds.current();
            tokenIds.increment();

            _safeMint(msg.sender, tokenID);
            _setTokenURI(tokenID, TOKEN_URI);

        }
    }

    ///@dev Method overloading implemented
    function mint() external payable {
        mint(1);
    }

    ///@notice Function that lets the owner of the contract to receive funds
    function withdraw() external onlyOwner{
        
        (bool success, ) = (msg.sender).call{value: address(this).balance}("");
        require(success, "Tx failed!");
        
    }

}