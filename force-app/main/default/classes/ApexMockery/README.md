# ApexMockery

Simple mocking framework for Apex

## Set up

This module is likely to be included as a submodule as part of a larger git repository. When cloning the parent repository, it is required that you run 
`git submodule update --init` to get the `ApexMockery` files into your local to start working on/with them. Please run this command first before you do a full deploy
so as to allow `sfdx` to also pick up and deploy this. (If CI/CD builds are failing due to `ApexMockery`, check that the aforementioned command is included in the build step.)

To pull code from another repo where this is a submodule of, run `git submodule update --remote --merge`.

## Quick start

To effectively mock and hence abstract the complexities of an object, use `ApexMockery` to inject the generated mock as a dependency of the class to be tested.
`SeriousBusiness.cls` (class to test)

```apex
public SeriousBusiness {
  public MockMe integralBusinessLogicClass;

  public void printMoney() {
    integralBusinessLogicClass.makeMoney();
   }
}
```

`SeriousBusinessTest.cls` (test class)

```apex
public SeriousBusinessTest {
  static void testPrintMoney() {
      MockProvider mock = new MockProvider(MockMe.class);
      SeriousBusiness rlySrsBiz = new SeriousBusiness();
      rlySrsBiz.integralBusinessLogicClass = (MockMe) mock.mockInstance;

      rlySrsBiz.printMoney();
      System.assert(mock.hasBeenCalled('makeMoney'), 'makeMoney should have been called');
  }
}
```
