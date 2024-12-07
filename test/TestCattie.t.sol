//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Cattie} from "../src/Cattie.sol";
import {DeployCattie} from "../script/DeployCattie.s.sol";

contract TestCattie is Test {
    DeployCattie deployer;
    Cattie cattie;
    address public user = makeAddr("user");

    function setUp() external {
        deployer = new DeployCattie();
        cattie = deployer.run();
    }

    function test_mintNft() external {
        vm.prank(user);
        cattie.mintCattie(Cattie.NFTColour(0));
    }

    function test_moreThanOneMint() external {
        vm.startPrank(user);
        cattie.mintCattie(Cattie.NFTColour(0));
        vm.expectRevert(Cattie.Catties_canOnlyMintOnce.selector);
        cattie.mintCattie(Cattie.NFTColour(1));
        vm.stopPrank();
    }

    function test_maxSupply() external view {
        uint256 pressumedMaxSupply = 100;
        uint256 actualMaxSupply = cattie.getMaxSupply();
        assertEq(pressumedMaxSupply, actualMaxSupply);
    }

    bytes32 maxSupply = bytes32(uint256(7));
    uint256 amount = 100;


    function testFail_revertIfMaxSupplyReached() external {
        // vm.store(address(cattie), maxSupply, bytes32(uint256(100)));
        for(uint256 i = 0; i < amount; i++) {
            address M_user = address(uint160(i+1));
             vm.startPrank(M_user);
            cattie.mintCattie(Cattie.NFTColour(0)); 
        }
        address fakeUser = address(0x123);
        vm.expectRevert(Cattie.Cattie_mintCapReached.selector);
        vm.startPrank(fakeUser);
        cattie.mintCattie(Cattie.NFTColour(1)); 
    }
}
