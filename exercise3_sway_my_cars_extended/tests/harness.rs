use fuels::{prelude::*, tx::ContractId};

// Load abi from json
abigen!(MyContract, "out/debug/sway_my_cars_extended-abi.json");

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
        "./out/debug/sway_my_cars_extended.bin",
        &wallet,
        TxParameters::default(),
        StorageConfiguration::with_storage_path(Some(
            "./out/debug/sway_my_cars_extended-storage_slots.json".to_string(),
        )),
    )
    .await
    .unwrap();

    let instance = MyContract::new(id.clone(), wallet);

    (instance, id.into())
}

#[tokio::test]
async fn can_add_carcollection() {
    let (instance, _id) = get_contract_instance().await;

    instance.methods().add_car_collection().call().await.unwrap();

    assert!(true);
}

#[tokio::test]
async fn can_add_and_get_car() {
    let (instance, _id) = get_contract_instance().await;

    let carStr = SizedAsciiString::<10>::new("First car ".to_string()).unwrap();
    let car1 = Car { year: 2020, name: carStr, brand: Brand::Audi(), color: Color::Silver() };
    
    instance.methods().add_car(car1).call().await.unwrap();
    let result = instance.methods().get_cars().call().await.unwrap();

    assert!(result.value.cars[0].is_some());
}

#[tokio::test]
async fn can_get_empty_car_collection() {
    let (instance, _id) = get_contract_instance().await;

    let result = instance.methods().get_cars().call().await.unwrap();

    assert!(result.value.cars[0].is_none());
}