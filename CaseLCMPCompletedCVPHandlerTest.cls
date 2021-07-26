/**
 * @description       : 
 * @author            : mohsin.hassan@gravitai.com
 * @group             :
 * @last modified on  : 07-23-2021
 * @last modified by  : Mohsin Hassan
 * Modifications Log
 * Ver   Date         Author              Modification
 * 1.0   07-17-2021   mohsin.hassan@gravitai.com   Initial Version
 **/

@isTest
Public class CaseLCMPCompletedCVPHandlerTest {
    
    @TestSetup
    static void setUpTestFData() {
        List<Account> householdAccounts = TestDataFactory.createHouseHoldAccounts(
            Constants.RT_ACC_HOUSEHOLD,
            1
        );
        insert householdAccounts;
        
        List<Account> personAccounts = TestDataFactory.createPersonAccounts(
            Constants.RT_ACC_PERSON_ACCOUNT,
            1
        );
        insert personAccounts;
        
        List<FinServ__ReciprocalRole__c> rrList =TestDataFactory.createReciprocalRole(
            Constants.RT_RR_ACCOUNT_ROLE , 1);
        insert rrList;

        List<FinServ__AccountAccountRelation__c> aarList = TestDataFactory.addRelatedAccounts(personAccounts, rrList[0]);
        insert aarList;
        
        List<FinServ__AccountAccountRelation__c> householdaarList = TestDataFactory.addRelatedAccounts(householdAccounts, rrList[0]);
        insert householdaarList;
        
        Contact con = TestDataFactory.createContact( 'Test Contact', null );
        insert con;
        
        List<Case> transactCases = TestDataFactory.createTransactCases( 
                                    personAccounts[0].Id,
                                    [SELECT Id FROM Contact WHERE AccountId = :personAccounts[0].Id].Id,
                                    1,true);
        List<Case> transactCaseshh = TestDataFactory.createTransactCases( 
                                    householdAccounts[0].Id,
                                    con.Id,
                                    1,true);
        
    }
  
  @isTest
  static void testPersonAccountCVP(){
    
     
    Id householdRecordTypeId = TestUtils.getRecordTypeId('Account', Constants.RT_ACC_HOUSEHOLD);
    Id personAccountRecordTypeId = TestUtils.getRecordTypeId('Account', Constants.RT_ACC_PERSON_ACCOUNT);
    Account personAccount = [SELECT Id,PersonContactId FROM Account WHERE RecordTypeId = :personAccountRecordTypeId LIMIT 1];
    system.assert(personAccount.Id != null, 'A Person Account');
    Case c = [select id from case where Account.RecordTypeId =:personAccountRecordTypeId limit 1 ];
    system.assert(c.Id != null, 'Person Account associated with Case');

    test.startTest(); 
      CaseLCMPCompletedCVPHandler.populateHighRiskCVP(personAccount.PersonContactId, c.Id);
    test.stopTest();

    
      CaseLCMPCompletedCVPHandler.getACR(c.Id);
      CaseLCMPCompletedCVPHandler.getAAR(c.Id);
      CaseLCMPCompletedCVPHandler.getCCR(c.Id);
     
  }
     @isTest
  static void testHouseHoldAccountCVP(){

      Id householdRecordTypeId = TestUtils.getRecordTypeId('Account', Constants.RT_ACC_HOUSEHOLD);
      Account householdAccount = [SELECT Id,PersonContactId FROM Account WHERE RecordTypeId = :householdRecordTypeId LIMIT 1];
      Case c = [select id from Case where Account.RecordTypeId =:householdRecordTypeId limit 1 ];
      system.assert(c.Id != null, 'Household Account associated with Case');
      Contact con = [SELECT Id FROM Contact limit 1];
      system.assert(con.id !=null, 'Contact');

      test.startTest();
      CaseLCMPCompletedCVPHandler.populateHighRiskCVP(con.Id, c.Id);
      test.stopTest();

      CaseLCMPCompletedCVPHandler.getACR(c.Id);
      CaseLCMPCompletedCVPHandler.getAAR(c.Id);
      CaseLCMPCompletedCVPHandler.getCCR(c.Id);
      

  } 

}
