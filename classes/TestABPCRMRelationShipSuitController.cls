/**********************************************************
* Class Name: TestABPCRMRelationShipSuitController 
* Author: HP/Akash Garg
* Date:18/10/2012 
* Requirement:  
* Description: Test class for ABPCRMRelationShipSuitController        
***********************************************************/
@isTest
public class TestABPCRMRelationShipSuitController
{
    static testMethod void myTest() 
    {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con = new Contact(LastName = 'test', Email = 'test@test.com',Title='abc');
        insert con;
        Contact con2 = new Contact(LastName = 'test2', Email = 'test2@test.com');
        insert con2;
        Account_Plan__c acp = new Account_Plan__c(Primary_AccountAccount__c = acc.id, Name = 'Test Account Plan');
        insert acp;
        
        Customer_Relationship_Map__c crm = new Customer_Relationship_Map__c(Account_Plan__c = acp.id,Contact__c = con.id,Parent_Contact__c = 'test');
        insert crm;
        ApexPages.StandardController sc = new ApexPages.StandardController(crm);
        ABPCRMRelationShipSuitController ars = new ABPCRMRelationShipSuitController(sc);
        ars.retURL = 'https://salesforce.com';  //ApexPages.currentPage().getParameters().put('retURL','/006');
        System.debug('****url: ' + ars.retURL);
        //ars.getDynamicImage();
        ars.getRelSuite();
        ars.save();
        //ars.changeHelpText();
        ars.cancel();
        List<SelectOption> so = ars.AbpContacts;
        if(so.size()==0)System.assert(false);
        //ars.OppContacts();
    }
}