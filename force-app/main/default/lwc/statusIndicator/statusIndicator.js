import { LightningElement, api, track } from 'lwc';

export default class StatusIndicator extends LightningElement {
    @api completed;
    @track text = '';

    get completedClass() {
        return this.completed ? 'completed' : 'cancelled';
    }

    handleInputChange(event) {
        this.text = event.target.value;
    }
}
