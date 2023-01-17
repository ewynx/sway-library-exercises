contract;

dep carcollections;

use carcollections::*;

use std::{
  hash::sha256,
  storage::StorageMap,
  logging::log,
  auth::msg_sender
};

storage {
  carCollections: StorageMap<Identity, CarCollection> = StorageMap {},
}

// Is there a way to know if the StorageMap already contains the key? Couldn't find it in the Sway codebase

impl CarCollections for Contract {
    #[storage(write)]
    fn add_car_collection() {
        let user = msg_sender().unwrap();
        storage.carCollections.insert(user, CarCollection::new())
    }

    #[storage(read, write)]
    fn add_car(car: Car) {
        let user = msg_sender().unwrap();
        let current_collection = storage.carCollections.get(user);
        let new_collection = current_collection.add_car(car);
        storage.carCollections.insert(user, new_collection)
    }

    #[storage(read)]
    fn get_cars() -> CarCollection {
        let user = msg_sender().unwrap();
        storage.carCollections.get(user)
    }
}
