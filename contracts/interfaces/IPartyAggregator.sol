// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

interface IPartyAggregator {
  error AlreadyHasAParty();

  event PartyCreated(uint256);

  function createParty(string memory, address) external;

  function isDelegateOf(address, address) external view returns (bool);

  function partyCount() external view returns (uint256);
}
