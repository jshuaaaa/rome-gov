// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import './interfaces/IPartyAggregator.sol';

contract PartyAggregator is IPartyAggregator {

        enum partyVerdict {
            Pending,
            Possitive,
            Negative
        }

    struct Proposal {
        /// @notice Unique id for looking up a proposal
        uint id;
        /// @notice Creator of the proposal
        address proposer;
        /// @notice The timestamp that the proposal will be available for execution, set once the vote succeeds.
        uint eta;
        /// @notice the ordered list of target addresses for calls to be made.
        address[] targets;
        /// @notice The ordered list of values (i.e. msg.value) to be passed to the calls to be made.
        uint[] values;
        /// @notice The ordered list of function signatures to be called.
        string[] signatures;
        /// @notice The ordered list of calldata to be passed to each call.
        bytes[] calldatas;
        /// @notice The timestamp at which voting ends: votes must be cast prior to this timestamp.
        uint endTimestamp;
        /// @notice Current number of votes in favor of this proposal.
        uint forVotes;
        /// @notice Current number of votes in opposition to this proposal.
        uint againstVotes;
        /// @notice Current number of votes for abstaining for this proposal.
        uint abstainVotes;
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
        uint id;
        /// @notice list of addresses delegated to this party
        address[] delegators;
        /// @notice list of tokens which the party operates on
        address[] token;
        /// @notice threshold of minimum token value for users to be able to join this party
        uint threshold;
        /// @notice current number of proposals
        uint proposalCount;
    }

    uint256 private _partyCount = 0;
    uint40 constant PROPOSAL_DURATION = 1 weeks;
    uint private _delegatorThreshold;

    /// @notice party id => Party
    mapping(uint256 => Party) private _parties;
    /// @notice user => party ids
    mapping(address => uint256[]) usersParties;

    function createParty(address _token) external {
        if (isDelegateOf(msg.sender, _token)) revert AlreadyHasAParty();
        _partyCount = _partyCount + 1;
        uint count = _partyCount;
        address[] memory users = new address[](1);
        address[] memory tokens = new address[](1);
        tokens[0] = _token;
        users[0] = msg.sender;

        _parties[count] = Party({
            id: count,
            delegators: users,
            token: tokens,
            threshold: 0,
            proposalCount: 0
        });

        emit PartyCreated(count);
    }

    // View functions
    function isDelegateOf(address _user, address _token) public view returns (bool) {
        uint256[] memory list = usersParties[_user];
        for(uint i = 0; i<list.length; i++) {
            Party memory party = _parties[i];
            if(_token == party.token[i]) return true;
        }
        return false;
    }
}