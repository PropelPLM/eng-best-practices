public with sharing class ManufacturerPartService {
    public class ManufacturerPartServiceException extends Exception {}

    @TestVisible
    private DML dmlService;
    public ManufacturerPartService() {
        this.dmlService = new DML();
    }

    public void updateManufacturer(Id accountId, Manufacturer_Part__c mPart) {
        this.updateManufacturer(accountId, new List<Manufacturer_Part__c>{ mPart });
    }

    public void updateManufacturer(Id accountId, List<Manufacturer_Part__c> mParts) {
        try {
            if (accountId == null || accountId.getSObjectType() != Account.SObjectType) { throw new ManufacturerPartServiceException('Invalid account ID.'); }
            if (mParts == null || mParts.isEmpty()) { return; }

            for (Manufacturer_Part__c mPart : mParts) {
                mPart.Manufacturer__c = accountId;
            }
            this.dmlService.updateRecords(mParts);
        } catch (Exception e) {
            throw new ManufacturerPartServiceException('Updating Manufacturer Parts\' Manufacturer failed: ' + e.getMessage());
        }
    }

    public Manufacturer_Part__c getManufacturerPart(Id mPartId) {
        List<Manufacturer_Part__c> mParts = this.getManufacturerParts(new List<Id>{ mPartId });
        return mParts?.get(0);
    }

    public List<Manufacturer_Part__c> getManufacturerParts(List<Id> mPartIds) {
        return this.getManufacturerParts(mPartIds, 'Id, Name');
    }

    public List<Manufacturer_Part__c> getManufacturerParts(List<Id> mPartIds, String fieldString) {
        try {
            return (List<Manufacturer_Part__c>) new QueryBuilder(Manufacturer_Part__c.class)
                .addFields(fieldString)
                .addConditions()
                    .add(new QueryBuilder.InCondition('Id').inCollection(mPartIds))
                .endConditions()
                .toList();
        } catch (Exception e) {
            throw new ManufacturerPartServiceException('Query for Manufacturer Parts failed: ' + e.getMessage());
        }
    }
}
