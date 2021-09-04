pragma solidity >=0.6.0 <0.7.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./EIP2771Context.sol";
//learn more: https://docs.openzeppelin.com/contracts/3.x/erc721

import "./MetadataGenerator.sol";
// GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract YourCollectible is ERC721, Ownable, EIP2771Context {

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor(address trustedForwarder) public ERC721("PLoogies", "PLOOG") EIP2771Context(trustedForwarder){
    // RELEASE THE LOOGIES!
  }

  function _msgSender() internal view override(Context, EIP2771Context) returns (address payable) {
    return EIP2771Context._msgSender();
  }

  mapping (uint256 => bytes3) public color;
  mapping (uint256 => uint256) public chubbiness;

  uint256 mintDeadline = block.timestamp + 24 hours;

  function mintItem()
      public
      returns (uint256)
  {
      require( block.timestamp < mintDeadline, "DONE MINTING");
      _tokenIds.increment();

      uint256 id = _tokenIds.current();
      _mint(_msgSender(), id);

      bytes32 predictableRandom = keccak256(abi.encodePacked( blockhash(block.number-1), _msgSender(), address(this) ));
      color[id] = bytes2(predictableRandom[0]) | ( bytes2(predictableRandom[1]) >> 8 ) | ( bytes2(predictableRandom[2]) >> 16 );
      chubbiness[id] = 35+((55*uint256(uint8(predictableRandom[3])))/255);

      return id;
  }

  function tokenURI(uint256 id) public view override returns (string memory) {
      require(_exists(id), "not exist");
      return MetadataGenerator.tokenURI( ownerOf(id), id, color[id], chubbiness[id] );
  }
}
