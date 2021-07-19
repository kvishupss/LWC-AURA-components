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

@isTest
Public class CaseLCMPCompletedCVPHandlerTest {
  
  @isTest
  static void testAccount(){
      Account acc = new Account();
      acc.firstName = 'Test';
      acc.lastName = 'Boss';
      acc.RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
      acc.PersonMailingState = 'RG';
      acc.PersonMailingPostalCode = '2055';
      insert acc;
      
      Account acc1 = new Account();
      acc1.firstName = 'Test1';
      acc1.lastName = 'Ben1';
      acc1.RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
      acc1.PersonMailingState = 'RG1';
      acc1.PersonMailingPostalCode = '20861';
      insert acc1;
      
      contact con = new contact();
      con.LastName = 'Test';
      con.AccountId = acc1.Id;
      //insert con;
      
      AccountContactRelation acr = new AccountContactRelation(); 
      acr.ContactId = acc1.PersonContactId;
      acr.AccountId = acc.Id;
      //insert acr;
      FinServ__ReciprocalRole__c rr = new FinServ__ReciprocalRole__c();
      rr.FinServ__InverseRole__c = 'Test Inverse Role';
      rr.Name = 'Test Role';
      rr.RecordTypeId = Schema.getGlobalDescribe().get('FinServ__ReciprocalRole__c').getDescribe().getRecordTypeInfosByName().get('Account Role').getRecordTypeId();
      insert rr;
      
      FinServ__ReciprocalRole__c rrCon = new FinServ__ReciprocalRole__c();
      rrCon.FinServ__InverseRole__c = 'Test Inverse Role';
      rrCon.Name = 'Test Role';
      rrCon.RecordTypeId = Schema.getGlobalDescribe().get('FinServ__ReciprocalRole__c').getDescribe().getRecordTypeInfosByName().get('Contact Role').getRecordTypeId();
      insert rrCon;
      
      FinServ__AccountAccountRelation__c aar = new FinServ__AccountAccountRelation__c();
      aar.FinServ__RelatedAccount__c = acc1.Id;
      aar.FinServ__Role__c = rr.Id;
      insert aar;
      
      //Finserv_ContactContactRelation__c ccr = new Finserv_ContactContactRelation__c();
      //ccr.FinServ__RelatedAccount__r.name = 'Test Jo';
      //ccr.FinServ__Role__c = rrCon.Id;
      //insert ccr;
     
      Case c = new Case();
      c.AccountId = acc.Id;
      c.recordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Transact').getRecordTypeId();
      c.Type = 'Advice';
      c.Origin = 'Phone';
      c.Status = 'In Progress';
      c.contactId = acc.PersonContactId;
      insert c;
      
      CaseLCMPCompletedCVPHandler.getAccRelationship(c.Id);
      CaseLCMPCompletedCVPHandler.populateHighRiskCVP(acc.PersonContactId, c.Id);
      CaseLCMPCompletedCVPHandler.getACR(c.Id);
      CaseLCMPCompletedCVPHandler.getAAR(c.Id);
      CaseLCMPCompletedCVPHandler.getCCR(c.Id);
   
  }

}