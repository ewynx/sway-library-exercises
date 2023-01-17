library mini_merkle_tree;

use std::hash::sha256;
use std::logging::log;

/***

A = leaves[0]
B = leaves[1]
C = leaves[2]
D = leaves[3]

                hashroot
                /     \
        hash01            hash23
        /   \             /     \
  hash(A)   hash(B)   hash(C)   hash(D)
    |          |         |         |
    A          B         C         D
***/
pub struct MiniMerkleTree<T> {
    leaves: [T; 4],
    hashroot: b256,
}

// TODO add impl eq to MiniMerkleTree
impl<T> MiniMerkleTree<T> {
    pub fn new(leaves: [T; 4]) -> Self {
        let hash_A = sha256(leaves[0]);
        let hash_B = sha256(leaves[1]);
        let hash_C = sha256(leaves[2]);
        let hash_D = sha256(leaves[3]);

      // log(hash_A);//cd2662154e6d76b2b2b92e70c0cac3ccf534f9b74eb5b89819ec509083d00a50
      // log(hash_B);//cd04a4754498e06db5a13c5f371f1f04ff6d2470f24aa9bd886540e5dce77f70
      // log(hash_C);//d5688a52d55a02ec4aea5ec1eadfffe1c9e0ee6a4ddbe2377f98326d42dfc975
      // log(hash_D);//8005f02d43fa06e7d0585fb64c961d57e318b27a145c857bcd3a6bdb413ff7fc
        let hash01 = sha256((hash_A, hash_B));
        let hash23 = sha256((hash_C, hash_D));

      // log(hash01);//1c4e119923ccaea7ab71c5161e3ff505f5fd4087aa9a827c8509a8f8804d86d9
      // log(hash23);//7d96d695f6738d448cfc0259941747422c8d090ce38d46e597ccf74b2fa96a8d
        let hashroot = sha256((hash01, hash23));
      // log(hashroot);//24862fce39fefec4a5622eba4807b49555e234f6063a1669f877a293d14df1e3
        MiniMerkleTree {
            leaves: leaves,
            hashroot: hashroot,
        }
    }
}
