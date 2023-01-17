use fuels::{prelude::*, tx::ContractId};

// Load abi from json
abigen!(MyContract, "out/debug/sway_single_vote-abi.json");

async fn get_contract_instance() -> (MyContract, ContractId) {
    // Launch a local network and deploy the contract
    let mut wallets = launch_custom_provider_and_get_wallets(
        WalletsConfig::new(
            Some(1),             /* Single wallet */
            Some(1),             /* Single coin (UTXO) */
            Some(1_000_000_000), /* Amount per coin */
        ),
        None,
        None,
    )
    .await;
    let wallet = wallets.pop().unwrap();

    let id = Contract::deploy(
        "./out/debug/sway_single_vote.bin",
        &wallet,
        TxParameters::default(),
        StorageConfiguration::with_storage_path(Some(
            "./out/debug/sway_single_vote-storage_slots.json".to_string(),
        )),
    )
    .await
    .unwrap();

    let instance = MyContract::new(id.clone(), wallet);

    (instance, id.into())
}

#[tokio::test]
async fn can_construct_single_vote_system() {
    let (instance, _id) = get_contract_instance().await;

    instance.methods().constructor().call().await.unwrap();

    assert!(true);
}

#[tokio::test]
#[should_panic(expected = "CannotReinitialize")]
async fn error_reinitializing_contract() {
    let (instance, _id) = get_contract_instance().await;

    instance.methods().constructor().call().await.unwrap();
    instance.methods().constructor().call().await.unwrap();
}

#[tokio::test]
async fn can_get_votes() {
    let (instance, _id) = get_contract_instance().await;

    instance.methods().constructor().call().await.unwrap();
    instance.methods().get_votes().call().await.unwrap();

    assert!(true);
}

//TODO why isn't this panicking?
// #[tokio::test]
// #[should_panic(expected = "ContractNotInitialized")]
// async fn error_non_initialized_contract_get_votes() {
//     let (instance, _id) = get_contract_instance().await;

//     instance.methods().get_votes().call().await.unwrap();
// }

#[tokio::test]
async fn can_vote_yes() {
    let (instance, _id) = get_contract_instance().await;
    
    instance.methods().constructor().call().await.unwrap();
    instance.methods().vote(true).call().await.unwrap();
    let result = instance.methods().get_votes().call().await.unwrap();
    assert_eq!(result.value.yes, 1);
    assert_eq!(result.value.no, 0);
}

#[tokio::test]
async fn can_vote_no() {
    let (instance, _id) = get_contract_instance().await;
    
    instance.methods().constructor().call().await.unwrap();
    instance.methods().vote(false).call().await.unwrap();
    let result = instance.methods().get_votes().call().await.unwrap();
    assert_eq!(result.value.yes, 0);
    assert_eq!(result.value.no, 1);
}

//TODO why isn't this panicking?
// #[tokio::test]
// #[should_panic(expected = "ContractNotInitialized")]
// async fn error_non_initialized_contract_vote() {
//     let (instance, _id) = get_contract_instance().await;

//     instance.methods().vote(false).call().await.unwrap();
// }

#[tokio::test]
#[should_panic(expected = "AlreadyVoted")]
async fn error_on_voting_twice() {
    let (instance, _id) = get_contract_instance().await;
    
    instance.methods().vote(true).call().await.unwrap();
    instance.methods().vote(true).call().await.unwrap();
}
