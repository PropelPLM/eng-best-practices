public with sharing class ManufacturerPartController {
    @TestVisible
    private static ManufacturerPartService mPartServiceInstance = new ManufacturerPartService();

    @AuraEnabled
    public static void associateManufacturerPartsWithAccount(Id accountId, List<Id> mPartIds) {
        List<Manufacturer_Part__c> mParts = mPartServiceInstance.getManufacturerParts(mPartIds);
        mPartServiceInstance.updateManufacturer(accountId, mParts);
    }
}
