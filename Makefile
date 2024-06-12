-include .env

build:; forge build 

deploy-sepolia :
		forge script script/DeployFundme.s.sol:DeployFundme --rpc-url ${SEPOLIA_URL_RPC} --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${ETHERSCAN_API_KEY} -vvvv