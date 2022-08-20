// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/NFTContract.sol";

///@title Testing NFTContract with Foundry
///@author John Nguyen
contract ContractTest is Test {
    
    ///@notice Initiating NFT-contract
    NFTContract nftContract;

    ///@notice Setting accounts for testing
    address owner = address(0x1234);
    address account1 = address(0x1111);
    address account2 = address(0x7777);

    ///@notice Mint Price of 1 NFT
    uint mintPrice = 0.01 ether;

    ///@notice Deploying NFT contract
    ///@dev The deployer of the contract is set to owner address
    function setUp() public {
        vm.startPrank(owner);

        nftContract = new NFTContract();

        vm.stopPrank();
    }

    ///@notice Testing Max Supply
    ///@dev Minting 101 NFTs => reverts with Error
    function testFailMaxSupply() public {
        vm.startPrank(account1);

        vm.deal(account1, 1.1 ether);
        for(uint i = 0; i < 101; i++){
            nftContract.mint{value: mintPrice}();
        }

        vm.stopPrank();
    }

    ///@notice Testing Mint Price
    ///@dev Minting NFT, but sending less ETH => reverts with Error
    function testFailMintPrice() public {
        //Setting account2 as the caller of the mint function
        vm.startPrank(account2);
        //Giving account2 a balance of 1 ether;
        vm.deal(account2, 1 ether);
        //Minting with provided amount twice less than the mint price
        nftContract.mint{value: mintPrice / 2}();
        vm.stopPrank();
    }

    ///@notice Testing Max NFTs per Transaction
    ///@dev Minting 6 NFTs => reverts with Error
    function testFailMaxPerTransaction() public {
        vm.startPrank(account1);
        vm.deal(account1, 1 ether);
        
        nftContract.mint{value: mintPrice * 6}(6);
        
        vm.stopPrank();
    }
    
    ///@notice Testing if owner can withdraw funds from contract 
    ///@dev Minting an NFT with account2 and calling withdraw with owner
    function testOwnerWithdraw() public {
        vm.startPrank(account2);
        vm.deal(account2, 1 ether);

        nftContract.mint{value: mintPrice}();

        vm.stopPrank();
        
        vm.startPrank(owner);

        nftContract.withdraw();

        vm.stopPrank();

        assertEq(owner.balance, 0.01 ether);
    }

    ///@notice Testing single NFT minting and batch NFT minting
    ///@dev Minting 1 NFT with account1 and Mintting 3 NFTs with account2
    function testCanMintCorrectly() public {        
        vm.startPrank(account1);
        vm.deal(account1, 1 ether);

        nftContract.mint{value: mintPrice}();
        
        vm.stopPrank();

        vm.startPrank(account2);
        vm.deal(account2, 1 ether);
        
        nftContract.mint{value: mintPrice * 3}(3);
        
        vm.stopPrank();

        assertEq(nftContract.balanceOf(account1), 1);
        assertEq(nftContract.balanceOf(account2), 3);
    }
}
