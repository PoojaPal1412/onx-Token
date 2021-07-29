// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import './ONX.sol';
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/TokenTimelock.sol';

contract TokenLock is TokenTimelock{
    constructor(IERC20 token, address beneficiary, uint256 releaseTime)  TokenTimelock(token, beneficiary, releaseTime)
    {}
}