import { LightningElement, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import ID_FIELD from '@salesforce/schema/Lead.Id';
import PHOTO_ID_FIELD from '@salesforce/schema/Lead.Photo_Id__c';

export default class LeadPhotoUploader extends LightningElement {

    @api recordId;
    lead;
    photoId;
    photoURL;

    /* Load Lead.Photo_Id__c for displaying the photo */
    @wire(getRecord, { recordId: '$recordId', fields: [PHOTO_ID_FIELD] })
    wiredRecord({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading information',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data) {
            this.lead = data;
            if (this.lead.fields.Photo_Id__c.value) {
                this.photoId = this.lead.fields.Photo_Id__c.value;
                this.photoURL = '/sfc/servlet.shepherd/version/download/' + this.photoId;
            }
        }
    }

    get acceptedFormats() {
        return ['.png','.jpg','.jpeg'];
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        this.photoId = uploadedFiles[0].contentVersionId;
        this.updateLead(this.photoId);
        this.photoURL = '/sfc/servlet.shepherd/version/download/'  + this.photoId;
    }

    updateLead(photoId) {
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[PHOTO_ID_FIELD.fieldApiName] = photoId;

        const recordInput = { fields };
        updateRecord(recordInput)
        .then(() => {
            // Display fresh data in the form
            return refreshApex(this.lead);
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating photo information on lead record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }
}