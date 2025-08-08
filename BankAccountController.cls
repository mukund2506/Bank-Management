public with sharing class BankAccountController {

    @AuraEnabled(cacheable=true)
    public static List<Bank_Account__c> getAllAccounts() {
        return [
            SELECT Id, Name, Balance__c, Account_Type__c, Status__c
            FROM Bank_Account__c
            ORDER BY CreatedDate DESC
        ];
    }

    @AuraEnabled
    public static Bank_Account__c depositAmount(Id accountId, Decimal amount) {
        Bank_Account__c acc = [SELECT Id, Balance__c FROM Bank_Account__c WHERE Id = :accountId LIMIT 1];
        acc.Balance__c += amount;
        update acc;
        return acc;
    }

    @AuraEnabled
    public static Bank_Account__c withdrawAmount(Id accountId, Decimal amount) {
        Bank_Account__c acc = [SELECT Id, Balance__c FROM Bank_Account__c WHERE Id = :accountId LIMIT 1];
        if (amount > acc.Balance__c) {
            throw new AuraHandledException('Insufficient balance.');
        }
        acc.Balance__c -= amount;
        update acc;
        return acc;
    }
    private static void logTransaction(Id accountId, String type, Decimal amount) {
    Bank_Transaction__c txn = new Bank_Transaction__c();
    txn.Account__c = accountId;
    txn.Type__c = type;
    txn.Amount__c = amount;
    txn.Date__c = System.now();
    insert txn;
}

@AuraEnabled
public static Bank_Account__c depositAmount(Id accountId, Decimal amount) {
    Bank_Account__c acc = [SELECT Id, Balance__c FROM Bank_Account__c WHERE Id = :accountId LIMIT 1];
    acc.Balance__c += amount;
    update acc;
    logTransaction(accountId, 'Deposit', amount);
    return acc;
}

@AuraEnabled
public static Bank_Account__c withdrawAmount(Id accountId, Decimal amount) {
    Bank_Account__c acc = [SELECT Id, Balance__c FROM Bank_Account__c WHERE Id = :accountId LIMIT 1];
    if (amount > acc.Balance__c) {
        throw new AuraHandledException('Insufficient balance.');
    }
    acc.Balance__c -= amount;
    update acc;
    logTransaction(accountId, 'Withdrawal', amount);
    return acc;
}

}
