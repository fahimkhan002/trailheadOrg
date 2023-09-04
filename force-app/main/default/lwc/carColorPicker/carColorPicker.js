import { LightningElement } from 'lwc';
const BASE_IMAGE_URL = 'https://sfdc-demo.s3-us-west-1.amazonaws.com/ecars';
const COLORS = ['green','red','black','blue','white'];

export default class CarColorPicker extends LightningElement {
    colors = COLORS;
    selectedColor = this.colors[0];

    get selectedImage(){
        return `${BASE_IMAGE_URL}/car_${this.selectedColor}.jpg`;
    }

    selectedHandler(event){
        this.selectedColor = event.target.dataset.color;
    }

}