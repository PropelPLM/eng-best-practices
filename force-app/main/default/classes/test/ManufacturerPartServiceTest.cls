@isTest
public class ManufacturerPartServiceTest {

    @isTest
    static void testUpdateManufacturerParts() {
        ManufacturerPartService mpartService = new ManufacturerPartService();
        MockProvider mock = new MockProvider(DML.class);
        mpartService.dmlService = (DML) mock.mockInstance;
        Id accountId = TestUtils.getFakeId(Account.class),
            mPartId = TestUtils.getFakeId(Manufacturer_Part__c.class);
        Manufacturer_Part__c mPart = new Manufacturer_Part__c(Id=mPartId);
        Manufacturer_Part__c desiredMPart = mPart.clone(true, false, false, false);
        desiredMPart.Manufacturer__c = accountId;

        mpartService.updateManufacturer(accountId, mPart);

        List<MockProvider.MethodInvocation> updateRecordsHistory = mock.invokedMethods.get('updateRecords');
        updateRecordsHistory[0].assertToHaveBeenCalledWith(new Map<String, Object>{
            'records' => new List<Manufacturer_Part__c>{ desiredMPart }
        });
    }
}
