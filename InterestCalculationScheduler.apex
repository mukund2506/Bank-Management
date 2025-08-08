global class InterestCalculationScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        List<Bank_Account__c> savingsAccounts = [
            SELECT Id, Balance__c
            FROM Bank_Account__c
            WHERE Account_Type__c = 'Savings' AND Status__c = 'Active'
        ];
        for (Bank_Account__c acc : savingsAccounts) {
            Decimal interest = acc.Balance__c * 0.04 / 12; // 4% annual
            acc.Balance__c += interest;
        }
        update savingsAccounts;
    }
}
