module test_pkg1;

string hello() {
  return "test_pkg1";
}

@("success")
unittest {
  assert(hello() == "test_pkg1");
}

@("fail")
unittest {
  assert(hello() != "test_pkg1");
}
