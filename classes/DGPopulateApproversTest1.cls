@isTest(seeAllData=true)
public Class DGPopulateApproversTest1 {
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
        am1.Approval_Matrix_Name__c='ES flowType3';
        am1.Weight__c=-1;
        am1.Active__c=true;
        
        
        am1.Approver_Level_1__c='FLM';
        am1.Approver_Level_Type_1__c='Job Function';
        am1.Approver_Level_2__c='AP-1011';
        am1.Approver_Level_Type_2__c='Approver Role';
        am1.Approver_Level_3__c='AP-1011';
        am1.Approver_Level_Type_3__c='Approver Role';
        am1.Approver_Level_4__c='AP-1011';
        am1.Approver_Level_Type_4__c='Approver Role';
        am1.Approver_Level_5__c='AP-1011';
        am1.Approver_Level_Type_5__c='Approver Role';
        am1.Approver_Level_6__c='AP-1011';
        am1.Approver_Level_Type_6__c='Approver Role';
        am1.Approver_Level_7__c='AP-1011';
        am1.Approver_Level_Type_7__c='Approver Role';
        am1.Approver_Level_8__c='AP-1011';
        am1.Approver_Level_Type_8__c='Approver Role';
        am1.Approver_Level_9__c='AP-1011';
        am1.Approver_Level_Type_9__c='Approver Role';
        am1.Approver_Level_10__c='AP-1011';
        am1.Approver_Level_Type_10__c='Approver Role';
        am1.Approver_Level_11__c='AP-1011';
        am1.Approver_Level_Type_11__c='Approver Role';
        am1.Approver_Level_12__c='AP-1011';
        am1.Approver_Level_Type_12__c='Approver Role';
        am1.Approver_Level_13__c='AP-1011';
        am1.Approver_Level_Type_13__c='Approver Role';
        am1.Approver_Level_14__c='AP-1011';
        am1.Approver_Level_Type_14__c='Approver Role';
        am1.Approver_Level_15__c='AP-1011';
        am1.Approver_Level_Type_15__c='Approver Role';
        am1.Approver_Level_16__c='AP-1011';
        am1.Approver_Level_Type_16__c='Approver Role';
        am1.Approver_Level_17__c='AP-1011';
        am1.Approver_Level_Type_17__c='Approver Role';
        am1.Approver_Level_18__c='AP-1011';
        am1.Approver_Level_Type_18__c='Approver Role';
        am1.Approver_Level_19__c='AP-1011';
        am1.Approver_Level_Type_19__c='Approver Role';
        am1.Approver_Level_20__c='AP-1011';
        am1.Approver_Level_Type_20__c='Approver Role';
        matrixList.add(am1);
        
        insert matrixList;
        
       
        world_region__c wr=[select ID from world_region__C where Country_Name__c='United States'];
        //Insert Account and Opportunity
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
        newOpp.stageName=  '02 - Validate Opportunity';
        opplist.add(newOpp);  
        
       
        insert opplist;
        
         Opportunity_Plan__c opplan=new Opportunity_Plan__c(Opportunity__c=opplist[0].id);
        insert opplan;
        // inserting approval 
        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get('Approval__c') ;
        Schema.DescribeSObjectResult cfrSchema = s.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rcdType= RecordTypeInfo.get('Opportunity Review').getRecordTypeId();
              
        Approval__c approval1=new Approval__c();
        approval1.opportunity__c=opplist[0].id;
        approval1.RecordTypeID=rcdType;
        approvalList.add(approval1);
        
        Approval__c approval2=new Approval__c();
        approval2.opportunity__c=opplist[0].id;
        approval2.RecordTypeID=rcdType;
        approvalList.add(approval2);
        
        insert approvalList;
        
        
        system.assertEquals(approversList[0].Approver_Role__c,'AP-1011');
        
              
        
    }
    
     public static testMethod void populateApproversPositiveTest() {
         Test.startTest();
         try{
         setupData();
        
         system.runAs(user2){
         
             ApexPages.currentPage().getParameters().put('id', approvalList[0].id);
             ApexPages.StandardController sc1 = new ApexPages.StandardController(approvalList[0]);
             DGPopulatingApprovers dpa1=new DGPopulatingApprovers(sc1);
             dpa1.populateApprovers();
             DGApprovalRoutingController dgappr1=new DGApprovalRoutingController(sc1); 
             dgappr1.routeToExactPage();
             dgappr1.routeToExactPageEdit();
             ApexPages.currentPage().getParameters().put('id', approvalList[1].id);
             ApexPages.StandardController sc2 = new ApexPages.StandardController(approvalList[1]);
             DGPopulatingApprovers dpa2=new DGPopulatingApprovers(sc2);
             
             matrixList[0].Approver_Level_1__c='TestT123';
             matrixList[0].Approver_Level_Type_1__c='Approver Role';
             matrixList[0].Approver_Level_2__c='';
             matrixList[0].Approver_Level_Type_2__c='';
             matrixList[0].Approver_Level_3__c='';
             matrixList[0].Approver_Level_Type_3__c='';
             matrixList[0].Approver_Level_4__c='';
             matrixList[0].Approver_Level_Type_4__c='';
             update matrixList[0];
             dpa2.populateApprovers();
             
            
             
            
         
        }  
        
        }catch(Exception e){}
         
         
         Test.StopTest();
     }
}