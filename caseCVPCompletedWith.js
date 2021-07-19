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
import { LightningElement, api, wire, track } from 'lwc';
import getACR from "@salesforce/apex/CaseLCMPCompletedCVPHandler.getACR";
import getAAR from "@salesforce/apex/CaseLCMPCompletedCVPHandler.getAAR";
import getCCR from "@salesforce/apex/CaseLCMPCompletedCVPHandler.getCCR";
import populateHighRiskCVP from "@salesforce/apex/CaseLCMPCompletedCVPHandler.populateHighRiskCVP";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';

export default class AccordionLWC extends LightningElement {

    @api recordId;
    @track items;
    @track aar;
    @track ccr;
    @track error;
    @track contacts;
    @track accName;


    connectedCallback(){
        getACR({ caseId: this.recordId })
        .then((result) => {
            console.log('result ',result);
            this.items = result;
            this.accName = result[0].Account.Name;
            this.error = undefined;
        })
        .catch((error) => {
            console.log('error ',error);
            this.error = error;
            this.items = undefined;
        });

        getAAR({ caseId: this.recordId })
        .then((result) => {
            console.log('result ',result);
            this.aar = result;
            this.error = undefined;
        })
        .catch((error) => {
            console.log('error ',error);
            this.error = error;
            this.aar = undefined;
        });

        getCCR({ caseId: this.recordId })
        .then((result) => {
            console.log('result ',result);
            this.ccr = result;
            this.error = undefined;
        })
        .catch((error) => {
            console.log('error ',error);
            this.error = error;
            this.ccr = undefined;
        });
    }

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;

        if (openSections.length === 0) {
            
        } else {
            
        }
    }

    handleChangeEvent(event){
        Array.from(this.template.querySelectorAll('lightning-input'))
        .forEach(element => {
            element.checked=false;
        });
        const checkbox = this.template.querySelector('lightning-input[data-value="'+event.target.dataset.value+'"]');
        checkbox.checked=true;
        console.log( 'event ',event.target.dataset.value);
        this.thePopulateHighRiskCVP( event.target.dataset.value );  
        let fields = {
            Id: this.recordId,
        }
        const recordInput = { fields };
        updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: ' High Risk CVP updated',
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

    thePopulateHighRiskCVP( conId ){
        populateHighRiskCVP({ name: conId, caseId:this.recordId })
            .then(result => {
                if(result){
                    console.log(result);
                }
            })
            .catch(error => {
                console.log('Error: ', error);
            })
    }


}