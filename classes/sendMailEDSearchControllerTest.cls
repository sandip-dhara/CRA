@isTest
public with sharing class sendMailEDSearchControllerTest {
    public static testmethod void testsendMailEDSearchController(){
        
        Test.startTest();
        
        Folder f = [SELECT ID,NAME FROM Folder WHERE NAME = 'Apttus Temporary Email Templates' LIMIT 1]; // we cant perform DML on Folder, need to fetch only
        BrandTemplate bt = [SELECT ID,NAME FROM BrandTemplate WHERE isActive = TRUE LIMIT 1];
        ID rtID = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeID();
        
        Apttus__APTS_Agreement__c agmt = new Apttus__APTS_Agreement__c();
        agmt.NAME = 'Testing Apttus';
        agmt.RecordTypeID = rtID;
        insert agmt;
        
        Attachment atmt = new Attachment();
        atmt.NAME = 'Testing Apttus';
        atmt.BODY = BLOB.valueOf('pString');
        atmt.ParentID = agmt.ID;
        insert atmt;
        Test.stopTest();
        /* DML Not Allowed on BrandTemplate
        BrandTemplate bt = new BrandTemplate();
        bt.isActive = TRUE;
        bt.Name = 'Apttus Brand Template';
        bt.Value = '<br>Welcome to Apttus</br>';
        insert bt;
        */
        User mike = new User();
        mike.Username= 'mike@hp.com';
        mike.Email = 'mike@hp.com';
        mike.Lastname = 'mike';
        mike.Firstname = 'Apttus';
        mike.Alias = 'mApttus';
        mike.CommunityNickname = 'Don';
        mike.ProfileID = UserInfo.getProfileID();
        mike.CurrencyIsoCode = 'USD';
        mike.TimeZoneSidKey = 'GMT';
        mike.LocaleSidKey = 'en_US';
        mike.EmailEncodingKey = 'ISO-8859-1';
        mike.LanguageLocaleKey = 'en_US';
        mike.UserPermissionsMobileUser = false;
        mike.Email_Address__c = 'avaru@apttus.com';
        mike.EmployeeNumber = '5252552';
        mike.Legacy_Employee_Ref__c = '52525523';
        mike.Adoption_Role_Type__c = 'IT';
        
        System.runAs(mike){
            
        EmailTemplate et = new EmailTemplate();
        et.Body = 'Testing Apttus Email Template';
        et.BrandTemplateId = bt.ID;
        et.TemplateType = 'text';
        et.DeveloperName = 'My_Apttus_Template';
        et.isActive = TRUE;
        et.NAME = 'Apttus Email Template';
        et.Subject = 'Welcome to Apttus';
        et.FolderId = f.ID;
        insert et;
        
        
        
        ApexPages.standardController sc = new ApexPages.standardController(agmt);
        
        PageReference pr = Page.SendMail;
        Test.setCurrentPage(pr);
        System.currentPageReference().getParameters().put('id',agmt.ID);
        System.currentPageReference().getParameters().put('action','Submit_For_Review_HP');
        System.currentPageReference().getParameters().put('P4','avaru@apttus.com');
        System.currentPageReference().getParameters().put('P5','avaru@apttus.com');
        System.currentPageReference().getParameters().put('P24','avaru@apttus.com');
        System.currentPageReference().getParameters().put('doc_id',atmt.ID);
        System.currentPageReference().getParameters().put('selET',f.ID);
        sendMailEDSearchController smsc = new sendMailEDSearchController(sc);
        PageReference pref = smsc.doCancel();
        System.assertEquals(pref.getUrl(), '/'+agmt.ID);
        
        smsc.doSearchED();
        System.assertEquals(smsc.getAdditionalTO(),'avaru@apttus.com');
        System.assertEquals(smsc.getCC(),'avaru@apttus.com');
        System.assertEquals(smsc.getBCC(),'avaru@apttus.com');
        smsc.getAttachment();
        
        List<ID> idList = new List<ID>();
        idList.add(UserInfo.getUserID());
        smsc.selectedEmailTemplateFolder = f.ID; 
        smsc.attachedIds = idList;
        smsc.getattachIds();
        smsc.doNext();
        smsc.getAllAttachments();
        smsc.addAttachments();
        smsc.getEmailTemplateFolderOpts();
        smsc.getEmailTemplateOpts();
        smsc.refreshEmailTemplateSection();
        smsc.doValidateEmailTemplateSelection();
        
        
        System.currentPageReference().getParameters().put('action','Send_To_Other_Party_For_Review');
        smsc.doNext();
        }
    }
}