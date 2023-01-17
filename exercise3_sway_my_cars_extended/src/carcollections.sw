library carcollections;

// Update: collection with 3 cars per user 
pub enum Color {
    Silver: (),
    White: (),
    Black: (),
    Red: (),
}

pub enum Brand {
    Audi: (),
    Mercedes: (),
    Kia: (),
    Ferrari: (),
}

pub struct Car {
    year: u16,
    name: str[10],
    brand: Brand,
    color: Color,
}

pub struct CarCollection {
    cars: [Option<Car>; 3],
}

impl CarCollection {
    pub fn new() -> Self {
        CarCollection {
            cars: [
                Option::None::<Car>(),
                Option::None::<Car>(),
                Option::None::<Car>(),
            ],
        }
    }

    pub fn get_car_count(self) -> u64 {
        if (self.cars[0].is_none()) {
            0
        } else if (self.cars[1].is_none()) {
            1
        } else if (self.cars[2].is_none()) { 2 } else { 3 }
    }
}

impl CarCollection {
    pub fn add_car(self, car: Car) -> Self {
        match self.get_car_count() {
            0 => CarCollection {
                cars: [Option::Some(car), Option::None, Option::None],
            },
            1 => CarCollection {
                cars: [self.cars[0], Option::Some(car), Option::None],
            },
            _ => CarCollection {
                cars: [self.cars[0], self.cars[1], Option::Some(car)],
            },
        }
    }
}

abi CarCollections {
    #[storage(write)]
    fn add_car_collection();

    #[storage(read, write)]
    fn add_car(car: Car);

    #[storage(read)]
    fn get_cars() -> CarCollection;
}
