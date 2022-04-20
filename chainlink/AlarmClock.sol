// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// KeeperCompatible.sol imports the functions from both ./KeeperBase.sol and
// ./interfaces/KeeperCompatibleInterface.sol
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

contract AlarmClock is KeeperCompatibleInterface {
    uint public endTime;
    bool public done;
    address public upkeepAddress;

    constructor(uint endTimeInSeconds, address _upkeepAddress) {
        endTime = block.timestamp + (endTimeInSeconds * 1 seconds);
        upkeepAddress = _upkeepAddress;
    }

    function checkUpkeep(bytes calldata checkData) external override returns (bool upkeepNeeded, bytes memory performData) {
        upkeepNeeded = done == false && block.timestamp >= endTime;
    }

    function performUpkeep(bytes calldata performData) external override {
        require(msg.sender == upkeepAddress, "Permission denied");
        done = true;
    }
}