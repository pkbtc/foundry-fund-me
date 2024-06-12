// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;


import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script{
    uint8 public constant DECIMALS=8;
    int256 public constant INITIAL_PRICE=2000e8;
    NetworkConfig public ActiveNetworkConfig;
        struct NetworkConfig{
            address  priceFeed;
        }
        constructor() {
            if(block.chainid==11155111){
                ActiveNetworkConfig=getSepoliaEthConfig();
            }
            else if(block.chainid==1){
                ActiveNetworkConfig=getEthConfig();
            }
            else{
                ActiveNetworkConfig=getAnvilEthConfig();
            }
        }
        function getSepoliaEthConfig() public pure returns(NetworkConfig memory){
            NetworkConfig memory sepoliaEthConfig=NetworkConfig({priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306});
            return sepoliaEthConfig;
        }
        function getEthConfig() public pure returns(NetworkConfig memory){
            NetworkConfig memory Ethconfig=NetworkConfig({priceFeed:0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
            return Ethconfig;
        }
        function getAnvilEthConfig() public  returns(NetworkConfig memory){
                if(ActiveNetworkConfig.priceFeed!=address(0)){
                    return ActiveNetworkConfig;
                }
                vm.startBroadcast();
                MockV3Aggregator anvildata=new MockV3Aggregator(DECIMALS,INITIAL_PRICE);
                vm.stopBroadcast();
                NetworkConfig memory local=NetworkConfig({priceFeed:address(anvildata)});
                return local;
        }
}