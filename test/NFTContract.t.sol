// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/NFTContract.sol";

contract ContractTest is Test {
    
    NFTContract nftContract;
    address owner = address(0x1234);
    address account1 = address(0x1111);
    address account2 = address(0x7777);
    uint mintPrice = 0.01 ether;

    function setUp() public {
        //Setting the owner as the deployer of the contract
        vm.startPrank(owner);
        nftContract = new NFTContract();
        vm.stopPrank();
    }

    function testFailMaxSupply() public {
        //Setting account1 as the caller of the mint function
        vm.startPrank(account1);
        //Giving account1 a balance of 1.1 ether
        vm.deal(account1, 1.1 ether);
        //Looping and calling mint function 101 times
        for(uint i = 0; i < 101; i++){
            nftContract.mint{value: mintPrice}();
        }
        vm.stopPrank();

    }

    function testFailMintPrice() public {
        //Setting account2 as the caller of the mint function
        vm.startPrank(account2);
        //Giving account2 a balance of 1 ether;
        vm.deal(account2, 1 ether);
        //Minting with provided amount twice less than the mint price
        nftContract.mint{value: mintPrice / 2}();
        vm.stopPrank();
    
    }

    function testFailMaxPerTransaction() public {
        //Setting account1 as the caller of the mint function
        vm.startPrank(account1);
        //Giving account1 a balance of 1 ether;
        vm.deal(account1, 1 ether);
        //Minting 6 NFTs in one transaction
        nftContract.mint{value: mintPrice * 6}(6);
        vm.stopPrank();

    }
    
    function testOwnerWithdraw() public {
        //Setting account2 as the caller of the mint function
        vm.startPrank(account2);
        //Giving account2 a balance of 1 ether;
        vm.deal(account2, 1 ether);
        //Minting 1 NFT
        nftContract.mint{value: mintPrice}();
        vm.stopPrank();
        
        //Minted 1 NFT => balance of contract = 0.01 ether

        //Setting owner as the caller of the withdraw function
        vm.startPrank(owner);
        //Calling withdraw function
        nftContract.withdraw();
        vm.stopPrank();

        //Asserting that owner has a balance of 0.01 ether
        assertEq(owner.balance, 0.01 ether);
                
    }
    
    function testCanMintCorrectly() public {
        
        //Minting 1 NFT with account1
        vm.startPrank(account1);
        vm.deal(account1, 1 ether);
        nftContract.mint{value: mintPrice}();
        vm.stopPrank();

        //Minting 3 NFts with account2
        vm.startPrank(account2);
        vm.deal(account2, 1 ether);
        nftContract.mint{value: mintPrice * 3}(3);
        vm.stopPrank();

        //Checking their balances after minting
        assertEq(nftContract.balanceOf(account1), 1);
        assertEq(nftContract.balanceOf(account2), 3);

    }


}
