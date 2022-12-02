// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

interface IPartyAggregator {
  error AlreadyHasAParty();
  error NotDelegator();
  error DoesntExist();
  error PartyExists();
  error IsOwner();

  event PartyCreated(uint256, string);
  event JoinedParty(uint256, address);

  function createParty(string memory, address) external;
  function joinParty(uint256 id) external;


  function isDelegateOf(address, address) external view returns (bool);
  function isDelegateOfAnyToken(address _user, address[] memory _token) external view returns (bool);
  function partyCount() external view returns (uint256);
  function isParty(uint256) external view returns (bool);
}
