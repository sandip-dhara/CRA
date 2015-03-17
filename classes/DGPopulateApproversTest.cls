@isTest(seeAllData=true)
public Class DGPopulateApproversTest {
    public Static List<Approval_Matrix__c> matrixList=new List<Approval_Matrix__c>();
    public static List<Approval_Matrix_Element__c> matrixItemList=new List<Approval_Matrix_Element__c>();
    public static List<Opportunity> opplist=new List<Opportunity>();
    public static List<Approval__c> approvalList=new List<Approval__c>();
    public static Attachment att;
    public static User user2;
    
    public static void setupData(){
    
        //Approvers creation
        List<User> approversList=new List<User>();
        User app1= new User();
        app1= TestingSetupDataUtil.createUser('stAppr1','abc1@hp.com','emailap1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeestap1@hp.com','87654381',Userinfo.getProfileId());
        app1.Approver_Role__c='AP-1011';
        approversList.add(app1);
        
        insert approversList;
         Map<Id,String> groupMap=new Map<ID,String>();
        for(Group gr: [select id,name from group where type='Queue'])
        {
             groupMap.put(gr.id,gr.name);   
        }
        QueueSObject  qs=[select id,queueID from queueSobject where SobjectType='Approval__c' and queueId in : groupMap.keySet() limit 1 ];
        
        Approval_Matrix__c am1=new Approval_Matrix__c();
        am1.Account_Region__c='ALL';
        am1.Owner_BG__c='ES;EG;SW';
        am1.Approval_Flow_Type__c='Hybrid';
        am1.Approval_Type__c='Opportunity Review';
        am1.Approval_Matrix_Name__c='ES flowType1';
        am1.Weight__c=2000000000;
        am1.Active__c=true;
        am1.Approver_Level_1__c='FLM';
        am1.Approver_Level_Type_1__c='Job Function';
        am1.Approver_Level_5__c='AP-1011';
        am1.Approver_Level_Type_5__c='Approver Role';
        am1.Approver_Level_9__c='AP-1011';
        am1.Approver_Level_Type_9__c='Approver Role';
        am1.Approver_Level_13__c='AP-1011';
        am1.Approver_Level_Type_13__c='Approver Role';
        am1.Approver_Level_17__c='AP-1011';
        am1.Approver_Level_Type_17__c='Approver Role';
        
        matrixList.add(am1);
        
        // second matrix record
        Approval_Matrix__c am2=new Approval_Matrix__c();
        am2.Account_Region__c='ALL';
        am2.Owner_BG__c='ES;EG;SW';
        am2.Approval_Flow_Type__c='Hybrid';
        am2.Approval_Type__c='Opportunity Review';
        am2.Approval_Matrix_Name__c='ES flowType2';
        am2.Weight__c=2000000001;
        am2.Active__c=true;
        am2.Approver_Level_1__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_1__c='Queue';
        am2.Approver_Level_5__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_5__c='Queue';
        am2.Approver_Level_9__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_9__c='Queue';
        am2.Approver_Level_13__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_13__c='Queue';
        am2.Approver_Level_17__c=groupMap.get(qs.queueID);
        am2.Approver_Level_Type_17__c='Queue';
        
        matrixList.add(am2);
        insert matrixList;
        system.debug('OOOOOOOOOO'+matrixList[0]);
        system.debug('OOOOOOOOOO'+matrixList[1]);
        Approval_Matrix_Element__c ami1=new Approval_Matrix_Element__c();
        ami1.Approval_Matrix__c=matrixList[0].id;
        ami1.Field_Name__c='Sales Stage';
        ami1.field_Api_name__c='stagename';
        ami1.Object__c='Opportunity';
        ami1.Match_Type__c='Contains';
        ami1.Value__c='01 - Understand Customer';
        matrixItemList.add(ami1);
        
        Approval_Matrix_Element__c ami2=new Approval_Matrix_Element__c();
        ami2.Approval_Matrix__c=matrixList[0].id;
        ami2.Field_Name__c='Coverage Segmentation';
        ami2.field_Api_name__c='coverage_segmentation__c';
        ami2.Object__c='Account';
        ami2.Match_Type__c='Starts With';
        ami2.Value__c='PPS SMB';
        matrixItemList.add(ami2);
        
        Approval_Matrix_Element__c ami3=new Approval_Matrix_Element__c();
        ami3.Approval_Matrix__c=matrixList[0].id;
        ami3.Field_Name__c='Opportunity Type';
        ami3.field_Api_name__c='type';
        ami3.Object__c='Opportunity';
        ami3.Match_Type__c='Equals';
        ami3.Value__c='New Business';
        matrixItemList.add(ami3);
        
        Approval_Matrix_Element__c ami4=new Approval_Matrix_Element__c();
        ami4.Approval_Matrix__c=matrixList[0].id;
        ami4.Field_Name__c='Forecast Category';
        ami4.field_Api_name__c='forecastcategoryname';
        ami4.Object__c='Opportunity';
        ami4.Match_Type__c='Starts With';
        ami4.value__c='Pipeline';
        
        Approval_Matrix_Element__c ami5=new Approval_Matrix_Element__c();
        ami5.Approval_Matrix__c=matrixList[0].id;
        ami5.Field_Name__c='Total Opportunity Value';
        ami5.field_Api_name__c='amount';
        ami5.Object__c='Opportunity';
        ami5.Match_Type__c='Range';
        ami5.Value_Max__c=2000;
        ami5.Value_Min__c=0;
        matrixItemList.add(ami5);
        
        
        
        Approval_Matrix_Element__c ami6=new Approval_Matrix_Element__c();
        ami6.Approval_Matrix__c=matrixList[1].id;
        ami6.Field_Name__c='Pursuit Budget (USD)';
        ami6.field_Api_name__c='Pursuit_Budget_USD__c';
        ami6.Object__c='Approval__c';
        ami6.Match_Type__c='Range';
        ami6.Value_Max__c=500;
        ami6.Value_Min__c=0;
        matrixItemList.add(ami6);
        
        insert matrixItemList;
        
        system.debug('**** '+ matrixItemList[0].field_name__c + ' '+matrixItemList[0].field_API_name__c); 
        system.debug('**** '+ matrixItemList[1].field_name__c + ' '+matrixItemList[1].field_API_name__c); 
        system.debug('**** '+ matrixItemList[2].field_name__c + ' '+matrixItemList[2].field_API_name__c); 
        system.debug('**** '+ matrixItemList[3].field_name__c + ' '+matrixItemList[3].field_API_name__c); 
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
        
        opportunity newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'testOpptyForApprovalFlow', system.today()+ 30);
        newOpp.owner__c=user1.id; 
        newOpp.stageName=  '01 - Understand Customer';
        newOpp.type='New Business';
        newOpp.ForecastCategoryName='Pipeline';
        newOpp.amount=200;
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
        approvalList.add(approval);
        
        Approval__c approval2=new Approval__c();
        approval2.opportunity__c=opplist[0].id;
        approval2.RecordTypeID=rcdType;
        approval2.Pursuit_Budget_USD__c=2000;
        approval2.approver1__c=user1.id;
        approvalList.add(approval2);
        
        insert approvalList;
        
        att=new  Attachment(parentId = approvalList[0].id, description='Test',name = 'Test',body=Blob.valueOf('body'));
        insert att;
        system.assertEquals(approversList[0].Approver_Role__c,'AP-1011');
        
        
        
        
    }
   /* @future
    public static void setupData1(){
        User app1= new User();
        app1= TestingSetupDataUtil.createUser('stAppr123','abc123@hp.com','emailap123@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeestap123@hp.com','87654397',Userinfo.getProfileId());
        app1.Approver_Role__c='AP-1011';
        insert app1;
        //creating the queues 
        Group g = new Group(Type='Queue', Name='Test queue');
        insert g;

        QueueSObject q = new QueueSObject(SobjectType='Approval__c', QueueId=g.Id);
        insert q;
       
        GroupMember gm1=new GroupMember(GroupId=g.id,UserOrGroupId=app1.id);
        
        insert Gm1; 
    }*/
     public static testMethod void populateApproversPositiveTest() {
         Test.startTest();
         try{
         setupData();
         system.runAs(user2){
             system.debug('*********'+ approvalList[0]);
             // Add parameters to page URL
             ApexPages.currentPage().getParameters().put('id', approvalList[0].id);
             ApexPages.StandardController sc = new ApexPages.StandardController(approvalList[0]);
             DGPopulatingApprovers dpa=new DGPopulatingApprovers(sc);
             dpa.populateApprovers();
             dpa.attId=att.id;
             dpa.customEdit();
             
            
             matrixList[0].Approver_Level_5__c='TestT2';
             update matrixList;
             dpa.populateApprovers();
          
           }  
     
        } 
        
       catch(Exception e){}  
         Test.stopTest();
         
     }
}