# pragma version 0.4.3
# SPDX-License-Identifier: MIT
# @Author: Yayoo19

#TODO: Get funds from users, Withdraw funds, Set a minimum funding value in USD
from interfaces import AggregatorV3Interface
import get_price_module

#Constants & Immutables
PRICE_FEED: public(immutable(AggregatorV3Interface))    #Address ETH/USD (testnet): 0x694AA1769357215DE4FAC081bf1f309aDC325306
MINIMUM_USD: public(constant(uint256)) = as_wei_value(5, "ether") # Minimum 5 USD in value
OWNER: public(immutable(address))
#Storage
funder_and_amount: public(HashMap[address, uint256])
funders: public(DynArray[address, 1000])

#Constructor
@deploy 
def __init__(price_feed_address: address):
    PRICE_FEED = AggregatorV3Interface(price_feed_address)
    OWNER = msg.sender

@external
@payable
def fund():
    self._fund()

@internal
@payable
def _fund():
    """
    Allow user to send $ to this contract.
    Have a minimun amount.
    """
    usd_value_eth: uint256 = get_price_module._get_eth_to_usd_rate(PRICE_FEED, msg.value)
    assert usd_value_eth >= MINIMUM_USD, "Minimum: 5 usd"
    self.funders.append(msg.sender)
    self.funder_and_amount[msg.sender] += msg.value

@external
def withdraw():
    """
    Withdraw money from the contract.
    """
    assert msg.sender == OWNER, "Not the contract owner!"
    # send(OWNER, self.balance)
    raw_call(OWNER, b"", value = self.balance)
    for funder: address in self.funders:
        self.funder_and_amount[funder] = 0
    self.funders = []
    
@external
def get_eth_to_usd_rate(eth_amount: uint256) -> uint256:
    return get_price_module._get_eth_to_usd_rate(PRICE_FEED, eth_amount)
    


@external
@payable
def __default__():
    self._fund()