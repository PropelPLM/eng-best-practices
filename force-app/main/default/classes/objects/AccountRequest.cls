public with sharing class AccountRequest {
    public AccountRequest() {}

    public List<Account> accounts { get; set; }
    public Boolean allOrNone { get; set; }
}