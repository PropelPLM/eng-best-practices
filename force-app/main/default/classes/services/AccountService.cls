public with sharing class AccountService {

    public class AccountServiceException extends Exception {}
    
    @TestVisible
    private DML dmlService;
    public AccountService() {
        this.dmlService = new DML();
    }

    public void createAccounts(List<Account> accounts) {
        createAccounts(accounts, true);
    }

    public void createAccounts(List<Account> accounts, Boolean allOrNothing) {
        if (accounts == null) { throw new AccountServiceException(); }
        this.dmlService.insertRecords(accounts, allOrNothing);
    }
}