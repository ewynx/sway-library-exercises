library events;

pub struct InitializeEvent {
    /// User who initialized the contract
    author: Identity,
}

pub struct VoteEvent {
    user_hash: b256,
}
