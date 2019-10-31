pragma solidity ^0.5.0; // Step 1

contract ProjectSubmission { // Step 1

    address public owner; // Step 1 (state variable)
    uint public ownerBalance;  // Step 4 (state variable)

    modifier onlyOwner() { // Step 1
      require(msg.sender == owner, "Only the owner can do this.");
      _;
    }
    struct University { // Step 1
        // address account; // this line is not necessary if I make the universities mapping (address => University)
        uint balance;
        bool acceptingSubmissions;
    }

    mapping(address => University) public universities; // Step 1 (state variable)

    enum ProjectStatus {
        Waiting, Rejected, Approved, Disabled
    } // Step 2

    struct Project { // Step 2
        address author;
        address universityAddress;
        ProjectStatus status;
        uint balance;
    }
    // ...projects... // Step 2 (state variable)

    mapping(bytes32 => Project) public projects;

    constructor() public {
      owner = msg.sender;
    }

    function registerUniversity(address account) onlyOwner public { // Step 1
        universities[account].acceptingSubmissions = true;
    }

    function disableUniversity(address account) onlyOwner public { // Step 1
        universities[account].acceptingSubmissions = false;
    }

    function submitProject(bytes32 projectHash, address universityAddress) public payable { // Step 2 and 4
        require(msg.value >= 1 ether, "Submission fee is 1 ether");
        require(projects[projectHash].author == address(0), "A project with this hash has already been submitted.");
        projects[projectHash] = Project(msg.sender, universityAddress, ProjectStatus.Waiting, msg.value);
        ownerBalance += msg.value;
    }

    function disableProject(bytes32 projectHash) onlyOwner public { // Step 3
        projects[projectHash].status = ProjectStatus.Disabled;
    }

    function reviewProject(bytes32 projectHash, ProjectStatus status) onlyOwner public { // Step 3
        require(status == ProjectStatus.Approved || status == ProjectStatus.Rejected, "The new status must be approved or rejected.");
        projects[projectHash].status = status;
    }

    function donate(address universityAddress, bytes32 projectHash) public payable { // Step 4
        ownerBalance += msg.value / 10;                           // = 10%
        universities[universityAddress].balance += msg.value / 5; // = 20%
        projects[projectHash].balance += msg.value * 7 / 10;      // = 70%
    }

    function withdraw() public { // Step 5
        require(msg.sender == owner || universities[msg.sender].balance > 0);
        if(msg.sender == owner){
            msg.sender.transfer(ownerBalance);
            ownerBalance = 0;
        } else {
            msg.sender.transfer(universities[msg.sender].balance);
            universities[msg.sender].balance = 0;
        }

    }

    function withdraw(bytes32 projectHash) public {  // Step 5 (Overloading Function)
        require(msg.sender == projects[projectHash].author, "Only the author can withdraw funds from a project.");
        msg.sender.transfer(projects[projectHash].balance);
        projects[projectHash].balance = 0;
    }
}