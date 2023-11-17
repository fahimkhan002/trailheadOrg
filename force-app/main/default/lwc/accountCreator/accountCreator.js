import { LightningElement, track,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createAccounts from '@salesforce/apex/AccountController.createAccounts';

export default class CreateAccounts extends LightningElement {
    @api numberOfAccounts = 1;


   //Connected callback will run when the component is initialized
   connectedCallback() {
       //Here we explicitly call our Apex method(Imperative call)
       this.createAccounts();
   }


    handleNumRecordsChange(event) {
        this.numberOfAccounts = event.detail.value;
    }
    
    createAccounts() {
        //console.log('User Input ',numberOfAccounts);
        createAccounts({ numRecords: this.numberOfAccounts })
            .then(result => {
              //  console.log(numRecords);
            
              console.log("Creating records" + JSON.stringify(result));
            
            })
            .catch(error => {
                console.error('Error creating records:', error);
            });
    }
}