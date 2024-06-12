// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundme.s.sol";
import {FundFundme,WithdrawFundme} from "../../script/Interacstions.s.sol";

contract FundMeInteraction is Test {
    FundMe fundme;
    address  USER=makeAddr("user");
    uint constant VALUE=0.1 ether;
    uint constant INITIAL_FUND=10 ether;
    function setUp() external{
        DeployFundMe deployer = new DeployFundMe();
        fundme=deployer.run();
        vm.deal(USER, INITIAL_FUND);
    }
    function testuserCanFund() public{
        FundFundme fundfundme=new FundFundme();
        fundfundme.fundFundme(address(fundme));

        WithdrawFundme withdrawfundme=new WithdrawFundme();
        withdrawfundme.withdrawFundme(address(fundme));
    }
}