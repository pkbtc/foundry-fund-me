// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {Script,console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundme is Script{
    uint constant SEND_VALUE=0.01 ether;
    function fundFundme(address mostRecentDeployment) public{
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployment)).fund{value:SEND_VALUE}();
        vm.stopBroadcast();
        console.log("funded with",SEND_VALUE);
    }
    function run() external{
        
        address mostRecentDeployment=DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundme(mostRecentDeployment);
        
    }
}

contract WithdrawFundme is Script{
    function withdrawFundme(address mostRecentDeployment) public{
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployment)).withdraw();
         vm.stopBroadcast();
    }
    function run() external{
        
        address mostRecentDeployment=DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundme(mostRecentDeployment);
       
    }
}