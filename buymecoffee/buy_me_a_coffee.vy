# pragma version 0.4.0
# SPDX-License-Identifier: MIT
# @Author: Yayoo19

#TODO: Get funds from users, Withdraw funds, Set a minimum funding value in USD



#interface to call contract price feed from chainlink.
interface AggregatorV3Interface:
    def decimals() -> int8: view
    def description() -> String[10000]: view
    def version() -> int256: view
    def latestAnswer() -> int256: view

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
    usd_value_eth: uint256 = self._get_eth_to_usd_rate(msg.value)
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
    
@internal
def _get_eth_to_usd_rate(eth_amount: uint256) -> uint256:
    """
    Convert ETH to USD 
    """
    # ABI from interface above 
    price: int256 = staticcall PRICE_FEED.latestAnswer() # 8 decimal places,  staticcall to use external function without modifing anything in external contract
    eth_price: uint256 = convert(price, uint256) * (10 ** 10)
    eth_amount_usd: uint256 = eth_amount * eth_price // (1 * (10 **18)) # 1 x 10^18
    return eth_amount_usd

@external
@payable
def __default__():
    self._fund()