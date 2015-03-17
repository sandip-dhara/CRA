/**********************************************************
* Class Name: TestABPRelationshipMeterTotalScore
* Author: HP/Akash Garg
* Date:18/10/2012 
* Requirement:  
* Description: Test class for RelationshipMeterTotalScore
***********************************************************/
@isTest(SeeAllData=true)
public class TestABPRelationshipMeterTotalScore
{
    static testMethod void myTest() 
    {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Account_Plan__c acp = new Account_Plan__c(Primary_AccountAccount__c = acc.id, Name = 'Test Account Plan');
        insert acp;
        Contact con = new Contact(LastName = 'test', Email = 'test@test.com',Title='abc');
        insert con;
        
        RelationshipMeterTotalScore rmts = new RelationshipMeterTotalScore();

        List<Customer_Relationship_Map__c> crmlist = new List<Customer_Relationship_Map__c>();

        Customer_Relationship_Map__c crm1 = new Customer_Relationship_Map__c(Account_Plan__c = acp.id, PP_S1__c = '1 - Disagree',RM_S1__c = '3 - Somewhat agree', Contact__c = con.id,Parent_Contact__c = 'test');
        Customer_Relationship_Map__c crm2 = new Customer_Relationship_Map__c(Account_Plan__c = acp.id, PP_S2__c = '1 - Disagree',RM_S2__c = '3 - Somewhat agree', Contact__c = con.id,Parent_Contact__c = 'test');
        Customer_Relationship_Map__c crm3 = new Customer_Relationship_Map__c(Account_Plan__c = acp.id, PP_S3__c = '1 - Disagree',RM_S3__c = '3 - Somewhat agree', Contact__c = con.id,Parent_Contact__c = 'test');
        Customer_Relationship_Map__c crm4 = new Customer_Relationship_Map__c(Account_Plan__c = acp.id, PP_S4__c = '1 - Disagree',RM_S4__c = '3 - Somewhat agree', Contact__c = con.id,Parent_Contact__c = 'test');
        Customer_Relationship_Map__c crm5 = new Customer_Relationship_Map__c(Account_Plan__c = acp.id, PP_S5__c = '1 - Disagree',RM_S5__c = '3 - Somewhat agree', Contact__c = con.id,Parent_Contact__c = 'test');
        Customer_Relationship_Map__c crm6 = new Customer_Relationship_Map__c(Account_Plan__c = acp.id, PP_S6__c = '1 - Disagree',RM_S6__c = '3 - Somewhat agree', Contact__c = con.id,Parent_Contact__c = 'test');
        Customer_Relationship_Map__c crm7 = new Customer_Relationship_Map__c(Account_Plan__c = acp.id, PP_S7__c = '1 - Disagree',RM_S7__c = '3 - Somewhat agree', Contact__c = con.id,Parent_Contact__c = 'test');
        Customer_Relationship_Map__c crm8 = new Customer_Relationship_Map__c(Account_Plan__c = acp.id, PP_S8__c = '1 - Disagree',RM_S8__c = '3 - Somewhat agree', Contact__c = con.id,Parent_Contact__c = 'test');
        Customer_Relationship_Map__c crm9 = new Customer_Relationship_Map__c(Account_Plan__c = acp.id, PP_S9__c = '1 - Disagree',RM_S9__c = '3 - Somewhat agree', Contact__c = con.id,Parent_Contact__c = 'test');
        Customer_Relationship_Map__c crm10 = new Customer_Relationship_Map__c(Account_Plan__c = acp.id, PP_S10__c = '1 - Disagree',RM_S10__c = '3 - Somewhat agree', Contact__c = con.id,Parent_Contact__c = 'test');
        Customer_Relationship_Map__c crm11 = new Customer_Relationship_Map__c(Account_Plan__c = acp.id, PP_S11__c = '1 - Disagree', Contact__c = con.id,Parent_Contact__c = 'test');
        Customer_Relationship_Map__c crm12 = new Customer_Relationship_Map__c(Account_Plan__c = acp.id, PP_S12__c = '1 - Disagree', Contact__c = con.id,Parent_Contact__c = 'test');

        crmlist.add(crm1);
        crmlist.add(crm2);
        crmlist.add(crm3);
        crmlist.add(crm4);
        crmlist.add(crm5);
        crmlist.add(crm6);
        crmlist.add(crm7);
        crmlist.add(crm8);
        crmlist.add(crm9);
        crmlist.add(crm10);
        crmlist.add(crm11);
        crmlist.add(crm12);

        insert crmlist;

        ABPRelationshipMeterTotalScore.RelationshipMeter(crmlist);
    }
}