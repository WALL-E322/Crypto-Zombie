// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.6.0;

 
contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string memory _name, uint _dna) private {
    
      /*array.push() returns a uint of the new length of the array and since the first item in an array has index 0,
        array.push() - 1 will be the index of the zombie we just added.*/
        
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        emit NewZombie(id, _name, _dna);
 
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
    
      /*Ethereum has the hash function keccak256 built in, which is a version of SHA3.
        A hash function basically maps an input into a random 256-bit hexadecimal number.
        keccak256 expects a single parameter of type bytes. This means that we have to "pack" any parameters*/
        
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        
        return rand % dnaModulus; //Because we want our DNA to only be 16 digits long

    }

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}