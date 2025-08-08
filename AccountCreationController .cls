public with sharing class AccountCreationController {

    @AuraEnabled
    public static Id createAccount(String name, String accountType, Decimal initialBalance) {
        Bank_Account__c acc = new Bank_Account__c();
        acc.Name = name;
        acc.Account_Type__c = accountType;
        acc.Balance__c = initialBalance;
        acc.Status__c = 'Active';
        insert acc;
        return acc.Id;
    }
}
