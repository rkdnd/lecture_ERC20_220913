pragma solidity ^0.8.0;

// forge test -vvv
contract ERC20{
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;
    uint private _totalSupply;

    string _name;
    string _symbol;
    uint8 _decimals;

    constructor() public {
        _name = "DREAM";
        _symbol = "DRM";
        _decimals = 18;
        _totalSupply = 100 ether;
        balances[msg.sender] = 100 ether;
    }

    function name() public view returns (string memory){
        return _name;
    }

    function symbol() public view returns (string memory){
        return _symbol;
    }

    function decimals() public view returns (uint256){
        return _decimals;
    }

    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256){
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) external returns (bool success){
        // require는 앞쪽에서 처리하는게 좋음, GAS를 사용하고 revert될 수 있기 떄문에
        require(msg.sender != address(0), "transfer from the zero address"); // 초기화 되지 않은 값이 들어간다 거나 하는 버그처리 목적 강함
        require(_to != address(0), "transfer to the zero address");
        require(balances[msg.sender] >= _value, "value exceeds balance");

        unchecked{
            balances[msg.sender] -= _value;
            balances[_to] += _value;
        }

        emit Transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success){
        require(msg.sender != address(0), "transfer from the zero address");
        require(_from != address(0), "transfer to the zero address");
        require(_to != address(0), "transfer to the zero address");

        uint256 currentAllowance = allowance(_from, msg.sender);
        require(currentAllowance >= _value, "insufficient allowance");
        unchecked{
            allowances[_from][msg.sender] -= _value;
        }
        require(balances[_from] >= _value, "_value exceeds balance");

        unchecked{
            balances[_from] -= _value;
            balances[_to] += _value;
        }

        emit Transfer(msg.sender, _to, _value);
    }

    function approve(address _spender, uint256 _value) public returns (bool success){
        allowances[msg.sender][_spender] = _value;

        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining){
        return allowances[_owner][_spender];
    }

    function _mint(address _owner, uint256 _value) internal returns (bool success){
        require(_owner != address(0), "transfer from the zero address");
        balances[_owner] += _value;
        _totalSupply += _value;

        return true;
    }

    function _burn(address _owner, uint256 _value) internal returns (bool success){
        require(_owner != address(0), "transfer from the zero address");
        balances[_owner] -= _value;
        _totalSupply -= _value;

        return true;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}