script;

dep my_u128;

use ::my_u128::*;

use std::assert::assert;
use std::logging::log;

fn main() {
  test_from();
  test_into();
  test_min();
  test_max();
  test_eq();
  test_add_and_sub();
}

fn test_from() {
  let a = MyU128 { upper: 1, lower: 100};
  let a_from = MyU128::from(1, 100);
  assert(a == a_from);
}

fn test_into() {
  let a = MyU128 { upper: 1, lower: 100};
  let (into_upper, into_lower) = MyU128::into(a);
  assert(into_upper == 1);
  assert(into_lower == 100);
}

fn test_min() {
  let min = MyU128::min();
  assert(min.upper == 0);
  assert(min.lower == 0);
}

fn test_max() {
  let min = MyU128::max();
  assert(min.upper == u64::max());
  assert(min.lower == u64::max());
}

fn test_eq() {
  let a = MyU128{ upper: 200, lower: 300};
  let b = MyU128{ upper: 200, lower: 300};
  let c = MyU128{ upper: 200, lower: 400};

  assert(a==b);
  assert(!(a==c));
  assert(b!=c);
}

fn test_add_and_sub() {
  let first = MyU128::from(0, 0);
  let second = MyU128::from(0, 1);
  let max_u64 = MyU128::from(0, u64::max());

  let one = first + second;
  assert(one.upper == 0);
  assert(one.lower == 1);

  let two = one + one;
  assert(two.upper == 0);
  assert(two.lower == 2);

  let add_of_one = max_u64 + one;
  assert(add_of_one.upper == 1);
  assert(add_of_one.lower == 0);

  let add_of_two = max_u64 + two;
  assert(add_of_two.upper == 1);
  assert(add_of_two.lower == 1);

  let add_max = max_u64 + max_u64;
  assert(add_max.upper == 1);
  assert(add_max.lower == u64::max() - 1);

  let sub_one = second - first;
  assert(sub_one.upper == 0);
  assert(sub_one.lower == 1);

  let sub_zero = first - first;
  assert(sub_zero.upper == 0);
  assert(sub_zero.lower == 0);

  let sub_max_again = add_of_two - two;
  assert(sub_max_again.upper == 0);
  assert(sub_max_again.lower == u64::max());
}