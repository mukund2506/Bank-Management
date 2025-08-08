public with sharing class BankNotificationHelper {
    @AuraEnabled
    public static void sendNotification(Set<Id> userIds, String title, String body) {
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle(title);
        notification.setBody(body);
        notification.setNotificationTypeId(getNotificationTypeId('Bank_Alert'));
        notification.setTargetId(UserInfo.getUserId()); // can also be a record Id
        notification.send(userIds);
    }

    private static Id getNotificationTypeId(String developerName) {
        return [SELECT Id FROM CustomNotificationType WHERE DeveloperName = :developerName LIMIT 1].Id;
    }
}
