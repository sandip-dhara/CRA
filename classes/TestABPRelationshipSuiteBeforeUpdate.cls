/**********************************************************
* Class Name: TestABPRelationshipSuiteBeforeUpdate 
* Author: HP/Akash Garg
* Date:18/10/2012 
* Requirement:  
* Description: Test class for ABPRelationshipSuiteBeforeUpdate        
***********************************************************/
@isTest(SeeAllData=true)
public class TestABPRelationshipSuiteBeforeUpdate 
{
    static testMethod void myTest() 
    {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Account_Plan__c acp = new Account_Plan__c(Primary_AccountAccount__c = acc.id, Name = 'Test Account Plan');
        insert acp;
        
        Contact con = new Contact(LastName = 'test', Email = 'test@test.com',Title='abc');
        insert con;
        
        Global_Config__c globalConfig = Global_Config__c.getInstance(); 
        //System.Assert(globalConfig.Mute_Triggers__c == false);
        
        globalConfig.Mute_Triggers__c = true;
        //System.Assert(globalConfig.Mute_Triggers__c == true);

        Customer_Relationship_Map__c crm = new Customer_Relationship_Map__c(Account_Plan__c = acp.id, Contact__c = con.id,Parent_Contact__c = 'test');
        insert crm;
        //System.Assert(globalConfig.Mute_Triggers__c == true);
                
        //Customer_Relationship_Map__c crm2 = new Customer_Relationship_Map__c(Account_Plan__c = acp.id);
        //insert crm2;
    }
}