// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract Bunzo is ERC721, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public constant MAX_SUPPLY = 45;

    constructor(string memory name, string memory symbol)
        ERC721(name, symbol)
        Ownable(_msgSender())
    {
        transferOwnership(_msgSender());
    }

    function tokenExists(uint256 tokenId) public view returns (bool) {
        try this.ownerOf(tokenId) returns (address owner) {
            return owner != address(0);
        } catch {
            return false;
        }
    }

    function mintNFT(address to) internal onlyOwner() {
        if (_tokenIds.current() + 1 > MAX_SUPPLY) {
            revert("Max supply reached");
        }
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(to, newTokenId);
    }

    function mintBatch(address[] memory recipients, uint256[] memory tokenIds) public onlyOwner {
        require(recipients.length == tokenIds.length, "recipients and tokenIds length mismatch");
        require(recipients.length > 0, "no recipients");

        for (uint256 i = 0; i < recipients.length; i++) {
            require(!tokenExists(tokenIds[i]), "token already minted");
            _mint(recipients[i], tokenIds[i]);
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://bafybeiekzsvec6snixgvmstldwfzuvtwpaqe3lxq6ymjbkpduma2ixokpa.ipfs.nftstorage.link/";
    }

    function transferFrom(address from, address to, uint256 tokenId) public override
    {
        if (from != address(0)) {
            revert("SoulBound Token: cannot transfer token");
        }
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public override
    {
        if (from != address(0)) {
            revert("SoulBound Token: cannot transfer token");
        }
        super.safeTransferFrom(from, to, tokenId, _data);
    }
}