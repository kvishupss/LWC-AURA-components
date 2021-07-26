/**
* @description       : 
* @author            : mohsin.hassan@gravitai.com
* @group             :
* @last modified on  : 07-17-2021
* @last modified by  : Mohsin Hassan
* Modifications Log
* Ver   Date         Author              Modification
* 1.0   07-22-2021   mohsin.hassan@gravitai.com   Initial Version
**/

public with sharing class CaseLCMPCompletedCVPHandler {


//Method for Lightning-Acordtion structure with check box.
@auraEnabled (cacheable = true)
Public static List<wrapper> getACR( String caseId ){
    
    //List<AccountContactRelation> acr = new List<AccountContactRelation>();
    List<wrapper> wrapList = new List<wrapper>();
    String accId = null;
    
    List<Case> accList = [select id,AccountId,Account.name ,Account.IsPersonAccount,Account.PersonContactId
                            from case 
                            where Id = : caseId and (Account.Recordtype.Name = 'Household' or Account.Recordtype.Name ='Person Account') limit 1];
    
    
    if( accList.size() > 0 && !accList[0].Account.IsPersonAccount ){
        for( AccountContactRelation acr : [SELECT Id, AccountId, Account.name, Contact.name, ContactId 
                                            FROM AccountContactRelation 
                                            WHERE AccountId =: accList[0].AccountId] )
        {
            wrapper wrap = new wrapper();
            wrap.id = acr.ContactId;
            wrap.name = acr.Contact.name;
            wrap.accname = accList[0].Account.name;

            wrapList.add(wrap);
        }
    }else if ( accList.size() > 0 && accList[0].Account.IsPersonAccount ){
            wrapper wrap = new wrapper();
            wrap.id = accList[0].AccountId;
            wrap.name = accList[0].Account.name;
            wrap.accname = accList[0].Account.name;
            
            wrapList.add(wrap);
    }
    
    system.debug(accId);
    system.debug('wrapListACR' +wrapList);
    
    
    return wrapList;
}

@auraEnabled (cacheable = true)
Public static List<FinServ__AccountAccountRelation__c> getAAR( String caseId ){
    
    List<Case> accList = [select id,AccountId,Account.name ,Account.IsPersonAccount,Account.PersonContactId
    from case 
    where Id = : caseId and (Account.Recordtype.Name = 'Household' or Account.Recordtype.Name ='Person Account') limit 1];
    
    Id accId = accList.size() > 0 ? accList[0].AccountId : null;
    
    return  [ SELECT Id, FinServ__RelatedAccount__c,  FinServ__RelatedAccount__r.name
                FROM FinServ__AccountAccountRelation__c WHERE FinServ__Account__c =:accId];
}

@auraEnabled (cacheable = true)
Public static List<FinServ__ContactContactRelation__c> getCCR( String caseId ){
    Set<Id> contactSet = new Set<Id>(); 
    List<Case> accList = [select id,AccountId,Account.name ,Account.IsPersonAccount,Account.PersonContactId
    from case 
    where Id = : caseId and (Account.Recordtype.Name = 'Household' or Account.Recordtype.Name ='Person Account') limit 1];
    
    if( accList.size() > 0 && !accList[0].Account.IsPersonAccount ){
        for(AccountContactRelation acr : [ SELECT Id, AccountId, Account.name, Contact.name, ContactId 
                                        FROM AccountContactRelation WHERE accountid =: accList[0].AccountId ]) 
        {  
            contactSet.add(acr.ContactId);
        } 
    }else if( accList.size() > 0 && accList[0].Account.IsPersonAccount ){
        contactSet.add(accList[0].Account.PersonContactId);
    }
    
    return  [ SELECT Id, FinServ__Contact__c,FinServ__Contact__r.name, FinServ__RelatedContact__c 
                FROM FinServ__ContactContactRelation__c
                WHERE FinServ__RelatedContact__c in: contactSet ];
}
@auraEnabled
// Populating High Risk CVP field with the clicked Id.
Public static void populateHighRiskCVP( String name, ID caseId ){
    
    try{
        Case c = new Case( Id = caseId );
        if( Id.valueOf(name).getSObjectType().getDescribe().getName() == 'Account' ){
            c.SPW_High_Risk_CVP__c = name;
        }else if( Id.valueOf(name).getSObjectType().getDescribe().getName() == 'Contact' ){
            List<contact> conList = [SELECT Id, AccountId, IsPersonAccount FROM Contact where id =:name];
            c.SPW_High_Risk_CVP__c = conList.size() > 0 ? conList[0].AccountId : null;
        }
        Database.update( c, false );
        
    }
    catch (Exception ex){    
        // throw new AuraHandledException(ex.getMessage());
    }
}

Public class wrapper{
    @AuraEnabled 
    public string id;

    @AuraEnabled 
    public string name;

    @AuraEnabled 
    public string accname;
}

}
