// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundme.s.sol";
contract FundMeTest is Test{
    FundMe fundme;
    address  USER=makeAddr("user");
    uint constant VALUE=0.1 ether;
    uint constant INITIAL_FUND=10 ether;
    function setUp() external{
       // fundme=new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
       DeployFundMe deployfundme=new DeployFundMe();
       vm.deal(USER, INITIAL_FUND);
      fundme= deployfundme.run();
    }
    modifier funded(){
        vm.prank(USER);
        fundme.fund{value:VALUE}();
        _;
    }
    function testminimumUsd() public{
        assertEq(fundme.MINIMUM_USD(),5e18);
    }
    

    function testVersion() public  view{
        uint version=fundme.getVersion();
        
        assertEq(version, 4);

    }
    function testFundFailsWithoutEnoughETH() public{
        vm.expectRevert();
        fundme.fund();

    }
    function testFundUpdate() public{
        vm.prank(USER);
        fundme.fund{value:VALUE}();
        
        uint amountFunded=fundme.getAddressToAmountFunded(USER);
        assertEq(amountFunded, VALUE);
    }
    function testAddFunderArray() public{
        vm.prank(USER);
        fundme.fund{value:VALUE}();
        address funder=fundme.getFunder(0);
        assertEq(USER, funder);
    }
    function testOnlyOwner() public funded(){
        

        vm.prank(USER);
        vm.expectRevert();
        fundme.withdraw();
    }
    function testWithDrawWithSingle() public funded(){
        //arrange
        uint startingOwnerBalance=fundme.getOwner().balance;
        uint StartingFundmeBalance=address(fundme).balance;

        //act
        vm.prank(fundme.getOwner());
        fundme.withdraw();

        //assert
        uint endingOwnerBalance=fundme.getOwner().balance;
        uint endingFundmeBalance=address(fundme).balance;

        assertEq(endingFundmeBalance, 0);
        assertEq(startingOwnerBalance+StartingFundmeBalance, endingOwnerBalance);


            }
             function testWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;
        for (uint160 i = startingFunderIndex; i < numberOfFunders + startingFunderIndex; i++) {
            // we get hoax from stdcheats
            // prank + deal
            hoax(address(i), INITIAL_FUND);
            fundme.fund{value: VALUE}();
        }

        uint256 startingFundMeBalance = address(fundme).balance;
        uint256 startingOwnerBalance = fundme.getOwner().balance;

        vm.startPrank(fundme.getOwner());
        fundme.withdraw();
        vm.stopPrank();

        assert(address(fundme).balance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == fundme.getOwner().balance);
        assert((numberOfFunders + 1) * VALUE == fundme.getOwner().balance - startingOwnerBalance);
    }
}
    
