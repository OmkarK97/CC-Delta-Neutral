// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/strategies/common/AbstractStrategy.sol";
import "../src/vaults/RiveraAutoCompoundingVaultV2Public.sol";
import "../src/strategies/irs/PdnRivera.sol";
import "../src/strategies/common/interfaces/IStrategy.sol";

import "./Weth.sol";

contract deployVolatile is Script {
    address public usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; // Usdc Eth Mainnet
    address public wEth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; //wEth eth
    address public midToken = 0xdAC17F958D2ee523a2206206994597C13D831ec7; //usdt Eth
    address public wMnt = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9; // Aave mantle
    address public debtToken = 0x5DF9a4BE4F9D717b2bFEce9eC350DcF4cbCb91d8; //Variable debt wEth lendle mantle
    address public aToken = 0xF36AFb467D1f05541d998BBBcd5F7167D67bd8fC; //aUsdc
    address public lendle = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9; //Aave v2  eth mainnet
    address  public pId =
        0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419; //weth id
    address public pIB =
        0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419; //wmnt id

    address public pIusdc =
        0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6; // usdc

    address public lendingPool = 0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9; // mantle  main net
    address public riveraVault = 0x5f247B216E46fD86A09dfAB377d9DBe62E9dECDA; //rivera agni mantle
    address public riveraWethMnt = 0xDc63179CC57783493DD8a4Ffd7367DF489Ae93BF;
    address public router = 0xE592427A0AEce92De3Edee1F18E0157C05861564; // uniswap v2
    address public pyth = 0xA2aa501b19aff244D90cc15a4Cf739D2725B5729; // on mantle
    address public multiFeeD = 0x5C75A733656c3E42E44AFFf1aCa1913611F49230; //Lendle Contract to collect fees
    address public masterCh = 0x79e2fd1c484EB9EE45001A98Ce31F28918F27C41;
    address public routerH = 0xDd0840118bF9CCCc6d67b2944ddDfbdb995955FD; // fusionx v2

    address public partner = 0xFaBcc4b22fFEa25D01AC23c5d225D7B27CB1B6B8; // my address
    address public protocol = 0xf12Ac6acb0B8542B1c717E520A5B4C085222e4b9;
    uint256 public protocolFee = 0;
    uint256 public partnerFee = 0;
    uint256 public fundManagerFee = 0;
    uint256 public feeDecimals = 100;
    uint256 public withdrawFee = 1;
    uint256 public withdrawFeeDecimals = 100;

    uint24 public poolFee = 500;

    uint256 public ltv = 80;
    uint256 stratUpdateDelay = 172800;
    uint256 vaultTvlCap = 10000e18;

    function setUp() public {}

    function run() public {
        address gaus = 0xFaBcc4b22fFEa25D01AC23c5d225D7B27CB1B6B8;
        uint privateKey = 0xfc2f8cc0abd2d9d05229c8942e8a529d1ba9265eb1b4c720c03f7d074615afbb;
        address acc = vm.addr(privateKey);
        console.log("Account", acc);

        vm.startBroadcast(privateKey);

        RiveraAutoCompoundingVaultV2Public vault = new RiveraAutoCompoundingVaultV2Public(
                usdc,
                "PdnRivera-USDC-WETH-Vault",
                "PdnRivera-USDC-WETH-Vault",
                stratUpdateDelay,
                vaultTvlCap
            );

        CommonAddresses memory _commonAddresses = CommonAddresses(
            address(vault),
            router
        );

        PdnParams memory _pdnParams = PdnParams(
            usdc,
            wEth,
            lendingPool,
            riveraVault,
            pIusdc,
            pId,
            ltv
        );

        PdnFeesParams memory _pdnFeesParams = PdnFeesParams(
            protocol,
            partner,
            protocolFee,
            partnerFee,
            fundManagerFee,
            feeDecimals,
            withdrawFee,
            withdrawFeeDecimals
        );

        PdnHarvestParams memory _pdnHarvestParams = PdnHarvestParams(
            lendle,
            wMnt,
            masterCh,
            multiFeeD,
            routerH
        );

        PdnRivera parentStrategy = new PdnRivera(
            _commonAddresses,
            _pdnParams,
            _pdnFeesParams,
            _pdnHarvestParams,
            poolFee,
            8
        );

        // Weth(wMnt).deposit{value: 100 * 1e18}();
        // uint256 bal = Weth(wMnt).balanceOf(acc);
        // console.log(bal);
        vault.init(IStrategy(address(parentStrategy)));
        console.log("ParentVault");
        console2.logAddress(address(vault));
        console.log("ParentStrategy");
        console2.logAddress(address(parentStrategy));
        vm.stopBroadcast();
    }
}

//forge script scripts/DeployVolatile.s.sol:deployVolatile --rpc-url http://127.0.0.1:8545/ --broadcast -vvv --legacy --slow

// anvil --fork-url https://rpc.mantle.xyz --mnemonic "disorder pretty oblige witness close face food stumble name material couch planet"

/* Account 0x69605b7A74D967a3DA33A20c1b94031BC6cAF27c
  ParentVault
  0x47C242E3336a523c2866F6c5c94dE03998064C30
  ParentStrategy
  0x9E238Eda182a8d9aB226933f5d30114d33250137 */

// forge script scripts/DeployVolatile.s.sol:deployVolatile --rpc-url http://13.232.85.53:8545\ --broadcast -vvv --legacy --slow
