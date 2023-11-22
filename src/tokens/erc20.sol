// Copyright (C) 2023 Martin Lundfall, dxo
// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity >=0.8.0;

import {Auth} from "src/utils/auth.sol";

contract ERC20 is Auth {

    // --- ERC20 ---

    uint8  constant public decimals = 18;
    string public name;
    string public symbol;
    uint   public totalSupply;

    mapping (address => uint)                      public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;

    event Approval(address indexed src, address indexed dst, uint amt);
    event Transfer(address indexed src, address indexed dst, uint amt);

    constructor(string memory symbol_, string memory name_) Auth(msg.sender) {
        symbol = symbol_;
        name   = name_;
    }

    // --- Token ---

    function transfer(address dst, uint amt) public returns (bool) {
        return transferFrom(msg.sender, dst, amt);
    }
    function transferFrom(address src, address dst, uint amt) public returns (bool)
    {
        if (src != msg.sender && allowance[src][msg.sender] != type(uint).max) {
            allowance[src][msg.sender] -= amt;
        }
        balanceOf[src] -= amt;
        balanceOf[dst] += amt;
        emit Transfer(src, dst, amt);
        return true;
    }
    function approve(address usr, uint amt) public returns (bool) {
        allowance[msg.sender][usr] = amt;
        emit Approval(msg.sender, usr, amt);
        return true;
    }

    // --- Mint / Burn ---

    function mint(address usr, uint amt) public auth {
        balanceOf[usr] += amt;
        totalSupply += amt;
        emit Transfer(address(0), usr, amt);
    }
    function burn(address usr, uint amt) public {
        require(usr == msg.sender || wards[usr] == 1, "not-authorized");
        balanceOf[usr] -= amt;
        totalSupply -= amt;
        emit Transfer(usr, address(0), amt);
    }

}
