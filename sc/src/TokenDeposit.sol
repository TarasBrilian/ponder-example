// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract TokenDeposit is ERC20 {
    constructor() ERC20("Token Deposit", "TD") {}

    function mint(address to, uint256 amount) external{
        _mint(to, amount);
    }
}
