# pragma version 0.4.3
# SPDX-License-Identifier: MIT
# @title Moccasin NFT

from snekmate.tokens import erc721
from snekmate.auth import ownable as ow

initializes: ow
initializes:erc721[ownable:=ow]

exports: erc721.__interface__

# ------------------------------------------------------------------
#                         STATE VARIABLES
# ------------------------------------------------------------------
NAME: constant(String[25]) = "BULL NFT"
SYMBOL: constant(String[5]) = "BULL"
BASE_URI: constant(String[80]) = " https://gateway.pinata.cloud/ipfs/"
EIP_NAME: constant(String[50]) = "BULL NFT"
EIP_VERSION: constant(String[20]) = "1"

@deploy
def __init__():
    ow.__init__()
    erc721.__init__(NAME, SYMBOL, BASE_URI, EIP_NAME, EIP_VERSION)


@external
def mint(uri: String[432]):
    token_id: uint256 = erc721._counter
    erc721._counter = token_id + 1
    erc721._safe_mint(msg.sender, token_id, b"")
    erc721._set_token_uri(token_id, uri)
    