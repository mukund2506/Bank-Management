trigger BankFraudDetectionTrigger on Bank_Transaction__c (after insert) {
    for (Bank_Transaction__c txn : Trigger.new) {
        if (txn.Type__c == 'Withdrawal' && txn.Amount__c > 50000) {
            // Send notification to admin
            BankNotificationHelper.sendNotification(
                new Set<Id>{UserInfo.getUserId()},
                'Suspicious Withdrawal',
                'Large withdrawal detected: ' + txn.Amount__c
            );
        }
    }
}
