// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.6;

/** @title RegularSale interface */
interface IRegularSale {

    /**
     * @dev fund {_count} tree
     * NOTE if {_recipient} address exist trees minted to the {_recipient}
     * and mint to the function caller otherwise
     * NOTE function caller pay for the price of trees
     * NOTE based on the allocation data for tree totalBalances and PlanterFund
     * contract balance and projected earnings updated
     * NOTE generate unique symbols for trees
     * NOTE if referrer address exists {_count} added to the referrerCount
     * NOTE emit a {TreeFunded} and {RegularMint} event
     * @param _count number of trees to fund
     * @param _referrer address of referrer
     * @param _recipient address of recipient
     */
    function fundTree(
        uint256 _count,
        address _referrer,
        address _recipient
    ) external;


    /** @return price of tree */
    function price() external view returns (uint256);

  
}
