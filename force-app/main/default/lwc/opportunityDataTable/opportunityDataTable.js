import { LightningElement, wire, track } from 'lwc';
import getOpportunities from '@salesforce/apex/OpportunityController.getOpportunities';

export default class OpportunityDataTable extends LightningElement {
    @track opportunities = [];

    @wire(getOpportunities)
    wiredOpportunities({ error, data }) {
        if (data) {
            this.opportunities = data.map(opportunity => ({
                ...opportunity,
                rowClass: this.getRowClass(opportunity),
            }));
        } else if (error) {
            console.error('Error fetching opportunities:', error);
        }
    }

    getRowClass(opportunity) {
        if (opportunity.StageName === 'Closed Won') {
            return 'row-closed-won';
        } else if (opportunity.StageName === 'Closed Lost') {
            return 'row-closed-lost';
        }
        return '';
    }
}
