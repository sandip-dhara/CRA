@isTest
public class TechDirectControllerTest {
static testMethod void testCallout() 
    {
        TechDirectController tdupdate = new TechDirectController ();
        List<TibcoSecurity__c> lstTibcoSec = new List<TibcoSecurity__c>();
        TibcoSecurity__c tibcoSec = new TibcoSecurity__c(Name='tibadmin', TargetSystemName__c='TechDirect', TibcoPassword__c='tibadmin');
        lstTibcoSec.add(tibcoSec);
        insert lstTibcoSec;       
    
        Case c = new Case(Techdirect_Case_ID__c='290290',Description='test',Reason='test',Scenario__c='test',BG__c='EG',New_Account_Name__c='test',Street__c='test',City__c='test',State_Province__c='test',Zip_Postal_Code__c='72882',Country__c='India',Subject='test',Region__c='APJ',Priority='Medium');
        insert c;
          
        String sId = c.Techdirect_Case_ID__c; 
        TechDirectController.invokeTibcoServiceforUpdate(sId);
        
        String xml ='<SOAP-ENV:Envelope xmlns:SOAPENV="http://schemas.xmlsoap.org/soap/envelope/">'+
                         '<SOAP-ENV:Header/>'+
                         '<SOAP-ENV:Body>'+
                         '<ns0:Result xmlns:ns0="http://www.tibco.com/schemas/CaseCreation/SharedResources/Schemas/TechDirectResponse.xsd">'+
                         '<ns0:Success>Success</ns0:Success>'+
                         '<ns0:Data>'+
                         '<ns0:TicketStatus>New</ns0:TicketStatus>'+
                         '<ns0:TicketDescription>This is a Test Ticket, Please ignore</ns0:TicketDescription>'+
                         '</ns0:Data>'+
                         '</ns0:Result>'+
                         '</SOAP-ENV:Body>'+
                         '</SOAP-ENV:Envelope>';
         
    }


}