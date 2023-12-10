// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import "../node_modules/@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import "../node_modules/@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import "../node_modules/@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import "./Interfaces/LinkTokenInterface.sol";

contract CrossChainStrat {
    address public link;
    address public router;

    constructor(address _link, address _router) {
        link = _link;
        router = _router;
        LinkTokenInterface(link).approve(router, type(uint256).max);
    }

    function send(
        address receiver,
        string memory someText,
        uint64 destinationChainSelector
    ) external {
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(receiver),
            data: abi.encode(someText),
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: "",
            feeToken: link
        });

        IRouterClient(router).ccipSend(destinationChainSelector, message);
    }
}
