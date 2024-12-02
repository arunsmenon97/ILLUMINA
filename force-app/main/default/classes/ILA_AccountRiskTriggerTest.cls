/**
* @File Name : ILA_AccountRiskTriggerTest.cls
* @Description : Test class for ILA_AccountRiskTrigger
* @Author : ARUN
* @Last Modified By :
* @Last Modified On : November 30, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | November 30, 2024 |   | Initial Version
**/

@IsTest
public class ILA_AccountRiskTriggerTest {
    @IsTest
    static void testILA_AccountRiskTrigger() {
        
        // Create test data for the 'insert' scenario
        Account highRiskAccount = new Account(Name = 'High Risk Account', ILA_Risk__c = 'High');
        Account lowRiskAccount = new Account(Name = 'Low Risk Account', ILA_Risk__c = 'Low');
        insert new List<Account>{highRiskAccount, lowRiskAccount};      
            
            Test.startTest();
        // Update test data for the 'update' scenario
        highRiskAccount.ILA_Risk__c = 'Medium'; // Change risk to Medium
        lowRiskAccount.ILA_Risk__c = 'High';   // Change risk to High
        update new List<Account>{highRiskAccount, lowRiskAccount};
            Test.stopTest();
        Test.getEventBus().deliver();
        
        //Asserts
        System.assertEquals('High', lowRiskAccount.ILA_Risk__c, 'The risk level should be High for the updated account.');
        System.assertEquals('Medium',  highRiskAccount.ILA_Risk__c , 'The risk level should be Medium for the updated account.');
    }
}