// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vault}from "../src/Vault.sol";
import {TokenDeposit} from "../src/TokenDeposit.sol";

contract VaultTest is Test {
    Vault public vault;
    TokenDeposit public tokenDeposit;

    address public user = makeAddr("user1");
    address public user2 = makeAddr("user2");
    address public user3 = makeAddr("user3");

    function setUp() public {
        tokenDeposit = new TokenDeposit("Token Deposit", "TD");
        vault = new Vault(address(tokenDeposit));

        tokenDeposit.transfer(user, 100);
        tokenDeposit.transfer(user2, 100);
        tokenDeposit.transfer(user3, 100);
    }

    function test_Deposit() external {
        uint256 initialBalance = tokenDeposit.balanceOf(user);
        uint256 depositAmount = 50;

        vm.startPrank(user);
        tokenDeposit.approve(address(vault), depositAmount);
        vault.deposit(depositAmount);
        vm.stopPrank();

        assertEq(tokenDeposit.balanceOf(user), initialBalance - depositAmount);
        assertEq(vault.balanceOf(user), depositAmount);
    }

    function test_Withdraw() external {
        uint256 depositAmount = 50;
        uint256 withdrawAmount = 30;

        vm.startPrank(user);
        tokenDeposit.approve(address(vault), depositAmount);
        vault.deposit(depositAmount);
        
        uint256 initialVaultBalance = vault.balanceOf(user);
        vault.withdraw(withdrawAmount);
        vm.stopPrank();

        assertEq(vault.balanceOf(user), initialVaultBalance - withdrawAmount);
        assertEq(tokenDeposit.balanceOf(user), 100 - depositAmount + withdrawAmount);
    }

    function test_WithdrawFail() external {
        uint256 depositAmount = 50;
        uint256 withdrawAmount = 60;

        vm.startPrank(user);
        tokenDeposit.approve(address(vault), depositAmount);
        vault.deposit(depositAmount);
        
        vm.expectRevert();
        vault.withdraw(withdrawAmount);
        vm.stopPrank();
    }
}
