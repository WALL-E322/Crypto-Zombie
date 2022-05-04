/*A token on Ethereum is basically just a smart contract that follows some common rules —
 namely it implements a standard set of functions that all other token contracts share,
  such as transferFrom(address _from, address _to, uint256 _tokenId) and balanceOf(address _owner).

Internally the smart contract usually has a mapping, mapping(address => uint256) balances,
 that keeps track of how much balance each address has*/

 /*ERC721 tokens are not interchangeable since each one is assumed to be unique, and are not divisible.
  You can only trade them in whole units, and each one has a unique ID. */

pragma solidity >=0.5.0 <0.6.0;

import "./zombieattack.sol";
import "./erc721.sol";
import "./safemath.sol";

// @author WALL_E322
contract ZombieOwnership is ZombieAttack, ERC721 {

  using SafeMath for uint256;

  mapping (uint => address) zombieApprovals;
 
 /*we can't change the function name in ZombieOwnership to something else because we're using the ERC721 token standard,
  which means other contracts will expect our contract to have functions with these exact names defined.

If another contract knows our contract is ERC721-compliant, it can simply talk to us without needing to know anything
 about our internal implementation decisions.*/
  function balanceOf(address _owner) external view returns (uint256) {
      //This function simply takes an address, and returns how many tokens that address owns.
    return ownerZombieCount[_owner];
  }

  function ownerOf(uint256 _tokenId) external view returns (address) {
      //This function takes a token ID (in our case, a Zombie ID), and returns the address of the person who owns it.
    return zombieToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
     ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].sub(1);
    zombieToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    require (zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    zombieApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

/*Remember, with approve the transfer happens in 2 steps:

You, the owner, call approve and give it the _approved address of the new owner, and the _tokenId you want them to take.

The new owner calls transferFrom with the _tokenId. Next, the contract checks to make sure the new owner has been already approved,
and then transfers them the token.*/

}
