/**********************************************************
* Class Name: TestABPScoreCardController
* Author: HP/Akash Garg
* Date:18/10/2012 
* Requirement:  
* Description: Test class for ABPScoreCardController
***********************************************************/
@isTest
public class TestABPScoreCardController
{
    static testMethod void myTest() 
    {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Account_Plan__c acp = new Account_Plan__c(Primary_AccountAccount__c = acc.id, Name = 'Test Account Plan');
        insert acp;

        Contact con = new Contact(LastName = 'test', Email = 'test@test.com',Title='abc');
        insert con;

        Contact con2 = new Contact(LastName = 'test2', Email = 'test2@test.com');
        insert con2;
        
        List<Customer_Relationship_Map__c> crm = new List<Customer_Relationship_Map__c>();

        Customer_Relationship_Map__c crm1 = new Customer_Relationship_Map__c(Account_Plan__c = acp.id,Contact__c = con.id,Parent_Contact__c = 'test');
        crm.add(crm1);

        Customer_Relationship_Map__c crm2 = new Customer_Relationship_Map__c(Account_Plan__c = acp.id,Contact__c = con2.id,Parent_Contact__c = 'test2');
        crm.add(crm2);

        insert crm;

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(crm);
        ABPScoreCardController rec = new ABPScoreCardController(sc);

        rec.AccPlanId = acp.id;
        crm = rec.RelSuite;
        rec.cancel();
        rec.getContactdata();
       
        integer temp1 = rec.RelSuiteCount;
        integer temp2 = rec.RelSuiteSMax;
        integer temp3 = rec.RelSuiteMin;

        crm = rec.RelSuite2;
        //rec.Cr_Name = 'abc'; //rc = new rsCustom();
    }
}