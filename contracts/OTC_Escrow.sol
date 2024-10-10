// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OTCEscrow {
    
    struct Transaction {
        address depositor;
        address whitelisted;
        uint256 amount;
        bool isWithdrawn;
        uint256 timestamp;
    }

    mapping(address => Transaction[]) public transactionHistory;

    event Deposited(address indexed depositor, uint256 amount, uint256 timestamp);
    event Whitelisted(address indexed depositor, address indexed whitelisted, uint256 timestamp);
    event Withdrawn(address indexed whitelisted, uint256 amount, uint256 timestamp);

    modifier onlyWhitelisted(address _depositor) {
        require(
            msg.sender == getWhitelisted(_depositor),
            "You are not the whitelisted address."
        );
        _;
    }

    function deposit(address _whitelisted) external payable {
        require(msg.value > 0, "Deposit amount should be greater than 0");
        
        Transaction memory newTransaction = Transaction({
            depositor: msg.sender,
            whitelisted: _whitelisted,
            amount: msg.value,
            isWithdrawn: false,
            timestamp: block.timestamp
        });

        transactionHistory[msg.sender].push(newTransaction);

        emit Deposited(msg.sender, msg.value, block.timestamp);
        emit Whitelisted(msg.sender, _whitelisted, block.timestamp);
    }

    function withdraw(address _depositor) external onlyWhitelisted(_depositor) {
        Transaction[] storage transactions = transactionHistory[_depositor];

        for (uint i = 0; i < transactions.length; i++) {
            Transaction storage txn = transactions[i];
            if (txn.isWithdrawn == false && txn.whitelisted == msg.sender) {
                txn.isWithdrawn = true;
                payable(msg.sender).transfer(txn.amount);

                emit Withdrawn(msg.sender, txn.amount, block.timestamp);
                break;
            }
        }
    }

    function getTransactionHistory(address _user) external view returns (Transaction[] memory) {
        return transactionHistory[_user];
    }

    function getWhitelisted(address _depositor) public view returns (address) {
        Transaction[] memory transactions = transactionHistory[_depositor];
        if (transactions.length > 0) {
            return transactions[transactions.length - 1].whitelisted;
        }
        return address(0);
    }
}