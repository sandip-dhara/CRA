@isTest(seeAllData=true)
public class DGApprovalsInfoControllerTest{
     public static Approval__c approval;
     public Static List<Approval_Matrix__c> matrixList=new List<Approval_Matrix__c>();
     public static List<Approval_Matrix_Element__c> matrixItemList=new List<Approval_Matrix_Element__c>();
     public static List<User> usersList=new List<User>();
     public static user user2;
    public static void setupData(){
    
        Approval_Matrix__c am1=new Approval_Matrix__c();
        am1.Account_Region__c='ALL';
        am1.Owner_BG__c='ES;EG;SW';
        am1.Approval_Flow_Type__c='Sequential';
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
        am1.Approver_Level_5__c='AP-1011';
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
        ami6.Value_Max__c=5000;
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
        user2.Adoption_Role_Type__c='Account Executive'; 
        insert user2;
        
        opportunity newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'testOpptyForApprovalFlow', system.today()+ 30);
        newOpp.owner__c=usersList[0].id; 
        newOpp.stageName=  '01 - Understand Customer';
        insert newOpp; 
        
        /* inserting approval */
        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get('Approval__c') ;
        Schema.DescribeSObjectResult cfrSchema = s.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        
        Id rcdType= RecordTypeInfo.get('Opportunity Review').getRecordTypeId();
        approval=new Approval__c();
        approval.opportunity__c=newOpp.id;
        approval.RecordTypeID=rcdType;
        approval.Pursuit_Budget_USD__c=200;
        
        
        insert approval;
    
    }
    public Static testMethod void  posittiveTest(){
        Test.startTest();
            setupData();
            system.runAs(user2){
                
                ApexPages.currentPage().getParameters().put('id', approval.id);
                ApexPages.StandardController sc1 = new ApexPages.StandardController(approval);
                DGPopulatingApprovers dpa=new DGPopulatingApprovers(sc1);
                dpa.populateApprovers();
                system.debug('OOOOOOOO'+approval.Approval_Type__c);
                system.debug('******'+approval.status__c);
             }
            system.runAs(usersList[1]){
                ApexPages.currentPage().getParameters().put('id', approval.id);
                ApexPages.StandardController sc = new ApexPages.StandardController(approval);
                DGApprovalsInfoController daic=new DGApprovalsInfoController(sc);
               
                daic.myApprovalList();
                daic.viewName='My Pending Approvals';
                daic.SearchByAssignedTo='test';
                daic.myApprovalList();
                
                daic.viewName='My Related Open Approvals';
                daic.nullifySearch();
                daic.myApprovalList();
                
                daic.viewName='My Related Open Approvals';
                daic.SearchByAssignedTo='test';
                daic.myApprovalList();
                
                daic.viewName='My Approval History';
                daic.myApprovalList();
                
                daic.viewName='My Approval History';
                daic.SearchByAssignedTo='test';
                daic.myApprovalList();
                
                daic.searchByName='test';
                daic.myApprovalList();
                daic.nullifySearch();
                
                daic.dateTo=date.today()+2;
                daic.searchByName='Test';
                daic.myApprovalList();
                daic.nullifySearch();
                
                daic.dateFrom=date.today()-2;
                daic.searchByName='Test';
                daic.myApprovalList();
                daic.nullifySearch();
                
                daic.dateFrom=date.today()-2;
                daic.dateTo=date.today()+3;
                daic.searchByName='Test';
                daic.myApprovalList();
                daic.nullifySearch();
                
                
                
                daic.dateFrom=date.today()-2;
                daic.dateTo=date.today()+3;
                daic.myApprovalList();
                
                daic.searchByName='test';
                daic.dateFrom=date.today()-2;
                daic.dateTo=date.today()+3;
                daic.myApprovalList();
                daic.nullifySearch();
                 
                daic.dateFrom=date.today()-2;
                daic.myApprovalList();
                daic.nullifySearch();
                
                daic.dateTo=date.today()+2;
                daic.myApprovalList();
                daic.nullifySearch();
            }
            
            
        Test.StopTest();
    }
}