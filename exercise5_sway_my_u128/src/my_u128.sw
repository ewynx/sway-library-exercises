library my_u128;

use core::ops::{Add, Eq, Ord, Subtract};
use std::flags::{disable_panic_on_overflow, enable_panic_on_overflow};

pub struct MyU128 {
    upper: u64,
    lower: u64,
}

// PART 1
impl MyU128 {
    pub fn from(upper: u64, lower: u64) -> MyU128 {
        MyU128 { upper, lower }
    }

    pub fn into(self) -> (u64, u64) {
        (self.upper, self.lower)
    }

    pub fn min() -> MyU128 {
        MyU128 {
            upper: 0,
            lower: 0,
        }
    }

    pub fn max() -> MyU128 {
        MyU128 {
            upper: u64::max(),
            lower: u64::max(),
        }
    }
}

// PART 2
impl Ord for MyU128 {
    fn gt(self, other: Self) -> bool {
        self.upper > other.upper || self.upper == other.upper && self.lower > other.lower
    }

    fn lt(self, other: Self) -> bool {
        self.upper < other.upper || self.upper == other.upper && self.lower < other.lower
    }
}

impl Eq for MyU128 {
    fn eq(self, other: Self) -> bool {
        self.lower == other.lower && self.upper == other.upper
    }
}

impl u64 {
    pub fn overflowing_add(self, right: Self) -> MyU128 {
        disable_panic_on_overflow();
        let mut result = MyU128 {
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

impl Add for MyU128 {
    /// Add a U128 to a U128. Panics on overflow.
    fn add(self, other: Self) -> Self {
        let mut upper_128 = self.upper.overflowing_add(other.upper);

        // If the upper overflows, then the number cannot fit in 128 bits, so panic.
        assert(upper_128.upper == 0);
        let lower_128 = self.lower.overflowing_add(other.lower);

        // If overflow has occurred in the lower component addition, carry.
        // Note: carry can be at most 1.
        if lower_128.upper > 0 {
            upper_128 = upper_128.lower.overflowing_add(lower_128.upper);
        }

        // If overflow has occurred in the upper component addition, panic.
        assert(upper_128.upper == 0);

        MyU128 {
            upper: upper_128.lower,
            lower: lower_128.lower,
        }
    }
}

impl Subtract for MyU128 {
    /// Subtract a U128 from a U128. Panics if there's underflow
    fn subtract(self, other: Self) -> Self {
        // If trying to subtract a larger number, panic.
        assert(!(self < other));

        let mut upper = self.upper - other.upper;
        let mut lower = 0;

        // If necessary, borrow and carry for lower subtraction
        if self.lower < other.lower {
            lower = u64::max() - (other.lower - self.lower - 1);
            upper -= 1;
        } else {
            lower = self.lower - other.lower;
        }

        MyU128 { upper, lower }
    }
}
