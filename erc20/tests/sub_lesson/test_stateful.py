from src.sub_lesson import stateful_fuzz
from hypothesis import settings
from hypothesis.stateful import RuleBasedStateMachine, rule
from boa.test.strategies import strategy

class StatefulFuzzer(RuleBasedStateMachine):
    def __init__(self):
        super().__init__()
        self.contract = stateful_fuzz.deploy()

        #rules -> Actions
        #invariants -> Properties that hold true
    @rule(new_number=strategy("uint256"))
    def change_number(self, new_number):
        self.contract.change_number(new_number)
        
    @rule(input=strategy("uint256"))
    def input_number_returns_itself(self, input):
        result = self.contract.always_returns_input_number(input)
        assert result == input, f"Expected {input} but got {result}"

TestStatefulFuzzer = StatefulFuzzer.TestCase

TestStatefulFuzzer.settings = settings(max_examples=10000, stateful_step_count=50)