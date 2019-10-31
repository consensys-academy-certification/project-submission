// ===== DO NOT MODIFY THIS FILE =====

var ProjectSubmission = artifacts.require("ProjectSubmission");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(ProjectSubmission, {from: accounts[0]});
};