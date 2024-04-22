public with sharing class ManufacturerPartService {
    public class ManufacturerPartServiceException extends Exception {}

    @TestVisible
    private DML dmlService;
    @TestVisible
    private FeatureFlagService ffService;
    public ManufacturerPartService() {
        this.dmlService = new DML();
        this.ffService = new FeatureFlagService();
    }

    public void updateManufacturer(Id accountId, Manufacturer_Part__c mPart) {
        this.updateManufacturer(accountId, new List<Manufacturer_Part__c>{ mPart });
    }

    /**
     * Update manufacturer parts' manufacturer field with manufacturer account.
     * @param Id accountId Id of manufacturer account that manufacturer parts' should be associated with
     * @param List<Manufacturer_Part__c> mParts manufacturer parts that should be associated to the given accountId
     */
    public void updateManufacturer(Id accountId, List<Manufacturer_Part__c> mParts) {
        try {
            if (accountId == null || accountId.getSObjectType() != Account.SObjectType) { throw new ManufacturerPartServiceException('Invalid account ID.'); }
            if (!this.ffService.canAssociateManufacturers()){ throw new ManufacturerPartServiceException(System.label.feature_is_in_beta); }
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

    /**
     * Retrieves manufacturer parts
     * @param List<Id> mPartIds list of IDs to retrieve manufacturer parts for
     * @param String fields of accounts that should be retrieved
     * @return List<Account> manufacturer parts retrieved
     */
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
