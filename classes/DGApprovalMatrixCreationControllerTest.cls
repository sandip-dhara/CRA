/*******************************
Author: Abrar
Date : 21/05/2013
Desc : Test Class for DGApprovalMatrixCreationController
********************************/
@isTest
public class DGApprovalMatrixCreationControllerTest {
private static Profile SRProfile = [select Name, Id from Profile where Name ='IT Administrator']; 
  public Static User SRuseroptyowner;
  public Static User SRuserRunAsowner;
  public static Group g;
  public static QueueSObject q;
  public static Approval_Matrix__c AM = new Approval_Matrix__c();
  public static Approval_Matrix__c AM2 = new Approval_Matrix__c();
  public static Approval_Matrix_Element__c AME= new Approval_Matrix_Element__c();
  

  public static void Queuecreation(){
  g = new Group(Type='Queue', Name='TEST DG ES SOAR Coordinator');
  insert g;

  q = new QueueSObject(SobjectType='Approval__c', QueueId=g.Id);
  insert q; 
  }
//Test Data Creation
 public static Approval_Matrix__c TestDataCreation(){
  
  SRuseroptyowner = new User(Lastname = 'TestDGoptyowner', Approver_Role__c = 'Approver', Firstname= 'BG', Username = 'DGtestingoptyowner0128@hp.com', Alias='TesBG', CommunityNickname='TestDGUseroptyowner', Email='test0128@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='testingoptyowner0128@hp.com',EmployeeNumber='.',Legacy_Employee_Ref__c='65348261', ProfileId = SRProfile.id,Business_Group__c = 'ES', Region__c = 'AMS');
  SRuseroptyowner.Adoption_Role_Type__c='Account Executive';
  Insert SRuseroptyowner;
  
  AM.Approval_Matrix_Name__c= 'Test Matrix';  
  AM.Approver_Level_1__c = 'Approver Role';
  AM.Approver_Level_Type_1__c = 'TestDGoptyownerBG';
  AM.Owner_BG__c = 'EG';
  AM.Active__c = True;
  AM.Approver_Level_2__c = 'Job Function';
  AM.Approver_Level_Type_2__c = 'TEST DG ES SOAR Coordinator';
  return AM;
  }
  
  public static Approval_Matrix_Element__c TestChildDataCreation(){
   AME.Object__c = 'Opportunity';
   AME.Field_Name__c = 'Sales Stage';
   AME.Match_Type__c = 'Equals';
   return AME;
  }
  
    public static testMethod void positiveTest()
      {
       SRuserRunAsowner = new User(Lastname = 'TestDGRunAsowner', Approver_Role__c = 'Approver', Firstname= 'BG', Username = 'DGtestingRunasOwner@hp.com', Alias='TesBG', CommunityNickname='TestDGUserRunAsowner', Email='test0128@hp.com',TimeZoneSidKey='America/Chicago',EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US', LocaleSidKey='en_US',IsActive=True,Email_Address__c='testingRunAs0128@hp.com',EmployeeNumber='.',Legacy_Employee_Ref__c='65148261', ProfileId = SRProfile.id,Business_Group__c = 'ES', Region__c = 'AMS');
       SRuserRunAsowner.Adoption_Role_Type__c='Account Executive'; 
       insert SRuserRunAsowner;
       Test.startTest();
       System.RunAs(SRuserRunAsowner){
       TestDataCreation();
       Queuecreation();      
       ApexPages.StandardController stdController= new ApexPages.StandardController(AM);
       DGApprovalMatrixCreationController DGAppMatrix = new DGApprovalMatrixCreationController(stdController);
       
       PageReference pageRefAMLP = Page.DGApproverMatrixUserQueueLookup;
        Test.setCurrentPage(pageRefAMLP);
        ApexPages.currentPage().getParameters().put('ApproverType', AM.Approver_Level_1__c);
        string strtype = AM.Approver_Level_1__c;
        string strfieldId = AM.Approver_Level_Type_1__c;
        ApexPages.currentPage().getParameters().put('ApproverFieldId', AM.Approver_Level_Type_1__c);
        DGApprovalMatrixUserlookup DGAMLP = new DGApprovalMatrixUserlookup();
        DGAMLP.getUserList();
        DGAMLP.getQueueList();
        DGAMLP.getJobFunctionList();
       DGAppMatrix.Save();
       insert AM;
       
       
       TestChildDataCreation();
       AME.Approval_Matrix__c = AM.Id;
       ApexPages.StandardController stdControllerAME= new ApexPages.StandardController(AME);
       DGApprovalMatrixElement DGAppMatrixEle = new DGApprovalMatrixElement(stdControllerAME);
       insert AME;
       
       PageReference pageRefAME = Page.DGApprovalMatrixElementCreation;
        Test.setCurrentPage(pageRefAME);
        ApexPages.currentPage().getParameters().put('Id', AME.id);
        ApexPages.StandardController stdControllerAME2= new ApexPages.StandardController(AME);
       DGApprovalMatrixElement DGAppMatrixEle2 = new DGApprovalMatrixElement(stdControllerAME2);
       update AME;
       
        //Code when Matrix record is Edited
        PageReference pageRef = Page.DGApprovalMatrixElementCreation;
        Test.setCurrentPage(pageRef);
       // system.currentPageReference().getParameters().put('Id','/apex/DGApprovalMatrixCreation?id='+AM.id);
       ApexPages.currentPage().getParameters().put('Id', AM.id);
       system.debug('!@@@'+AM.id);
       ApexPages.StandardController stdController2= new ApexPages.StandardController(AM);
       DGApprovalMatrixCreationController DGAppMatrix2 = new DGApprovalMatrixCreationController(stdController2);
       DGAppMatrix2.Save();
       
          AM2.Approval_Matrix_Name__c = 'Test Matrix';  
          AM2.Approver_Level_1__c = 'Approver Role';
          AM2.Approver_Level_Type_1__c = 'TestDGoptyownerBG';
          AM2.Owner_BG__c = 'EG';
          AM2.Active__c = True;
          AM2.Approver_Level_1__c = 'Job Function';
          AM2.Approver_Level_Type_1__c = 'TEST DG ES SOAR Coordinator';
          ApexPages.StandardController stdController3= new ApexPages.StandardController(AM2);
          DGApprovalMatrixCreationController DGAppMatrix3 = new DGApprovalMatrixCreationController(stdController3);
          DGAppMatrix3.Save();
       }
        Test.stopTest();
       }  
 }