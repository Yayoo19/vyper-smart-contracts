import boa

def main():
    favorites_contract = boa.load("favorites.vy")
    starting_favorite_number = favorites_contract.retrieve()
    print(starting_favorite_number)
    favorites_contract.store(5)
    modified_favorite_number = favorites_contract.retrieve()
    print(modified_favorite_number)

if __name__ == "__main__":
    main()