public with sharing class TestUtils {
    static Integer idCounter = 1;

    public static Id getFakeId(System.Type sObjectType) {
        return getFakeId(((SObject) sObjectType.newInstance()).getSObjectType());
    }

    public static Id getFakeId(Schema.SObjectType sObjectType) {
        String index = String.valueOf(idCounter++);
        return (Id) (sObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12 - index.length()) + index);
    }
}
