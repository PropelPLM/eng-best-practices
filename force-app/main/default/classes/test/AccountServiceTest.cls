@isTest
public class AccountServiceTest {

    @isTest
    static void testCreateAccounts() {
        AccountService accService = new AccountService();
        MockProvider dmlMock = new MockProvider(DML.class);
        accService.dmlService = (DML) dmlMock.mockInstance;
        MockProvider actionRuleServiceMock = new MockProvider(ActionRulesService.class);
        accService.actionRuleService = (ActionRulesService) actionRuleServiceMock.mockInstance;
        actionRuleServiceMock.mockReturnValue('canPerformDML', true);
        List<Account> accs = new List<Account> { new Account(Name='KimJinPangTng') };
        accService.createAccounts(accs);

        List<MockProvider.MethodInvocation> insertRecordsHistory = dmlMock.invokedMethods.get('insertRecords');
        insertRecordsHistory[0].assertToHaveBeenCalledWith(new Map<String, Object>{
            'records' => accs,
            'allOrNone' => true
        });
    }

    @isTest
    static void testCreateAccountsPermissionsDenied() {
        AccountService accService = new AccountService();
        MockProvider actionRuleServiceMock = new MockProvider(ActionRulesService.class);
        accService.actionRuleService = (ActionRulesService) actionRuleServiceMock.mockInstance;
        actionRuleServiceMock.mockReturnValue('canPerformDML', false);
        List<Account> accs = new List<Account> { new Account(Name='KimJinPangTng') };
        try {
            accService.createAccounts(accs);
        } catch (AccountService.AccountServiceException ase) {
            system.assert(ase.getMessage().containsIgnoreCase(System.Label.insufficient_permissions), 'AccountServiceException error message is non standard.');
        }
    }
}
