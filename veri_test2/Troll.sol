// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        require(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
}

/**
 * @notice invariant totalSupply == __verifier_sum_uint(balances)
 */
contract BecTokenSimplified {
    using SafeMath for uint256;

    uint256 public totalSupply;
    mapping(address => uint256) balances;

    constructor() {
        totalSupply = 7000000000 * (10**18);
        balances[msg.sender] = totalSupply; // Give the creator all initial tokens
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _receiver, uint256 _value) public returns (bool) {
        require(_value > 0 && balances[msg.sender] >= _value);

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_receiver] = balances[_receiver].add(_value);
        return true;
    }

    function batchTransfer(address[] memory _receivers, uint256 _value) public returns (bool) {
        uint cnt = _receivers.length;
        uint256 amount = uint256(cnt) * _value; // Overflow
        require(cnt > 0 && cnt <= 20);
        require(_value > 0 && balances[msg.sender] >= amount);

        balances[msg.sender] = balances[msg.sender].sub(amount);
        /**
         * @notice invariant totalSupply == __verifier_sum_uint(balances) + (cnt - i) * _value
         * @notice invariant i <= cnt
         */
        for (uint i = 0; i < cnt; i++) {
            balances[_receivers[i]] = balances[_receivers[i]].add(_value);
        }
        return true;
    }
}