import { LightningElement, track , wire} from 'lwc';
import saveData from '@salesforce/apex/ILA_SearchZipCodeController.saveData';
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import COUNTRYCODE_FIELD from "@salesforce/schema/ILA_Zipcode__c.ILA_Country_Code__c";

export default class Ila_searchZipcodes extends LightningElement {
 
  @track zipCode = '';
  @track country = ''; // Default country code
  @track response;
  @track showInputs = true;
  @track errorResponse;
  countryOptions;

@wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: COUNTRYCODE_FIELD })
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.countryOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));
        } else if (error) {
            console.error(error);
        }
    }


  handleCountryChange(event) {
    this.country = event.target.value;
  }

  handleZipCodeChange(event) {
    this.zipCode = event.target.value;
  }

  async fetchDetails() {
    this.response = ''; // Clear previous response
     this.errorResponse = '';
     

    if (!this.zipCode || !this.country) {
      this.errorResponse = 'Error: Please enter both country and ZIP code.';
      return;
    }
    const url = `http://api.zippopotam.us/${this.country}/${this.zipCode}`;
    try {
      const res = await fetch(url);
      if (res.status === 404) {
        // Handle ZIP code not found (404 error)
        this.showInputs = false;
        this.response = `Error: No data found for ZIP code ${this.zipCode} in country ${this.country}.`;
        return;
      }
      const data = await res.json();
      if (!data || !data.country) {
        // Handle empty or invalid data
         this.showInputs = false;
        this.response = `Error: No valid data received for ZIP code ${this.zipCode}.`;
        return;
      }
      if (data.country === 'United States') {
        // Display US data in another component
        this.showInputs = false;
        this.response = `US Data fetched successfully: ${JSON.stringify(data, null, 2)}`;
        const event = new CustomEvent('usdata', { detail: data });
        this.dispatchEvent(event);
      } else {
        // Save non-US data in the custom object
        await saveData({ data: JSON.stringify(data) });
        this.showInputs = false;
        this.response = `Data saved successfully: ${JSON.stringify(data, null, 2)}`;
      }
    } catch (error) {
      // Handle other network errors or exceptions
      this.showInputs = false;
      this.response = `Error: Unable to fetch details due to ${error.message}`;
    }
  }

  handleBack() {
      this.showInputs = true; 
    }
}