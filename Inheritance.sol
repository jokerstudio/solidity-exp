pragma solidity 0.8.18;

contract Base {
  uint public u;
}

contract C is Base {
  function f() public virtual {
    u = 1;
  }
}

contract B is Base {
  function f() public virtual {
    u = 2;
  }
}

contract A is B, C {
  function f() public override(B, C) {  // will set u to 3
    u = 3;
  }

  function f1() public { // will set u to 1
    super.f(); //call the right first
  }

  function f2() public { // will set u to 2
    B.f();
  }

  function f3() public { // will set u to 1
    C.f();
  }
}
