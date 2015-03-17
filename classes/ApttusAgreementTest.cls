@isTest(SeeAllData = True)
public with sharing class ApttusAgreementTest {
    public static testmethod void testApttusAgreement(){
        
        
        ID currentUserID = UserInfo.getUserID();
        ID rtID = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Bailment').getRecordTypeID();
        ID profileID = UserInfo.getProfileId();
        
        List<Global_Config__c> gc = [SELECT ID,Mute_Triggers__c FROM Global_Config__c];
        List<Global_Config__c> gcUpdate = new List<Global_Config__c>();
        for(Global_Config__c g : gc){
            g.Mute_Triggers__c = TRUE;
            gcUpdate.add(g);
        }
        update gcUpdate;
        
        User mike = new User();
        mike.Username= 'mike@hp.com';
        mike.Email = 'mike@hp.com';
        mike.Lastname = 'mike';
        mike.Firstname = 'Apttus';
        mike.Alias = 'mApttus';
        mike.CommunityNickname = 'Don';
        mike.ProfileID = profileID;
        mike.CurrencyIsoCode = 'USD';
        mike.TimeZoneSidKey = 'GMT';
        mike.LocaleSidKey = 'en_US';
        mike.EmailEncodingKey = 'ISO-8859-1';
        mike.LanguageLocaleKey = 'en_US';
        mike.UserPermissionsMobileUser = false;
        mike.Email_Address__c = 'avaru@hp.com';
        mike.EmployeeNumber = '5252552';
        mike.Legacy_Employee_Ref__c = '52525523';
        mike.Adoption_Role_Type__c= 'IT';

        
        //insert mike;
        
        System.runAs(mike){
            
            Group g = new Group();
            g.Name = 'Apttus India Queue';
            g.Type = 'Queue';
            insert g;
        
            GroupMember gm1 = new GroupMember();
            gm1.GroupId = g.ID;
            gm1.UserOrGroupId = currentUserID;
            insert gm1;
            
            GroupMember gm2 = new GroupMember();
            gm2.GroupId = g.ID;
            gm2.UserOrGroupId = UserInfo.getUserID();
            insert gm2;
        }
        
        
        
        Apttus__APTS_Agreement__c agmt1 = new Apttus__APTS_Agreement__c();
        Apttus__APTS_Agreement__c agmt2 = new Apttus__APTS_Agreement__c();
        
        agmt1.NAME = 'Testing Apttus1';
        if(rtID != null){
            agmt1.RecordTypeID = rtID;
            agmt2.RecordTypeID = rtID;
        }
        insert agmt1;
        
        agmt2.NAME = 'Testing Apttus2';
        insert agmt2;
        
        List<Apttus__APTS_Agreement__c> setAgmt = new List<Apttus__APTS_Agreement__c>();
        setAgmt.add(agmt1);
        setAgmt.add(agmt2);
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ApttusTibcoWebServiceCalloutMockResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/xml');

        Test.setMock(HttpCalloutMock.class, mock);

        ApexPages.standardSetController ssc = new ApexPages.standardSetController(setAgmt);
        
        Test.startTest();
        
        ApttusAgreement aAgmt = new ApttusAgreement(ssc);
        ApttusRequests rAgmt = new ApttusRequests(ssc);
        
        Test.stopTest();
        
        PageReference pr = Page.ApttusAgreement;
        Test.setCurrentPage(pr);
        aAgmt.apprReqId = agmt1.ID;
        
        PageReference p = aAgmt.doView();
        System.assertEquals(p.getURL(),'/'+agmt1.ID);
        
        aAgmt.goAgmt();
        aAgmt.doAccept();
        List<Apttus__APTS_Agreement__c> agreements = aAgmt.getAgmtReqPagination1();
        System.assert(agreements.size() > 0);
        
        aAgmt.getAgmtReqPagination2();
        
        agreements = null;
        
        //Apttus Request Link Test class
        pr = Page.ApttusRequests;
        Test.setCurrentPage(pr);
        
        rAgmt.apprReqId = agmt1.ID;
        
        p = rAgmt.doView();
        System.assertEquals(p.getURL(),'/'+agmt1.ID);
        
        rAgmt.goAgmt();
        rAgmt.doAccept();
        agreements = rAgmt.getApprReqPagination1();
        //System.assert(agreements.size() > 0);
        
        rAgmt.getApprReqPagination2();
        rAgmt.getApprReqPagination3();
        rAgmt.getApprReqPagination4();
        
    }
}