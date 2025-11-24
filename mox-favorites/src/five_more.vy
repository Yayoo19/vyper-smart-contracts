# pragma version 0.4.3
# @license MIT
import favorites

initializes: favorites
exports: (
    favorites.retrieve,
    #favorites.__interface__,
)

@deploy
def __init__():
    favorites.__init__()
    
@external
def store(new_number: uint256):
    favorites.my_favorite_number = new_number + 5




