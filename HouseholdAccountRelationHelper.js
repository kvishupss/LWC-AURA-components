({  
    helperMethod : function(component) {  
        var action = component.get("c.getAccRelationship");  
        action.setParams({ caseId : component.get("v.recordId") });  
        action.setCallback(this, function(response) {  
            var state = response.getState(); 
            if (state === "SUCCESS" ) {  
                component.set( "v.items", response.getReturnValue());  
            }
            else if (state === "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: result.getError()[0].message,
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        });  
        $A.enqueueAction(action);  
    }  ,
    helperhandleSelect: function (component, event, helper) {  
        var name = event.getParam('name');
        console.log('name',event.getParam('name'));
        console.log('label',event.getParam('label'));
        var action = component.get("c.populateHighRiskCVP");  
        action.setParams({ 	name : name,
                          caseId : component.get("v.recordId")
                         });
        action.setCallback(this, function(response) {  
            var state = response.getState(); 
            if (state === "SUCCESS" ) {   
                $A.get('e.force:refreshView').fire();
            }  
        });  
        $A.enqueueAction(action);       
    }
})