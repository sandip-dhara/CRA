/*
Author : Praveen Kumar Reddy
Release : R6
Date : 18-08-2013

*/
@isTest(SeeAllData=true)
private class DGWorkSpaceDetailPageControllerTest{
        public static Reviewer_Workspace__c workspace;
        public static List<Attachment> attachmentList;
        public static Approval__c approval;
        public static List<AttachmentExtension__c > atextList;
        public static void setupData(){
            //world_region__c wr=[select ID from world_region__C where Country_Name__c='United States'];
            /*Insert Account and Opportunity*/
            Account newAcc=TestingSetupDataUtil.createAccount('ApprovalFlowTest','test_22@hp.com','Customer');
            //newAcc.World_Region1__c=wr.id;
            insert newAcc;
            User testUser= new User();
            testUser= TestingSetupDataUtil.createUser('stAppr1','abc1@hp.com','emailap1@hp.com','UTF-8','Tertlan','en_US','en_US','America/Los_Angeles','saeestap1@hp.com','87654381',Userinfo.getProfileId());
            testUser.Approver_Type__c='Coordinator';
            insert testUser;
            opportunity newOpp=TestingSetupDataUtil.createOpportunity(newAcc.Id, 'testOpptyForApprovalFlow', system.today()+ 30);
            //newOpp.owner__c=usersList[0].id; 
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
            
            workspace=new Reviewer_Workspace__c ();
            workspace.Approval__c=approval.id;
            workspace.Approval_Level__c='1';
            workspace.Status__c='Open';
            system.runAs(testUser){
                insert workspace;
            }
            attachmentList=new List<Attachment>();
            Attachment att=new Attachment(parentId =workspace.id,description='descriptiontrest1',body=blob.valueOf('Test'),name='Test');
            Attachment att1=new Attachment(parentId =workspace.id,description='descriptiontrest2',body=blob.valueOf('Test'),name='Test1');
            Attachment att2=new Attachment(parentId =workspace.id,description='descriptiontrest3',body=blob.valueOf('Test'),name='Test2');
            attachmentList.add(att);
            attachmentList.add(att1);
            attachmentList.add(att2);
            insert attachmentList;
            
            atextList=new List<AttachmentExtension__c >();
            AttachmentExtension__c ate1=new AttachmentExtension__c();
            ate1.version_number__c = 1;
            ate1.AttachmentReference__c = attachmentList[0].id;
            atextList.add(ate1);    
            AttachmentExtension__c ate2=new AttachmentExtension__c();
            ate2.version_number__c = 1;
            ate2.AttachmentReference__c = attachmentList[1].id;
            atextList.add(ate2); 
            AttachmentExtension__c ate3=new AttachmentExtension__c();
            ate3.version_number__c = 1;
            ate3.AttachmentReference__c = attachmentList[2].id;
            atextList.add(ate3); 
            insert atextList;
               
        }
    
        public Static  testmethod void testworkspace(){
            Test.StartTest();
            setupData();
            PageReference pgAttupload=Page.UploadAttachment;
            ApexPages.currentPage().getParameters().put('Approvalid',approval.id);
            ApexPages.currentPage().getParameters().put('Page','DGApprovalBusinessReviewDetail');
            ApexPages.currentPage().getParameters().put('context','Approval');
            AttachmentController  attcon=new AttachmentController ();
            attCon.allFileList[0].description='version1';
            attCon.allFileList[0].body=blob.valueOf('Test'); 
            attCon.allFileList[0].name='Test';
            attCon.allFileList[0].parentID=approval.id;
            attCon.SaveAttachments();
            attCon.Cancel();
            PageReference pgAttEdit=Page.AttachmentEdit;
            Test.setCurrentPage(pgAttEdit);
            ApexPages.CurrentPage().getParameters().put('Approvalid',workspace.id);
            ApexPages.CurrentPage().getParameters().put('Page','DGWorkSpaceDetailPage');
            ApexPages.CurrentPage().getParameters().put('AttachmentId',attachmentList[0].id);
            ApexPages.CurrentPage().getParameters().put('filename','Test');
            UpdateAttachmentController updateAtt=new UpdateAttachmentController();
            updateAtt.UpdateAttachment(); 
            updateAtt.AttWrapper.AttachmentRecordUI.name='Test'; 
            updateAtt.AttWrapper.AttachmentRecordUI.description='Version 2';
            updateAtt.AttWrapper.AttachmentRecordUI.body=blob.valueOf('Test');            
            updateAtt.UpdateAttachment();   
            updateAtt.AttWrapper.AttachmentRecordUI.name='Test1'; 
            updateAtt.UpdateAttachment();  
            updateAtt.Cancel();  
            PageReference pgAttVer=Page.DGAttachmentVersionHistoryPage;
            Test.setCurrentPage(pgAttVer);
            ApexPages.CurrentPage().getParameters().put('ApprovalWorkspaceID',workspace.id);
            ApexPages.CurrentPage().getParameters().put('Page','DGWorkSpaceDetailPage');
            ApexPages.CurrentPage().getParameters().put('filename','Test');
            DGAttachmentVersionHistoryPageController  attVer=new DGAttachmentVersionHistoryPageController ();
            attVer.getAttachments();
            attVer.gotoPreviousPage();
            PageReference pageWorkSpaceDetail=Page.DGWorkSpaceDetailPage;
            ApexPages.CurrentPage().getParameters().put('id',workspace.id);  
            ApexPages.StandardController  sc=new ApexPages.StandardController (workspace);
            DGWorkSpaceDetailPageController DGworksSpace=new DGWorkSpaceDetailPageController (sc);
            DGworksSpace.getAttachments();
            DGworksSpace.DeleteAttachment();
            DGworksSpace.LockAttachment();
            DGworksSpace.customAttachmentEdit();
            DGworksSpace.attId =attachmentList[0].id;
            DGworksSpace.LockAttachment();
            DGworksSpace.attId =attachmentList[0].id;
            DGworksSpace.DeleteAttachment();
            Test.StopTest();
        }

}