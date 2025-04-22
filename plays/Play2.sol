// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

contract Play2 {
    bytes[5] owners;
    mapping(bytes => bool) isOwner;

    constructor(){
        owners[0] = "idk";
        owners[1] = "omg";
        owners[2] = "nah";
        owners[3] = "goku";
        owners[4] = "ldha";
    }

    /// @notice postcondition forall (uint i) (isOwner[owners[i]]) || (i >= 5) || (i < 0)
    function randomFunction() public {
        /// @notice invariant forall (uint k) !(0 <= k && k < i) || isOwner[owners[k]]
        for(uint i = 0; i < 5; i++){
            isOwner[owners[i]] = true;
        }
    }
}
