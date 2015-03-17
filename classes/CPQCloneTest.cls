/***********************************************************
* Class Name: CPQCloneTest
* Author: HP
* Date: 21-OCT-2012 
* Requirement # Request Id: 
* Description: This class does the test coverage for Whole CPQ Functionality
***********************************************************/

@isTest(SeeAllData=true)
private class CPQCloneTest{
    //Test Method 
    public static testMethod void CPQCloneFunctionalityTest() {
        Test.startTest();
         List<HPQuoteController.QuoteWrapperClass> quoteWrapper = new  List<HPQuoteController.QuoteWrapperClass>();
          User objUser = [select Business_Group__c,Country,Region__c from user where id=:userinfo.getuserid()];
            objUser.Business_Group__c = 'ESSN';
            objUser.Region__c = 'EMEA';
            objUser.Country = 'Germany';
            update objUser;
            
            Account objAccount = TestingSetupDataUtil.createAccount('Test Partner Account1', 'partner1211@partnercollab.com','Customer');
            objAccount.ShippingStreet = 'Test Street';
            objAccount.ShippingState = 'Test State';
            objAccount.ShippingCity = 'Test City';
            objAccount.ShippingCountry = 'Test Country';
            objAccount.ShippingPostalCode = 'Test Postal';
            insert objAccount;
            
            Opportunity objOpportunity = TestingSetupDataUtil.createOpportunity(objAccount.Id, 'test Oppty',system.today()+30);
            objOpportunity.Route_To_Market__c = 'Direct';
            objOpportunity.CurrencyIsoCode = 'USD';
            insert objOpportunity;
            
            List<Support_Request__c> oSupportRequestList= new List<Support_Request__c>();
            //create a test Support Request
            Support_Request__c objSupportRequest = new Support_Request__c();
            Map<String,Support_Request_FS_CS__c> sRequestFieldSetCSMap = Support_Request_FS_CS__c.getAll();
            Support_Request_FS_CS__c csRecord = sRequestFieldSetCSMap.get('Quote-to-Order-ESSN-CPQ');
            Id recordTypeId = null;
            if(csRecord!=null){
                recordTypeId = SupportRequestRoutingRulesTriggerUtil.getRecordTypeIDByName(csRecord.RecordType_Name__c);
            }
            objSupportRequest = TestingSetupDataUtil.createSupportRequest(objOpportunity.id,'Request description');
            if(recordTypeId !=null){
                objSupportRequest.recordTypeId = recordTypeId;
                objSupportRequest.Request_Submitted_From__c = csRecord.View_VF_Page_Name__c;
            }
            oSupportRequestList.add(objSupportRequest) ;   
            //insert objSupportRequest;
            
            Support_Request__c objDeleteSupportRequest = new Support_Request__c();
            objDeleteSupportRequest = TestingSetupDataUtil.createSupportRequest(objOpportunity.id,'Request description');
            if(recordTypeId !=null){
                objDeleteSupportRequest.recordTypeId = recordTypeId;
                objDeleteSupportRequest.Request_Submitted_From__c = csRecord.View_VF_Page_Name__c;
            }
            oSupportRequestList.add(objDeleteSupportRequest) ;       
            insert oSupportRequestList;
            
           List<HP_Quote__c> oQuoteList= new List<HP_Quote__c>();
            
            //Create HP Quote
            HP_Quote__c objQuote = new HP_Quote__c(Quote_IDS_ID__c ='TestClass' ,Synced_To_Opportunity__c = true,Opportunity_Name__c = objOpportunity.Id,Name='testQuote',Support_Request__c=objSupportRequest.id,Hide_Record__c = false);
            oQuoteList.add(objQuote);
            
            HP_Quote__c objQuote1 = new HP_Quote__c(Quote_IDS_ID__c ='TestClass' ,Synced_To_Opportunity__c = true,Opportunity_Name__c = objOpportunity.Id,Name='testQuote',Support_Request__c=objSupportRequest.id,Hide_Record__c = false);
            oQuoteList.add(objQuote1);
            insert oQuoteList;
            
            /* //Add Attachement to support Request
            Attachment attach=new Attachment();     
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=objSupportRequest.id;
            insert attach;*/
            
            //Request Revision
            String cloneResult = CPQCloneRequest.CPQCloneRequestForRevision(String.valueof(objSupportRequest.id),String.valueof(objQuote.Id),'Special Pricing');
            
            String deleteRequest = CPQCloneRequest.CPQDeleteSupportRequest(String.valueof(objDeleteSupportRequest.id));
            String clonePositiveResult = CPQCloneRequest.CPQCloneRequestForRevision(String.valueof(objSupportRequest.id),String.valueof(objQuote.Id),'');
            String cloneResult1 = CPQCloneRequest.CPQCloneRequestForRevision(String.valueof(objSupportRequest.id),String.valueof(objQuote.Id),'Pricing Escalation');
                        
            User objUser1 = TestingSetupDataUtil.createUser('int1Te','interna1l1@hp.com','int_12311@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','internalpat1@intUser.com','55248616',userInfo.getProfileId());
            objUser1.Business_Group__c = 'ESSN';
            objUser1.Region__c = 'EMEA';
            insert objUser1;
            system.runAs(objUser1){
                Support_Request__c objCPQCloneRequest = new Support_Request__c();
                objCPQCloneRequest = TestingSetupDataUtil.createSupportRequest(objOpportunity.id,'Request description');
                if(recordTypeId !=null){
                objCPQCloneRequest.recordTypeId = recordTypeId;
                objCPQCloneRequest.Request_Submitted_From__c = csRecord.View_VF_Page_Name__c;
                }
                insert objCPQCloneRequest;
              /*  String cloneNegtiveResult = CPQCloneRequest.CPQCloneRequestForRevision(String.valueof(objCPQCloneRequest.id),String.valueof(objQuote.Id),'Revision');
                objUser1.Business_Group__c = 'ES';
                objUser1.Region__c = 'EMEA';
                update objUser1;
                String cloneNegtiveResult1 = CPQCloneRequest.CPQCloneRequestForRevision(String.valueof(objCPQCloneRequest.id),String.valueof(objQuote.Id),'Revision');                
                */
            }
    }
}