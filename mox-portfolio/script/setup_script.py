from boa.contracts.abi.abi_contract import ABIContract
from typing import Tuple
from moccasin.config import get_active_network
import boa

STARTING_ETH_BALANCE = int(1000e18)
STARTING_WETH_BALANCE = int(1e18)
STARTING_USDC_BALANCE = int(100e6)

def _add_eth_balance():
    boa.env.set_balance(boa.env.eoa, STARTING_ETH_BALANCE)

def _add_token_balance(usdc, weth):
    my_address = boa.env.eoa
    print(f"weth balance before deposit: {weth.balanceOf(boa.env.eoa)} ")
    weth.deposit(value=STARTING_WETH_BALANCE)
    print(f"weth balance after deposit: {weth.balanceOf(boa.env.eoa)} ")
    with boa.env.prank(usdc.owner()):
        usdc.updateMasterMinter(my_address)
    
    usdc.configureMinter(my_address, STARTING_USDC_BALANCE)
    print(f"usdc balance before mint: {usdc.balanceOf(boa.env.eoa)} ")
    usdc.mint(my_address, STARTING_USDC_BALANCE)
    print(f"usdc balance after mint: {usdc.balanceOf(boa.env.eoa)} ")
    
    


def setup_script() -> Tuple[ABIContract, ABIContract, ABIContract, ABIContract]:
    print("Starting setup script...")

    active_network = get_active_network()
    usdc = active_network.manifest_named("usdc")
    weth = active_network.manifest_named("weth")

    if active_network.is_local_or_forked_network():
        _add_eth_balance()
        _add_token_balance(usdc, weth)

def moccassin_main():
    setup_script()

moccassin_main()
