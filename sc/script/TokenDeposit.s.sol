// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {TokenDeposit} from "../src/TokenDeposit.sol";

contract TokenDepositScript is Script {
    TokenDeposit public token;

    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        token = new TokenDeposit();
        console.log("address token:", address(token));

        vm.stopBroadcast();
    }
}
