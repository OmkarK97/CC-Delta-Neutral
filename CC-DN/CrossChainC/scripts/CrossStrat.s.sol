// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/CrossChainRecis.sol";
import "../src/CrossChainStrat.sol";

contract CrossStrat is Script {
    address public router = 0x70499c328e1E2a3c41108bd3730F6670a44595D1;
    address public mesg;

    function setUp() public {}

    function run() public {
        string
            memory phrases = "disorder pretty oblige witness close face food stumble name material couch planet";

        uint privateKey = vm.deriveKey(phrases, 0);
        uint privateKey2 = vm.deriveKey(phrases, 1);

        address user = vm.addr(privateKey2);

        vm.startBroadcast(privateKey2);
        console.log(user);

        CrossChainReci rcC = new CrossChainReci(router);

        console.log("address of conract is", address(rcC));
        vm.stopBroadcast();
    }
}

// forge script scripts/CrossStrat.s.sol:CrossStrat --rpc-url https://rpc.ankr.com/polygon_mumbai --broadcast -vvv --legacy --slow

/* 
0xFaBcc4b22fFEa25D01AC23c5d225D7B27CB1B6B8
  address of conract is 0x5728376DCB18A8F9A8A16B4f7843fE05DB9e3E5C */
