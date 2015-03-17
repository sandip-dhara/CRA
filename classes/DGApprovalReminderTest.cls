@isTest(seeAllData=true)
public Class DGApprovalReminderTest {
    public Static List<Approval_Matrix__c> matrixList=new List<Approval_Matrix__c>();
    public static List<Approval_Matrix_Element__c> matrixItemList=new List<Approval_Matrix_Element__c>();
    public static List<Opportunity> opplist=new List<Opportunity>();
    public static List<Approval__c> approvalList=new List<Approval__c>();
    public static User user2;
    
    public static void setupData(){
    
        //Approvers creation
        List<User> approversList=new List<User>();
        User app1= new User();
        app1= TestingSetupDataUtil.createUser('stAppr1','abc1@hp.com','emailap1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeestap1@hp.com','87654381',Userinfo.getProfileId());
        app1.Approver_Role__c='AP-1011';
        approversList.add(app1);
        
        
        
        insert approversList;
        
        
        
        Approval_Matrix__c am1=new Approval_Matrix__c();
        am1.Account_Region__c='ALL';
        am1.Owner_BG__c='ES;EG;SW';
        am1.Approval_Flow_Type__c='Hybrid';
        am1.Approval_Type__c='Opportunity Review';
        am1.Approval_Matrix_Name__c='ES flowType1';
        am1.Weight__c=2000000000;
        am1.Active__c=true;
        am1.Approver_Level_1__c='TestT1';
        am1.Approver_Level_Type_1__c='Approver Role';
        am1.Approver_Level_5__c='AP-1011';
        am1.Approver_Level_Type_5__c='Approver Role';
        am1.Approver_Level_9__c='AP-1011';
        am1.Approver_Level_Type_9__c='Approver Role';
        am1.Approver_Level_13__c='AP-1011';
        am1.Approver_Level_Type_13__c='Approver Role';
        am1.Approver_Level_17__c='AP-1011';
        am1.Approver_Level_Type_17__c='Approver Role';
        
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
        approval.Pursuit_Budget_USD__c=2000;
        approvalList.add(approval);
        
        insert approvalList;
        
        
        system.assertEquals(approversList[0].Approver_Role__c,'AP-1011');
        
       
    }
    
     public static testMethod void RemindermailTest() {
         Test.startTest();
         setupData();
         system.runAs(user2){
         // Add parameters to page URL
         
         ApexPages.currentPage().getParameters().put('id', approvalList[0].id);
         ApexPages.StandardController sc = new ApexPages.StandardController(approvalList[0]);
         DGPopulatingApprovers dpa=new DGPopulatingApprovers(sc);
         dpa.populateApprovers();
         DGBatchSchedulerReminder rem=new DGBatchSchedulerReminder();   

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
          system.schedule('DGBatchSchedulerReminder:'+datetime.now(), schExp1, rem); 

             
             
        } 
         
         
         Test.stopTest();
         
     }
}