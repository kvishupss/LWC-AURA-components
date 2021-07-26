/**
 * @description       :
 * @author            : venu@gravitai.com
 * @group             :
 * @last modified on  : 07-16-2021
 * @last modified by  : Raju Vegesna
 * Modifications Log
 * Ver   Date         Author              Modification
 * 1.0   08-25-2020   venu@gravitai.com   Initial Version
 **/
@isTest
public with sharing class TestDataFactory {
  public static final string EMPTY_STRING = '';
  public static final String BLANK_SPACE = ' ';
  public static final String USER_LASTNAME = 'TestUser';
  public static final String SAMPLE_POSTCODE = 'WC1A 2AB';
  public static final String HUB_CMBRDGE = 'Cambridge Hub';
  public static final String LEAD_SOURCE_WS = 'Website';
  public static final String LEAD_SOURCE_LBG_WS = 'LBG Website';
  public static final String LEAD_SOURCE_LBG_BRAN = 'LBG Branch';
  public static final String LEAD_S_SOURCE_LBG_BOS = 'BOS';
  // public static final String LEAD_S_SOURCE_LBG_LLOY = 'Lloyds';
  // public static final String LEAD_S_SOURCE_LBG_HAL = 'Halifax';
  public static final List<String> IRE_REF_FIN_BRAND = new List<String>{
    'Lloyds', 'BoS', 'Halifax', 'Scottish Widows'
  }; 
  public static final List<String> IRE_REF_FIN_PRODUCT_CATEGORY = new List<String>{
    'Bank Account', 'Loans', 'Mortgages', 'Credit Cards', 'Pension'
  }; 


  //Set of all the profiles required to run tests
  public static Set<String> profiles = new Set<String>{
    Constants.SYS_ADMIN_PROFILE,
    Constants.SPW_COMPLIANCE_PROFILE,
    Constants.SPW_PWA_PROFILE
  };

  //Query to retrieve test users
  public static List<Profile> profileList = [
    SELECT Id, Name
    FROM Profile
    WHERE Name IN :profiles
    ORDER BY Name ASC
  ];

  //Map variable, key is Profile Id and value is Profile Name
  public static map<Id /* Profile Id */, String /* Profile Name*/> profileNameByIdMap {
    get {
      if (profileList != null) {
        map<Id, String> outMap = new Map<Id, String>();
        for (Profile profileLoop : profileList) {
          outMap.put(profileLoop.Id, profileLoop.Name);
        }
        return outMap;
      }
      return profileNameByIdMap;
    }
  }

  /**
   * @description
   * @author venu@gravitai.com | 08-25-2020
   * @param profileId
   * @return User
   **/
  public static User getProfileUser(ID profileId) {
    return [
      SELECT Id, Profile.Name, Name
      FROM User
      WHERE ProfileId = :profileId AND LastName = :USER_LASTNAME
      LIMIT 1
    ];
  }

  /**
   * @description
   * @author venu@gravitai.com | 08-25-2020
   * @return Map<String, Profile>
   **/
  public static Map<String, Profile> getProfileMap() {
    map<String, Profile> profileMap = new Map<String, Profile>();
    for (Profile p : profileList) {
      profileMap.put(p.Name, p);
    }
    return profileMap;
  }

  /**
   * @description
   * @author venu@gravitai.com | 08-25-2020
   * @return String
   **/
  public static String getUniqueUsername() {
    String orgId = UserInfo.getOrganizationId();
    String dateString = String.valueof(Datetime.now())
      .replace(BLANK_SPACE, EMPTY_STRING)
      .replace(':', EMPTY_STRING)
      .replace('-', EMPTY_STRING);
    Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
    String uniqueName = orgId + dateString + randomInt;

    return (uniqueName + '@dummy' + orgId + '.com');
  }

  public static List<User> createUserList(Boolean doInsert) {
    return createUserList(doInsert, 'Europe/London');
  }

  /**
   * @description insert user for each profile
   * @author venu@gravitai.com | 08-25-2020
   * @param doInsert
   * @param timeZone
   * @return List<User>
   **/
  public static List<User> createUserList(Boolean doInsert, string timeZone) {
    List<User> newUserList = new List<User>();
    for (Profile p : profileList) {
      String uniqueUserEMailId = getUniqueUsername();
      User u = new User(
        Alias = 'tstUsr',
        Country = 'United Kingdom',
        Email = uniqueUserEMailId,
        EmailEncodingKey = 'UTF-8',
        LastName = USER_LASTNAME,
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_GB',
        ProfileId = p.Id,
        TimeZoneSidKey = timeZone,
        UserName = uniqueUserEMailId,
        Phone = '+44123456789'
      );
      newUserList.add(u);
    }
    if (doInsert) {
      insert newUserList;
    }

    return newUserList;
  }

  /**
   * @description insert user for each profile
   * @author raju@gravitai.com | 05-Oct-2020
   * @param doInsert
   * @param timeZone
   * @param sbxName
   * @return List<User>
   **/
  public static List<User> createUsersForSBX(
    Boolean doInsert,
    string timeZone,
    String sbxName
  ) {
    List<User> newUserList = new List<User>();
    for (Profile p : profileList) {
      String uniqueUserEMailId = getUniqueUsername();
      User u = new User(
        Alias = 'tstUsr',
        Country = 'United Kingdom',
        Email = uniqueUserEMailId,
        EmailEncodingKey = 'UTF-8',
        LastName = USER_LASTNAME,
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_GB',
        ProfileId = p.Id,
        TimeZoneSidKey = timeZone,
        UserName = uniqueUserEMailId + '.' + sbxName,
        Phone = '+44123456789'
      );
      newUserList.add(u);
    }
    if (doInsert) {
      insert newUserList;
    }

    return newUserList;
  }

  /**
   * @description
   * @author 
   * @return 
   **/

  public static User createUser(
    Boolean insertToDatabase,
    String profileName,
    String lastName,
    String emailAddress,
    String userNameString,
    String alias,
    String teamSegment,
    String postcode,
    Decimal lat,
    Decimal lon
  ) {
    List<Profile> p = [SELECT id FROM Profile WHERE name = :profileName];
    Id queriedProfileId = p[0].id;

    User u = new User(
      Alias = alias,
      Email = emailAddress,
      EmailEncodingKey = 'UTF-8',
      Lastname = lastName,
      LanguageLocaleKey = 'en_US',
      LocalesidKey = 'en_US',
      Profileid = queriedProfileId,
      TimezonesidKey = 'America/Los_Angeles',
      Username = userNameString,
      Postalcode = postcode,
      Latitude = lat,
      Longitude = lon,
      Team_Segment__c = teamSegment,
      Phone = '+44123456789'
    );

    if (insertToDatabase) {
      insert u;
    }
    return u;
  }

    /**
   * @description
   * @author 
   * @return 
   **/

  public static String getGeolocationAPIResponse(
    Decimal latitude,
    Decimal longitude,
    Boolean isEmpty
  ) {
    Map<String, Object> geolocationMapping = new Map<String, Object>{
      'latitude' => latitude,
      'longitude' => longitude
    };
    Map<String, Object> result;
    if (isEmpty) {
      result = new Map<String, Object>{ 'result' => new Map<String, Object>() };
    } else {
      result = new Map<String, Object>{ 'result' => geolocationMapping };
    }
    return JSON.serialize(result);
  }

    /**
   * @description
   * @author raju@gravitai.com | 
   * @return SObject : Lead
   **/
  public static Lead createLead(
    Boolean insertToDatabase,
    String firstName,
    String lastName
  ) {
    string email = firstName + '.' + lastName + '@email.com';

    Lead ld = new Lead(
      FirstName = firstName,
      LastName = lastName,
      Email = email,
      SPW_Hub__c = HUB_CMBRDGE,
      LeadSource = LEAD_SOURCE_WS
    );

    if (insertToDatabase) {
      insert ld;
    }
    return ld;
  }

  /**
   * @description 
   * @author raju@gravitai.com | 06-16-2021
   * @return SObject : Lead
   **/

  public static Lead createIRELead(Boolean insertToDatabase, String firstName, String lastName, String source, String secondarySource) {
    string email = firstName + '.' + lastName + '@email.com';

    Lead ld = new Lead(
      FirstName = firstName,
      LastName = lastName,
      Email = email,
      SPW_Hub__c = HUB_CMBRDGE,
      LeadSource = source,
      SPW_Secondary_Lead_Source__c = secondarySource);

    if (insertToDatabase) {
      insert ld;
    }
    return ld;
  }

  /**
   * @name createPersonAccounts
   * @description: construct a list of Account records based on record type
   */
  public static List<Account> createPersonAccounts(
    String recordTypeName,
    Integer cnt
  ) {
    List<Account> accounts = new List<Account>();
    Id rtId = TestUtils.getRecordTypeId(
      'Account',
      Constants.RT_ACC_PERSON_ACCOUNT
    );
    for (Integer i = 0; i < cnt; i++) {
      Account acct = new Account(
        FirstName = 'First',
        LastName = 'Last: ' + i,
        Phone = '+44 0123456789' + i,
        PersonMailingPostalCode = SAMPLE_POSTCODE,
        SPW_Birthdate__pc = Date.newInstance(1981, 4, 1).addDays(i),
        RecordTypeId = rtId
      );
      accounts.add(acct);
    }
    return accounts;
  }

  /**
   * @name createHouseHoldAccounts
   * @description: construct a list of Account records based on record type
   */
  public static List<Account> createHouseHoldAccounts(
    String recordTypeName,
    Integer cnt
  ) {
    List<Account> accounts = new List<Account>();
    Id rtId = TestUtils.getRecordTypeId('Account', Constants.RT_ACC_HOUSEHOLD);
    for (Integer i = 0; i < cnt; i++) {
      Account acct = new Account(
        Name = 'Test HH Acc: ' + i,
        RecordTypeId = rtId
      );
      accounts.add(acct);
    }
    return accounts;
  }

  /**
   * @name: createOpporutnities
   * @description: construct a number of Opportunity records to every accounts from the given accounts
   */
  public static List<Opportunity> createOpportunities(
    String recordTypeName,
    List<Account> accounts,
    Integer cnt
  ) {
    List<Opportunity> opporutunities = new List<Opportunity>();
    Id rtId = TestUtils.getRecordTypeId('Opportunity', recordTypeName);

    for (Account acc : accounts) {
      for (Integer i = 0; i < cnt; i++) {
        Opportunity opp = new Opportunity(
          Name = 'Test Opp : ' + i,
          StageName = 'New',
          AccountId = acc.Id,
          CloseDate = System.today().addDays(30),
          recordTypeId = rtId
        );
        opporutunities.add(opp);
      }
    }

    return opporutunities;
  }

  /**
   * @name: createOpporutnitiesWithNoAccount
   * @description: construct opporutunities with out an account on opporutunity
   */
  public static List<Opportunity> createOpporutnitiesWithNoAccount(
    String recordTypeName,
    Integer cnt
  ) {
    List<Opportunity> opporutunities = new List<Opportunity>();
    Id rtId = TestUtils.getRecordTypeId('Opportunity', recordTypeName);
    for (Integer i = 0; i < cnt; i++) {
      Opportunity opp = new Opportunity(
        Name = 'Test Opp : ' + i,
        StageName = 'New',
        CloseDate = System.today().addDays(30),
        recordTypeId = rtId
      );
      opporutunities.add(opp);
    }
    return opporutunities;
  }

  /** @name: createPricebook
   *  @description: create pricebook and make it standard pricebook
   */
  public static Pricebook2 createPricebook(String name) {
    Pricebook2 pricebook = new Pricebook2(Name = name, IsActive = true);
    return pricebook;
  }

  /**
   * @name: createProducts
   * @description: create number of proudcts
   */
  public static List<Product2> createProducts(Integer cnt) {
    List<Product2> products = new List<Product2>();
    List<String> productFamily = new List<String>{
      'Aviva',
      'Canada Life',
      'Referral',
      'Standard Life'
    };
    for (Integer i = 0; i < cnt; i++) {
      Product2 product = new Product2(
        Name = 'Product ' + i,
        ProductCode = 'PC-01',
        Family = productFamily.get(TestUtils.randomInt(4)),
        SPW_Advice_Need__c = 'No',
        SPW_Advice_Fee_Required__c = 'Yes',
        SPW_Commission_Required__c = 'Yes',
        SPW_Term_Required__c = 'Yes',
        SPW_Regular_Premium_Required__c = 'Yes',
        Single_Premium_Required__c = 'Yes',
        SPW_Transfer_Premium_Required__c = 'Yes'
      );
      products.add(product);
    }
    return products;
  }

  /**
   * @name: createPriceBookEntries
   * @description: create Pricebook Entries for given products
   */
  public static List<PricebookEntry> createPriceBookEntries(
    List<Product2> products
  ) {
    List<PricebookEntry> pbes = new List<PricebookEntry>();
    for (Product2 prd : products) {
      PricebookEntry pbe = new PricebookEntry(
        UnitPrice = 0.0,
        isActive = true,
        Product2Id = prd.Id,
        Pricebook2Id = Test.getStandardPricebookId()
      );
      pbes.add(pbe);
    }
    return pbes;
  }

  /**
   * @name: createOpportunityProducts
   * @description: construct opportunity line items (Opportunity Products) for an opportunity
   */
  public static List<OpportunityLineItem> createOpportunityProducts(
    Opportunity opportunity,
    List<PricebookEntry> pricebookEntries,
    Integer cnt
  ) {
    List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();

    for (Integer i = 0; i < cnt; i++) {
      Integer randPBE = TestUtils.randomInt(pricebookEntries.size());
      OpportunityLineItem lineItem = new OpportunityLineItem(
        OpportunityId = opportunity.Id,
        Product2Id = pricebookEntries.get(randPBE).Product2Id,
        PricebookEntryId = pricebookEntries.get(randPBE).Id,
        SPW_Advice_Fee__c = 1,
        SPW_Regular_Premium__c = 1,
        SPW_Single_Premium__c = 1,
        SPW_Transfer_Premium__c = 1,
        SPW_Commission__c = 1,
        Term__c = '12',
        SPW_Written_Date__c = System.today().addDays(30)
      );
      lineItems.add(lineItem);
    }
    return lineItems;
  }

  /**
   * @name: createOpportunityProductsWithRelatedAccounts
   * @description: create opportunity products with a related accounts assigned from person accounts
   */
  public static List<OpportunityLineItem> createOpportunityProductsWithRelatedAccounts(
    Opportunity opportunity,
    List<PricebookEntry> pricebookEntries,
    List<Account> accounts,
    Integer cnt
  ) {
    List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
    for (Integer i = 0; i < cnt; i++) {
      Integer randPBE = TestUtils.randomInt(pricebookEntries.size());
      Integer randPA = TestUtils.randomInt(accounts.size());
      OpportunityLineItem lineItem = new OpportunityLineItem(
        OpportunityId = opportunity.Id,
        Product2Id = pricebookEntries.get(randPBE).Product2Id,
        PricebookEntryId = pricebookEntries.get(randPBE).Id,
        SPW_Related_Account__c = accounts.get(randPA).Id,
        SPW_Advice_Fee__c = 1,
        SPW_Regular_Premium__c = 1,
        SPW_Single_Premium__c = 1,
        SPW_Transfer_Premium__c = 1,
        SPW_Commission__c = 1,
        Term__c = '12',
        SPW_Written_Date__c = System.today().addDays(30)
      );
      lineItems.add(lineItem);
    }
    return lineItems;
  }

  /**
   * @name: createOpportunityProductsWithHouseholdRelatedAccount
   * @description: create opportunity products with household/person account of an opportunity as related account
   */
  public static List<OpportunityLineItem> createOpportunityProductsWithParentAccountAsRelatedAccount(
    Opportunity opportunity,
    List<PricebookEntry> pricebookEntries,
    Integer cnt
  ) {
    List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
    for (Integer i = 0; i < cnt; i++) {
      Integer randPBE = TestUtils.randomInt(pricebookEntries.size());
      OpportunityLineItem lineItem = new OpportunityLineItem(
        OpportunityId = opportunity.Id,
        Product2Id = pricebookEntries.get(randPBE).Product2Id,
        PricebookEntryId = pricebookEntries.get(randPBE).Id,
        SPW_Related_Account__c = opportunity.AccountId,
        SPW_Advice_Fee__c = 1,
        SPW_Regular_Premium__c = 1,
        SPW_Single_Premium__c = 1,
        SPW_Transfer_Premium__c = 1,
        SPW_Commission__c = 1,
        Term__c = '12',
        SPW_Written_Date__c = System.today().addDays(30)
      );
      lineItems.add(lineItem);
    }
    return lineItems;
  }
    
    /** @name: createContact
   *  @description: create contact
   */
  public static Contact createContact(String name, String accId) {
    Contact Con = new Contact(LastName = name, AccountId = accId);
    return Con;
  }


  /**
   * @name: addRelatedContactsWithinHousehold
   * @description: add related person accounts to a household account
   */
  public static List<AccountContactRelation> addRelatedContactsWithinHousehold(
    Account household,
    List<Account> personAccounts
  ) {
    List<AccountContactRelation> acrList = new List<AccountContactRelation>();
    for (Account pc : personAccounts) {
      AccountContactRelation acr = new AccountContactRelation(
        AccountId = household.Id,
        ContactId = pc.PersonContactId,
        IsActive = true
      );
      acrList.add(acr);
    }
    return acrList;
  }
    /**
   * @name: addRelatedAccount
   * @description: add related accounts to a household account
   */
  public static List<FinServ__AccountAccountRelation__c> addRelatedAccounts(
   List<Account> accList, 
   FinServ__ReciprocalRole__c Role) {
    List<FinServ__AccountAccountRelation__c> aarList = new List<FinServ__AccountAccountRelation__c>();
    for (Account acc : accList) {
        FinServ__AccountAccountRelation__c aar = new FinServ__AccountAccountRelation__c(
        FinServ__RelatedAccount__c = acc.Id,
        FinServ__Role__c = Role.Id
      );
      aarList.add(aar);
    }
    return aarList;
  }
 /**
   * @name createReciprocalRoles
   * @description: add Reciprocal roles for Account Account Relationship
   */
  public static List<FinServ__ReciprocalRole__c> createReciprocalRole(
    String recordTypeName, Integer cnt) {
    List<FinServ__ReciprocalRole__c> ReciprocalRole = new List<FinServ__ReciprocalRole__c>();
    Id rtId = TestUtils.getRecordTypeId(
      'FinServ__ReciprocalRole__c',
      Constants.RT_RR_ACCOUNT_ROLE
    );
    for (Integer i = 0; i < cnt; i++) {
      FinServ__ReciprocalRole__c rr = new FinServ__ReciprocalRole__c(
        FinServ__InverseRole__c = 'Test Inverse Role',
      	Name = 'Test Role',
        RecordTypeId = rtId
      );
      ReciprocalRole.add(rr);
    }
    return ReciprocalRole;
  }
  /**
   * @name: updateOpportunityProudctsWithRelatedAccounts
   * @description: update the given opportunity line items with related accounts
   */
  public static List<OpportunityLineItem> updateOpportunityProudctsWithRelatedAccounts(
    List<OpportunityLineItem> lineItems,
    List<Account> accounts
  ) {
    for (OpportunityLineItem item : lineItems) {
      Integer randPA = TestUtils.randomInt(accounts.size());
      item.SPW_Related_Account__c = accounts.get(randPA).id;
    }
    return lineItems;
  }

  /**
   * @description: inserting complaint caess
   * @author venu@gravitai.com | 08-25-2020
   * @param accountId
   * @param ContactId
   * @param UserId
   * @param numCasesPerAcct
   * @param doInsert
   * @return List<Case>
   **/
  public static List<Case> createComplaintCases(
    Id accountId,
    Id ContactId,
    Id UserId,
    Integer numCasesPerAcct,
    Boolean doInsert
  ) {
    Map<String, Id> recordTypesMap = CommonUtils.getRecordTypesByObjectName(
      'Case'
    );

    List<Case> cases = new List<Case>();
    for (Integer k = 0; k < numCasesPerAcct; k++) {
      cases.add(
        new Case(
          Status = Constants.CASE_STATUS_NEW,
          AccountId = accountId,
          Compliance_Manager__c = UserId,
          ContactId = ContactId,
          Type = 'Advisor Process',
          Origin = 'Email',
          Complaint_Received__c = system.today(),
          SPW_Complaint_Start_Date__c = system.today(),
          Apologised_On_Date__c = system.today(),
          Complaint_Brand__c = 'Other',
          Subject = 'Subject',
          Description = 'Description',
          Theme__c = 'Portfolio Charges',
          RecordTypeId = recordTypesMap.get(Constants.RT_COMPLAINT)
        )
      );
    }
    // Insert all opportunities for all accounts.
    if (doInsert) {
      insert cases;
    }

    return cases;
  }

  public static List<Case> createTransactCases(
    Id accountId,
    Id ContactId,
    Integer numCasesPerAcct,
    Boolean doInsert
  ) {
    Map<String, Id> recordTypesMap = CommonUtils.getRecordTypesByObjectName(
      'Case'
    );

    List<Case> cases = new List<Case>();
    for (Integer k = 0; k < numCasesPerAcct; k++) {
      cases.add(
        new Case(
          Status = Constants.CASE_STATUS_INPROGRESS,
          AccountId = accountId,
          ContactId = ContactId,
          SPW_Advisory_Type__c  = True,
          Type = 'Withdrawal',
          SPW_Case_Hub__c  = 'London Hub', 
          SPW_Withdrawal_Amount__c = 5000,
          SPW_Sub_type__c = 'ad-hoc withdrawal',
          SPW_Plausibility_Considered__c = 'No',
          Origin = 'Email',    
          Subject = 'Withdrawal Request',
          Description = 'Withdrawal request for 50K',
          Callback_Undertaken__c = false,
          SPW_Used_for_security_GIA__c= 'Yes',
          SPW_Advised_of_Timescales_to_rec_funds__c = false,
          SPW_Confirmed_Linked_Bank_Account__c = false,
          RecordTypeId = recordTypesMap.get(Constants.CASE_TRANSACT)
        )
      );
    }
    if (doInsert) {
      insert cases;
    }
    return cases;
  }

  public static List<Task> createTransactTask(
    Id caseId, 
    Integer numTasksPerCase, 
    Boolean doInsert
    ){
    Map<String, Id> recordTypesMap = CommonUtils.getRecordTypesByObjectName(
      'Task'
      );
    List<Task> tasks = new List<Task>();
    for (Integer k = 0; k < numTasksPerCase; k++) {
      tasks.add(
        new Task(
            Subject = 'Ongoing Advice Review',
            RecordTypeId = recordTypesMap.get(Constants.TASK_SPW_TRANSACT),
            SPW_Created_by_Process__c = True,
            WhatId = caseId
        )
      );
    }
    if (doInsert) {
      insert tasks;
    }
    return tasks;
  }
    
  public static List<Case> createTransactCasesWithStrategyChange(
    Id accountId,
    Id ContactId,
    Integer numCasesPerAcct,
    Boolean doInsert
  ) {
    Map<String, Id> recordTypesMap = CommonUtils.getRecordTypesByObjectName(
      'Case'
    );
    List<Case> cases = new List<Case>();
    for (Integer k = 0; k < numCasesPerAcct; k++) {
      cases.add(
        new Case(
          Status = Constants.CASE_STATUS_INPROGRESS,
          AccountId = accountId,
          ContactId = ContactId,
          Type = 'Strategy Change',
          SPW_Case_Hub__c  = 'London Hub',
          SPW_Plausibility_Considered__c = 'No',
          Origin = 'Email',    
          Subject = 'Strategy Change Request',
          Description = 'Strategy Change Request 50K',
          SPW_Client_requires_regular_withdrawal__c = 'Yes',
          SPW_Has_the_outcome_been_recorded__c  = 'Yes',
          SPW_Report_and_CoA_Letter_to_Client__c  = 'Yes',
          SPW_Has_AML_been_refreshed__c ='Yes',
          SPW_Frequency_Strategy_Change__c ='Monthly',
          SPW_Amount_Strategy_Change__c = 50,
          RecordTypeId = recordTypesMap.get(Constants.CASE_TRANSACT)
        )
      );
    }
    if (doInsert) {
      insert cases;
    }
    return cases;
  }

  public static List<Case> createS_Tinvestements(
    Id accountId,
    Id ContactId,
    Id UserId,
    Integer numCasesPerAcct,
    Boolean doInsert
  ) {
    Map<String, Id> recordTypesMap = CommonUtils.getRecordTypesByObjectName(
      'Case'
    );

    List<Case> cases = new List<Case>();
    for (Integer k = 0; k < numCasesPerAcct; k++) {
      cases.add(
        new Case(
          Status = Constants.CASE_STATUS_NEW,
          AccountId = accountId,
          PWA_Name__c = UserId,
          ContactId = ContactId,
          Type = 'Advisor Process',
          SPW_Case_Hub__c = 'Birmingham Hub',
          Origin = 'Email',
          Subject = 'Subject',
          Description = 'Description',
          RecordTypeId = recordTypesMap.get(Constants.RT_S_T_Investments)
        )
      );
    }
    // Insert all opportunities for all accounts.
    if (doInsert) {
      insert cases;
    }

    return cases;
  }

  public static List<Case> createS_Tpensions(
    Id accountId,
    Id ContactId,
    Id UserId,
    Integer numCasesPerAcct,
    Boolean doInsert
  ) {
    Map<String, Id> recordTypesMap = CommonUtils.getRecordTypesByObjectName(
      'Case'
    );

    List<Case> cases = new List<Case>();
    for (Integer k = 0; k < numCasesPerAcct; k++) {
      cases.add(
        new Case(
          Status = Constants.CASE_STATUS_NEW,
          AccountId = accountId,
          PWA_Name__c = UserId,
          ContactId = ContactId,
          Type = 'Advisor Process',
          SPW_Case_Hub__c = 'Birmingham Hub',
          Origin = 'Email',
          Subject = 'Subject',
          Description = 'Description',
          RecordTypeId = recordTypesMap.get(Constants.RT_S_T_Pensions)
        )
      );
    }
    // Insert all opportunities for all accounts.
    if (doInsert) {
      insert cases;
    }

    return cases;
  }
  

    /**
   * @name: createIREReferralFinancials
   * @description: create Referral Financials for a IRE Lead 
   * @author: raju@gravitai.com | 16-Jul-2021
   * @return: List<SObject>
   */
  public static List<SPW_ReferralFinancial__c> createIREReferralFinancials(Boolean doInsert, Lead lead, Integer cnt)  {

    List<SPW_ReferralFinancial__c> refFinancials = new List<SPW_ReferralFinancial__c>();
    
    for(Integer i = 0; i < cnt; i++){
     
      Integer b = TestUtils.randomInt(IRE_REF_FIN_BRAND.size());
      Integer pc = TestUtils.randomInt(IRE_REF_FIN_PRODUCT_CATEGORY.size());
      Integer balance = TestUtils.randomInt(100000);
      refFinancials.add( 
        new SPW_ReferralFinancial__c(
          Primary_Owner__c = lead.Id,
          Balance__c = balance,
          Brand_Name__c = IRE_REF_FIN_BRAND.get(b),
          Product_Category__c = IRE_REF_FIN_PRODUCT_CATEGORY.get(pc),
          Product_Name__c = 'Test account' + i,
          Ownership__c	= 'Solo',
          Product_Description__c = 'Test description '+i )
      );
    }

    if (doInsert) {
      insert refFinancials;
    }

    return refFinancials;
  }
}
