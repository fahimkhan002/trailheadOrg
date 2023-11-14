import { LightningElement, track, wire } from 'lwc';
import getStandardObjects from '@salesforce/apex/RecordCreatorController.getStandardObjects';
import createRecords from '@salesforce/apex/RecordCreatorController.createRecords';

export default class RecordCreator extends LightningElement {
    @track selectedObject = '';
    @track numRecords = 1;
    @track objectOptions = [];

    @wire(getStandardObjects)
    wiredObjectOptions({ data, error }) {
        if (data) {
            this.objectOptions = data;
        } else if (error) {
            console.error('Error fetching standard objects:', error);
        }
    }

    handleObjectChange(event) {
        this.selectedObject = event.detail.value;
    }

    handleNumRecordsChange(event) {
        this.numRecords = event.detail.value;
    }

    createRecords() {
        createRecords({ objectApiName: this.selectedObject, numRecords: this.numRecords })
            .then(result => {
                console.log('Records created successfully:', result);
            })
            .catch(error => {
                console.error('Error creating records:', error);
            });
    }
}
