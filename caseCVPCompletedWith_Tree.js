/*
* @description       : 
* @author            : mohsin.hassan@gravitai.com
* @group             :
* @last modified on  : 07-17-2021
* @last modified by  : Mohsin Hassan
* Modifications Log
* Ver   Date         Author              Modification
* 1.0   07-17-2021   mohsin.hassan@gravitai.com   Initial Version
*/

import { LightningElement, api, track } from "lwc";
import getAccRelationship from "@salesforce/apex/CaseLCMPCompletedCVPHandler.getAccRelationship";
//import getAccountId from "@salesforce/apex/CaseLCMPCompletedCVPHandler.getAccountId";
import populateHighRiskCVP from "@salesforce/apex/CaseLCMPCompletedCVPHandler.populateHighRiskCVP";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { updateRecord } from 'lightning/uiRecordApi';

export default class CaseLCMPCompletedCVPHandler extends LightningElement {

@api recordId;
@track items;
@track error;
@track result;

connectedCallback(){
getAccRelationship({ caseId: this.recordId })
.then((result) => {
    console.log('result ',result);
    this.items = result;
    this.error = undefined;
})
.catch((error) => {
    console.log('error ',error);
    this.error = error;
    this.items = undefined;
});
}

thePopulateHighRiskCVP( event ){
populateHighRiskCVP({ name: event.detail.name, caseId:this.recordId })
.then(result => {
    if(result){
        console.log(result);
    }
})
.catch(error => {
    console.log('Error: ', error);
})
}

handleselect(event){
this.thePopulateHighRiskCVP(event);  
console.log('event' , event.detail.name);  
let fields = {
    Id: this.recordId,
}
const recordInput = { fields };
updateRecord(recordInput)
.then(() => { 
    this.dispatchEvent(
        new ShowToastEvent({
            title: 'Success',
            message: 'High Risk CVP updated',
            variant: 'success'
        })
    );
})
.catch(error => {
    console.log('error ',error);
    this.dispatchEvent(
        new ShowToastEvent({
            title: 'Error creating record',
            message: error.body.message,
            variant: 'error'
        })
    );
});
}
}
