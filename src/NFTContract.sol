// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// Importing ERC721URIStorage, Counter and Ownable from Openzeppelin
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/Counters.sol";

contract NFTContract is ERC721URIStorage, Ownable{
    //Creating counter to keep track of the number of NFTs minted
    using Counters for Counters.Counter;
    Counters.Counter public tokenIds;

    //Declaring constant variables
    uint public constant MAX_SUPPLY = 100; //max supply
    uint public constant MINT_PRICE = 0.01 ether; //price of 1 nft
    uint public constant MAX_AMOUNT_PER_TRANSACTION = 5; //max amount of nfts allowed per transaction
    string private constant TOKEN_URI = "ipfs://QmYEhCEARig7Ur1Qkf5YwJtTZmfjTyXWbcDTzi5axqjLaU"; //token uri, metadata uploaded to ipfs using pinata

    //Setting the name and symbol of the NFT
    constructor() ERC721("King Street Analytics", "KSA"){}

    //Mint function
    function mint(uint amount) public payable {
        //Basic requirnments for mint to execute
        require(tokenIds.current() < MAX_SUPPLY, "No NFTs left!");
        require(amount <= MAX_AMOUNT_PER_TRANSACTION, "Not allowed to mint more than 5 NFTs per transaction!");
        require(msg.value == MINT_PRICE * amount, "Not enough ETH!");

        //For loop to mint multiple amounts of NFTs provided by the user
        for(uint i = 0; i < amount; i++){

            uint tokenID = tokenIds.current();
            tokenIds.increment();
            //_safeMint function inherited from ERC721 contract
            _safeMint(msg.sender, tokenID);
            //Setting token URI for each minted NFT
            _setTokenURI(tokenID, TOKEN_URI);

        }
    }

    //Method overloading, called when minting one NFT
    function mint() external payable {
        mint(1);
    }

    //Withdraw function, sends the owner of the contract the amount of money collected from the mints
    function withdraw() external onlyOwner{
        
        (bool success, ) = (msg.sender).call{value: address(this).balance}("");
        require(success, "Tx failed!");
        
    }

}