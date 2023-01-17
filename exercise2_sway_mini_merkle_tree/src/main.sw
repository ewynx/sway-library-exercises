script;
dep mini_merkle_tree;

use mini_merkle_tree::*;
use std::logging::log;

fn main() {
    create_new_tree();
}

fn create_new_tree() {
    let tree = MiniMerkleTree::new([1, 2, 3, 4]);

    log(tree.hashroot);
    assert(tree.hashroot == 0x24862fce39fefec4a5622eba4807b49555e234f6063a1669f877a293d14df1e3);
}
