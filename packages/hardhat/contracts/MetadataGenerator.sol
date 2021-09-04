// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.7.0;

import 'base64-sol/base64.sol';
import "@openzeppelin/contracts/utils/Strings.sol";
import './HexStrings.sol';
import './ToColor.sol';
/// @title NFTSVG
/// @notice Provides a function for generating an SVG associated with a Uniswap NFT
library MetadataGenerator {

  using Strings for uint256;
  using HexStrings for uint160;
  using ToColor for bytes3;

  function generateSVGofTokenById(uint256 tokenId, bytes3 color, uint256 chubbiness, string memory svgPath, bool isLucky) internal pure returns (string memory) {

    string memory luckyPart = '';
    if(isLucky) {
      luckyPart = '<path d="M128.4,191.8c0,0-0.5-10.4-9.6,0.8c-6,7.4,17.2,11.5,26.2,3.5c8.4-7.4,25.2-0.6,27,5.3c0.2,0.7,0.9,1,1.6,0.8c3.2-0.9,11-2.4,15,2.4c5.1,6,7.8,11.3,11,17.6c3.2,6.3,6.3,13.8,14.6,13.2c8.3-0.6,3-17.3-2.9-11.1c0,0,1.1-4.6,4.8-2.7c3.6,1.9,7.6,7.9,5.9,12.2c-1.7,4.4-4.3,7.9-16.2,9.2c-11.7,1.3-29.6-6.4-39.7-22.5c-0.4-0.6-1.1-0.9-1.7-0.7c-4.7,1.5-23.7,5.7-46.7-12.4c-2.8-2.2-4.8-5.5-5-9.2C112,185.9,130.3,181.7,128.4,191.8L128.4,191.8z"/>';
    }
    string memory svg = string(abi.encodePacked(
      '<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">',
        '<g id="eye1">',
          '<ellipse stroke-width="3" ry="29.5" rx="29.5" id="svg_1" cy="154.5" cx="181.5" stroke="#000" fill="#fff"/>',
          '<ellipse ry="3.5" rx="2.5" id="svg_3" cy="154.5" cx="173.5" stroke-width="3" stroke="#000" fill="#000000"/>',
        '</g>',
        '<g id="head">',
          '<ellipse fill="#',
          color.toColor(),
          '" stroke-width="3" cx="204.5" cy="211.80065" id="svg_5" rx="',
          chubbiness.toString(),
          '" ry="51.80065" stroke="#000"/>',
        '</g>',
        '<g id="eye2">',
          '<ellipse stroke-width="3" ry="29.5" rx="29.5" id="svg_2" cy="168.5" cx="209.5" stroke="#000" fill="#fff"/>',
          '<ellipse ry="3.5" rx="3" id="svg_4" cy="169.5" cx="208" stroke-width="3" fill="#000000" stroke="#000"/>',
        '</g>',
        luckyPart,
        svgPath,
      '</svg>'
    ));

    return svg;
  }

  function tokenURI(uint256 tokenId, bytes3 color, uint256 chubbiness, bool isLucky, string memory svgPath, address owner) internal pure returns (string memory) {

      string memory name = string(abi.encodePacked('Loogie #',tokenId.toString()));
      string memory description = string(abi.encodePacked('This Loogie is the color #',color.toColor(),' with a chubbiness of ',uint2str(chubbiness),'!!!'));
      string memory image = Base64.encode(bytes(generateSVGofTokenById(tokenId, color, chubbiness, svgPath, isLucky)));

      return
          string(
              abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                          abi.encodePacked(
                              '{"name":"',
                              name,
                              '", "description":"',
                              description,
                              '", "external_url":"https://burnyboys.com/token/',
                              tokenId.toString(),
                              '", "attributes": [{"trait_type": "color", "value": "#',
                              color.toColor(),
                              '"},{"trait_type": "chubbiness", "value": ',
                              uint2str(chubbiness),
                              '}], "owner":"',
                              (uint160(owner)).toHexString(20),
                              '", "image": "',
                              'data:image/svg+xml;base64,',
                              image,
                              '"}'
                          )
                        )
                    )
              )
          );
  }

  function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
      if (_i == 0) {
          return "0";
      }
      uint j = _i;
      uint len;
      while (j != 0) {
          len++;
          j /= 10;
      }
      bytes memory bstr = new bytes(len);
      uint k = len;
      while (_i != 0) {
          k = k-1;
          uint8 temp = (48 + uint8(_i - _i / 10 * 10));
          bytes1 b1 = bytes1(temp);
          bstr[k] = b1;
          _i /= 10;
      }
      return string(bstr);
  }

}
