// Copyright (C) 2023 dxo, rain
// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity >=0.8.0;

contract Auth {
    mapping (address => uint) public wards;

    event Rely(address indexed usr);
    event Deny(address indexed usr);

    constructor(address usr) {
        wards[usr] = 1;
        emit Rely(usr);
    }

    function rely(address usr) external auth {
        wards[usr] = 1;
        emit Rely(usr);
    }

    function deny(address usr) external auth {
        wards[usr] = 0;
        emit Deny(usr);
    }

    modifier auth {
        require(wards[msg.sender] == 1, "Auth/not-authorized");
        _;
    }
}
