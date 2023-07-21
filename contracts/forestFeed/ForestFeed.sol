// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.9;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {IAccessRestriction} from "./../access/IAccessRestriction.sol";
import {IERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import {IRegularSale} from "./../regularSale/IRegularSale.sol";
import {IForestFeed} from "./IForestFeed.sol";

contract ForestFeed is
    IForestFeed,
    Initializable,
    UUPSUpgradeable
{

    mapping(address => uint256) public totalBalance; //-----> creator => balance

    IERC20Upgradeable public daiToken;
    IAccessRestriction public accessRestriction;
    IRegularSale public treejerRegularSale;

    modifier onlyAdmin() {
        accessRestriction.ifAdmin(msg.sender);
        _;
    }

    modifier onlyScript() {
        accessRestriction.ifScript(msg.sender);
        _;
    }

    /** NOTE modifier for check if function is not paused */
    modifier ifNotPaused() {
        accessRestriction.ifNotPaused();
        _;
    }


    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _accessRestrictionAddress,address _daiToken,address _regularSale) external override initializer {
        __UUPSUpgradeable_init();
       
        accessRestriction = IAccessRestriction(_accessRestrictionAddress);
        daiToken = IERC20Upgradeable(_daiToken);
        treejerRegularSale = IRegularSale(_regularSale);

        //----->approve for regularSale contract

        daiToken.approve(_regularSale,type(uint256).max);
    }

    function deposit(uint256 _amount) override external ifNotPaused {
        require(
            daiToken.balanceOf(msg.sender) >= _amount,
            "Insufficient balance"
        );

        bool success = daiToken.transferFrom(
            msg.sender,
            address(this),
            _amount
        );

        require(success, "Unsuccessful transfer");

        totalBalance[msg.sender] += _amount;

        emit Deposited(msg.sender,_amount);
    }

    function reward(address _creator,address _to,uint256 _count) override external onlyScript ifNotPaused {

        require(_count > 0 && _count < 101, "Invalid count");

        uint256 price = treejerRegularSale.price();
        
        uint256 totalPrice = price * _count;

        require(totalBalance[_creator]>= totalPrice,"Insufficient balance");

        totalBalance[_creator] -= totalPrice;

        treejerRegularSale.fundTree(
        _count,
        address(0),
        _to
        );

        emit Rewarded(_creator,_to,_count);
    }
    
    function withdraw(address _creator,uint256 _amount) override external onlyScript ifNotPaused {

        require(totalBalance[_creator] >= _amount, "Insufficient balance");
        
        totalBalance[_creator] -= _amount;

        daiToken.transfer(_creator,_amount);

        emit Withdrawn(_creator); 
    }


    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyAdmin
    {}
}