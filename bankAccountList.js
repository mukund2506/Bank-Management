import { LightningElement, wire, track } from 'lwc';
import getAllAccounts from '@salesforce/apex/BankAccountController.getAllAccounts';
import depositAmount from '@salesforce/apex/BankAccountController.depositAmount';
import withdrawAmount from '@salesforce/apex/BankAccountController.withdrawAmount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BankAccountList extends LightningElement {
    @track accounts;
    accountId;
    amount;

    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Type', fieldName: 'Account_Type__c' },
        { label: 'Balance', fieldName: 'Balance__c', type: 'currency' },
        { label: 'Status', fieldName: 'Status__c' }
    ];

    @wire(getAllAccounts)
    wiredAccounts({ data, error }) {
        if (data) {
            this.accounts = data;
        } else if (error) {
            console.error(error);
        }
    }

    handleAccountIdChange(event) {
        this.accountId = event.target.value;
    }
    handleAmountChange(event) {
        this.amount = parseFloat(event.target.value);
    }

    handleDeposit() {
        depositAmount({ accountId: this.accountId, amount: this.amount })
            .then(() => {
                this.showToast('Success', 'Amount Deposited', 'success');
                return refreshApex(this.accounts);
            })
            .catch(error => this.showToast('Error', error.body.message, 'error'));
    }

    handleWithdraw() {
        withdrawAmount({ accountId: this.accountId, amount: this.amount })
            .then(() => {
                this.showToast('Success', 'Amount Withdrawn', 'success');
                return refreshApex(this.accounts);
            })
            .catch(error => this.showToast('Error', error.body.message, 'error'));
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
