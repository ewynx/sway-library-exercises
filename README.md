# Sway exercises

These are a few exercise to practice with the Sway language, specifically libraries. They are based on `forc 0.33.0`. 

Use the following resources:
- [Sway book](https://fuellabs.github.io/sway/v0.33.0/book/index.html)
- [Fuel book](https://fuellabs.github.io/fuel-docs/master/index.html)
  - Specifically, the [Developer Quickstart](https://fuellabs.github.io/fuel-docs/master/developer-quickstart.html)
- This [full-stack tutorial](https://github.com/ewynx/swayworkshop-web3rsvp/tree/beta-2), which is a fork from [this](https://github.com/camiinthisthang/learnsway-web3rsvp) original tutorial

The idea is to write the code yourself. The repo contains solutions for all exercises but you are encouraged to not look at them before solving it yourself! For each exercise you'll write test code either in a script or in Rust with the SDK. 

Another option is to take the test parts from this repo and fill in the code yourself, but writing the testcode yourself is highly recommended and best practice. 

Disclaimer: these exercises and the code are by no means perfect and WIP. Any improvements and additional exercises are welcome!

## Get started
Switch toolchain to `latest`: Make sure to use `forc 0.33`, at the moment of writing that is the case with the latest toolchain. 

```console
$ fuelup default latest
```

## Testing 

### With a script

Run script tests

First, spin up a test node 
```
fuel-core --db-type in-memory
```

Then, you can run a script as follows: 

```
forc run --unsigned --pretty-print
```

Obviously the keyword `unsigned` makes sure you can run it without providing your wallet, if this is not what you want, then just remove it. 

### In Rust

Read [here](https://fuellabs.github.io/fuel-docs/master/developer-quickstart.html#testing-your-contract) how to start testing in Rust. 

## **Exercises Easy**
### (0) A strange calculator

Write a strange calculator in `strange_calculator.sw` with the following functionalities:

- add_ten(a) returns a+10
- get_largest(numbers) returns largest element in vector
- add_between(a,b) add all numbers from a to b (including a, excluding b)

That the file with `library strange_calculator;`. 

Add tests through a script in `main.sw`. The file will look something like this:

```rust
script;

dep strange_calculator;

use ::strange_calculator::*;

use std::assert::assert;
use std::logging::log;

fn main() {
  //.. 
}
```

### (1) My cars

Register your own Car collection! This is a contract for a single user and will simply store the cars of the user in a `StorageVec`. 

A Car has a year, name (`str[10]`), brand and color. The latter 2 are enums.

The contract `MyCars` will have the following functions:
- add_car
- get_car_count
- get_car for index: `u8`. If the index is out of bound throw a custom error, which you can create like this: `pub enum CarCollectionErrors {
    IndexOutOfBound: ()
}`

Add tests for all functions in Rust. Also test for the error case like this:
```rust
  #[tokio::test]
  #[should_panic(expected = "IndexOutOfBound")]
  async fn error_get_car_wrong_index() {
      // test
  }
```


### (2) Mini Merkle Tree

Get hashroot for a tiny Merkle tree of 4 leaves. Use `use std::hash::sha256;`. 
Try out in script. 

## **Exercises Medium**

### (3) My cars extended

Now, we'll store Car collections of 3 cars for all users. This builds on the previous Car collection exercise. 

The contract `CarCollections` holds in storage a `StorageMap<Identity, CarCollection>`, where we have the following struct:

```rust
pub struct CarCollection {
  cars: [Option<Car>; 3]
}
```

The struct `CarCollection` has functions with the following signatures:
- `pub fn new() -> Self`
- `fn get_car_count(self) -> u64`
- `fn add_car(self, car: Car) -> Self`
These can be added like this:

```rust
impl CarCollection {
  pub fn new() -> Self {
//TODO
  }

  pub fn get_car_count(self) -> u64 {
//TODO
  }
}

impl CarCollection {

  pub fn add_car(self, car: Car) -> Self {
//TODO
  }
}
```

The contract `CarCollections` has the functions:
- add_car_collection for msg_sender (use `let user: Identity = msg_sender().unwrap();`) )
- add_car to collection of msg_sender
- get_cars for msg_sender

### (4) Singlevote

A single event vote system for YES or NO.

Users have max 1 vote, and have to make a deposit before they can vote. 

At any time the amount of YES and NO votes can be retrieved. 

Testing in Rust.

## **Exercises Advanced**

### (5) Our U128 impl

We'll create our own implementation of u128 called `MyU128`, which is an unsigned integer of 128 bits that consists of 2 `u64`'s `upper` and `lower`. 

#### Part 1

Add the following functions to `MyU128`:
- `from` 2 `u64`'s, create a `MyU128`
- `into` from the current `MyU128` return the tuple `(upper, lower)`
- `min`, which returns upper=lower=0
- `max`, which returns upper=lower=`u64::max()` (the highest value of an `u64`)

Test in script.

#### Part 2

It is possible to implement traits that enable the usable of certain operators such as `==` and `+`. For this, it is necessary to import the corresponding trait, for example `core::ops::Eq` and implement the function of the trait. 

Use the code snippet to implement `<` and `>` on `MyU128` (this will be usefull further along):

```rust
use core::ops::Ord; 

impl Ord for MyU128 {
    fn gt(self, other: Self) -> bool {
        self.upper > other.upper || self.upper == other.upper && self.lower > other.lower
    }

    fn lt(self, other: Self) -> bool {
        self.upper < other.upper || self.upper == other.upper && self.lower < other.lower
    }
}
```

Implement the following traits for `MyU128`:
1. `core::ops::Eq`
2. `core::ops::Add`. If the result of adding the 2 `MyU128`'s: panic.
3. `core::ops::Subtract` If the result is negative: panic. 

For 2: use the following helper function:
```rust
use ::flags::{disable_panic_on_overflow, enable_panic_on_overflow};

impl u64 {
    pub fn overflowing_add(self, right: Self) -> U128 {
        disable_panic_on_overflow();
        let mut result = U128 {
            upper: 0,
            lower: 0,
        };
        asm(sum, overflow, left: self, right: right, result_ptr: result) {
            // Add left and right.
            add sum left right;
            // Immediately copy the overflow of the addition from `$of` into
            // `overflow` so that it's not lost.
            move overflow of;
            // Store the overflow into the first word of result.
            sw result_ptr overflow i0;
            // Store the sum into the second word of result.
            sw result_ptr sum i1;
        };
        enable_panic_on_overflow();
        result
    }
}
```
In this snippet, inline assembly is used to make addition with overflow possible. If you're up for the challenge, you can write this yourself using the [Fuel book](https://fuellabs.github.io/sway/v0.33.0/book/advanced/assembly.html). 

Also, use `assert(xxx);` to panic when needed. 

For 3: use once again `u64::max()`.

Test all the functions in a script.
