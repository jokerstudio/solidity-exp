// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.11;

interface IStorage {
    
    function setA(uint) external returns (uint);
}

contract Storage is IStorage {
    uint public a = 0;
    
    function setA(uint _a) public returns (uint) {
        a = _a;
        return a;
    }
}

contract ExistingWithoutABI  {
    
    address dc;
    
    constructor(address _t) {
        dc = _t;
    }

    function setA_Interface(uint _val) external returns(uint){
        return IStorage(dc).setA(_val);
    }
    
    function setA_Selector(uint _val) external returns(bytes memory){
        bytes memory payload = abi.encodeWithSelector(bytes4(keccak256("setA(uint256)")), _val);
        (bool success, bytes memory returnData) = dc.call(payload);
        require(success);
        return returnData;
    }

    function setA_Signature(uint _val) external returns(bytes memory){
        bytes memory payload = abi.encodeWithSignature("setA(uint256)", _val);
        (bool success, bytes memory returnData) = dc.call(payload);
        require(success);
        return returnData;
    }

    function setA_Assembly(uint _val) external returns(bytes32 answer){
        bytes4 sig = bytes4(keccak256("setA(uint256)"));
        assembly {
            // move pointer to free memory spot
            let ptr := mload(0x40)
            // put function sig at memory spot
            mstore(ptr,sig)
            // append argument after function sig
            mstore(add(ptr,0x04), _val)

            let result := call(
              15000, // gas limit
              sload(0x00),  // to addr. append var to _slot to access storage variable
              0, // not transfer any ether
              ptr, // Inputs are stored at location ptr
              0x24, // Inputs are 36 bytes long
              ptr,  //Store output over input
              0x20) //Outputs are 32 bytes long
            
            if eq(result, 0) {
                revert(0, 0)
            }

            answer := mload(ptr) // Assign output to answer var
            mstore(0x40,add(ptr,0x24)) // Set storage pointer to new space
        }
    }

    function setA_FunctionSelector(uint _val) external returns(bytes memory){
        bytes memory payload = abi.encodeWithSelector(IStorage.setA.selector, _val);
        (bool success, bytes memory returnData) = dc.call(payload);
        require(success);
        return returnData;
    }
}