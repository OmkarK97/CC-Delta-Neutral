// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/CrossChainRecis.sol";
import "../src/CrossChainStrat.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract CrossStratSender is Script {
    address public router = 0xD0daae2231E9CB96b94C8512223533293C3693Bf;
    address public link = 0x779877A7B0D9E8603169DdbD7836e478b4624789;
    address public reci = 0x5728376DCB18A8F9A8A16B4f7843fE05DB9e3E5C;
    uint64 public destSe = 12532609583862916517; //mumbai

    function setUp() public {}

    function run() public {
        string
            memory phrases = "disorder pretty oblige witness close face food stumble name material couch planet";

        uint privateKey = vm.deriveKey(phrases, 0);
        uint privateKey2 = vm.deriveKey(phrases, 1);

        address user = vm.addr(privateKey2);

        vm.startBroadcast(privateKey2);
        console.log(user);

        CrossChainStrat rcC = new CrossChainStrat(link, router);

        IERC20(link).transfer(address(rcC), 1e18);
        console.log("address of conract is", address(rcC));

        rcC.send(reci, "Hi", destSe);
        vm.stopBroadcast();
    }
}

// forge script scripts/CrossStratSender.s.sol:CrossStratSender --rpc-url https://rpc.sepolia.org --broadcast -vvv --legacy --slow

/* 
 0xFaBcc4b22fFEa25D01AC23c5d225D7B27CB1B6B8
  address of conract is 0x2b2a92781D8E49755dD1d8334CA68bc7eD6D57d9*/
