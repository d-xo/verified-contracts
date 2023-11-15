// Copyright (C) 2023 dxo, transmissions11
// SPDX-License-Identifier: AGPL-3.0-only
// Adapted from: https://github.com/transmissions11/solmate/blob/e0e9ff05d8aa5c7c48465511f85a6efdf5d5c30d/src/tokens/ERC721.sol

pragma solidity >=0.8.0;

import {Auth} from "src/utils/auth.sol";

abstract contract ERC721 is Auth {

    // --- state ---

    string public name;
    string public symbol;

    mapping(uint256 => address) internal _ownerOf;
    mapping(address => uint256) internal _balanceOf;

    mapping(uint256 => address) public getApproved;
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    event Transfer(address indexed src, address indexed dst, uint256 indexed id);
    event Approval(address indexed src, address indexed dst, uint256 indexed id);
    event ApprovalForAll(address indexed src, address indexed dst, bool approved);

    constructor(string memory name_, string memory symbol_) Auth(msg.sender) {
        name = name_;
        symbol = symbol_;
    }

    // --- metadata ---

    function tokenURI(uint256 id) public view virtual returns (string memory);

    function ownerOf(uint256 id) public view returns (address owner) {
        require((owner = _ownerOf[id]) != address(0), "erc721/not-minted");
    }

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "erc721/zero-address");
        return _balanceOf[owner];
    }

    // --- transfers ---

    function transferFrom(
        address src,
        address dst,
        uint256 id
    ) public virtual {
        require(src == _ownerOf[id], "erc721/wrong-from");
        require(dst != address(0), "erc721/invalid-recipient");
        require(
            msg.sender == src || isApprovedForAll[src][msg.sender] || msg.sender == getApproved[id],
            "erc721/not-authorized"
        );

        _balanceOf[src] -= 1;
        _balanceOf[dst] += 1;
        _ownerOf[id] = dst;
        delete getApproved[id];

        emit Transfer(src, dst, id);
    }

    function safeTransferFrom(
        address src,
        address dst,
        uint256 id
    ) external {
        transferFrom(src, dst, id);

        require(
            dst.code.length == 0 ||
                ERC721TokenReceiver(dst).onERC721Received(msg.sender, src, id, "") ==
                ERC721TokenReceiver.onERC721Received.selector,
            "erc721/unsafe-recipient"
        );
    }

    function safeTransferFrom(
        address src,
        address dst,
        uint256 id,
        bytes calldata data
    ) external {
        transferFrom(src, dst, id);

        require(
            dst.code.length == 0 ||
                ERC721TokenReceiver(dst).onERC721Received(msg.sender, src, id, data) ==
                ERC721TokenReceiver.onERC721Received.selector,
            "erc721/unsafe-recipient"
        );
    }

    // --- delegation ---

    function approve(address dst, uint256 id) external {
        address src = _ownerOf[id];
        require(msg.sender == src || isApprovedForAll[src][msg.sender], "erc721/not-authorized");
        getApproved[id] = dst;
        emit Approval(src, dst, id);
    }

    function setApprovalForAll(address usr, bool approved) external {
        isApprovedForAll[msg.sender][usr] = approved;
        emit ApprovalForAll(msg.sender, usr, approved);
    }

    // --- admin ---

    function mint(address to, uint256 id) external auth {
        require(to != address(0), "erc721/invalid-recipient");
        require(_ownerOf[id] == address(0), "erc721/already-minted");

        _balanceOf[to] += 1;
        _ownerOf[id] = to;

        emit Transfer(address(0), to, id);
    }

    function burn(uint256 id) external auth {
        address owner = _ownerOf[id];

        require(owner != address(0), "erc721/not-minted");

        _balanceOf[owner] -= 1;
        delete _ownerOf[id];
        delete getApproved[id];

        emit Transfer(owner, address(0), id);
    }

    // --- ERC165 ---

    function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f;   // ERC165 Interface ID for ERC721Metadata
    }

}

abstract contract ERC721TokenReceiver {
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external virtual returns (bytes4) {
        return ERC721TokenReceiver.onERC721Received.selector;
    }
}
