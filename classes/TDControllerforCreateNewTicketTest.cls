@isTest
public class TDControllerforCreateNewTicketTest{
static testMethod void testCallout() 
    {
        TechDirectControllerforCreateNewTicket tdnew = new TechDirectControllerforCreateNewTicket();
        List<TibcoSecurity__c> lstTibcoSec = new List<TibcoSecurity__c>();
        TibcoSecurity__c tibcoSec = new TibcoSecurity__c(Name='tibadmin', TargetSystemName__c='TechDirect', TibcoPassword__c='tibadmin');
        lstTibcoSec.add(tibcoSec);
        insert lstTibcoSec;       
    
        Case c = new Case(Description='test',Reason='test',Case_Comments__c='(test)',Scenario__c='test',BG__c='EG',New_Account_Name__c='test',Street__c='test',City__c='test',State_Province__c='test',Zip_Postal_Code__c='72882',Country__c='India',Subject='test',Region__c='APJ',Priority='Medium');
        insert c;
          
        Id sId = c.id; 
        TechDirectControllerforCreateNewTicket.invokeTibcoServiceforCreateNewTicket(sId,'028992','test','Sreedhar','test','test','ES', 'test','test','test','test','test','627892','test','test','AMS','Medium','Sreedhar Jagannath','(test)');
    }


}