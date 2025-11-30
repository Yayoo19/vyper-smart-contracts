from script.deploy import INITIAL_SUPPLY
import boa

RANDOM_USER = boa.env.generate_address()


def test_token_supply(erc20_contract):
    assert erc20_contract.totalSupply() == INITIAL_SUPPLY


def test_token_emits_event(erc20_contract):
    with boa.env.prank(erc20_contract.owner()):
        erc20_contract.transfer(RANDOM_USER, INITIAL_SUPPLY)
        erc20_contract.get_logs()
        # breakpoint()
    assert erc20_contract.balanceOf(RANDOM_USER) == INITIAL_SUPPLY
