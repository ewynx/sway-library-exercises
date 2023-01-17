contract;

dep my_cars;
dep errors;

use my_cars::*;
use errors::CarCollectionErrors;
use std::storage::StorageVec;

storage {
    my_cars: StorageVec<Car> = StorageVec {},
}

impl MyCars for Contract {
    #[storage(read, write)]
    fn add_car(car: Car) {
        storage.my_cars.push(car);
    }

    #[storage(read)]
    fn get_car_count() -> u8 {
        storage.my_cars.len()
    }

    #[storage(read)]
    fn get_car(index: u8) -> Option<Car> {
        require(index < storage.my_cars.len(), CarCollectionErrors::IndexOutOfBound());
        storage.my_cars.get(index)
    }
}
