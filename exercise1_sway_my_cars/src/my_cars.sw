library my_cars;

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

abi MyCars {
    #[storage(read, write)]
    fn add_car(car: Car);

    #[storage(read)]
    fn get_car_count() -> u8;

    #[storage(read)]
    fn get_car(index: u8) -> Option<Car>;
}
