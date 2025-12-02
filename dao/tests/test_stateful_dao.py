from src import dao
from hypothesis import settings, strategies as st
from hypothesis.stateful import RuleBasedStateMachine, rule
import boa

class StatefulDao(RuleBasedStateMachine):
    def __init__(self):
        super().__init__()
        self.contract = dao.deploy()
    
    @rule(new_number=st.integers(min_value=1, max_value=10**18))
    def deposit(self, new_number):
        self.contract.deposit(value=new_number)
    
    @rule(
            text=st.text(min_size=1, max_size=1000),
            amount=st.integers(min_value=1, max_value=10**18)
    )
    def submit_proposal(self, text, amount):
        self.contract.submit_proposal(amount, text)
        count = self.contract.proposals_count()
        assert self.contract.proposals(count).amount == amount
        assert self.contract.proposals(count).description == text


    @rule(
            text=st.text(min_size=1, max_size=1000),
            amount=st.integers(min_value=1, max_value=10**18)
    )
    def approve_proposal(self, text, amount):
        address = boa.env.generate_address("reviewer")
        self.contract.setReviewer(address, True)
        self.contract.submit_proposal(amount, text)
        with boa.env.prank(address):
            self.contract.approve_proposal(self.contract.proposals_count())
        assert self.contract.proposals(self.contract.proposals_count()).approved is True

TestStatefulDao = StatefulDao.TestCase

TestStatefulDao.settings = settings(max_examples=1000, stateful_step_count=50)