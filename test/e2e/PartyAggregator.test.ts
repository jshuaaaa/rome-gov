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
    await connect.createParty('Chads', token.address);
    await expect(partyAgg.createParty('Chads', token.address)).to.be.revertedWith('AlreadyHasAParty');
  });
});
