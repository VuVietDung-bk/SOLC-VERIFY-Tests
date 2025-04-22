// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;
pragma abicoder v2;

contract Play3 {
    mapping(bytes => bool) isOwner;

    constructor() {

    }

    function isOwnerBytes(bytes memory account) public view returns (bool) {
        return isOwner[account];
    }

    /// @notice precondition forall (uint k) !(0 <= k && k < length) || (owners[k].length == 32)
    /// @notice precondition length >= 0
    /// @notice postcondition forall (uint k) !(0 <= k && k < length) || isOwner[owners[k]]
    function initializeOwners(
        bytes[1000] memory owners,
        uint length
    ) public {
        /// @notice invariant forall (uint k) !(0 <= k && k < i) || isOwner[owners[k]]
        for (uint256 i = 0; i < length; i++) {
            require(
                owners[i].length == 32 || owners[i].length == 64,
                "Invalid length"
            );
            _addOwnerAtIndexNoCheck(owners[i]);
        }
    }

    /// @notice postcondition isOwner[owner]
    function _addOwnerAtIndexNoCheck(bytes memory owner) internal {
        if (isOwnerBytes(owner)) revert();

        isOwner[owner] = true;
    }

}
