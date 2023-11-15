// Copyright (C) 2023 dxo, rain

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

contract Auth {
    mapping (address => bool) public wards;

    event Rely(address indexed usr);
    event Deny(address indexed usr);

    constructor(address usr) {
        wards[usr] = true;
        emit Rely(usr);
    }

    function rely(address usr) external auth {
        wards[usr] = true;
        emit Rely(usr);
    }

    function deny(address usr) external auth {
        wards[usr] = false;
        emit Deny(usr);
    }

    modifier auth {
        require(wards[msg.sender], "Auth/not-authorized");
        _;
    }
}
