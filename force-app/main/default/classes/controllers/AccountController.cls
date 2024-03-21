public with sharing class AccountController {
    @TestVisible
    private static AccountService accountServiceInstance = new AccountService();

    @AuraEnabled
    public static void createAccounts(AccountRequest req) {
        AccountController.accountServiceInstance.createAccounts(req.accounts, req.allOrNone);
    }
}