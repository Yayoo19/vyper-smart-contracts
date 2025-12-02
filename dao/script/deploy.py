from src import dao
from moccasin.boa_tools import VyperContract
import boa
from eth_utils import to_wei

RANDOM_USER = boa.env.generate_address("non-owner")
GUARDIAN_USER = boa.env.generate_address("guardian")
REVIEWER_USER = boa.env.generate_address("reviewer")
EXECUTOR_USER = boa.env.generate_address("executor")
PROPOSAL_VALUE = to_wei(10, "ether")
DAO_BALANCE = to_wei(100, "ether")


def deploy_dao():
    dao_contract: VyperContract = dao.deploy()
    return dao_contract

deploy_dao()
