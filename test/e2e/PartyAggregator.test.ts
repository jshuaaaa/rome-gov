import chai, { expect } from 'chai';
import { ethers, waffle, deployments, network } from 'hardhat';
import { utils, BigNumber } from 'ethers';
import { PartyAggregator, PartyAggregator__factory, Token, Token__factory } from '@typechained';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/dist/src/signers';
import { Console, time } from 'console';
import { BlockList } from 'net';
import { create } from 'domain';

const overrides = {
  gasLimit: 9999999,
};

describe('PartyAggregator', function () {
  let deployer: SignerWithAddress;
  let randomUser: SignerWithAddress;
  let user: SignerWithAddress;

  let partyAggFactory: PartyAggregator__factory;
  let tokenFactory: Token__factory;

  let partyAgg: PartyAggregator;
  let token: Token;

  let block;
  let timestamp: number;

  beforeEach(async () => {
    [user, deployer, randomUser] = await ethers.getSigners();

    partyAggFactory = (await ethers.getContractFactory('PartyAggregator')) as PartyAggregator__factory;
    tokenFactory = (await ethers.getContractFactory('Token')) as Token__factory;

    partyAgg = await partyAggFactory.deploy();
    token = await tokenFactory.deploy();

    block = await ethers.provider.getBlockNumber();
    timestamp = (await ethers.provider.getBlock(block)).timestamp as number;
  });

  it('createParty()', async () => {
    await partyAgg.createParty('Chads', token.address);
    const connect = await partyAgg.connect(deployer);
    const count = await partyAgg.partyCount();
    expect(count.toString()).to.equal('1');
    await connect.createParty('Chadsss', token.address);
    await expect(partyAgg.createParty('Chads', token.address)).to.be.revertedWith('AlreadyHasAParty');
  });

  it('joinParty()', async () => {
    await partyAgg.createParty('Chads', token.address);
    const connect = await partyAgg.connect(deployer);
    await connect.joinParty(1);
    const party = await partyAgg.parties(1);
    expect(party.delegators.length).to.equal(2);

    expect(await partyAgg.isDelegateOf(user.address, token.address)).to.equal(true);
    expect(await partyAgg.isDelegateOf(deployer.address, token.address)).to.equal(true);
  });

  it('leaveParty()', async () => {
    await partyAgg.createParty('Chads', token.address);
    const connect = await partyAgg.connect(deployer);
    await connect.joinParty(1);
    await connect.leaveParty(1);
    const party = await partyAgg.parties(1);
    const userParty = await partyAgg.userParties(deployer.address)
    
    expect(party.delegators.length).to.equal(1);
    // Should be empty as user has no parties
    expect(userParty.length).to.equal(0)
  })
});

