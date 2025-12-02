import pytest
from script.deploy import deploy_dao

@pytest.fixture
def dao_contract():
    return deploy_dao()