@isTest(seeAllData=true)
public Class DGApprovalsForSupportRequestTest {
    public Static List<Approval_Matrix__c> matrixList=new List<Approval_Matrix__c>();
    public static List<Approval_Matrix_Element__c> matrixItemList=new List<Approval_Matrix_Element__c>();
    public static List<Opportunity> opplist=new List<Opportunity>();
    public static List<Approval__c> approvalList=new List<Approval__c>();
    public static User user2 = new user();
    public static support_request__c sRequest=new support_request__c();
    public static List<User> approversList=new List<User>();
    public static User user1 = new User();
    public static Individual_Employee_Assignments__c IEA = new Individual_Employee_Assignments__c();
    public static opportunity newOpp = new Opportunity();
    
    public static void setupData(){
    
        //Approvers creation
        
        User app1= new User();
        app1= TestingSetupDataUtil.createUser('stAppr1','abc1@hp.com','emailap1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeestap1@hp.com','87654381',Userinfo.getProfileId());
        app1.Approver_Role__c='AP-101';
        app1.Adoption_Role_Type__c='Account Executive'; 
        approversList.add(app1);
        insert approversList;
        // second matrix record
        Approval_Matrix__c am2=new Approval_Matrix__c();
        am2.Account_Region__c='ALL';
        am2.Owner_BG__c='ES;EG;SW';
        am2.Approval_Flow_Type__c='Sequential';
        am2.Approval_Type__c='Opportunity Review';
        am2.Approval_Matrix_Name__c='ES flowType2';
        am2.Weight__c=2000000001;
        am2.Active__c=true;
        am2.Approver_Level_1__c='AP-101';
        am2.Approver_Level_Type_1__c='Approver Role';
        
        matrixList.add(am2);
        insert matrixList;
        
        
        Approval_Matrix_Element__c ami1=new Approval_Matrix_Element__c();
        ami1.Approval_Matrix__c=matrixList[0].id;
        ami1.Field_Name__c='Pursuit Budget (USD)';
        ami1.field_Api_name__c='Pursuit_Budget_USD__c';
        ami1.Object__c='Approval__c';
        ami1.Match_Type__c='Range';
        ami1.Value_Max__c=3000;
        ami1.Value_Min__c=0;
        matrixItemList.add(ami1);
        
        insert matrixItemList;
        
        world_region__c wr=[select ID from world_region__C where Country_Name__c='United States'];
        /*Insert Account and Opportunity*/
        Account newAcc=TestingSetupDataUtil.createAccount('ApprovalFlowTest','test_22@hp.com','Customer');
        newAcc.World_Region1__c=wr.id;
        newAcc.coverage_segmentation__c='PPS=PPS SMB';
        insert newAcc;
        
        user1 = TestingSetupDataUtil.createUser('stTest1','abc@hp.com','email1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@hp.com','87654321',Userinfo.getProfileId());
        user1.Business_Group__c='ES';
        insert user1;
        

        user2 = TestingSetupDataUtil.createUser('stTest2','abc@hp.com','email2@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest2@hp.com','87654322',Userinfo.getProfileId());
        user2.Business_Group__c='ES';
        user2.managerID=user1.id;
        insert user2;
        
        
        newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'testOpptyForApprovalFlow', system.today()+ 30);
        newOpp.owner__c=user1.id; 
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
        approval.approver1__c=user1.id;
        approvalList.add(approval);
        insert approvalList;
        
       
        
    }
     
          public static testMethod void populateApproversPositiveTest() {
         Test.startTest();
         setupData();
         system.runAs(user2){
         
                     
       //create a test Support Request
        Map<String,Support_Request_FS_CS__c> sRequestFieldSetCSMap = Support_Request_FS_CS__c.getAll();
        Support_Request_FS_CS__c csRecord = sRequestFieldSetCSMap.get('ES-FunctionalSupport-WBScode');
        Id recordTypeId = null;
        if(csRecord!=null){
            recordTypeId = SupportRequestRoutingRulesTriggerUtil.getRecordTypeIDByName(csRecord.RecordType_Name__c);
            system.debug('!@#'+recordTypeId);
        }
       
        sRequest = TestingSetupDataUtil.createSupportRequest(newOpp.id,'Request description');
        if(recordTypeId !=null)
            sRequest.recordTypeId = recordTypeId;
            sRequest.Bid_Manager_Contact_with_Employee_ID__c = '12345';
            sRequest.Request_Description__c = 'Test';
            sRequest.Request_Type__c = 'New Project';
            sRequest.Industry_Sales_Channel__c = 'All';
                    
            insert sRequest;
          
            
          SupReqIndividualEmployeeCompController IEAcontroller = new SupReqIndividualEmployeeCompController();
            IEAcontroller.SupportReqId = sRequest.Id;
            IEAcontroller.getEmployee();
            
                IEA.Home_Region__c = 'Americas';
                IEA.Organisation__c = 'Apps Dedicated Solutioning';
                IEA.Employee_Name__c = 'Test';
                IEA.Employee_ID__c = '12345';
                IEA.Time_Tracking_Tool__c ='OMEGA';
                IEA.Support_Request__c = sRequest.Id;
                Insert IEA;
            
            SupReqIndividualEmployeeCompController IEAcontrollerNegative = new SupReqIndividualEmployeeCompController();
            IEAcontrollerNegative.SupportReqId = sRequest.Id;
            IEAcontrollerNegative.getEmployee();
            
            /* 
            *Code for coverage of ApprovalQueueListing 
            */
          PageReference pageRefQueueLookup = Page.CustomQueueLookup;
          Test.setCurrentPage(pageRefQueueLookup);
          ApexPages.currentPage().getParameters().put('QueueId', approvalList[0].id);
          ApexPages.currentPage().getParameters().put('ApproverId', approvalList[0].id);
          ApprovalQueueListing DGApprovalQueue = new ApprovalQueueListing();
           DGApprovalQueue.initialize();
           DGApprovalQueue.getQueueList();
           

            
            //system.assertEquals(approvalList[0].approval_flow_type__c,'Sequential');
          ApexPages.currentPage().getParameters().put('id', approvalList[0].id);
          ApexPages.StandardController sc1 = new ApexPages.StandardController(approvalList[0]);
          DGPopulatingApprovers dpa1=new DGPopulatingApprovers(sc1);
          dpa1.populateApprovers();
           
          List<ProcessInstanceWorkitem> workItemList0 = [Select p.ProcessInstance.TargetObjectId,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :approvalList[0].id ];
          
           try{                              
            Approval.ProcessWorkitemRequest req1 = new Approval.ProcessWorkitemRequest();
            req1.setComments('Approving request using Class');
            req1.setAction('Approve');
            //req1.setNextApproverIds(new Id[] {approvalList[0].Approver2__c});
            req1.setWorkitemId(workItemList0[0].id);

            Approval.ProcessResult result1 =  Approval.process(req1);
            
            ApexPages.StandardController stdController= new ApexPages.StandardController(sRequest);
            SupportReqApprovalInfoController sric=new SupportReqApprovalInfoController(stdController);
            SupportReqApprovalInfoCompController  supportReq=new SupportReqApprovalInfoCompController ();
            supportReq.SRId = sRequest.Id;
            supportReq.getinfo();
            
            DGHideEmailTextController DGHideText = new  DGHideEmailTextController();
            DGHideText.AppId = approvalList[0].id;
            DGHideText.RecpId = approversList[0].id; 
            DGHideText.getShowtext(); 
            DGHideText.RecpId = user1.id; 
            DGHideText.getShowtext(); 
            
            DGPursuitResourcesController DGPRC = new DGPursuitResourcesController();
            DGPRC.AppId = approvalList[0].id;
            DGPRC.getPursuitResource();
            DGPRC.getOpportunityInfo();
            
           
            
            }catch(Exception e){}
            
            system.debug('9999999 '+ approvalList[0].status__c);   
         
         }
         Test.stopTest();

     
         }
         
     }