// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import './interfaces/IPartyAggregator.sol';
import 'hardhat/console.sol';

contract PartyAggregator is IPartyAggregator {
  enum partyVerdict {
    Pending,
    Possitive,
    Negative
  }

  struct Proposal {
    /// @notice Unique id for looking up a proposal
    uint256 id;
    /// @notice Creator of the proposal
    address proposer;
    /// @notice The timestamp that the proposal will be available for execution, set once the vote succeeds.
    uint256 eta;
    /// @notice the ordered list of target addresses for calls to be made.
    address[] targets;
    /// @notice The ordered list of values (i.e. msg.value) to be passed to the calls to be made.
    uint256[] values;
    /// @notice The ordered list of function signatures to be called.
    string[] signatures;
    /// @notice The ordered list of calldata to be passed to each call.
    string[] calldatas;
    /// @notice The timestamp at which voting ends: votes must be cast prior to this timestamp.
    uint256 endTimestamp;
    /// @notice Current number of votes in favor of this proposal.
    uint256 forVotes;
    /// @notice Current number of votes in opposition to this proposal.
    uint256 againstVotes;
    /// @notice Current number of votes for abstaining for this proposal.
    uint256 abstainVotes;
    /// @notice Flag marking whether the proposal has been canceled.
    bool canceled;
    /// @notice Flag marking whether the proposal has been executed.
    bool executed;
    /// @notice The state of the guild's response about the particular proposal
    partyVerdict partyVerdict;
    /// @notice The timestamp at which voting starts: votes must be cast after this timestamp.
    uint256 startTimestamp;
  }

  struct Party {
    /// @notice id of party
    uint256 id;
    /// @notice name of party
    string name;
    /// @notice list of addresses delegated to this party
    address[] delegators;
    /// @notice list of tokens which the party operates on
    address[] token;
    /// @notice threshold of minimum token value for users to be able to join this party
    uint256 threshold;
    /// @notice current number of proposals
    uint256 proposalCount;
    /// @notice owner of party
    address owner;
  }

  uint256 private _partyCount = 0;
  uint8 constant MAX_PARTY_TOKENS = 10;
  uint40 constant PROPOSAL_DURATION = 1 weeks;
  uint256 private _delegatorThreshold;

  /// @notice party id => Party
  mapping(uint256 => Party) private _parties;
  /// @notice user => party ids
  mapping(address => uint256[]) private _usersParties;

  function createParty(string memory name, address _token) external {
    if (isDelegateOf(msg.sender, _token)) revert AlreadyHasAParty();
    _partyCount = _partyCount + 1;
    uint256 count = _partyCount;
    address[] memory users = new address[](1);
    address[] memory tokens = new address[](1);
    tokens[0] = _token;
    users[0] = msg.sender;

    _parties[count] = Party({id: count, name: name, delegators: users, token: tokens, threshold: 0, proposalCount: 0, owner: msg.sender});
    _usersParties[msg.sender].push(count);

    emit PartyCreated(count, name);
  }

  function joinParty(uint256 id) external {
    if (id > partyCount()) revert DoesntExist();
    Party storage party = _parties[id];
    if (isDelegateOfAnyToken(msg.sender, party.token)) revert AlreadyHasAParty();

    _usersParties[msg.sender].push(id);
    party.delegators.push(msg.sender);

    emit JoinedParty(party.id, msg.sender);
  }

  function leaveParty(uint256 id) external {
    if (id > partyCount()) revert DoesntExist();
    Party storage party = _parties[id];
    if (!isDelegateOfAnyToken(msg.sender, party.token)) revert NotDelegator();
    (uint pIndex, uint uIndex) = _getIndex(msg.sender, id);
    _usersParties[msg.sender][uIndex] = _usersParties[msg.sender][_usersParties[msg.sender].length - 1];
    party.delegators[pIndex] = party.delegators[party.delegators.length - 1];
    party.delegators.pop();
    _usersParties[msg.sender].pop();
  }

  // View functions
  function _getIndex(address user, uint id) internal view returns (uint pIndex, uint uIndex) {
    Party memory party = _parties[id];
    uint[] memory list = _usersParties[msg.sender];
    for(uint i = 0; i<list.length;i++) {
        if(list[i] == id) uIndex = i;
    }

    for(uint i = 0; i<list.length;i++) {
        if(party.delegators[i] == user) pIndex = i;
    }

    return (pIndex,uIndex);
  }

  function userParties(address user) public view returns (uint[] memory) {
    return _usersParties[user];
  }

  function isDelegateOf(address _user, address _token) public view returns (bool) {
    uint256[] memory list = _usersParties[_user];
    for (uint256 i = 0; i < list.length; i++) {
      Party memory party = _parties[list[i]];
      for (uint256 j = 0; j < party.token.length; j++) {
        if (_token == party.token[j]) return true;
      }
    }
    return false;
  }

  function isDelegateOfAnyToken(address _user, address[] memory _token) public view returns (bool) {
    uint256[] memory list = _usersParties[_user];
    for (uint256 i = 0; i < list.length; i++) {
      Party memory party = _parties[list[i]];
      for (uint256 j = 0; j < party.token.length; j++) {
        for (uint256 z = 0; z < _token.length; z++) {
          if (_token[z] == party.token[j]) return true;
        }
      }
    }
    return false;
  }

  function partyCount() public view returns (uint256) {
    return _partyCount;
  }

  function parties(uint256 id)
    public
    view
    returns (
      string memory name,
      address[] memory delegators,
      address[] memory token,
      uint256 threshold,
      uint256 proposalCount,
      address owner
    )
  {
    Party memory party = _parties[id];
    return (
      name = party.name,
      delegators = party.delegators,
      token = party.token,
      threshold = party.threshold,
      proposalCount = party.proposalCount,
      owner = party.owner
    );
  }
}
