/**********************************************************
* Class Name: CaseTriggerUtilTest2
* Author: HP CO Team
* Date: 29-May-2012 
* Description: This class is used as Test Class for the  Before Insert and Update Triggers.  
***********************************************************/

@isTest(seeAllData = true)
public class CaseTriggerUtilTest2 {
    static Account account;
    static Case caseObj;
    static String errorMessage;
    static User usr;
    static TurnValidationOff__c testsetting;
    
    /**
    * @description Prepare data & execute positive test for Controller Class
    *
    * @return Void
    */
    private static void setupData(){
                
        String randomstr = Math.round(Math.random()*Math.pow(10, 7))+'';
        usr = new User();
        usr = TestingSetupDataUtil.createUser('st'+randomstr.substring(0,4), randomstr+'standarduser@hp.com', randomstr+'standarduser@hp.com', 
                                                'UTF-8', 'U LastName', 'en_US', 'en_US', 'America/Los_Angeles', randomstr+'standarduser12@hp.com', 
                                                randomstr+'5', Userinfo.getProfileId());                                 
        insert usr;
        System.assertEquals('U LastName',usr.lastName);
         
        
        //Create test data for case obj 
        caseObj = new Case();
        caseObj = TestingSetupDataUtil.createCase('Other', 'Salesforce', 'New',  Userinfo.getUserId());
        
        insert caseObj;
     
        System.assertEquals('Other',caseObj.Reason);

    }

    static testMethod void testCasebeforeUpdate() {
    setUpData();
        usr.Business_Group__c = 'TS';
        update usr;
        
        String cocaseId = RecordTypeIdHelper.getRecordTypeId('Case','CO Case');
        Id CSIFRecordTypeId=null;
        CSIFRecordTypeId = RecordTypeIdHelper.getRecordTypeId ('support_request__c','Quote-to-Order-CSIF');
        

        CSIFRecordTypeId=null;
        CSIFRecordTypeId = RecordTypeIdHelper.getRecordTypeId ('support_request__c','Quote-to-Order-CSIF');
        
        Account a =  new Account(Name='Demo Account');
          {
          a.ShippingCountry = 'India';  
          a.Regions__c = 'Asia Pacific';
          }
          Insert a;
          
          //Creating Test Opportunity 
          opportunity opp = TestingSetupDataUtil.createOpportunity(a.Id,'Opty99ZZ_952PM',System.Today()+30);  
          Insert opp;
          
          //creating CSIF Support Request  
          support_Request__c CSIF_SR= new support_request__c(RecordTypeId = CSIFRecordTypeId, Support_Type__c ='Quote-to-Order', Opportunity__c=opp.Id,Sub_Type__c ='CSIF');
          Insert CSIF_SR;
        
        List<Case> caseList = new List<Case>();
        
         Case caseObj2 = new Case();
        caseObj2 = TestingSetupDataUtil.createCase('Other', 'Salesforce', 'New', Userinfo.getUserId());
        caseObj2.Request_Type__c = 'Renewal Amendment';
        caseObj2.Program_Type__c = 'CAP';
        caseObj2.Region__c = 'APJ';
        caseObj2.Country__c = 'Japan';
        caseObj2.RecordTypeId = Id.valueof(cocaseId);
        caseObj2.Status = 'New';
        caseObj2.Close_Case_Reason__c = 'Completed';
        //caseObj2.BG__c = 'PPS';
        caseObj2.Business_Type__c = 'Custom';
        caseObj2.Requestor_s_TimeZone__c = '(GMT+10:00) Australian Eastern Standard Time (Australia/Brisbane)';
        caseObj2.Support_Request_ID__c = CSIF_SR.Id;
        caseObj2.ParentId = caseObj.Id;
        caseObj2.Sub_Case_Type__c = 'Customer Name';
        caseObj2.Case_Classification__c = 'Small'; 
        caseList.add(caseObj2);
        
        Case caseObj3 = new Case();
        caseObj3 = TestingSetupDataUtil.createCase('Other', 'Salesforce', 'New',  Userinfo.getUserId());
        caseObj3.Request_Type__c = 'Renewal Amendment';
        caseObj3.Region__c = 'APJ';
        caseObj3.Country__c = 'Japan';
        caseObj3.RecordTypeId = Id.valueof(cocaseId);
        caseObj3.Status = 'New';
        caseObj3.Close_Case_Reason__c = 'Completed';
        //caseObj3.BG__c = 'TS';
        caseObj3.Business_Type__c = 'Custom';
        caseObj3.Requestor_s_TimeZone__c = '(GMT+10:00) Australian Eastern Standard Time (Australia/Brisbane)';
        //caseObj3.ParentId = caseObj.Id;
        //caseObj3.Sub_Case_Type__c = 'Customer Name';
        //caseObj3.Case_Classification__c = 'Small';
        caseList.add(caseObj3);
        
        Case caseObj4 = new Case();
        caseObj4 = TestingSetupDataUtil.createCase('Other', 'Salesforce', 'New',  Userinfo.getUserId());
        caseObj4.Request_Type__c = 'New Business Quote';
        caseObj4.Region__c = 'APJ';
        caseObj4.Country__c = 'Japan';
        caseObj4.RecordTypeId = Id.valueof(cocaseId);
        caseObj4.Status = 'New';
        caseObj4.Close_Case_Reason__c = 'Completed';
        //caseObj4.BG__c = 'TS';
        caseObj4.Business_Type__c = 'Custom';
        caseObj4.Requestor_s_TimeZone__c = '(GMT+10:00) Australian Eastern Standard Time (Australia/Brisbane)';
        caseList.add(caseObj4);
        
        /** bala added code */
        
        Case caseObj5 = new Case();
        caseObj5 = TestingSetupDataUtil.createCase('Other', 'Salesforce', 'New', Userinfo.getUserId());
        caseObj5.Request_Type__c = 'Contract Amendment';
        caseObj5.Region__c = 'APJ';
        caseObj5.Country__c = 'Japan';
        caseObj5.RecordTypeId = Id.valueof(cocaseId);
        caseObj5.Requestor_s_TimeZone__c = '(GMT+10:00) Australian Eastern Standard Time (Australia/Brisbane)';
        caseObj5.BG__c = 'TS';
        caseObj5.Business_Type__c = 'Custom';
        caseObj5.Work_Location__c = 'In country';
        caseObj5.Subject = 'Test contract amndmnt milestone';
        caseObj5.Route_to_Market__c = 'Direct';
        caseObj5.Origin ='Salesforce';
     
        insert caseObj5;
        
       
         
         Case caseObj6 = new Case();
        caseObj6 = TestingSetupDataUtil.createCase('Other', 'Salesforce', 'New', Userinfo.getUserId());
        caseObj6.Request_Type__c = 'Contract Amendment';
        caseObj6.Region__c = 'APJ';
        caseObj6.Country__c = 'Japan';
        caseObj6.RecordTypeId = Id.valueof(cocaseId);
        caseObj6.Status = 'New';
        caseObj6.Requestor_s_TimeZone__c = '(GMT+10:00) Australian Eastern Standard Time (Australia/Brisbane)';
        caseObj6.BG__c = 'TS';
        caseObj6.Sub_Case_Type__c = 'Quality Check';
        caseObj6.Business_Type__c = 'Custom';
        caseObj6.ParentId = caseObj5.Id;
        caseObj6.Case_Classification__c = 'Small';
        
        Insert caseObj6;
        
        Case caseObj7 = new Case();
        caseObj7 = TestingSetupDataUtil.createCase('Other', 'Salesforce', 'New', Userinfo.getUserId());
        caseObj7.Request_Type__c = 'Contract Amendment';
        caseObj7.Region__c = 'APJ';
        caseObj7.Country__c = 'Japan';
        caseObj7.RecordTypeId = Id.valueof(cocaseId);
        caseObj7.Status = 'New';
        caseObj7.Requestor_s_TimeZone__c = '(GMT+10:00) Australian Eastern Standard Time (Australia/Brisbane)';
        caseObj7.BG__c = 'TS';
        caseObj7.Sub_Case_Type__c = 'Quality Check';
        caseObj7.Business_Type__c = 'Custom';
        caseObj7.ParentId = caseObj5.Id;
        caseObj7.Case_Classification__c = 'Small';
        caseObj7.Rework_to__c = caseObj6.Id;
        
        Insert caseObj7;
        
        /** Bala code end */
        
        Test.startTest();
        
        insert caseList;
        
        HPUtils.CaseAfterInsert = false;
        //caseObj2.Status = 'Closed';
        CaseTriggerUtil.insertCaseFlag = false;
        update caseObj2;
        system.debug ('case object6 parent caseId ---->'+caseObj6.ParentId);
        List<CaseMilestone> Parentcm = [Select MilestoneTypeId, MilestoneType.Name, IsCompleted,CompletionDate From CaseMilestone where caseId=:caseObj6.ParentId];
        List<CaseMilestone> cm = [Select MilestoneTypeId, MilestoneType.Name, IsCompleted From CaseMilestone where caseId in :caseList limit 50000];
        for(CaseMilestone c : cm)
            c.CompletionDate = DateTime.now();
        update cm;
        System.debug('????????InTest Class '+caseObj.Id);
        caseObj2.Status = 'Closed';
        update caseObj2;
        caseObj.Status = 'Closed';
        caseObj.Resolution_Details__c ='Test';
        update caseObj;
        
        caseObj7.Status = 'Closed';
        caseObj7.Close_Case_Reason__c = 'Rejected';
        caseObj7.Support_Request_ID__c = CSIF_SR.Id;
        update caseObj7;
        
        
        caseObj6.Status = 'Closed';
        caseObj6.Close_Case_Reason__c = 'Rejected';
        
        update caseObj6;
        
       /* caseObj2.Close_Case_Reason__c ='Cancelled';
        update caseObj2;*/
        
       /* caseObj7.Status = 'Closed';
        caseObj7.Close_Case_Reason__c = 'Completed';
        update caseObj7;*/
        
        
        
        Test.stopTest();
        
    
    }
    
    
    //CO Case Functionality:Debmalya:R5:28th May, 2013:Insert subCase:End
     
 }