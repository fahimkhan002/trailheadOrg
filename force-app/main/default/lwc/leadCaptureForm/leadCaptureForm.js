import { LightningElement, track, wire } from 'lwc';
import getLeadSourcePicklistValues from '@salesforce/apex/LeadController.getLeadSourcePicklistValues';
import createLead from '@salesforce/apex/LeadController.createLead';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; // Import ShowToastEvent


export default class LeadCaptureForm extends LightningElement {
    @track firstName = '';
    @track lastName = '';
    @track email = '';
    @track mobilePhone = '';
    @track howDidYouHear = '';
    @track comments = '';
    @track recordId = ''; // To store the uploaded file's record ID
    @track howDidYouHearOptions = []; // Populate with picklist values
    specialtyOptions = []; // Populate with picklist values

    @track selectedFileName = ''; // To display the selected file name
    fileToUpload = null; // To store the selected file for upload

    // Fetch picklist values using a wire adapter
    // @wire(getLeadSourcePicklistValues)
    // wiredLeadSourcePicklistValues({ error, data }) {
    //     if (data) {
    //         this.howDidYouHearOptions = data;
    //         console.log(data);
    //         console.log(' how did you head ',this.howDidYouHearOptions);
    //     } else if (error) {
    //         // Handle the error
    //         console.error('Error fetching picklist values:', error);
    //     }
    // }


    // Add a new method to handle file changes
    handleFileChange(event) {
        const selectedFile = event.target.files[0];
        if (selectedFile) {
            this.selectedFileName = selectedFile.name;
            this.fileToUpload = selectedFile; // Store the selected file for later upload
        } else {
            this.selectedFileName = '';
            this.fileToUpload = null;
        }
    }


        // Add a method to handle the file upload
        handleUpload() {
            if (this.fileToUpload) {
                // You can now proceed to upload the file using your chosen method,
                // and once the upload is successful, associate it with the Lead record.
                
                // Example: You can call an Apex method to handle the file upload
                uploadFile({ parentId: this.recordId, fileName: this.selectedFileName, fileData: this.fileToUpload })
                    .then(result => {
                        // Handle the success of the file upload
                        this.showToast('Success', 'File uploaded successfully', 'success');
                    })
                    .catch(error => {
                        // Handle any errors during file upload
                        this.showToast('Error', 'An error occurred during file upload', 'error');
                    });
            } else {
                this.showToast('Error', 'Please select a file to upload', 'error');
            }
        }

    // Define change handlers for new fields
    handleFirstNameChange(event) {
        this.firstName = event.target.value;
    }

    handleLastNameChange(event) {
        this.lastName = event.target.value;
    }

    handleEmailChange(event) {
        this.email = event.target.value;
    }

    handleMobilePhoneChange(event) {
        this.mobilePhone = event.target.value;
    }

    handleHowDidYouHearChange(event) {
        this.howDidYouHear = event.detail.value;
    }

    handleFileUpload(event) {
        // Handle file upload, e.g., store the uploaded file's record ID
        this.recordId = event.detail.files[0].documentId;
    }

    handleCommentsChange(event) {
        this.comments = event.target.value;
    }

    handleSubmit() {
        // Prepare data to send to Apex method
        const leadData = {
            FirstName: this.firstName,
            LastName: this.lastName,
            Email: this.email,
            MobilePhone: this.mobilePhone,
            HowDidYouHear: this.howDidYouHear,
            RecordId: this.recordId, // Pass the uploaded file's record ID
            Comments: this.comments
            // Add other fields here
        };

        // Call the Apex method to create a Lead
        createLead({ leadData })
            .then(result => {
                // Handle success, e.g., show a success message
                this.showToast('Success', 'Lead created successfully', 'success');
                // Reset form fields
                this.resetForm();
            })
            .catch(error => {
                // Handle error, e.g., show an error message
                this.showToast('Error', 'An error occurred while creating the Lead', 'error');
            });
    }

    resetForm() {
        this.firstName = '';
        this.lastName = '';
        this.email = '';
        this.mobilePhone = '';
        this.howDidYouHear = '';
        this.comments = '';
        this.recordId = '';
        // Reset other fields as needed
    }

    showToast(title, message, variant) {
        // Show a toast message to the user
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(toastEvent);
    }
}
