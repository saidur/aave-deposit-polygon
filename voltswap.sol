//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./IERC20.sol";
//import "./ILendingPool.sol";
import {ILendingPool, ILendingPoolAddressesProvider} from "./ILendingPool.sol";

contract Escrow {
    
    
    address arbiter;
    address depositor;
    address beneficiary;
    uint amountDeposited;

    // the mainnet AAVE v2 lending pool
   // ILendingPool pool = ILendingPool(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9);
    // aave interest bearing DAI
    IERC20 aDai = IERC20(0x028171bCA77440897B824Ca71D1c56caC55b68A3);
    // the DAI stablecoin 
    IERC20 dai = IERC20(0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F);
    
    /// Retrieve LendingPool address
    ILendingPoolAddressesProvider provider = ILendingPoolAddressesProvider(address(0x178113104fEcbcD7fF8669a0150721e231F0FD4B)); // mainnet address, for other addresses: https://docs.aave.com/developers/deployed-contracts/deployed-contract-instances 
    ILendingPool public pool = ILendingPool(provider.getLendingPool());

    /*constructor(address _arbiter, address _beneficiary, uint _amount) {
        arbiter = _arbiter;
        beneficiary = _beneficiary;
        depositor = msg.sender;
        amountDeposited = _amount;

        dai.transferFrom(msg.sender, address(this), _amount);

        dai.approve(address(pool), _amount);
        pool.deposit(address(dai), _amount, address(this), 0);
    }*/
    
    constructor() {
        //arbiter = _arbiter;
        //beneficiary = _beneficiary;
        depositor = msg.sender;
        
    }
    
    function putDeposit (uint256 _amount) external{
        amountDeposited = _amount;

        dai.transferFrom(msg.sender, address(this), _amount);

        dai.approve(address(pool), _amount);
        pool.deposit(address(dai), _amount, address(this), 0);
        
    }

    function approve() external {
        require(msg.sender == arbiter, "Only the arbiter is permitted to call this function.");
        aDai.approve(address(pool), type(uint).max);
        pool.withdraw(address(dai), amountDeposited, beneficiary);
        pool.withdraw(address(dai), type(uint).max, depositor);
    }
}
