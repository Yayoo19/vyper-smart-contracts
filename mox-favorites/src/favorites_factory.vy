# pragma version 0.4.3
# @license MIT

from interfaces import i_favorites

original_contract: public(address)
list_of_favorites_contracts: public(DynArray[address, 100])

@deploy
def __init__(original_contract: address):
    self.original_contract = original_contract

@external
def create_favorites_contract():
    new_favorites_contract: address = create_copy_of(self.original_contract)
    self.list_of_favorites_contracts.append(new_favorites_contract)

@external
def store_from_factory(favorite_index: uint256, new_number: uint256):
    favorites_address: address = self.list_of_favorites_contracts[favorite_index]
    favorites_contract: i_favorites = i_favorites(favorites_address)
    extcall favorites_contract.store(new_number)

@external
@view
def view_from_factory(favorite_index: uint256) -> uint256:
    favorites_contract: i_favorites = i_favorites(self.list_of_favorites_contracts[favorite_index])
    value: uint256 = staticcall favorites_contract.retrieve()
    return value
    