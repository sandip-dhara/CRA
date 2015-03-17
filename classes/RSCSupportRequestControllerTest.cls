@isTest(seeAllData = true)
public class RSCSupportRequestControllerTest {
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
        PageReference pageRef = Page.RSCSupportRequestPage;
       // String Str = '/'+String.valueOf(app.Id);
        pageRef.getParameters().put('id',sRequest.id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(sRequest);
        RSCSupportRequestController testsRequest = new RSCSupportRequestController(sc);
      
}
}
}