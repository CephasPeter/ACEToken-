// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract ACEToken is IERC20 {
    using SafeMath for uint256;

    address payable public owner;

    string public constant name = "CEPHAS BLOCKGAMES TOKEN";
    string public constant symbol = "CEP";
    uint8 public constant decimals = 2;
    uint256 tokenPrice = 1000 ether;

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;

    constructor(uint256 total) {
        owner = payable(msg.sender);
        totalSupply_ = total;
        balances[owner] = totalSupply_;
    }

    function totalSupply() external override view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) external override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) external returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
 
    function approve(address spender, uint tokens) external returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
 
    function transferFrom(address from, address to, uint tokens) external returns (bool success) {
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
 
    function allowance(address tokenOwner, address spender) external view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function buyToken(address receiver, uint256 numOfTokens) external payable returns (bool) {
        uint256 etherPrice = numOfTokens / 1000;

        require(numOfTokens <= balances[msg.sender],"Amount Greater Than Available Supply");

        (bool sent, bytes memory data) = msg.sender.call{value: etherPrice}("");
        require(sent, "Transaction Failed");

        balances[msg.sender] = balances[msg.sender].sub(numOfTokens);
        balances[receiver] = balances[receiver].add(numOfTokens);
        emit Transfer(msg.sender, receiver, numOfTokens);
        return true;
    }
}