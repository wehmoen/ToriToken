pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ToriToken is ERC20Capped, Ownable {

    mapping(address => bool) private _airdropped;
    uint256 private _totalAirdropped = 0;
    uint256 private _airdropAmount = 10 * (10 ** uint256(decimals()));
    uint256 private _maxSupply = 42000000 * (10 ** uint256(decimals()));

    event AirdropUpdatedEvent(address sender, uint256 amount);
    event Mint(address sender, uint256 amount);
    event AirdropClaim(address sender, uint256 amount);

    constructor() ERC20("Tori Token", "TORI") ERC20Capped(_maxSupply) public {
        _setupDecimals(3);
    }

    function mint(address _account, uint256 _amount) public onlyOwner {
        _mint(_account, _amount);
        emit Mint(_account, _amount);
    }

    function getAirdrop() external {
        require(!_airdropped[msg.sender], "You already received your airdrop.");
        require(totalSupply() + _airdropAmount <= _maxSupply / 2, "The airdrop has ended");
        _totalAirdropped++;
        _airdropped[msg.sender] = true;
        _mint(msg.sender, _airdropAmount);
        emit AirdropClaim(msg.sender, _airdropAmount);
    }

    function getAirdropAmount() view public returns (uint256) {
        return _airdropAmount;
    }

    function setAirdropAmount(uint256 _amount) public onlyOwner {
        require(_totalAirdropped == 0, "Airdrop has already started");
        _airdropAmount = _amount * (10 ** uint256(decimals()));
        emit AirdropUpdatedEvent(msg.sender, _amount);
    }
}
