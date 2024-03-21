@isTest
public class ManufacturerPartControllerTest {

    // complete mocking of ManufacturerPartService class
    @isTest
    static void testAssociateManufacturerPartsWithAccount() {
        MockProvider mock = new MockProvider(ManufacturerPartService.class);
        ManufacturerPartController.mPartServiceInstance = (ManufacturerPartService) mock.mockInstance;
        Id accountId = TestUtils.getFakeId(Account.class),
            mPartId = TestUtils.getFakeId(Manufacturer_Part__c.class);
        String fakeName = 'look ma';
        Manufacturer_Part__c mPart = new Manufacturer_Part__c(Id=mPartId, Name=fakeName);
        mock.mockReturnValue('getManufacturerParts', new List<Manufacturer_Part__c>{ mPart });
        
        ManufacturerPartController.associateManufacturerPartsWithAccount(accountId, new List<Id>{ mPartId });

        List<MockProvider.MethodInvocation> getManufacturerPartsHistory = mock.invokedMethods.get('getManufacturerParts');
        getManufacturerPartsHistory[0].assertToHaveBeenCalledWith(new Map<String, Object>{
            'mPartIds' => new List<Id> { mPartId }
        });
        List<MockProvider.MethodInvocation> updateManufacturerHistory = mock.invokedMethods.get('updateManufacturer');
        updateManufacturerHistory[0].assertToHaveBeenCalledWith(new Map<String, Object>{
            'accountId' => accountId,
            'mParts' => new List<Manufacturer_Part__c>{ mPart }
        });
    }
}
