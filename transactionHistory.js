import { LightningElement, track } from 'lwc';
import getTransactions from '@salesforce/apex/TransactionController.getTransactions';

export default class TransactionHistory extends LightningElement {
    @track transactions;
    accountId;

    columns = [
        { label: 'Type', fieldName: 'Type__c' },
        { label: 'Amount', fieldName: 'Amount__c', type: 'currency' },
        { label: 'Date', fieldName: 'Date__c', type: 'date' }
    ];

    handleAccountIdChange(event) {
        this.accountId = event.target.value;
    }

    loadTransactions() {
        getTransactions({ accountId: this.accountId })
            .then(result => {
                this.transactions = result;
            })
            .catch(error => console.error(error));
    }
}
