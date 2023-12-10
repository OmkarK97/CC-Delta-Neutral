// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/strategies/common/AbstractStrategy.sol";
import "../src/vaults/RiveraAutoCompoundingVaultV2Public.sol";
import "../src/strategies/irs/PdnRivera.sol";
import "../src/strategies/common/interfaces/IStrategy.sol";

import "./Weth.sol";
    
contract BuyTokens is Script {
    address public token = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public wEth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public wMnt = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9;
    address public midToken = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address public router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    uint24 public fees = 500;

    // path[0] = wEth;
    // path[1] = token;

    function setUp() public {}

    function run() public {
        address gaus = 0xFaBcc4b22fFEa25D01AC23c5d225D7B27CB1B6B8;
        uint privateKey = 0xfc2f8cc0abd2d9d05229c8942e8a529d1ba9265eb1b4c720c03f7d074615afbb;
        address acc = vm.addr(privateKey);
        console.log("Account", acc);

        vm.startBroadcast(privateKey);

        Weth(wEth).deposit{value: 5e17}();

        uint256 bW = Weth(wEth).balanceOf(acc);
        IERC20(wEth).approve(router, bW);
        swapTokens(wEth ,token ,bW);

        // uint256 usdcB = IERC20(token).balanceOf(acc);

        // console.log("usdc ", usdcB);
        // IERC20(token).approve(router, usdcB);
        // _swapV3In(token, wEth, usdcB, fees);

        console.log("eth", IERC20(token).balanceOf(acc));

        vm.stopBroadcast();
    }

    function swapTokens(
        address tokenA,
        address tokenB,
        uint256 amountIn
    ) public {
        address[] memory path = new address[](2);
        path[0] = tokenA;
        path[1] = tokenB;

        IPancakeRouter02(router).swapExactTokensForTokens(
            amountIn,
            0,
            path,
            0x69605b7A74D967a3DA33A20c1b94031BC6cAF27c,
            block.timestamp * 2
        );
    }

    // function _swapV3In(
    //     address tokenIn,
    //     address tokenOut,
    //     uint256 amountIn,
    //     uint24 fee
    // ) public returns (uint256 amountOut) {
    //     amountOut = IV3SwapRouter(router).exactInputSingle(
    //         IV3SwapRouter.ExactInputSingleParams(
    //             tokenIn,
    //             tokenOut,
    //             fee,
    //             0x69605b7A74D967a3DA33A20c1b94031BC6cAF27c,
    //             block.timestamp * 2,
    //             amountIn,
    //             0,
    //             0
    //         )
    //     );
    // }
}

// forge script scripts/BuyTokens.s.sol:BuyTokens --rpc-url http://127.0.0.1:8545/ --broadcast -vvv --legacy --slow

// forge script scripts/BuyTokens.s.sol:BuyTokens --rpc-url http://13.232.85.53:8545/  --broadcast -vvv --legacy --slow