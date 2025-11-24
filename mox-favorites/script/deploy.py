from src import favorites, favorites_factory, five_more
from moccasin.boa_tools import VyperContract
from moccasin.config import get_active_network


def deploy_fav() -> VyperContract:
    favorites_contract: VyperContract = favorites.deploy()
    active_network = get_active_network()
    if active_network.has_explorer():
        result = active_network.moccasin_verify(favorites_contract)
        result.wait_for_verification()
    return favorites_contract

def deploy_factory(favorites_contract: VyperContract):
    factory_contract: VyperContract = favorites_factory.deploy(favorites_contract)
    factory_contract.create_favorites_contract()
    new_favorites_address: str = factory_contract.list_of_favorites_contracts(0)
    new_favorites_contract: VyperContract = favorites.at(new_favorites_address)
    new_favorites_contract.store(74)
    print(new_favorites_contract.retrieve())
    factory_contract.store_from_factory(0, 42)
    print(new_favorites_contract.retrieve())
    print(favorites_contract.retrieve())

def deploy_five_more():
    five_more_contract: VyperContract = five_more.deploy()
    five_more_contract.store(55)
    print("value from five_more_contract: ", five_more_contract.retrieve())

def moccasin_main():
    favorites_contract = deploy_fav()
    deploy_factory(favorites_contract)
    deploy_five_more()    