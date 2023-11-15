// Copyright (C) 2023 Martin Lundfall, dxo

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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

    event Approval(address indexed holder, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    constructor(string memory symbol_, string memory name_) Auth(msg.sender) {
        symbol = symbol_;
        name   = name_;
    }

    // --- Token ---

    function transfer(address dst, uint amt) public returns (bool) {
        transferFrom(msg.sender, dst, amt);
        return true;
    }
    function transferFrom(address src, address dst, uint amt)
        public returns (bool)
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
        require(usr == msg.sender || wards[usr], "not-authorized");
        balanceOf[usr] -= amt;
        totalSupply -= amt;
        emit Transfer(usr, address(0), amt);
    }
}
