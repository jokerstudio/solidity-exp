pragma solidity 0.8.18;

contract Base {
  uint public u;

  function f() public virtual {
    u = 1;
  }
}

contract Base2 {
  uint public x;

  function f() public virtual {
    x = 1;
  }
}

contract A is Base {
  function f() public virtual override {
    u = 2;
  }
}

contract B is Base {
  function f() public virtual override {
    u = 3;
  }
}


contract C is Base{
  function f() public virtual override {
    super.f();
  }
}


contract D is A, B, C {
  function f() public override(A, B, C) { 
    super.f();  
  }

  function f1() public {
    super.f(); 
  }

  function f2() public {
    B.f();
  }

  function f3() public {
    C.f();
  }
}
