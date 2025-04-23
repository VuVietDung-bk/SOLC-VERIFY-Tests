// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma abicoder v2;

contract ERC4337Factory {
    address public immutable implementation;

    constructor(address erc4337) payable {
        implementation = erc4337;
    }

    function createAccount(
        bytes[1000] memory owners,
        uint length
    ) public payable virtual returns (address account) {
        require(length <= 1000 && length >= 0);
        account = address(new ERC4337Account());
        ERC4337Account(payable(account)).initialize(owners, length);
    }
}

contract ERC4337Account {
    uint8 public nextOwnerIndex;
    uint dummy = 0;
    mapping(uint8 => bytes) ownerAtIndex;
    mapping(bytes => bool) isOwner;

    constructor() {
        nextOwnerIndex = 0;
    }

    function isOwnerBytes(bytes memory account) public view returns (bool) {
        return isOwner[account];
    }

    /// @notice precondition nextOwnerIndex == 0
    /// @notice precondition length >= 0
    /// @notice postcondition nextOwnerIndex == dummy
    /// @notice postcondition forall (uint k) !(0 <= k && k < length) || isOwner[owners[k]]
    function _initializeOwners(
        bytes[1000] memory owners,
        uint length
    ) internal {
        dummy = length;

        /// @notice invariant nextOwnerIndex == i && nextOwnerIndex <= dummy
        /// @notice invariant forall (uint k) !(0 <= k && k < i) || isOwner[owners[k]]
        for (uint256 i = 0; i < dummy; i++) {
            require(owners[i].length == 32 || owners[i].length == 64);

            if (owners[i].length == 32) {
                bytes32 ownerBytes = toBytes32(owners[i]);
                require(uint256(ownerBytes) <= uint256(uint160(-1)));
            }
            _addOwnerAtIndexNoCheck(owners[i], nextOwnerIndex++);
        }
    }

    /// @notice postcondition isOwner[owner]
    function _addOwnerAtIndexNoCheck(bytes memory owner, uint8 index) internal {
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

    /// @notice postcondition nextOwnerIndex == dummy
    function initialize(
        bytes[1000] memory owners,
        uint length
    ) public payable virtual {
        require(length <= 1000 && length >= 0);
        if (nextOwnerIndex == 0) {
            _initializeOwners(owners, length);
        }
    }
}

contract Hack {
    ERC4337Factory factory;
    ERC4337Account account;
    mapping(bytes => bool) isOwner;

    constructor() {
        factory = new ERC4337Factory(address(0x046C5E73));
        bytes[1000] memory emptyArray;
        account = ERC4337Account(factory.createAccount(emptyArray, 0));
    }

    /// @notice precondition account.nextOwnerIndex() == 0
    /// @notice postcondition account.nextOwnerIndex() > 0
    /// @notice postcondition forall (uint i) !isOwner[owners[i]] || (i >= 5) || (i < 0)
    /// @notice postcondition forall (uint i) isOwner[fakeOwners[i]] || (i >= 5) || (i < 0)
    function vuln() public {

        bytes[1000] memory fakeOwners;
        bytes[1000] memory owners;

        owners[0] = "idk";
        owners[1] = "omg";
        owners[2] = "nah";
        owners[3] = "goku";
        owners[4] = "ldha";

        fakeOwners[0] = "1";
        fakeOwners[1] = "2";
        fakeOwners[2] = "3";
        fakeOwners[3] = "4";
        fakeOwners[4] = "5";

        account.initialize(fakeOwners, 5);

        account.initialize(owners, 5);

    }


}
