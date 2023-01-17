library errors;

pub enum InitializationError {
    CannotReinitialize: (),
    ContractNotInitialized: (),
}

pub enum UserError {
    AlreadyVoted: (),
}
