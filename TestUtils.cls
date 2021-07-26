/**
 * @author              : Raju Vegesna
 * @description         : Utility class for Test classes
 * @created             : July 2020
 * @created by          : Gravitai   
 * @last modified       : Aug 2020  
 * @last modified by    : Raju Vegesna
 **/

public with sharing class TestUtils {

    /**
     * @name: getRecordTypeId
     * @description: to get the Id of the given record type Name (not the developer name)
     */
    public static Id getRecordTypeId(String sObjectName, String recordTypeName) {
        Id rtId;
        switch on sObjectName {
            when 'Account' {
                rtId = Schema.sObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
            }
            when 'Opportunity' {
                rtId = Schema.sObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
            }
            when 'FinServ__ReciprocalRole__c' {
                rtId = Schema.sObjectType.FinServ__ReciprocalRole__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
            }
        }
        return rtId; 
        
    }

    /**
     * @name: randomInt
     * @description: Generates a random number from 0 up to, but not including, max.
     */
           
    public static Integer randomInt(Integer max) {
        return Math.mod(Math.abs(Crypto.getRandomInteger()), max);
    }

}
