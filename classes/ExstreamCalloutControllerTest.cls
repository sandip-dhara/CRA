@isTest
public class ExstreamCalloutControllerTest{





static testMethod void testCallout() 
    {
        ExstreamCalloutController ex = new ExstreamCalloutController();
        List<TibcoSecurity__c> lstTibcoSec = new List<TibcoSecurity__c>();
        TibcoSecurity__c tibcoSec = new TibcoSecurity__c(Name='tibadmin', TargetSystemName__c='Exstream', TibcoPassword__c='tibadmin');
        lstTibcoSec.add(tibcoSec);
        insert lstTibcoSec;
        
        
    
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Account_Plan__c acp = new Account_Plan__c(Primary_AccountAccount__c = acc.id, Name = 'Test Account Plan');
        insert acp;

          
        String id = acp.id; 
        ExstreamCalloutController.invokeTibcoService(id,'Customer');
        
        
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
      
       List< Business_Unit_Plan__c> lstBUPlan = new List< Business_Unit_Plan__c>();
       Business_Unit_Plan__c bup = new Business_Unit_Plan__c(Name = 'abc', Account_Plan__c = acp.id);
       lstBUPlan.add(bup);
       insert lstBUPlan;
        
        String buId = bup.id; 
        
        ExstreamCalloutController.invokeTibcoService(id,'Exec');
        ExstreamCalloutController.invokeTibcoService(id,'Customer');
        ExstreamCalloutController.invokeTibcoService(buId,'BUPlan');
        ExstreamCalloutController.testSOAPFault(id,'Exec');
        ExstreamCalloutController.testException(id,'Exec');
        
        String status = '';
        System.AssertNotEquals(status, acp.Integration_status_execSummaryReport__c);
        
    }


}