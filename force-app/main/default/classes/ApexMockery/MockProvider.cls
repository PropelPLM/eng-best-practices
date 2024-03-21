@isTest
public class MockProvider implements System.StubProvider {
    public static Boolean ignoreDatabaseInteractions = false;
    public class MockProviderException extends Exception {}
    private static final Set<Type> INCONSTRUCTIBLE_TYPES = new Set<Type> {
        Date.class,
        DateTime.class,
        Decimal.class,
        Double.class,
        Integer.class,
        String.class,
        Type.forName('void')
    };

    Type mockType;
    public Object mockInstance;
    public Map<String, List<MethodInvocation>> invokedMethods = new Map<String, List<MethodInvocation>>();
    public Map<String, Object> mockReturnValues = new Map<String, Object>();

    public MockProvider(Type typeToMock) {
        this.mockType = typeToMock;
        this.mockInstance = Test.createStub(typeToMock, this);
    }

    public Boolean hasBeenCalled(String methodName) {
        List<MethodInvocation> invocations = this.invokedMethods.get(methodName);
        return invocations != null && invocations.size() > 0;
    }

    public void assertHasBeenCalled(String methodName) {
        Boolean assertion = this.hasBeenCalled(methodName);
        System.assert(assertion, methodName + ' should have been called.');
    }

    public Boolean hasBeenCalledTimes(String methodName, Integer times) {
        List<MethodInvocation> invocations = this.invokedMethods.get(methodName);
        return invocations != null && invocations.size() == times;
    }

    public void assertHasBeenCalledTimes(String methodName, Integer times) {
        Boolean assertion = this.hasBeenCalledTimes(methodName, times);
        System.assert(assertion, methodName + ' should have been called ' + String.valueOf(times) + '(s).');
    }

    public Boolean hasNotBeenCalled(String methodName) {
        return !this.invokedMethods.containsKey(methodName);
    }

    public void assertHasNotBeenCalled(String methodName) {
        Boolean assertion = this.hasNotBeenCalled(methodName);
        System.assert(assertion, methodName + ' should not have been called.');
    }

    public void mockReturnValue(String methodName, Object returnValue) {
        this.mockReturnValues.put(methodName, returnValue);
    }

    public void reset() {
        this.invokedMethods.clear();
        this.mockReturnValues.clear();
    }

    public Object handleMethodCall(
        Object stubbedObject,
        String stubbedMethodName,
        Type returnType,
        List<Type> listOfParamTypes,
        List<String> listOfParamNames,
        List<Object> listOfArgs
    ) {
        Object returnValue = evaluateReturnValue(returnType);
        MethodInvocation mi = new MethodInvocation(listOfParamNames, listOfArgs, returnValue);

        if (!this.invokedMethods.containsKey(stubbedMethodName)) {
            this.invokedMethods.put(stubbedMethodName, new List<MethodInvocation>{ mi });
        } else {
            this.invokedMethods.get(stubbedMethodName).add(mi);
        }

        if (this.mockReturnValues.containsKey(stubbedMethodName)) {
            return this.mockReturnValues.get(stubbedMethodName);
        }

        return returnValue;
    }

    private Object evaluateReturnValue(Type returnType) {
        if (INCONSTRUCTIBLE_TYPES.contains(returnType)) { return null; }

        return returnType == this.mockType
            ? this.mockInstance
            : returnType.newInstance();
    }

    public class MethodInvocation {
        public String methodSignature;
        public Map<String, Object> paramArgMap;
        public Object returnValue;

        public MethodInvocation(
            List<String> listOfParamNames,
            List<Object> listOfArgs,
            Object returnValue
        ) {
            this.methodSignature = String.join(listOfParamNames, ',');
            this.paramArgMap = createParamArgumentMap(listOfParamNames, listOfArgs);
            this.returnValue = returnValue;
        }

        private Map<String, Object> createParamArgumentMap(List<String> listOfParamNames, List<Object> listOfArgs) {
            if (
                listOfParamNames == null ||
                listOfArgs == null ||
                listOfParamNames.size() != listOfArgs.size()
            ) { throw new MockProviderException('Num of arguments and parameters should match'); }

            Map<String, Object> paramArgMap = new Map<String, Object>();
            for (Integer i = 0; i < listOfParamNames.size(); i++) {
                paramArgMap.put(listOfParamNames[i], listOfArgs[i]);
            }
            return paramArgMap;
        }

        public Boolean toHaveBeenCalledWith(Map<String, Object> compareTo) {
            // for some reason this.paramArgMap.equals(compareTo) doesnt work in stubApi THANKS SALESFORCE
            if (compareTo.size() != this.paramArgMap.size()) { return false; }

            for (String key : compareTo.keySet()) {
                if (compareTo.get(key) != this.paramArgMap.get(key)) { return false; }
            }
            return true;
        }
        
        public void assertToHaveBeenCalledWith(Map<String, Object> compareTo) {
            Boolean assertion = this.toHaveBeenCalledWith(compareTo);
            System.assert(assertion, 'Actual call: ' + this.paramArgMap.toString());
        }
    }
}
