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
        vm.startPrank(owner);
        nftContract = new NFTContract();
        vm.stopPrank();
    }

}
