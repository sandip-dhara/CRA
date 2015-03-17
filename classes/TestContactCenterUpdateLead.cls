@isTest
public class TestContactCenterUpdateLead {
    static testMethod void TestContactCenterUpdateLead(){
    List<lead> leadList = new list<lead>();
    
    Id CampaignRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Sales Initiatives').getRecordTypeId();  
    Campaign camp = new Campaign(RecordTypeid = CampaignRecordTypeId,IsActive = true,Name = 'testCampCJ12ab',Ownerid = UserInfo.getUserId(),Description = 'newTest Campaign12',StartDate =System.Today(),Status ='Planned',Type='Email' );
    insert camp;
            
    Lead l = new lead(LastName='Test123',Company = 'Hp',Email='hp@hp.com',Phone='9738335102',LeadSource='List Import',C_Mobile_Opt_in1__c = 'Y',Phone_Opt_in__c = 'Y',Last_Successful_Call__c = NULL);
    leadList.add(l);
    
    Lead l1 = new lead(LastName='Test124',Company = 'Hps',Email='hp1@hp.com',Phone='9738335103',LeadSource='List Import',C_Mobile_Opt_in1__c = 'Y',Phone_Opt_in__c = 'Y',Last_Successful_Call__c = datetime.now());
    leadList.add(l1);
    
    Lead l2 = new lead(LastName='Test125',Campaign__C = camp.id,Company = 'Hps',Email='hp2@hp.com',Phone='9738335103',LeadSource='List Import',C_Mobile_Opt_in1__c = 'N',Phone_Opt_in__c = 'N',Last_Successful_Call__c = NULL);
    leadList.add(l2);
    
    Lead l3 = new lead(LastName='Test126',Company = 'Hps',Email='hp3@hp.com',Phone='9738335103',LeadSource='List Import',C_Mobile_Opt_in1__c = 'N',Phone_Opt_in__c = 'N',Last_Successful_Call__c = NULL);
    leadList.add(l3);
    
    Lead l4 = new lead(LastName='Test126',Company = 'Hps',Email='hp3@hp.com',Phone='9738335103',LeadSource='List Import',C_Mobile_Opt_in1__c = 'Y',Phone_Opt_in__c = 'Y',Last_Successful_Call__c = NULL);
    leadList.add(l4);
    
    Lead l5 = new lead(LastName='Test126',Company = 'Hps',Email='hp3@hp.com',Phone='9738335103',LeadSource='List Import',C_Mobile_Opt_in1__c = 'N',Phone_Opt_in__c = 'N',Last_Successful_Call__c = datetime.now());
    leadList.add(l5);
    
    Lead l6 = new lead(LastName='Test127',Company = 'Hps',Email='hp3@hp.com',Phone='9738335109',LeadSource='List Import',C_Mobile_Opt_in1__c = 'Y',Phone_Opt_in__c = 'N',Last_Successful_Call__c = NULL);
    leadList.add(l6);
    
    Lead l7 = new lead(LastName='Test127',Company = 'Hps',Email='hp3@hp.com',Phone='9738335109',LeadSource='List Import',C_Mobile_Opt_in1__c = 'N',Phone_Opt_in__c = 'Y',Last_Successful_Call__c = NULL);
    leadList.add(l7);
    
    Lead l8 = new lead(LastName='Test127',Company = 'Hps',Email='hp3@hp.com',Phone='9738335109',LeadSource='List Import',C_Mobile_Opt_in1__c = 'N',Phone_Opt_in__c = 'Y',Last_Successful_Call__c = NULL);
    leadList.add(l8);
    
    Lead l9 = new lead(LastName='Test127',Company = 'Hps',Email='hp3@hp.com',Phone='9738335109',LeadSource='List Import',C_Mobile_Opt_in1__c = 'N',Phone_Opt_in__c = 'Y',Last_Successful_Call__c = datetime.now());
    leadList.add(l9);
    
    insert(leadList);
    
    l.C_Mobile_Opt_in1__c = 'N';
    system.debug(' updated values are @@@@ C_Mobile_Opt_in1__c '+l.C_Mobile_Opt_in1__c+' Phone_Opt_in__c  '+l.Phone_Opt_in__c+' Last_Successful_Call__c '+l.Last_Successful_Call__c+' CreatedDate '+l.CreatedDate);
    
    l1.C_Mobile_Opt_in1__c = 'N';
    
    l2.C_Mobile_Opt_in1__c = 'Y';
    
    l3.C_Mobile_Opt_in1__c = 'Y';
    
    l4.C_Mobile_Opt_in1__c = 'N';
    
    l5.C_Mobile_Opt_in1__c = 'Y';
    
    l6.C_Mobile_Opt_in1__c = 'N';
    
    l7.C_Mobile_Opt_in1__c = 'Y';
    
    l8.C_Mobile_Opt_in1__c = 'Y';
    
    l9.C_Mobile_Opt_in1__c = 'Y';
    
    update(leadList);
    
   
    }
}