// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./Interfaces/AutomationCompatibleInterface.sol";

contract testingLog is AutomationCompatibleInterface {
    uint256 public count = 0;
    bool public call;
    event called(uint256 _count);

    constructor() {
        call = true;
    }

    function checkUpkeep(
        bytes calldata checkData
    )
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        bool dec = shouldCall();
        return (dec, bytes(""));
    }

    function performUpkeep(bytes calldata performData) external override {
        convertFalse();
    }

    function shouldCall() public view returns (bool) {
        return call;
    }

    function convertTrue() public {
        call = true;
    }

    function convertFalse() public {
        call = false;
        count = 1000;
    }
}
