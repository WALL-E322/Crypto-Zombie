pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }
// calldata is somehow similar to memory, but it's only available to external functions.
  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }
 /*view functions don't cost any gas when they're called externally by a user.
This is because view functions don't actually change anything on the blockchain – they only read the data.*/

/*If a view function is called internally from another function in the same contract that is not a view function, it will still cost gas.
 This is because the other function creates a transaction on Ethereum, and will still need to be verified from every node.
  So view functions are only free when they're called externally.*/

  function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
    /*You can use the memory keyword with arrays to create a new array inside a function without needing to write anything to storage.
     The array will only exist until the end of the function call, and this is a lot cheaper gas-wise than updating an array in storage —
      free if it's a view function called externally.

    memory arrays must be created with a length argument. They currently cannot be resized like storage arrays can with array.push() */
    uint[] memory result = new uint[](ownerZombieCount[_owner]);

    uint counter = 0;
    for(uint i = 0 ; i < zombies.length ; i++){
      if(zombieToOwner[i] == _owner){
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
