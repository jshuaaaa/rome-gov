// @ts-ignore
import { ethers } from 'ethers';

export const networkConfig = function (chainId: number) {
  if (chainId == 5) {
    return {
      name: 'goerli',
      vrfCoordinatorV2: '0x2ca8e0c643bde4c2e08ab1fa0da3401adad7734d', // address for goerli
      gasLane: '0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15',
      subId: '6326',
      gasLimit: '500000000',
    };
  }

  return {
    name: 'hardhat',
    vrfCoordinatorV2: '',
    gasLane: '0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15',
    gasLimit: '500000000',
  };
};

export const developmentChains = ['hardhat', 'localhost'];
