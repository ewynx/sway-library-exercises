library strange_calculator;

const EMPTY_INPUT_VECTOR = 100;
const WRONG_RANGE = 101;

// returns a + 10
pub fn add_ten(a: u64) -> u64 {
    a + 10
}

// returns largest element in vector
// errors 100 on empty vector
pub fn get_largest(numbers: Vec<u64>) -> u64 {
    let len = numbers.len();
    require(len > 0, EMPTY_INPUT_VECTOR);

    let mut i = 0;
    let mut largest: u64 = 0;
    while i < len {
        if (numbers.get(i).unwrap() > largest) {
            largest = numbers.get(i).unwrap();
        }
        i += 1;
    }
    largest
}

// returns sum of all nr starting from a until b
// errors 101 when b > a
pub fn add_between(a: u64, b: u64) -> u64 {
    require(a <= b, WRONG_RANGE);
    let mut res = 0;
    let mut current_nr = a;
    while current_nr < b {
        res += current_nr;
        current_nr += 1;
    }
    res
}
