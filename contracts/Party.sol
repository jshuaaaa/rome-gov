pragma solidity ^0.8.10;

contract Party {
    address private _token;
    uint private _delegatorThreshold;
    
    address[] delegators;

    constructor(address token, uint delegatorThreshold) {
        _token = token;
        _delegatorThreshold = delegatorThreshold;
    }
}