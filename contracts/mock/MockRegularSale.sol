// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.9;

/** @title RegularSale interface */
contract MockRegularSale {

    uint256 public price;

    constructor(){
        price = 10 * 10**18;
    }

    function fundTree(
        uint256 _count,
        address _referrer,
        address _recipient
    ) external {
        if(_count>50){
            revert("error");
        }
    }

    function changePrice(uint256 _price) external {
        price = _price;
    }

  
}
