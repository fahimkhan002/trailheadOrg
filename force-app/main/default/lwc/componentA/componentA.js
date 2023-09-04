import { LightningElement, track } from 'lwc';

export default class ComponentA extends LightningElement {
    @track parentUserName;

    handleInputChange(event) {
        this.parentUserName = event.target.value;
    }

    submitClickHandler() {
        // Get the input value by querying the DOM
        const inputElement = this.template.querySelector('[data-id="userNameInput"]');
        const inputElment = this.template.querySelector('[data-id="userNameInput"]');
        this.parentUserName = inputElement.value;
    }
}
