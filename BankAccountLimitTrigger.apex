trigger BankAccountTrigger on Bank_Account__c (before update, after update) {
    Set<Id> notifyUsers = new Set<Id>{UserInfo.getUserId()}; // Could be bankers or admins

    if (Trigger.isBefore) {
        for (Bank_Account__c acc : Trigger.new) {
            Bank_Account__c oldAcc = Trigger.oldMap.get(acc.Id);
            if (acc.Balance__c <= 0 && oldAcc.Balance__c > 0) {
                acc.Status__c = 'Inactive';
            }
        }
    }

    if (Trigger.isAfter) {
        for (Bank_Account__c acc : Trigger.new) {
            Bank_Account__c oldAcc = Trigger.oldMap.get(acc.Id);
            if (acc.Balance__c <= 0 && oldAcc.Balance__c > 0) {
                BankNotificationHelper.sendNotification(
                    notifyUsers,
                    'Account Inactivated',
                    'Account ' + acc.Name + ' has been set to Inactive due to zero balance.'
                );
            }
        }
    }
}
