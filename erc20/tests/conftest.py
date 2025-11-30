import pytest
from script.deploy import deploy


@pytest.fixture(scope="function")
def erc20_contract():
    return deploy()
