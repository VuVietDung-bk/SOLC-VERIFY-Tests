// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma abicoder v2;

contract ERC4337Factory {
    address public immutable implementation;

    constructor(address erc4337) payable {
        implementation = erc4337;
    }

    function createAccount(bytes[] memory owners) public payable virtual returns (address account) {
        account = address(new ERC4337Account());
        ERC4337Account(payable(account)).initialize(owners);
    }

}

contract ERC4337Account {

    uint8 nextOwnerIndex;
    uint8 dummy = 0;
    mapping(uint8 => bytes) ownerAtIndex;
    mapping(bytes => bool) isOwner;

    constructor(){
        nextOwnerIndex = 0;
    }

    function isOwnerBytes(
        bytes memory account
    ) public view returns (bool) {
        return isOwner[account];
    }

    function getNextOwnerIndex() public view returns (uint8) {
        return nextOwnerIndex;
    }

    /// @notice precondition nextOwnerIndex == 0
    /// @notice postcondition nextOwnerIndex == dummy
    function _initializeOwners(bytes[] memory owners) internal {
        dummy = uint8(owners.length);

        /// @notice invariant nextOwnerIndex == i && nextOwnerIndex <= dummy
        for (uint256 i = 0; i < dummy; i++) {
            require(
                owners[i].length == 32 || owners[i].length == 64,
                "Invalid length"
            );

            if (owners[i].length == 32) {
                bytes32 ownerBytes = toBytes32(owners[i]);
                require(
                    uint256(ownerBytes) <= uint256(uint160(-1)),
                    "Invalid address"
                );
            }
            _addOwnerAtIndexNoCheck(owners[i], nextOwnerIndex++);
        }
    }

    function _addOwnerAtIndexNoCheck(
        bytes memory owner,
        uint8 index
    ) internal {
        if (isOwnerBytes(owner)) revert();

        isOwner[owner] = true;
        ownerAtIndex[index] = owner;
    }

    function _power(
        uint256 base,
        uint256 exponent
    ) internal pure returns (uint256 result) {
        result = 1;
        for (uint256 i = 0; i < exponent; i++) {
            result = result * base;
        }
    }

    function toBytes32(bytes memory b) internal pure returns (bytes32 result) {
        require(b.length >= 32, "Insufficient bytes");
        uint256 temp = 0;
        for (uint256 i = 0; i < 32; i++) {
            // Each byte is multiplied by 256^(31 - i) and added to temp.
            temp += uint256(uint8(b[i])) * _power(256, 31 - i);
        }
        result = bytes32(temp);
    }

    function initialize(bytes[] memory owners) public payable virtual {
        if (nextOwnerIndex != 0) {
            revert();
        }

        _initializeOwners(owners);
    }
}