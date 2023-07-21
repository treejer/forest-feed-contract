// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.9;

/** @title ForestFeed interface */
interface IForestFeed {

    event Deposited(address creator,uint256 amount);
    event Rewarded(address creator,address to,uint256 count);
    event Withdrawn(address creator);

    function initialize(address _accessRestrictionAddress,address daiToken,address _regularSale) external;

    function deposit (uint256 _totalPrice) external;

    function reward(address _creator,address _to,uint256 _count) external;

    function withdraw(address _creator,uint256 _amount) external;

}
