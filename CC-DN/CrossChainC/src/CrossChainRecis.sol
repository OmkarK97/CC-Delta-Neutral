// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../node_modules/@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import "../node_modules/@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import "./Interfaces/AutomationCompatibleInterface.sol";

contract CrossChainReci is CCIPReceiver, AutomationCompatibleInterface {
    address public latestSender;
    uint public latestMessage;
    bool public decision;

    constructor(address router) CCIPReceiver(router) {}

    function _ccipReceive(
        Client.Any2EVMMessage memory message
    ) internal override {
        latestSender = abi.decode(message.sender, (address));
        latestMessage = abi.decode(message.data, (uint));
        decision = true;
    }

    function checkUpkeep(
        bytes calldata checkData
    )
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        bool dec = performTask();
        return (dec, bytes(""));
    }

    function performUpkeep(bytes calldata performData) external override {
        if (latestMessage == 1) {
            deposit();
        }
        withdrawLiqui();
    }

    function performTask() public view returns (bool) {
        return decision;
    }

    function deposit() internal {}

    function withdrawLiqui() internal {}
}
