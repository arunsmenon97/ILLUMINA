import { LightningElement,api } from 'lwc';
export default class Ila_showCountryResponse extends LightningElement {
@api response;
handleBack() {
       // Dispatch a custom event to notify the parent component
        const backEvent = new CustomEvent('back');
        this.dispatchEvent(backEvent);
    }
}