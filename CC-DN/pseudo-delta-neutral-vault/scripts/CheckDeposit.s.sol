// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/strategies/common/AbstractStrategy.sol";
import "../src/vaults/RiveraAutoCompoundingVaultV2Public.sol";
import "../src/strategies/irs/PdnRivera.sol";
import "../src/strategies/common/interfaces/IStrategy.sol";

import "./Weth.sol";
import "@pancakeswap-v2-exchange-protocol/interfaces/IPancakeRouter02.sol";

contract CheckDeposit is Script {
    address public vault = 0x47C242E3336a523c2866F6c5c94dE03998064C30;
    address public strategy = 0x9E238Eda182a8d9aB226933f5d30114d33250137;
    address public token = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    function setUp() public {}

    function run() public {
        uint privateKey = 0xfc2f8cc0abd2d9d05229c8942e8a529d1ba9265eb1b4c720c03f7d074615afbb;
        address acc = vm.addr(privateKey);
        console.log("Account", acc);

        uint256 dpDai = 1e7;

        vm.startBroadcast(privateKey);

        IERC20(token).approve(vault, dpDai);

        RiveraAutoCompoundingVaultV2Public(vault).deposit(dpDai, acc);

        console.log(RiveraAutoCompoundingVaultV2Public(vault).totalAssets());
        console.log(RiveraAutoCompoundingVaultV2Public(vault).balanceOf(acc));
        console.log(IERC20(token).balanceOf(acc));
        vm.stopBroadcast();
    }
}

// forge script scripts/CheckDeposit.s.sol:CheckDeposit --rpc-url http://127.0.0.1:8545/ --broadcast -vvv --legacy --slow
