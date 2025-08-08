import { LightningElement, track } from 'lwc';
import createAccount from '@salesforce/apex/AccountCreationController.createAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateBankAccount extends LightningElement {
    @track name;
    @track accountType;
    @track balance;

    accountTypes = [
        { label: 'Savings', value: 'Savings' },
        { label: 'Current', value: 'Current' }
    ];

    handleNameChange(event) {
        this.name = event.target.value;
    }
    handleTypeChange(event) {
        this.accountType = event.detail.value;
    }
    handleBalanceChange(event) {
        this.balance = parseFloat(event.target.value);
    }

    createAccount() {
        createAccount({ name: this.name, accountType: this.accountType, initialBalance: this.balance })
            .then(() => {
                this.showToast('Success', 'Account Created', 'success');
                this.name = '';
                this.accountType = '';
                this.balance = '';
            })
            .catch(error => this.showToast('Error', error.body.message, 'error'));
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
