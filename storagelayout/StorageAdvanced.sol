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
        uint64 id;
        uint128 value;
        uint64 extra;
    }

    Entry c;       // slots 3
    Entry[] d;     // slot 4 for length, keccak256(4)+ for data

    mapping(uint256 => uint256) e; // slots 5, keccak256(key, 5)+ for data
    mapping(uint256 => mapping(uint256 => uint256)) f; // slots 6, keccak256(key2, key1, 6)+ for data

    constructor() payable {
        a = 5;
        b[0] = 1;
        b[1] = 2;
        c = Entry({id:1, value:2, extra: 3});
        d.push(Entry({id:77, value:8, extra: 1}));
        d.push(Entry({id:9, value:10, extra: 1}));
        d.push(Entry({id:11, value:12, extra: 1}));
        e[0] = 21;
        e[1] = 22;
        f[0][0] = 99;
        f[0][1] = 100;
    }

    function x() public view returns (bytes32 data) {
        assembly {
            data := sload(0x03)
        }
    }

    function dynamicArrayLocation(uint256 index) public view returns (bytes32 data, uint256 id, uint256 value, uint256 extra) {
        assembly {
            mstore(0x0, 0x4)
            let local := add(keccak256(0x0, 32), index)

            mstore(0x80, sload(local))
            mstore(add(0xa0, 0x18), mload(add(0x80, 24)))
            mstore(add(0xd0, 0x10), mload(add(0x80, 8)))
            mstore(add(0xfa, 0x18), mload(0x80))

            data := mload(0x80)
            id := mload(0xa0)
            value := mload(0xd0)
            extra := mload(0xfa)
        }
    }

    function mapLocation(uint256 slot, uint256 key1, uint256 key2) public view returns (uint256 r) {
        assembly {
            mstore(0x80, key1)
            mstore(0xa0, slot)
            mstore(0xc0, key2)
            let key1local := keccak256(0x80, 64)
            mstore(0xe0, key1local)
            let local := keccak256(0xc0, 64)
            r := sload(local)
        }
    }
}
