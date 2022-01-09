// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// KeeperCompatible.sol imports the functions from both ./KeeperBase.sol and
// ./interfaces/KeeperCompatibleInterface.sol
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

contract AlarmClock is KeeperCompatibleInterface {
    uint public alarmTime;
    bool public done;
    bytes secret;

    constructor(uint endTimeInSeconds, string memory _secret) {
        secret = bytes(_secret);
        alarmTime = block.timestamp + (endTimeInSeconds * 1 seconds);
    }

    function checkUpkeep(bytes calldata checkData) external override returns (bool upkeepNeeded, bytes memory performData) {
        if(keccak256(bytes(secret)) == keccak256(checkData))
        {
            upkeepNeeded = done == false && block.timestamp >= alarmTime;
            performData = bytes(secret);
        }
        else
        {
            upkeepNeeded = false;
        }
    }

    function performUpkeep(bytes calldata performData) external override {
        if(keccak256(bytes(secret)) == keccak256(performData))
        {
            if(done == false) 
            {
                done = true;
            }
        }
    }
}