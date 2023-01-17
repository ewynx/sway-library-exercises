contract;

dep events;
dep single_voting_system;
dep errors;

use events::*;
use single_voting_system::*;
use errors::*;
use std::{auth::msg_sender, hash::sha256, logging::log, storage::StorageVec};

// A single event vote system for YES or NO.
// Users have max 1 vote - we check this with the hash of user for privacy reasons
// At any time the amount of YES and NO votes can be retrieved. 

storage {
    /// The initialization state of the contract.
    state: State = State::NotInitialized,
    yes: u64 = 0,
    no: u64 = 0,
    // hashes of users that have voted, to check they can only vote once
    users_voted: StorageMap<b256, bool> = StorageMap {},
}

impl SingleVotingSystem for Contract {
    #[storage(read, write)]
    fn constructor() {
        require(storage.state == State::NotInitialized, InitializationError::CannotReinitialize);

        storage.state = State::Initialized;

        log(InitializeEvent {
            author: msg_sender().unwrap(),
        })
    }

    #[storage(read, write)]
    fn vote(yes: bool) {
        require(storage.state == State::Initialized, InitializationError::ContractNotInitialized);

        let user = msg_sender().unwrap();
        let user_hash = sha256(user);
        require(!storage.users_voted.get(user_hash), UserError::AlreadyVoted);

        if (yes) {
            storage.yes = storage.yes + 1;
        } else {
            storage.no = storage.no + 1;
        }

        storage.users_voted.insert(user_hash, true);
        log(VoteEvent {
            user_hash: user_hash,
        })
    }

    #[storage(read)]
    fn get_votes() -> Votes {
        require(storage.state == State::Initialized, InitializationError::ContractNotInitialized);

        return Votes {
            yes: storage.yes,
            no: storage.no,
        };
    }
}
