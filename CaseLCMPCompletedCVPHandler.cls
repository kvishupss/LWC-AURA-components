/**
 * @description       : 
 * @author            : mohsin.hassan@gravitai.com
 * @group             :
 * @last modified on  : 07-17-2021
 * @last modified by  : Mohsin Hassan
 * Modifications Log
 * Ver   Date         Author              Modification
 * 1.0   07-17-2021   mohsin.hassan@gravitai.com   Initial Version
 **/
/*public with sharing class CaseLCMPCompletedCVPHandler {

// Method for Lightning-Tree structure component.
@auraEnabled (cacheable = true)
Public static List<items> getAccRelationship( String caseId ){
    Set<Id> contactSet = new Set<Id>(); 
    List<items> finalWrap = new List<items>(); 
    List<items> finalItem = new List<items>();
    List<items> finalItem1 = new List<items>();
    
    List<Case> accList = [select id,AccountId,Account.name 
                            from case 
                            where Id = : caseId and Account.Recordtype.Name = 'Household' limit 1];
                            
    
    Id accId = accList.size() > 0 ? accList[0].AccountId : null;
    String accName = accList.size() > 0 ? accList[0].Account.name : null;
    
    for(AccountContactRelation acr : [ SELECT Id, AccountId, Account.name, Contact.name, ContactId 
                                        FROM AccountContactRelation WHERE accountid =: accId ]) 
    {  
        contactSet.add(acr.ContactId);
        List<items> tree = new List<items>{new items(acr.ContactId, acr.Contact.name, false, null)}; 
            finalItem.addAll(tree);
    }    
    finalWrap.add(new items(accName, accName, false, finalItem));
    
    for(FinServ__AccountAccountRelation__c aar : [ SELECT Id, FinServ__RelatedAccount__c,  FinServ__RelatedAccount__r.name
                                                    FROM FinServ__AccountAccountRelation__c WHERE FinServ__Account__c =:accId]) 
    {  
        
        List<items> tree = new List<items>{new items(aar.FinServ__RelatedAccount__c, aar.FinServ__RelatedAccount__r.name, false, null)}; 
            finalItem1.addAll(tree);
        
    }       
    finalWrap.add(new items('Related Account', 'Related Account', false, finalItem1));
    
    List<items> finalItem2 = new List<items>();
    for(FinServ__ContactContactRelation__c ccr : [ SELECT Id, FinServ__Contact__c,FinServ__Contact__r.name, FinServ__RelatedContact__c 
                                                    FROM FinServ__ContactContactRelation__c
                                                    WHERE FinServ__RelatedContact__c in: contactSet ]) 
    {  
        List<items> tree = new List<items>{new items(ccr.FinServ__Contact__c, ccr.FinServ__Contact__r.name, false, null)}; 
            finalItem2.addAll(tree);
        
    }    
    finalWrap.add(new items('Related Contact', 'Related Contact', false, finalItem2));
    
    System.debug('finalWrap-->' + finalWrap);   
    return finalWrap;  
    
} */   
@auraEnabled
// Populating High Risk CVP field with the clicked Id.
Public static void populateHighRiskCVP( String name, ID caseId ){
    
    try{
        //List<Account> accPerson = new List<Account>();
        Case c = new Case( Id = caseId );
        if( Id.valueOf(name).getSObjectType().getDescribe().getName() == 'Account' ){
         // accPerson = [SELECT Id FROM Account where Id =:name  limit 1];
            c.SPW_High_Risk_CVP__c = name;
        }else if( Id.valueOf(name).getSObjectType().getDescribe().getName() == 'Contact' ){
            //accPerson = [SELECT Id, Name, RecordTypeId, PersonContactId FROM Account where PersonContactId =:name or  limit 1];
            List<contact> conList = [SELECT Id, AccountId, IsPersonAccount FROM Contact where id =:name];
            c.SPW_High_Risk_CVP__c = conList.size() > 0 ? conList[0].AccountId : null;
        }
        Database.update( c, false );
    }
    catch (Exception ex){    
        //throw new AurahandledException(ex.getMessage());
    }
}

//Method for Lightning-Acordtion structure with check box.
@auraEnabled (cacheable = true)
Public static List<AccountContactRelation> getACR( String caseId ){
    
    List<Case> accList = [select id,AccountId,Account.name 
                            from case 
                            where Id = : caseId and Account.Recordtype.Name = 'Household' limit 1];
                            
    
    Id accId = accList.size() > 0 ? accList[0].AccountId : null;
    String accName = accList.size() > 0 ? accList[0].Account.name : null;

    return [ SELECT Id, AccountId, Account.name, Contact.name, ContactId 
    FROM AccountContactRelation WHERE accountid =: accId ];
}

@auraEnabled (cacheable = true)
Public static List<FinServ__AccountAccountRelation__c> getAAR( String caseId ){
    
    List<Case> accList = [select id,AccountId,Account.name 
                            from case 
                            where Id = : caseId and Account.Recordtype.Name = 'Household' limit 1];
                            
    
    Id accId = accList.size() > 0 ? accList[0].AccountId : null;
    String accName = accList.size() > 0 ? accList[0].Account.name : null;

    return  [ SELECT Id, FinServ__RelatedAccount__c,  FinServ__RelatedAccount__r.name
    FROM FinServ__AccountAccountRelation__c WHERE FinServ__Account__c =:accId];
}

@auraEnabled (cacheable = true)
Public static List<FinServ__ContactContactRelation__c> getCCR( String caseId ){
    Set<Id> contactSet = new Set<Id>(); 
    List<Case> accList = [select id,AccountId,Account.name 
                            from case 
                            where Id = : caseId and Account.Recordtype.Name = 'Household' limit 1];

    Id accId = accList.size() > 0 ? accList[0].AccountId : null;

    for(AccountContactRelation acr : [ SELECT Id, AccountId, Account.name, Contact.name, ContactId 
                            FROM AccountContactRelation WHERE accountid =: accId ]) 
    {  
        contactSet.add(acr.ContactId);
    } 

    return  [ SELECT Id, FinServ__Contact__c,FinServ__Contact__r.name, FinServ__RelatedContact__c 
                FROM FinServ__ContactContactRelation__c
                WHERE FinServ__RelatedContact__c in: contactSet ];
}

}
