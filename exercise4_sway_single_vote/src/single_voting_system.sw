library single_voting_system;

use core::ops::Eq;

pub enum State {
    NotInitialized: (),
    Initialized: (),
}

impl Eq for State {
    fn eq(self, other: Self) -> bool {
        match (self, other) {
            (State::Initialized, State::Initialized) => true,
            (State::NotInitialized, State::NotInitialized) => true,
            _ => false,
        }
    }
}

pub struct Votes {
    yes: u64,
    no: u64,
}

abi SingleVotingSystem {
    #[storage(read, write)]
    fn constructor();

    #[storage(read, write)]
    fn vote(yes: bool);

    #[storage(read)]
    fn get_votes() -> Votes;
}
