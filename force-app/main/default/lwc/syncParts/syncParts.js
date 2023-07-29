import { track, LightningElement } from 'lwc';
import syncPartsCallout from '@salesforce/apex/CQPartIntegration.makeCalloutToGetPartData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SyncParts extends LightningElement {
		@track showSpinner = false;
		handleSync() {
				this.showSpinner = true;
				syncPartsCallout()
		.then(result => {
						this.showSpinner = false;
			var response =	JSON.parse(result);
						console.log(response);
						if(response) {
							 if(response.isSuccess) {
									 this.showToast(response.message, 'success', 'Success');
							 } else if(!response.isSuccess) {
									 this.showToast(response.message, 'error', 'Error');
							 }	
						}
						
		})
		.catch(error => {
						this.showSpinner = false;
				this.showToast(JSON.stringify(error), 'error', 'Error');
		})
		}
		
		showToast(msg, variant, title) {
								const event = new ShowToastEvent({
            		title: title,
								variant : variant,		
            		message: msg
        			});
        this.dispatchEvent(event);
		}
}