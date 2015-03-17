@isTest(seeAllData = true)
public class ReferenceViewTriggerTestCoverage {

static Support_Request__c sRequest; 
public Static testMethod  void setupData(){

User user1 = new User();
        user1 = TestingSetupDataUtil.createUser('Accut1','A1@hp.com','AppcalfuncTest2@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','ApprovalfuncTest3@hp.com','87654321',Userinfo.getProfileId());
        user1.Business_Group__c='ES';
        insert user1;
        world_region__c wr=[select ID from world_region__C where Country_Name__c='United States'];
          system.runas(user1){
         
          Account newAcc=TestingSetupDataUtil.createAccount('ApprovalTestAccount','ApprovalfuncTest1@hp.com','Customer');
           newAcc.World_Region1__c=wr.id;
             insert newAcc;
        Opportunity     newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'testOppty567', system.today()+ 30);
            insert newOpp; 
            
       //create a test Support Request
        Map<String,Support_Request_FS_CS__c> sRequestFieldSetCSMap = Support_Request_FS_CS__c.getAll();
        Support_Request_FS_CS__c csRecord = sRequestFieldSetCSMap.get('ES-FunctionalSupport-RSC');
        Id recordTypeId = null;
        if(csRecord!=null){
            recordTypeId = SupportRequestRoutingRulesTriggerUtil.getRecordTypeIDByName(csRecord.RecordType_Name__c);
        }
        sRequest = TestingSetupDataUtil.createSupportRequest(newOpp.id,'Request description');
        if(recordTypeId !=null)
            sRequest.recordTypeId = recordTypeId;
        insert sRequest;
      
       
   roi__Reference_Request__c roi = new roi__Reference_Request__c();
     roi.roi__Opportunity__c = Newopp.id;
     Insert roi;
     
     roi__Sales_Win__c SalesWin = new roi__Sales_Win__c();
     SalesWin.roi__Opportunity__c = Newopp.id;
     saleswin.roi__SalesWinID__c = decimal.valueof('90909');
     saleswin.roi__Date__c = date.today();
     saleswin.roi__Status__c ='Pending';
     saleswin.roi__Submitted_By__c = 'TestUser';
    
     Insert SalesWin;
   
    roi__Spotlight_Activity__c SplotLight = new roi__Spotlight_Activity__c();
     SplotLight.roi__Opportunity__c = Newopp.id;
     Insert SplotLight;
  }
  }
}