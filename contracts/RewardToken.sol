// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

// Basic ERC20 token contract
contract RewardToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(uint256 initialSupply, string memory _name, string memory _symbol, uint8 _decimals) {
        totalSupply = initialSupply * 10 ** uint256(_decimals);
        balanceOf[msg.sender] = totalSupply;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function transfer(address _to, uint256 _value) external returns (bool) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
}