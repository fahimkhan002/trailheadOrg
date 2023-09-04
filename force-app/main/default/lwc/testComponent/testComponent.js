import { LightningElement, api } from 'lwc';

export default class testComponent extends LightningElement {
    @api text;
    @api completed;

    get completedClass() {
        return this.completed ? 'completed' : 'cancelled';
    }
}
