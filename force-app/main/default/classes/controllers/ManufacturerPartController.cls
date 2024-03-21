public with sharing class ManufacturerPartController {
    @TestVisible
    private static ManufacturerPartService mPartServiceInstance = new ManufacturerPartService();

    /**
     *  Notice how `List<Manufacturer_Part__c>` is injected directly into `.updateManufacturer()`.
     *  how we got those `Manufacturer Part` s, `.updateManufacturer()` doesn't need to know =>  
     *  this gives us opportunities to:
     *      1. test `.updateManufacturer()` in isolation without depending on what's in the DB
     *      2. move the code that gets the manufacturer parts out into a data access layer if needed
     */
    @AuraEnabled
    public static void associateManufacturerPartsWithAccount(Id accountId, List<Id> mPartIds) {
        List<Manufacturer_Part__c> mParts = mPartServiceInstance.getManufacturerParts(mPartIds);
        mPartServiceInstance.updateManufacturer(accountId, mParts);
    }
}
