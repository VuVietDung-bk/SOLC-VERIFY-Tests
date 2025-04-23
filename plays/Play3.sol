// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;
pragma abicoder v2;

contract Play3 {
    mapping(bytes => bool) isOwner;
    bool dummy;

    constructor() {
        dummy = true;
    }

    function isOwnerBytes(bytes memory account) public view returns (bool) {
        return isOwner[account];
    }

    /// @notice precondition length >= 0
    /// @notice postcondition forall (uint k) !(0 <= k && k < length) || isOwner[owners[k]]
    function initializeOwners(
        bytes[1000] memory owners,
        uint length
    ) public {
        /// @notice invariant forall (uint k) !(0 <= k && k < i) || isOwner[owners[k]]
        for (uint256 i = 0; i < length; i++) {
            bool temp = owners[i].length == 32 || owners[i].length == 64;
            if(!temp) revert();
            _addOwnerAtIndexNoCheck(owners[i]);
        }
    }

    /// @notice postcondition isOwner[owner]
    function _addOwnerAtIndexNoCheck(bytes memory owner) internal {
        if (isOwnerBytes(owner)) revert();

        isOwner[owner] = true;
    }
}
