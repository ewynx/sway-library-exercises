use fuels::{prelude::*, tx::ContractId};
use std::borrow::Borrow;

// Load abi from json
abigen!(MyContract, "./out/debug/sway_my_cars-abi.json");

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
        "./out/debug/sway_my_cars.bin",
        &wallet,
        TxParameters::default(),
        StorageConfiguration::with_storage_path(Some(
            "./out/debug/sway_my_cars-storage_slots.json".to_string(),
        )),
    )
    .await
    .unwrap();

    let instance = MyContract::new(id.clone(), wallet);

    (instance, id.into())
}

#[tokio::test]
async fn can_add_car() {
    let (instance, _id) = get_contract_instance().await;

    let carStr = SizedAsciiString::<10>::new("First car ".to_string()).unwrap();
    let car1 = Car { year: 2020, name: carStr, brand: Brand::Audi(), color: Color::Silver() };
    
    instance.methods().add_car(car1).call().await.unwrap();

    assert!(true);
}

#[tokio::test]
async fn can_get_car_count() {
    let (instance, _id) = get_contract_instance().await;

    let car1Str = SizedAsciiString::<10>::new("First car ".to_string()).unwrap();
    let car1 = Car { year: 2020, name: car1Str, brand: Brand::Audi(), color: Color::Silver() };

    let car2Str = SizedAsciiString::<10>::new("Second car".to_string()).unwrap();
    let car2 = Car { year: 2008, name: car2Str, brand: Brand::Ferrari(), color: Color::Red() };
    
    instance.methods().add_car(car1).call().await.unwrap();
    instance.methods().add_car(car2).call().await.unwrap();

    let result = instance.methods().get_car_count().call().await.unwrap();
    assert_eq!(result.value, 2);
  }

  #[tokio::test]
  async fn can_get_car() {
      let (instance, _id) = get_contract_instance().await;
  
      let carStr = SizedAsciiString::<10>::new("First car ".to_string()).unwrap();
      let car1 = Car { year: 2020, name: carStr, brand: Brand::Audi(), color: Color::Silver() };
      
      instance.methods().add_car(car1).call().await.unwrap();
  
      let result = instance.methods().get_car(0).call().await.unwrap();
      let result_car = result.value.unwrap();
      assert_eq!(result_car.name, "First car ");
      assert_eq!(result_car.brand, Brand::Audi());
      assert_eq!(result_car.color, Color::Silver());
  }

  #[tokio::test]
  #[should_panic(expected = "IndexOutOfBound")]
  async fn error_get_car_wrong_index() {
      let (instance, _id) = get_contract_instance().await;
      // Calling get_car(0) on empty car collection -> should give out of bound error
      instance.methods().get_car(0).call().await.unwrap();
  }
