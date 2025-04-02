// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

contract Hopeless {
    uint x;
    uint y;
    uint i;

    /// @notice precondition x == 0
    /// @notice precondition y >= 0
    /// @notice postcondition x == y
    function useless() internal {

        /// @notice invariant x == i && i <= y
        for(i = 0; i < y; i++){
            x++;
        }
    }

    function dummy(uint n) public {
        if(n < 0) revert();
        if(x != 0) revert();
        y = n;
        useless();
    }
}
