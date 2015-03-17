@isTest(seeAllData=true)
public Class DGApprovalurlselectionControllerTest
{      static PageReference pref,pref1; 
       public static Approval__c approval1,approval2,approval3;
       public static Approval__c ap;
       public static opportunity newOpp;
public static void setupData(){
        world_region__c wr=[select ID from world_region__C where Country_Name__c='United States'];
        /*Insert Account and Opportunity*/
        Account newAcc=TestingSetupDataUtil.createAccount('ApprovalTestAccount','ApprovalfuncTest1@hp.com','Customer');
        newAcc.World_Region1__c=wr.id;
        insert newAcc;
        User user1 = new User();
        user1 = TestingSetupDataUtil.createUser('Approut1','ApprovalfuncTest1@hp.com','ApprovalfuncTest2@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','ApprovalfuncTest3@hp.com','87654321',Userinfo.getProfileId());
        user1.Business_Group__c='ES';
        insert user1;
        newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'OpptyApprovalfuncTest1', system.today()+ 30);
        newOpp.owner__c=user1.id; 
        newOpp.stageName=  '01 - Understand Customer';
        insert newOpp; 
        
        /* inserting approval */
        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get('Approval__c') ;
        Schema.DescribeSObjectResult cfrSchema = s.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        Id rcdType1= RecordTypeInfo.get('Opportunity Review').getRecordTypeId();
        approval1=new Approval__c();
        approval1.opportunity__c=newOpp.id;
        approval1.RecordTypeID=rcdType1;
        insert approval1;
        
        Id rcdType2= RecordTypeInfo.get('Opportunity Business Review').getRecordTypeId();
        approval2=new Approval__c();
        approval2.opportunity__c=newOpp.id;
        approval2.RecordTypeID=rcdType2;
        insert approval2;
        
        Id rcdType3= RecordTypeInfo.get('Renewal').getRecordTypeId();
        approval3=new Approval__c();
        approval3.opportunity__c=newOpp.id;
        approval3.RecordTypeID=rcdType3;
        insert approval3;
    
    }
    public Static testMethod void routingtest(){
   
    Test.startTest();
     setupData();
      pref = Page.DGApprovalRecordTypeUrlPage;
     test.setCurrentPage(pref);
     pref.getParameters().put('retURL','/'+newOpp.id);
     
     ApexPages.StandardController sc = new ApexPages.StandardController(approval1);
     DGApprovalRecordTypeUrlController dgurl = new DGApprovalRecordTypeUrlController(sc);
     dgurl.url();
     
     pref1 = Page.DGApprovalRecordSelectionPage;
     test.setCurrentPage(pref1);
     pref1.getParameters().put('Opportunityid',newOpp.id);
     
     //ApexPages.StandardController sc = new ApexPages.StandardController(approval1);
     DGApprovalRecordSelectionController dgselect = new DGApprovalRecordSelectionController();
     dgselect.opptyAccess();
     dgselect.ApprovalRequestLabel='Opportunity Review';
     dgselect.next();
     dgselect.ApprovalRequestLabel='Opportunity Business Review';
     dgselect.next();
     dgselect.getSupportRequestSubTypes();
     dgselect.cancel();
     dgselect.getSelected();
   
    
    Test.StopTest();
    }
}