-include .env

.PHOHY:  all test deploy

build:; @forge compile

deploy:; @forge script script/DeployCattie.s.sol:DeployCattie $(NETWORK_ARGS)

NETWORK_ARGS := --rpc-url http://127.0.0.1:8545 --private-key $(ANVIL_KEY) --broadcast -vvvv

ifeq ($(findstring --network sepolia,$(ARGS)), --network sepolia)
     NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY)
endif
##ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
#  NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
# endif

test:; @forge test test/TestCattie.t.sol:TestCattie $(NETWORK_ARGS)