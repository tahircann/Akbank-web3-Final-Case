// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Workers {
    string public workerName; // name of the saving account.
    address boss; // address of the owner.
    uint256 balance; // balance of the contract.

    event moneyAdded(string wName, uint256 addedAmount);

    struct Worker {
        address adr;
        string name;
    }

    mapping(address => uint256) saveWorker; // savings to workers

    Worker[] public workers;

    constructor(string memory _workerName, string memory _bossName) {
        workerName = _workerName;
        boss = msg.sender;
        workers.push(Worker(boss, _bossName)); // boss is a worker.
        balance = 0;
    }

  
    function isWorker(address toCheck) private view returns (bool) {   // returns if an adress is in worker array.
        for (uint256 i = 0; i < workers.length; ++i) {
            Worker memory worker = workers[i];
            if (worker.adr == toCheck) return true;
        }
        return false;
    }

    
    function workerNametoAddr(address adr) private view returns (string memory) {   // returns the worker name by adress
        for (uint256 i = 0; i < workers.length; ++i) {
            if (adr == workers[i].adr) return workers[i].name;
        }
        return "noUser";
    }

    modifier justOwn() {
        require(msg.sender == boss, "Only boss can use this.");
        _;
    }

    modifier justWorker() {
        require(isWorker(msg.sender), "Only workers can use this.");
        _;
    }

    
    function addMoney() public payable justWorker {
        balance += msg.value;

        emit moneyAdded(workerNametoAddr(msg.sender), msg.value);
        saveWorker[msg.sender] += msg.value;
    }


    function addWorker(Worker memory worker) external justOwn {
        require(!isWorker(worker.adr), "Already worker added.");
        workers.push(worker);
    }

    function showWorker(address adr) public view justWorker returns (uint256) {
        return saveWorker[adr];
    }

    function showSalary() public view justWorker returns (uint256) {
        return balance;
    }

  
}
