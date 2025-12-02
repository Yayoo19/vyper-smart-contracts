# pragma version 0.4.3
# SPDX-License-Identifier: MIT
# @Author: Yayoo19

# ------------------------------------------------------------------
#                              EVENTS
# ------------------------------------------------------------------

event ProposalSubmitted:
    id: uint256
    requester: address
    amount: uint256


event ProposalApproved:
    id: uint256
    reviewer: address


event ProposalExecuted:
    id: uint256
    executor: address
    requester: address
    amount: uint256


event Paused:
    by: address


event Unpaused:
    by: address


event Deposit:
    sender: address
    amount: uint256

event RoleChanged:
    admin: address
    role: address


# ------------------------------------------------------------------
#                              ROLES
# ------------------------------------------------------------------
admin: public(address)
guardian: public(address)
reviewer: public(HashMap[address, bool])
executor: public(HashMap[address, bool])

# ------------------------------------------------------------------
#                     PROPOSAL STRUCT AND VARIABLES
# ------------------------------------------------------------------

struct Proposal:
    requester: address
    amount: uint256
    description: String[1000]
    approved: bool
    executed: bool


proposals: public(HashMap[uint256, Proposal])
proposals_count: public(uint256)
paused: public(bool)


# ------------------------------------------------------------------
#                              CONSTRUCTOR
# ------------------------------------------------------------------

@deploy
def __init__():
    self.admin = msg.sender
    self.paused = False


# ------------------------------------------------------------------
#                              INTERNAL FUNCTIONS
# ------------------------------------------------------------------

@internal
def _only_admin():
    assert msg.sender == self.admin


@internal
def _only_guardian():
    assert msg.sender == self.guardian


@internal
def _only_reviewer():
    assert self.reviewer[msg.sender]


@internal
def _only_executor():
    assert self.executor[msg.sender]


@internal
def _when_not_paused():
    assert not self.paused, "Contract is Paused"


# ------------------------------------------------------------------
#                              ROLE MANAGEMENT
# ------------------------------------------------------------------

@external
def setReviewer(user: address, status: bool):
    self._only_admin()
    self.reviewer[user] = status
    log RoleChanged(admin=msg.sender, role=user)


@external
def setExecutor(user: address, status: bool):
    self._only_admin()
    self.executor[user] = status
    log RoleChanged(admin=msg.sender, role=user)


@external
def setGuardian(new_guardian: address):
    self._only_admin()
    self.guardian = new_guardian
    log RoleChanged(admin=msg.sender, role=new_guardian)

# ------------------------------------------------------------------
#                              EXTERNAL FUNCTIONS
# ------------------------------------------------------------------
@external
def submit_proposal(amount: uint256, description: String[1000]):
    self._when_not_paused()
    self.proposals_count += 1
    self.proposals[self.proposals_count] = Proposal(
        requester=msg.sender,
        amount=amount,
        description=description,
        approved=False,
        executed=False,
    )
    log ProposalSubmitted(
        id=self.proposals_count, requester=msg.sender, amount=amount
    )


@external
def approve_proposal(proposal_id: uint256):
    self._only_reviewer()
    self._when_not_paused()
    assert not self.proposals[proposal_id].approved
    self.proposals[proposal_id].approved = True
    log ProposalApproved(id=proposal_id, reviewer=msg.sender)


@external
def execute_payment(proposal_id: uint256):
    self._only_executor()
    self._when_not_paused()
    assert (
        self.proposals[proposal_id].approved
        and not self.proposals[proposal_id].executed
    )
    assert (
        self.proposals[proposal_id].amount <= self.balance
    ), "Not enough balance to cover proposal"
    raw_call(
        self.proposals[proposal_id].requester,
        b"",
        value=self.proposals[proposal_id].amount,
    )
    self.proposals[proposal_id].executed = True
    log ProposalExecuted(
        id=proposal_id,
        executor=msg.sender,
        requester=self.proposals[proposal_id].requester,
        amount=self.proposals[proposal_id].amount,
    )


@external
def pause_operations():
    self._only_guardian()
    self.paused = True
    log Paused(by=msg.sender)


@external
def unpause_operations():
    self._only_admin()
    self.paused = False
    log Unpaused(by=msg.sender)


@external
@payable
def deposit():
    assert msg.value > 0, "No value sent"
    log Deposit(sender=msg.sender, amount=msg.value)


@view
@external
def get_balance() -> uint256:
    return self.balance


@external
@payable
def __default__():
    log Deposit(sender=msg.sender, amount=msg.value)
