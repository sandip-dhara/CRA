@isTest(seeAllData=true)
public Class DGPopulateApproversTest4 {
    public Static List<Approval_Matrix__c> matrixList=new List<Approval_Matrix__c>();
    public static List<Approval_Matrix_Element__c> matrixItemList=new List<Approval_Matrix_Element__c>();
    public static List<Opportunity> opplist=new List<Opportunity>();
    public static List<Approval__c> approvalList=new List<Approval__c>();
    public static User user2;
    public static List<Attachment> attachmentList;
    public static List<AttachmentExtension__c > atextList;
    
    public static void setupData(){
    
               
        
        
        Approval_Matrix__c am1=new Approval_Matrix__c();
        am1.Account_Region__c='ALL';
        am1.Owner_BG__c='ES;EG;SW';
        am1.Approval_Flow_Type__c='Hybrid';
        am1.Approval_Type__c='Opportunity Review';
        am1.Approval_Matrix_Name__c='ES flowType1';
        am1.Weight__c=2000000000;
        am1.Active__c=true;
        am1.Approver_Level_1__c='AP-1011';
        am1.Approver_Level_Type_1__c='Approver Role';
        am1.Approver_Level_2__c='AP-1011';
        am1.Approver_Level_Type_2__c='Approver Role';
        am1.Approver_Level_3__c='AP-1011';
        am1.Approver_Level_Type_3__c='Approver Role';
        am1.Approver_Level_4__c='AP-1011';
        am1.Approver_Level_Type_4__c='Approver Role';
        am1.Approver_Level_5__c='Test';
        am1.Approver_Level_Type_5__c='Approver Role';
        am1.Approver_Level_6__c='AP-1011';
        am1.Approver_Level_Type_6__c='Approver Role';
        am1.Approver_Level_7__c='AP-1011';
        am1.Approver_Level_Type_7__c='Approver Role';
        am1.Approver_Level_8__c='AP-1011';
        am1.Approver_Level_Type_8__c='Approver Role';
        matrixList.add(am1);
        
        
        insert matrixList;
        
        
        
        Approval_Matrix_Element__c ami6=new Approval_Matrix_Element__c();
        ami6.Approval_Matrix__c=matrixList[0].id;
        ami6.Field_Name__c='Pursuit Budget (USD)';
        ami6.field_Api_name__c='Pursuit_Budget_USD__c';
        ami6.Object__c='Approval__c';
        ami6.Match_Type__c='Range';
        ami6.Value_Max__c=3000;
        ami6.Value_Min__c=0;
        matrixItemList.add(ami6);
        
        insert matrixItemList;
        
        world_region__c wr=[select ID from world_region__C where Country_Name__c='United States'];
        /*Insert Account and Opportunity*/
        Account newAcc=TestingSetupDataUtil.createAccount('ApprovalFlowTest','test_22@hp.com','Customer');
        newAcc.World_Region1__c=wr.id;
        insert newAcc;
        
        List<User> usersList=new List<User>();
        User user1 = new User();
        user1 = TestingSetupDataUtil.createUser('stTest1','abc@hp.com','email1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@hp.com','87654321',Userinfo.getProfileId());
        user1.Business_Group__c='ES';
        usersList.add(user1);
        
        User app1= new User();
        app1= TestingSetupDataUtil.createUser('stAppr1','abc1@hp.com','emailap1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeestap1@hp.com','87654381',Userinfo.getProfileId());
        app1.Approver_Role__c='AP-1011';
        usersList.add(app1);
        
        insert usersList;
        
        user2 = new User();
        user2 = TestingSetupDataUtil.createUser('stTest2','abc@hp.com','email2@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest2@hp.com','87654322',Userinfo.getProfileId());
        user2.Business_Group__c='Test';
        user2.managerID=user1.id;
        user2.Approver_Type__c='Coordinator';
        insert user2;
        
        opportunity newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'testOpptyForApprovalFlow', system.today()+ 30);
        newOpp.owner__c=usersList[0].id; 
        newOpp.stageName=  '01 - Understand Customer';
        
        opplist.add(newOpp);  
        
        insert opplist;
        /* inserting approval */
        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get('Approval__c') ;
        Schema.DescribeSObjectResult cfrSchema = s.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        Id rcdType= RecordTypeInfo.get('Opportunity Review').getRecordTypeId();
              
        Approval__c approval=new Approval__c();
        approval.opportunity__c=opplist[0].id;
        approval.RecordTypeID=rcdType;
        approval.Pursuit_Budget_USD__c=500;
        approvalList.add(approval);
        
        insert approvalList;
        
        attachmentList=new List<Attachment>();
            Attachment att=new Attachment(parentId =approval.id,description='descriptiontrest1',body=blob.valueOf('Test'),name='Test');
            Attachment att1=new Attachment(parentId =approval.id,description='descriptiontrest2',body=blob.valueOf('Test'),name='Test1');
            Attachment att2=new Attachment(parentId =approval.id,description='descriptiontrest3',body=blob.valueOf('Test'),name='Test2');
            attachmentList.add(att);
            attachmentList.add(att1);
            attachmentList.add(att2);
            insert attachmentList;
            
            atextList=new List<AttachmentExtension__c >();
            AttachmentExtension__c ate1=new AttachmentExtension__c();
            ate1.version_number__c = 1;
            ate1.AttachmentReference__c = attachmentList[0].id;
            atextList.add(ate1);    
            AttachmentExtension__c ate2=new AttachmentExtension__c();
            ate2.version_number__c = 1;
            ate2.AttachmentReference__c = attachmentList[1].id;
            atextList.add(ate2); 
            AttachmentExtension__c ate3=new AttachmentExtension__c();
            ate3.version_number__c = 1;
            ate3.AttachmentReference__c = attachmentList[2].id;
            atextList.add(ate3); 
            insert atextList;
        
        
        
        system.assertEquals(usersList[1].Approver_Role__c,'AP-1011');
        
        
        
        
    }
    
     public static testMethod void populateApproversPositiveTest() {
         Test.startTest();
         try{
         setupData();
         
         // Add parameters to page URL
         
         ApexPages.currentPage().getParameters().put('id', approvalList[0].id);
         ApexPages.StandardController sc = new ApexPages.StandardController(approvalList[0]);
         DGPopulatingApprovers dpa=new DGPopulatingApprovers(sc);
         dpa.populateApprovers();
         matrixList[0].Approver_Level_13__c='TestT2';
        
         update matrixList;
         dpa.populateApprovers();
         
         
          matrixList[0].Approver_Level_17__c='TestT2';
         update matrixList;
         dpa.populateApprovers();
         
         dpa.getAttachments();
         dpa.DeleteAttachment();
         dpa.LockAttachment();
         dpa.customAttachmentEdit();
         dpa.attId =attachmentList[0].id;
         dpa.LockAttachment();
         dpa.attId =attachmentList[0].id;
         dpa.DeleteAttachment();
         /*matrixList[0].Approver_Level_7__c='AP-1011';
         matrixList[0].Approver_Level_8__c='AP-1011';
         matrixList[0].Approver_Level_3__c='AP-1011';
         matrixList[0].Approver_Level_4__c='TestT2';
         update matrixList;
         dpa.populateApprovers();*/
        system.runAs(user2){    
            Reviewer_Workspace__c Workspace = new Reviewer_Workspace__c();    
            workspace.Approval_Level__c = 'Level 1';
            Workspace.approval__c = approvalList[0].id;
            insert workspace;    
            update workspace;    
            delete workspace;   
         }
          
         
         }Catch(Exception e){}
         
         Test.stopTest();
         
     }
}