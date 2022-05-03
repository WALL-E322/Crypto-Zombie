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
    /*Storage refers to variables stored permanently on the blockchain.
    Memory variables are temporary, and are erased between external function calls to your contract.

    State variables (variables declared outside of functions) are by default storage and written permanently to the blockchain,
    while variables declared inside functions are memory and will disappear when the function call ends.*/

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    /*internal is the same as private, except that it's also accessible to contracts that inherit from this contract.
    external is similar to public, except that these functions can ONLY be called outside the contract — 
    they can't be called by other functions inside that contract.*/

    function _createZombie(string memory _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        /*In Solidity, there are certain global variables that are available to all functions.
         One of these is msg.sender, which refers to the address of the person (or smart contract) who called the current function.*/
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }

}
