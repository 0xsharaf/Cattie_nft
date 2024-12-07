//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Cattie} from "../src/Cattie.sol";

contract DeployCattie is Script {
    Cattie cattie;
    uint256 maxSupply = 100;

    function run() external returns (Cattie) {
        vm.startBroadcast();
        cattie = new Cattie(maxSupply);
        vm.stopBroadcast();
        return cattie;
    }
}
