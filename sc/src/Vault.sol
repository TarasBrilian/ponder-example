// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract Vault is ERC20 {
    error AmountCannotBeZero();

    address public owner;
    address public token;

    event Deposit(address user, uint256 amount, uint256 shares);
    event Withdraw(address user, uint256 amount, uint256 shares);

    constructor(address _asetsToken) ERC20("Vault", "VLT") {
        token = _asetsToken;
        owner = msg.sender;
    }

    function deposit(uint256 amount) external {
        if(amount == 0) revert AmountCannotBeZero();
        uint256 shares = 0;
        uint256 totalAsets = IERC20(token).balanceOf(address(this));

        if(totalAsets == 0) {
            shares = amount;
        } else {
            shares = (amount * totalSupply() / totalAsets);
        }

        _mint(msg.sender, shares);
        IERC20(token).transferFrom(msg.sender, address(this), amount);

        emit Deposit(msg.sender, amount, shares);
    }

    function withdraw(uint256 shares) external {
        uint256 totalAsset = IERC20(token).balanceOf(address(this));
        uint256 amount = (shares * totalAsset / totalSupply());

        _burn(msg.sender, shares);
        IERC20(token).transfer(msg.sender, amount);

        emit Withdraw(msg.sender, amount, shares);
    }

    function distributeYield(uint256 amount) external {
        require(msg.sender == owner, "Only owner can distribute the yield");

        IERC20(token).transferFrom(msg.sender, address(this), amount);
    }

}
