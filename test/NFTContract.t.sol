// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/NFTContract.sol";

contract ContractTest is Test {
    
    NFTContract nftContract;
    address owner = address(0x1234);
    address account1 = address(0x1111);
    address account2 = address(0x7777);

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
        //Looping and calling mint function 101 times => should lead to an error, since 100 is the max supply
        for(uint i = 0; i < 101; i++){
            nftContract.mint{value: nftContract.MINT_PRICE()}();
        }
        vm.stopPrank();

    }

    
    

}
