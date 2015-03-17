@isTest(seeAllData=true)
public class WorkspaceTriggersTest{
public static Approval__c approval1;
 public static opportunity newOpp;
public static Id rcdType1;
public static User user1;
public static User user2;
public static User user3;
public static Reviewer_Workspace__c workspc;
public static WS_Approver__c wsApp;

public static void setupData(){
 /*Insert Account and Opportunity*/
    world_region__c wr=[select ID from world_region__C where Country_Name__c='United States'];
   Account newAcc=TestingSetupDataUtil.createAccount('ApprovalTestAccount','ApprovalWorkspace@hp.com','Customer');
   newAcc.World_Region1__c=wr.id;
   insert newAcc;
   
    user1 = new User();
     user1 = TestingSetupDataUtil.createUser('Appwo1','ApprovalWorkspace1@hp.com','ApprovalWorkspace12@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','ApprovalworkspaceTest1@hp.com','87654321',Userinfo.getProfileId());
     user1.Business_Group__c='SW';
     user1.Adoption_Role_Type__c='Account Executive';
     user1.Approver_Type__c='Coordinator';
     insert user1;
     
     user2 = new User();
     user2 = TestingSetupDataUtil.createUser('Appwo2','ApprovalWorkspace2@hp.com','ApprovalWorkspace2@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','ApprovalworkspaceTest2@hp.com','87654322',Userinfo.getProfileId());
     user2.Business_Group__c='SW';
     user2.Adoption_Role_Type__c='Account Executive';
     user2.Approver_Type__c='Approver';
     insert user2;
     
      user3 = new User();
     user3 = TestingSetupDataUtil.createUser('Appwo3','ApprovalWorkspace3@hp.com','ApprovalWorkspace3@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','ApprovalworkspaceTest3@hp.com','87654323',Userinfo.getProfileId());
     user3.Business_Group__c='SW';
     user3.Adoption_Role_Type__c='Account Executive';
     user3.Approver_Type__c='Coordinator';
     insert user3;
   
   newOpp = new Opportunity();
   newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'OpptyApprovalfuncTest1', system.today()+ 30);
   newOpp.owner__c=user1.id; 
   newOpp.stageName=  '01 - Understand Customer';
   insert newOpp; 
   
 /* inserting approval */
    Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
    Schema.SObjectType s = m.get('Approval__c') ;
    Schema.DescribeSObjectResult cfrSchema = s.getDescribe() ;
    Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
    List<Approval__c> listApproval = new List<Approval__c>();

    rcdType1= RecordTypeInfo.get('Opportunity Review').getRecordTypeId();
    approval1=new Approval__c();
    approval1.opportunity__c=newOpp.id;
    approval1.RecordTypeID=rcdType1;
    approval1.status__c='Open';
    listApproval.add(approval1);
    
    insert approval1;
    
    }
    
    
    public Static testMethod void routingtest(){
    
    Reviewer_Workspace__c workspc1;
    Test.startTest();
        setupData();
   System.Runas(user1) {  
  try{   
   workspc=new Reviewer_Workspace__c (Approval__c=approval1.id,Approval_Level__c='Level 1',Status__c='Open');
   insert workspc;
  
   }
   catch(Exception e)
   {
    Boolean expectedExceptionThrown =  e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false;
    System.AssertEquals(expectedExceptionThrown, true);
    }
    }
     
   System.Runas(user1){
  //Create Approver 
   wsApp=new WS_Approver__c();
   wsApp.Reviewer_Workspace__c=workspc.id;
   wsApp.Approver__c=user2.id;
   insert wsApp;
   
   wsApp.Approval_Status__c='Approved';
   update wsApp;
   delete wsApp;
   
   //Create Reviewer
   Reviewer__c wsrevw = new Reviewer__c();
   wsrevw.Reviewer_Workspace__c = workspc.id;
   wsrevw.Reviewer__c=user2.id;
   insert wsrevw;
   
   wsrevw.Signoff_Feedback__c='High';
   update wsrevw;
   delete wsrevw;
   
   //Finally delete workspace
    delete workspc;
   }
   Test.stopTest();
    
    }




}