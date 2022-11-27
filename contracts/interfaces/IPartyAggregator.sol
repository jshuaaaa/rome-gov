// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

interface IPartyAggregator {
    error AlreadyHasAParty();

    event PartyCreated(uint);

    function createParty(address) external;

    function isDelegateOf(address, address) external view returns (bool);
}