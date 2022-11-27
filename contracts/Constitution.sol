// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract Constitution {
    address[] private _signedTokens;
    mapping(address => address[]) private boardMembers;

    function signConstitution(address token) external {
        _signedTokens.push(token);
    }
}