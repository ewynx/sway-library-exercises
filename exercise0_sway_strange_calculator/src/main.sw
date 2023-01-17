script;

dep strange_calculator;

use ::strange_calculator::*;

use std::assert::assert;
use std::logging::log;

fn main() {
    // Test for function add_ten
    add_ten_correctly();

        // Tests for function get_largest
    get_largest_gives_largest();

    // When uncommenting test below, a Revert will appear and 100 will be logged
    // get_largest_errors_on_empty();
    // Tests for function add_between
    add_between_sum_correctly();
    // When uncommenting test below, a Revert will appear and 101 will be logged
    // add_between_errors_wrong_range();
}

fn add_ten_correctly() {
    assert(add_ten(10) == 20);
    assert(add_ten(100) == 110);
}

fn get_largest_gives_largest() {
    let mut test = Vec::new();
    test.push(42);
    test.push(4200);
    assert(get_largest(test) == 4200);

    test.push(1);
    test.push(10000);
    assert(get_largest(test) == 10000);
}

fn get_largest_errors_on_empty() {
    let mut empty_vec = Vec::new();
    get_largest(empty_vec);
}

fn add_between_sum_correctly() {
    // a= 5, b =10: 5+6+7+8+9 = 35
    assert(add_between(5, 10) == 35);
    // a = 1001, b = 1009; 1001 + 1002 + 1003 + 1004 + 1005 + 1006 + 1007 + 1008 = 8036
    assert(add_between(1001, 1009) == 8036);
}

fn add_between_errors_wrong_range() {
    add_between(10, 9);
}
