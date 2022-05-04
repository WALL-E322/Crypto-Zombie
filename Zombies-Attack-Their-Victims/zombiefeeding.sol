// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.6.0;

import "./zombiefactory.sol";
 
/*For our contract to talk to another contract on the blockchain that we don't own, first we need to define an interface.

By including this interface in our dapp's code our contract knows what the other contract's functions look like,
 how to call them, and what sort of response to expect.*/
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}
/*your contract can interact with any other contract on the Ethereum blockchain,
 as long they expose those functions as public or external. (and you need the address of the contract you want to interact with)*/

contract ZombieFeeding is ZombieFactory {

  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  KittyInterface kittyContract = KittyInterface(ckAddress);


  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    
    if( keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty")) ){
      /*last 2 unused digits to handle "special" characteristics.
      We'll say that cat-zombies have 99 as their last two digits of DNA*/
      newDna = newDna - newDna % 100 + 99;
    }
    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty" );
  }

}
