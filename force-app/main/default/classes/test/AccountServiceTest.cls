@isTest
public class AccountServiceTest {

    @isTest
    static void testCreateAccounts() {
        AccountService accService = new AccountService();
        MockProvider mock = new MockProvider(DML.class);
        accService.dmlService = (DML) mock.mockInstance;
        List<Account> accs = new List<Account> { new Account(Name='KimJinPangTng') };
        accService.createAccounts(accs);

        List<MockProvider.MethodInvocation> insertRecordsHistory = mock.invokedMethods.get('insertRecords');
        insertRecordsHistory[0].assertToHaveBeenCalledWith(new Map<String, Object>{
            'records' => accs,
            'allOrNone' => true
        });
    }
}
