// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Vault} from "../src/Vault.sol";

contract VaultScript is Script {
    Vault public vault;

    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        vault = new Vault(0x886aD109ca35c7B5cf7017aF9F5b2C3306A666f9);
        console.log("address vault:", address(vault)); //0xD1fECB135eE971F7DB0a1B0506e9DC1dD1532b1C

        vm.stopBroadcast();
    }
}
