# pragma version 0.4.3
# SPDX-License-Identifier: MIT
# ERC20 Token

# ------------------------------------------------------------------
#                             IMPORTS
# ------------------------------------------------------------------
from snekmate.auth import ownable
from snekmate.tokens import erc20
from ethereum.ercs import IERC20

implements: IERC20

initializes: ownable
initializes: erc20[ownable := ownable]

exports: erc20.__interface__

# ------------------------------------------------------------------
#                        CONSTANT VARIABLES
# ------------------------------------------------------------------
NAME: constant(String[25]) = "yay token"
SYMBOL: constant(String[5]) = "YAY"
DECIMALS: constant(uint8) = 18
EIP712_VERSION: constant(String[20]) = "1"


# ------------------------------------------------------------------
#                            FUNCTIONS
# ------------------------------------------------------------------
@deploy
def __init__(initial_supply: uint256):
    ownable.__init__()
    erc20.__init__(NAME, SYMBOL, DECIMALS, NAME, EIP712_VERSION)
    erc20._mint(msg.sender, initial_supply)


# This is a bug! Remove it (but our stateful tests should catch it!)
@external
def super_mint():
    # We forget to update the total supply!
    # self.totalSupply += amount
    amount: uint256 = as_wei_value(100, "ether")
    erc20.balanceOf[msg.sender] = erc20.balanceOf[msg.sender] + amount
    log IERC20.Transfer(empty(address), msg.sender, amount)