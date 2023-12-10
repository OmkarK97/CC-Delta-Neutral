// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TestingLog.sol";

contract testLog is Script {
    function setUp() public {}

    function run() public {
        string
            memory phrases = "disorder pretty oblige witness close face food stumble name material couch planet";

        uint privateKey = vm.deriveKey(phrases, 0);
        uint privateKey2 = vm.deriveKey(phrases, 1);

        address user = vm.addr(privateKey2);

        vm.startBroadcast(privateKey2);
        console.log(user);

        // testingLog ts = new testingLog();

        testingLog ts = testingLog(0xF52d943f40Df903365453ae570e406A06f32035d);
        console.log(ts.count());
        console.log(ts.call());
        ts.convertTrue();
    }
}

// forge script scripts/deployLog.s.sol:testLog --rpc-url https://rpc.sepolia.org  --broadcast -vvv --legacy --slow
