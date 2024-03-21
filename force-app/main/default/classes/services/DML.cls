public with sharing class DML {

    public List<Database.SaveResult> insertRecords(List<SObject> records, Boolean allOrNone) {
        return this.insertRecords(
            records, 
            new DMLOptions()
                .setAllOrNone(allOrNone)
                .build()
        );
    }

    public List<Database.SaveResult> insertRecords(List<SObject> records, Database.DMLOptions dmo) {
        return Database.insert(records, dmo);
    }
}