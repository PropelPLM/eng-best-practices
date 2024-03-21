public with sharing class DML {

    public List<Database.SaveResult> insertRecords(List<SObject> records) {
        return this.insertRecords(records, true);
    }

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

    public List<Database.SaveResult> updateRecords(List<SObject> records) {
        return this.updateRecords(records, true);
    }

    public List<Database.SaveResult> updateRecords(List<SObject> records, Boolean allOrNone) {
        return this.updateRecords(
            records, 
            new DMLOptions()
                .setAllOrNone(allOrNone)
                .build()
        );
    }

    public List<Database.SaveResult> updateRecords(List<SObject> records, Database.DMLOptions dmo) {
        return Database.update(records, dmo);
    }
}
