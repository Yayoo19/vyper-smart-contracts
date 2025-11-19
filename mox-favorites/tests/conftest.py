import pytest
from script.deploy import deploy_fav

@pytest.fixture(scope="session")
def favorites_contract():
    favorites_contract = deploy_fav()
    return favorites_contract