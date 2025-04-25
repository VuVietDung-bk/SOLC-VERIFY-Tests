// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

contract Play4 {
    bytes[5] owners;
    mapping(bytes => bool) isOwner;

    constructor(){
        owners[0] = "idk";
        owners[1] = "omg";
        owners[2] = "nah";
        owners[3] = "goku";
        owners[4] = "ldha";
    }

    function name() public {
        bytes[1000] memory fakeOwners;
        fakeOwners[0] = "idk";
        fakeOwners[1] = "omg";
        fakeOwners[2] = "nah";
        fakeOwners[3] = "goku";
        fakeOwners[4] = "ldha";
        for(uint i = 0; i < 5; i++){
            syncState(fakeOwners[i], owners[i]);
        }
    }

    function syncState(
        bytes memory memBytes1,
        bytes storage memBytes2
    ) internal {
        
    }
}