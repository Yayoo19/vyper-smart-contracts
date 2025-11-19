from script.deploy import deploy_fav
 
def test_starting_values(favorites_contract):
    assert favorites_contract.retrieve() == 7

def test_can_change_values(favorites_contract):
    favorites_contract.store(5)
    assert favorites_contract.retrieve() == 5

def test_can_add_person(favorites_contract):
    person = "You"
    favorite_number = 10
    favorites_contract.add_person(person, favorite_number)
    assert favorites_contract.list_of_people(0) == (favorite_number, person)