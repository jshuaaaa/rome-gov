// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import './interfaces/ISupremeCourt.sol';
import './PartyAggregator.sol';

contract SupremeCourt is ISupremeCourt {
    struct Council {
        uint256 councilId;
        uint256 partyId;
        address[8] members;
    }  
    
    mapping(uint256 => Council) private _council;
    uint256 private _councilId = 0;
    uint8 constant LENGTH = 8;
    IPartyAggregator private _party;

    constructor(address party) {
        _party = IPartyAggregator(party);
    }

    function createCouncil(uint _partyId, address[8] memory _members) external {
        if(_members.length != LENGTH) revert NotValidLength();
        if(!_party.isParty(_partyId)) revert NotParty();
        _councilId += 1;
        uint256 id = _councilId;
        Council memory council = Council({
            councilId: id,
            partyId: _partyId,
            members: _members
        });
        _council[id] = council;
    }
}
