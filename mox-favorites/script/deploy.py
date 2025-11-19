from src import favorites
from moccasin.boa_tools import VyperContract
from moccasin.config import get_active_network


def deploy_fav() -> VyperContract:
    favorites_contract: VyperContract = favorites.deploy()
    active_network = get_active_network()
    if active_network.has_explorer():
        result = active_network.moccasin_verify(favorites_contract)
        result.wait_for_verification()
    return favorites_contract

deploy_fav()