@isTest(seeAllData=true)
public Class DGApprovalReassignApproverTest3{
    public Static List<Approval_Matrix__c> matrixList=new List<Approval_Matrix__c>();
    public static List<Approval_Matrix_Element__c> matrixItemList=new List<Approval_Matrix_Element__c>();
    public static List<Opportunity> opplist=new List<Opportunity>();
    public static List<Approval__c> approvalList=new List<Approval__c>();
    public static Attachment att;
    public static User user2;
    
    public static void setupData(){
         system.debug('****1****');
        //Approvers creation
        List<User> approversList=new List<User>();
        User app1= new User();
        app1= TestingSetupDataUtil.createUser('stAppr1','abc1@hp.com','emailap1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeestap1@hp.com','87654381',Userinfo.getProfileId());
        app1.Approver_Role__c='AP-1011';
        approversList.add(app1);
         system.debug('****2****');
        insert approversList;
        Map<Id,String> groupMap=new Map<ID,String>();
        for(Group gr: [select id,name from group where type='Queue'])
        {
             groupMap.put(gr.id,gr.name);   
        }
        QueueSObject  qs=[select id,queueID from queueSobject where SobjectType='Approval__c' and queueId in : groupMap.keySet() limit 1 ];
         system.debug('****3****');
        
        Approval_Matrix__c am2=new Approval_Matrix__c();
        am2.Account_Region__c='ALL';
        am2.Owner_BG__c='ES;EG;SW';
        am2.Approval_Flow_Type__c='Unanimous';
        am2.Approval_Type__c='Opportunity Review';
        am2.Approval_Matrix_Name__c='ES flowType2';
        am2.Weight__c=2000000001;
        am2.Active__c=true;
        am2.Approver_Level_1__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_1__c='Queue';
        am2.Approver_Level_2__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_2__c='Queue';
        am2.Approver_Level_3__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_3__c='Queue';
        am2.Approver_Level_4__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_4__c='Queue';
        am2.Approver_Level_5__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_5__c='Queue';
        am2.Approver_Level_6__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_6__c='Queue';
        am2.Approver_Level_7__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_7__c='Queue';
        am2.Approver_Level_8__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_8__c='Queue';
        am2.Approver_Level_9__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_9__c='Queue';
        am2.Approver_Level_10__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_10__c='Queue';
        am2.Approver_Level_11__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_11__c='Queue';
        am2.Approver_Level_12__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_12__c='Queue';
        am2.Approver_Level_13__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_13__c='Queue';
        am2.Approver_Level_14__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_14__c='Queue';
        am2.Approver_Level_15__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_15__c='Queue';
        am2.Approver_Level_16__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_16__c='Queue';
        am2.Approver_Level_17__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_17__c='Queue';
        am2.Approver_Level_18__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_18__c='Queue';
        am2.Approver_Level_19__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_19__c='Queue';
        am2.Approver_Level_20__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_20__c='Queue';
        matrixList.add(am2);
        insert matrixList;
         system.debug('****4****');
       system.debug('matrixList queue name '+matrixList[0].Approver_Level_1__c);
        
        
        
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
         system.debug('****5****');
        
        world_region__c wr=[select ID from world_region__C where Country_Name__c='United States'];
        /*Insert Account and Opportunity*/
        Account newAcc=TestingSetupDataUtil.createAccount('ApprovalFlowTest','test_22@hp.com','Customer');
        newAcc.World_Region1__c=wr.id;
        newAcc.coverage_segmentation__c='PPS=PPS SMB';
        insert newAcc;
        User user1 = new User();
        user1 = TestingSetupDataUtil.createUser('stTest1','abc@hp.com','email1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest@hp.com','87654321',Userinfo.getProfileId());
        user1.Business_Group__c='ES';
        insert user1;
        
        user2 = new User();
        user2 = TestingSetupDataUtil.createUser('stTest2','abc@hp.com','email2@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeest2@hp.com','87654322',Userinfo.getProfileId());
        user2.Business_Group__c='Test';
        user2.managerID=user1.id;
        insert user2;
         system.debug('****6****');
        
        opportunity newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'testOpptyForApprovalFlow', system.today()+ 30);
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
       
         system.debug('****6****');
        Approval__c approval=new Approval__c();
        approval.opportunity__c=opplist[0].id;
        approval.RecordTypeID=rcdType;
        approval.Pursuit_Budget_USD__c=500;
        approval.approver1__c=user1.id;
        approvalList.add(approval);
        
        Approval__c approval1=new Approval__c();
        approval1.opportunity__c=opplist[0].id;
        approval1.RecordTypeID=rcdType;
        approval1.Pursuit_Budget_USD__c=500;
        approval1.approver1__c=user1.id;
        approvalList.add(approval1);
        system.debug('****7****');
        /*****Added for Hybrid Approval*****Mousumi*/
        Approval__c approval2=new Approval__c();
        approval2.opportunity__c=opplist[0].id;
        approval2.RecordTypeID=rcdType;
        approval2.Pursuit_Budget_USD__c=500;
        approval2.approver1__c=user1.id;
        approvalList.add(approval2);
        
        insert approvalList;
        system.debug('approvalList****************'+approvalList);
        att=new  Attachment(parentId = approvalList[0].id, description='Test',name = 'Test',body=Blob.valueOf('body'));
        insert att;
        system.debug('****7****');
       /* DG_Batch_Controller__c dbc = new DG_Batch_Controller__c();
        dbc.name='Batch Job Started';
        dbc.Start_Job__c=false;
        insert dbc; */
        
        
        
    }
    
    public static void setupData1(){
        User app1= new User();
        app1= TestingSetupDataUtil.createUser('stAppr9','abc123@hp.com','emailap123@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeestap123@hp.com','87654397',Userinfo.getProfileId());
        app1.Approver_Role__c='AP-1011';
        insert app1;
        //creating the queues 
        Group g = new Group(Type='Queue', Name='QueueTest1');
        insert g;

        QueueSObject q = new QueueSObject(SobjectType='Approval__c', QueueId=g.Id);
        insert q;
       
        GroupMember gm1=new GroupMember(GroupId=g.id,UserOrGroupId=app1.id);
        
        insert Gm1; 
    }
     public static testMethod void populateApproversPositiveTest() {
         Test.startTest();
         setupData();
         //setupData1();
         system.runAs(user2){
             ApexPages.currentPage().getParameters().put('id', approvalList[0].id);
             ApexPages.StandardController sc = new ApexPages.StandardController(approvalList[0]);
             DGPopulatingApprovers dpa=new DGPopulatingApprovers(sc);
             dpa.populateApprovers();
             
            
             
                        
             // List<ProcessInstanceWorkitem> workItemList = [Select p.ProcessInstance.TargetObjectId,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :approvalList[0].id ];
             //DGApprovalReassignApprover.reassignToQueue(workItemList );
             
            matrixList[0].Approval_Flow_Type__c='Sequential';
            update matrixList[0];
            //system.assertEquals(approvalList[0].approval_flow_type__c,'Sequential');
            ApexPages.currentPage().getParameters().put('id', approvalList[1].id);
          ApexPages.StandardController sc1 = new ApexPages.StandardController(approvalList[1]);
          DGPopulatingApprovers dpa1=new DGPopulatingApprovers(sc1);
          dpa1.populateApprovers();
          
          
          
         /************Added by Mousumi****For Hybrid Approval*******/ 
           matrixList[0].Approval_Flow_Type__c='Hybrid';
           update matrixList[0];
            ApexPages.currentPage().getParameters().put('id', approvalList[2].id);
          ApexPages.StandardController sc2 = new ApexPages.StandardController(approvalList[2]);
          DGPopulatingApprovers dpa2=new DGPopulatingApprovers(sc2);
          dpa2.populateApprovers();
         
          
         
           approvalList[0].Current_Approval_level__c =4;
           approvalList[1].Current_Approval_level__c =4;
          approvalList[2].Current_Approval_level__c =4;
          update  approvalList;
          
          DGBatchSchedulerReassignToQueue ppn1=new DGBatchSchedulerReassignToQueue();
          datetime currentDateTime1 = datetime.now();
         // String min1 = String.valueOf(math.mod((currentDateTime1.minute() + 0),60));
          integer min=currentDateTime1.minute();
          integer hour1=currentDateTime1.hour();
          
          if(min==59){
              min=01;
              if(hour1==23){
               hour1=00;
              }else{
                  hour1=hour1+1;
              }
          }             
          
          
          String schExp1=hour1+' '+min+' * * * ? ';
          
          //String schExp1 = currentDateTime1.hour()+' '+(currentDateTime1.minute()+1) +' * * * ? ';
          system.schedule('DGBatchSchedulerReassignToQueue:'+datetime.now(), schExp1, ppn1); 
           
          //List<ProcessInstanceWorkitem> workItemList0 = [Select p.ProcessInstance.TargetObjectId,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :approvalList[2].id ];
          //DGApprovalReassignApprover.reassignToQueue(workItemList0);
            //approving the first level 
            //ProcessInstanceWorkitem piw1=[Select p.id,p.ProcessInstance.TargetObjectId,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :approvalList[1].id];
           
          /* try{                              
            Approval.ProcessWorkitemRequest req1 = new Approval.ProcessWorkitemRequest();
            req1.setComments('Approving request using Trigger');
            req1.setAction('Approve');
            req1.setNextApproverIds(new Id[] {approvalList[2].Approver5__c});
            req1.setWorkitemId(workItemList0[0].id);

            Approval.ProcessResult result1 =  Approval.process(req1);

            
            List<ProcessInstanceWorkitem> workItemList1 = [Select p.ProcessInstance.TargetObjectId,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :approvalList[2].id ];
             DGApprovalReassignApprover.reassignToQueue(workItemList1 );
            }
            
            */
             //approving the second leve2 
           /* ProcessInstanceWorkitem piw2=[Select p.id,p.ProcessInstance.TargetObjectId,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :approvalList[1].id];
                                        
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approving request using Trigger');
            req2.setAction('Approve');
            req2.setNextApproverIds(new Id[] {approvalList[0].Approver3__c});
            req2.setWorkitemId(piw2.id);
            Approval.ProcessResult result2 =  Approval.process(req2);

            
            List<ProcessInstanceWorkitem> workItemList2 = [Select p.ProcessInstance.TargetObjectId,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :approvalList[1].id ];
            DGApprovalReassignApprover.reassignToQueue(workItemList2 );
            
            //approving the second leve3 
            ProcessInstanceWorkitem piw3=[Select p.id,p.ProcessInstance.TargetObjectId,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :approvalList[1].id];
                                        
            Approval.ProcessWorkitemRequest req3= new Approval.ProcessWorkitemRequest();
            req3.setComments('Approving request using Trigger');
            req3.setAction('Approve');
            req3.setNextApproverIds(new Id[] {approvalList[0].Approver4__c});
            req3.setWorkitemId(piw3.id);
            Approval.ProcessResult result3 =  Approval.process(req3);

            
            List<ProcessInstanceWorkitem> workItemList3 = [Select p.ProcessInstance.TargetObjectId,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :approvalList[1].id ];
            DGApprovalReassignApprover.reassignToQueue(workItemList3 );
         
             //approving the second leve4
            ProcessInstanceWorkitem piw4=[Select p.id,p.ProcessInstance.TargetObjectId,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :approvalList[1].id];
                                        
            Approval.ProcessWorkitemRequest req4= new Approval.ProcessWorkitemRequest();
            req4.setComments('Approving request using Trigger');
            req4.setAction('Approve');
            req4.setNextApproverIds(new Id[] {approvalList[0].Approver5__c});
            req4.setWorkitemId(piw4.id);
            Approval.ProcessResult result4 =  Approval.process(req4);

            
            List<ProcessInstanceWorkitem> workItemList4 = [Select p.ProcessInstance.TargetObjectId,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :approvalList[1].id ];
            DGApprovalReassignApprover.reassignToQueue(workItemList4 );
            
            //approving the second leve4
            ProcessInstanceWorkitem piw5=[Select p.id,p.ProcessInstance.TargetObjectId,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :approvalList[1].id];
                                        
            Approval.ProcessWorkitemRequest req5= new Approval.ProcessWorkitemRequest();
            req5.setComments('Approving request using Trigger');
            req5.setAction('Approve');
            req5.setNextApproverIds(new Id[] {approvalList[0].Approver6__c});
            req5.setWorkitemId(piw5.id);
            Approval.ProcessResult result5 =  Approval.process(req5);
            
            //approving the second leve4
            ProcessInstanceWorkitem piw6=[Select p.id,p.ProcessInstance.TargetObjectId,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :approvalList[1].id];
                                        
            Approval.ProcessWorkitemRequest req6= new Approval.ProcessWorkitemRequest();
            req6.setComments('Approving request using Trigger');
            req6.setAction('Approve');
            req6.setNextApproverIds(new Id[] {approvalList[0].Approver7__c});
            req6.setWorkitemId(piw6.id);
            Approval.ProcessResult result6 =  Approval.process(req6);
            
            //approving the second leve4
            ProcessInstanceWorkitem piw7=[Select p.id,p.ProcessInstance.TargetObjectId,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId = :approvalList[1].id];
                                        
            Approval.ProcessWorkitemRequest req7= new Approval.ProcessWorkitemRequest();
            req7.setComments('Approving request using Trigger');
            req7.setAction('Approve');
            req7.setNextApproverIds(new Id[] {approvalList[0].Approver8__c});
            req7.setWorkitemId(piw7.id);
            Approval.ProcessResult result7=  Approval.process(req7);
            
            }*/
            
            /*catch(Exception e){}*/
            
            system.debug('9999999 '+ approvalList[1].status__c);   
         
         }
        
         
         Test.stopTest();
         
     }
}