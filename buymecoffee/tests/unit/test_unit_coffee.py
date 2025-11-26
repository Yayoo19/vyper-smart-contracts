import boa
from conftest import FUND_VALUE
from eth_utils import to_wei

RANDOM_USER = boa.env.generate_address("non-owner")

def test_price_feed(coffee, eth_usd):
    assert coffee.PRICE_FEED() == eth_usd.address

def test_starting_values(coffee, account):
    assert coffee.MINIMUM_USD() == to_wei(5, "ether")
    assert coffee.OWNER() == account.address

def test_fund_not_enough_eth(coffee):
    with boa.reverts():
        coffee.fund()

def test_fund_with_money(coffee, account):
    boa.env.set_balance(account.address, FUND_VALUE)
    coffee.fund(value=FUND_VALUE)
    funder = coffee.funders(0)
    assert funder == account.address
    assert coffee.funder_and_amount(funder) == FUND_VALUE

def test_withdraw_not_owner(coffee_funded, account):
    with boa.env.prank(RANDOM_USER):
        with boa.reverts("Not the contract owner!"):
            coffee_funded.withdraw()

def test_withdraw(coffee_funded):
    coffee_funded.withdraw()
    assert boa.env.get_balance(coffee_funded.address) == 0
