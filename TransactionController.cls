public with sharing class TransactionController {
    @AuraEnabled(cacheable=true)
    public static List<Bank_Transaction__c> getTransactions(Id accountId) {
        return [
            SELECT Id, Type__c, Amount__c, Date__c
            FROM Bank_Transaction__c
            WHERE Account__c = :accountId
            ORDER BY Date__c DESC
        ];
    }
}
