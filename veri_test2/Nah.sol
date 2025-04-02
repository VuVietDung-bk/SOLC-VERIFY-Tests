// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

/// @notice invariant x == y
contract C {
    int x;
    int y;

    constructor(){
        x = 10;
        y = 10;
    }

    /// @notice precondition x == y
    /// @notice postcondition x == y + n
    function add_to_x(int n) internal {
        x = x + n;    
        require(x >= y);
    }

    function add(int n) public {
        require(n >= 0);
        add_to_x(n);
        /// @notice invariant y <= x
        while (y < x) {
            y = y + 1;
        }
    }
}