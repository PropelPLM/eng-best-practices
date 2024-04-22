public with sharing class AccountService {

    public class AccountServiceException extends Exception {}
    
    @TestVisible
    private DML dmlService;
    @TestVisible
    private ActionRulesService actionRuleService;
    public AccountService() {
        this.dmlService = new DML();
        this.actionRuleService = new ActionRulesService();
    }

    public void createAccounts(List<Account> accounts) {
        createAccounts(accounts, true);
    }


    /**
     * Creates accounts
     * @param List<Account> accounts list of accounts to be created
     * @param Boolean allOrNothing to allow partial operations to the database
     */
    public void createAccounts(List<Account> accounts, Boolean allOrNothing) {
        try {
            if (accounts == null) { throw new AccountServiceException(System.Label.argument_cant_be_null); }
            if (!this.actionRuleService.canPerformDML()) { throw new AccountServiceException(System.Label.insufficient_permissions); }
            this.dmlService.insertRecords(accounts, allOrNothing);
        } catch (Exception e) {
            throw new AccountServiceException(e.getMessage());
        }
    }

    public Account getAccount(Id accountId) {
        List<Account> acc = this.getAccounts(new List<Id>{ accountId });
        return acc?.get(0);
    }

    public List<Account> getAccounts(List<Id> accountIds) {
        return this.getAccounts(accountIds, 'Id, Name');
    }

    /**
     * Retrieves accounts
     * @param List<Id> accountIds list of IDs to retrieve accounts for
     * @param String fields of accounts that should be retrieved
     * @return List<Account> accounts retrieved
     */
    public List<Account> getAccounts(List<Id> accountIds, String fieldString) {
        try {
            return (List<Account>) new QueryBuilder(Account.class)
                .addFields(fieldString)
                .addConditions()
                    .add(new QueryBuilder.InCondition('Id').inCollection(accountIds))
                .endConditions()
                .toList();
        } catch (Exception e) {
            throw new AccountServiceException();
        }
    }
}
