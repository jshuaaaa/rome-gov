pragma solidity ^0.8.10;

contract PartyProposal {
        
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


    uint256 private _proposalCountl;
    address private _party;
    uint40 constant PROPOSAL_DURATION = 1 weeks;

    constructor(address party) {
        _party = party;
    }
}