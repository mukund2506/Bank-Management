trigger BankAccountTrigger on Bank_Account__c (before update) {
    for (Bank_Account__c acc : Trigger.new) {
        Bank_Account__c oldAcc = Trigger.oldMap.get(acc.Id);
        if (acc.Balance__c <= 0 && oldAcc.Balance__c > 0) {
            acc.Status__c = 'Inactive';
        }
    }
}
