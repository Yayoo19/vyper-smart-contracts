from moccasin.config import get_active_network
from moccasin.boa_tools import VyperContract
from src import buy_me_a_coffee
from script.deploy_mocks import deploy_feed

def deploy_coffee(price_feed_address: VyperContract) -> VyperContract:
    coffee_contract: VyperContract = buy_me_a_coffee.deploy(price_feed_address)
    active_network = get_active_network()
    if active_network.has_explorer():
        result = active_network.moccasin_verify(coffee_contract)
        result.wait_for_verification()
    return coffee_contract
    
    

def moccasin_main() -> VyperContract:
    print("Deploying coffee contract...")
    active_network = get_active_network()
    price_feed: VyperContract = active_network.manifest_named("price_feed")
    print(f" On Active Network: {active_network.name} with price_feed: {price_feed.address}")
    return deploy_coffee(price_feed)

    # price_feed: VyperContract = deploy_feed()
    # coffee = buy_me_a_coffee.deploy(price_feed)
    # print(f"Deployed coffee contract at {coffee.address}")