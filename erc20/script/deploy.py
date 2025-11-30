from src import erc20_token
from eth_utils import to_wei
from moccasin.boa_tools import VyperContract

INITIAL_SUPPLY = to_wei(1000, "ether")


def deploy() -> VyperContract:
    print("Deploying contract...")
    erc20_contract = erc20_token.deploy(INITIAL_SUPPLY)
    print(f"Deployed contract at {erc20_contract.address}")
    return erc20_contract


def mocassin_main() -> VyperContract:
    return deploy()
