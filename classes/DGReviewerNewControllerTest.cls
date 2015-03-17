@isTest(seeAllData=true)
public Class DGReviewerNewControllerTest{

    public static testMethod void approvertest(){
    Test.startTest();
        
        User user1 = new User();
        user1 = TestingSetupDataUtil.createUser('Approut1','ApprovalfuncTest1@hp.com','ApprovalfuncTest2@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','ApprovalfuncTest3@hp.com','87654321',Userinfo.getProfileId());
        user1.Business_Group__c='SW';
        user1.Adoption_Role_Type__c='Account Executive';
         user1.Approver_Type__c='Coordinator';
        insert user1;
        
        Account newAcc=TestingSetupDataUtil.createAccount('ApprovalTestAccount','ApprovalfuncTest1@hp.com','Customer');
       // newAcc.World_Region1__c=wr.id;
        insert newAcc; 
        
        Opportunity newOpp = new Opportunity();
        newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'OpptyApprovalfuncTest1', system.today()+ 30);
        newOpp.owner__c=user1.id; 
        newOpp.stageName=  '01 - Understand Customer';
        insert newOpp; 
        
        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get('Approval__c') ;
        Schema.DescribeSObjectResult cfrSchema = s.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        //List<Approval__c> listApproval = new List<Approval__c>();
        Approval__c approval1 =new Approval__c();
       // rcdType1= RecordTypeInfo.get('Opportunity Business Review').getRecordTypeId();
        approval1=new Approval__c();
        approval1.opportunity__c=newOpp.id;
        //approval1.RecordTypeID=rcdType1;
        approval1.status__c='Open';
        approval1.solution_mix__c='None';
        insert approval1;
        //listApproval.add(approval1); 
        System.runAs(user1){
        Reviewer_Workspace__c rws = new Reviewer_Workspace__c();
        rws.Approval_Level__c='1';
        rws.Approval__c= approval1.id;
        insert rws;
        
        
        
        pageReference pgref = new pageReference('apex/DGApproverNewPage?retURL=%2F'+rws.id);
        Test.setCurrentPageReference(pgref);    
        WS_Approver__c wsappr = new WS_Approver__c(Approver__c=user1.id);
        ApexPages.StandardController std = new ApexPages.StandardController(wsappr);
        DGReviewerNewController dgapprv = new DGReviewerNewController(std);
        dgapprv.getReviewerWrapper();
        dgapprv.customSave();
        }
        Test.stopTest();
     
        }
        }