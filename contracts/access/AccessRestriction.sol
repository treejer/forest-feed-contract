// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.9;

import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import {IAccessRestriction} from "./IAccessRestriction.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";



/** @title AccessRestriction contract */

contract AccessRestriction is
    AccessControlUpgradeable,
    PausableUpgradeable, 
    IAccessRestriction,
    UUPSUpgradeable
{
    bytes32 public constant SCRIPT_ROLE = keccak256("SCRIPT_ROLE");


    /** NOTE modifier to check msg.sender has admin role */
    modifier onlyAdmin() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller not admin");
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /// @inheritdoc IAccessRestriction
    function initialize(address _deployer) external override initializer {
        __UUPSUpgradeable_init();
        AccessControlUpgradeable.__AccessControl_init();
        PausableUpgradeable.__Pausable_init();

        if (!hasRole(DEFAULT_ADMIN_ROLE, _deployer)) {
            _setupRole(DEFAULT_ADMIN_ROLE, _deployer);
        }
    }


    /// @inheritdoc IAccessRestriction
    function ifAdmin(address _address) external view override {
        require(isAdmin(_address), "Caller not admin");
    }

    /// @inheritdoc IAccessRestriction
    function isAdmin(address _address) public view override returns (bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, _address);
    }

    /// @inheritdoc IAccessRestriction
    function ifScript(address _address) external view override {
        require(isScript(_address), "Caller not script");
    }

    /// @inheritdoc IAccessRestriction
    function isScript(address _address) public view override returns (bool) {
        return hasRole(SCRIPT_ROLE, _address);
    }


    /// @inheritdoc IAccessRestriction
    function pause() external override onlyAdmin {
        _pause();
    }

    /// @inheritdoc IAccessRestriction
    function unpause() external override onlyAdmin {
        _unpause();
    }


    /// @inheritdoc IAccessRestriction
    function ifNotPaused() external view override {
        require(!paused(), "Pausable: paused");
    }

    /// @inheritdoc IAccessRestriction
    function ifPaused() external view override {
        require(paused(), "Pausable: not paused");
    }

    /// @inheritdoc IAccessRestriction
    function paused()
        public
        view
        virtual
        override(PausableUpgradeable, IAccessRestriction)
        returns (bool)
    {
        return PausableUpgradeable.paused();
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyAdmin
    {}

}
