// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract Storage {

    uint256 a;     // slot 0
    uint256[2] b;  // slots 1-2

    struct Entry { // store reverse Ex. extra, value, id
        uint256 value;
        uint256 id;
    }

    Entry c;       // slots 3-4
    Entry[] d;     // slot 5 for length, keccak256(5)+ for data

    mapping(uint256 => uint256) e; // slots 6, keccak256(key, 6)+ for data

    constructor() payable {
        a = 5;
        b[0] = 1;
        b[1] = 2;
        c = Entry({id:1, value:2});
        d.push(Entry({id:77, value:8}));
        d.push(Entry({id:9, value:10}));
        d.push(Entry({id:11, value:12}));
        e[0] = 21;
        e[1] = 22;
    }

    function dynamicArrayLocation(uint256 index, uint256 propIndex) public view returns (uint r) {
        uint256 elementSize = 2;
        uint256 slot = 0x5;
        bytes32 location = keccak256(abi.encode(slot)); // access location in solidity  
        assembly {
            mstore(0x0, 0x5)
            let local := keccak256(0x0, 32)
            r := sload(add(local, add(mul(index, elementSize), propIndex)))
        }
    }

    function dynamicArrayLenght(uint256 slot) public view returns (uint256 r) {
        uint256 location = slot;
        assembly {
            r := sload(location)
        }
    }

    function mapLocation(uint256 slot, uint256 key) public view returns (uint256 r) {
        bytes32 location = keccak256(abi.encode(key, slot)); // access location in solidity
        assembly {
            mstore(0x80, key)
            mstore(0xa0, slot)
            let local := keccak256(0x80, 64)
            r := sload(local)
        }
    }

    function getCaller() public view returns (bytes32) {
        assembly {
            mstore(0x80, caller())
            return(0x80, 32)
        }
    }
}
