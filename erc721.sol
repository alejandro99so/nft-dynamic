// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract MyNFT is ERC721, ERC721Pausable, Ownable, ERC721Burnable {
    uint256 private _nextTokenId;
    mapping(uint256 => string) private _tokenURIs;

    constructor(address initialOwner)
        ERC721("MyNFT", "MNFT")
        Ownable(initialOwner)
    {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to, string memory tokenURI_) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI_);
    }

    function _setTokenURI(uint256 tokenId, string memory tokenURI_) internal {
        require(_nextTokenId >= tokenId, "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = tokenURI_;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_nextTokenId >= tokenId, "ERC721Metadata: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }
}