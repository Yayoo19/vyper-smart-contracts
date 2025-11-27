import pytest
from moccasin.config import get_active_network
from script.deploy import deploy_coffee
from tests.conftest import FUND_VALUE
import boa

@pytest.mark.staging
@pytest.mark.local
@pytest.mark.ignore_isolation
def test_fund_and_withdraw_live():
    active_network = get_active_network()
    if active_network.name == "sepolia":
        price_feed = active_network.manifest_named("price_feed")
        coffee = deploy_coffee(price_feed)
        coffee.fund(value=FUND_VALUE)
        amount_funded = coffee.funder_and_amount(boa.env.eoa)
        assert amount_funded == FUND_VALUE
        coffee.withdraw()
        assert boa.env.get_balance(coffee.address) == 0