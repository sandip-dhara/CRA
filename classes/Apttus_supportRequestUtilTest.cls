@isTest(seeAllData= true)
private class Apttus_supportRequestUtilTest{
    public static testMethod void testAfterUpdate() {
       Support_Request__c supp=new Support_Request__c ();
       PriceBook2 pb = new PriceBook2 ();
       Product2 newPro2=new Product2();
       Account acc=new Account();
       opportunity newOpp = new opportunity();
       OpportunityLineItem newOppLineItem ;
       Attachment attachment =new Attachment();
       Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
       Note note =new Note();
    // Cretaing Customer Account   
       acc.name='Apttus-Acc';
       acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
       acc.ShippingCountry='India';
          insert acc;
       pb=[select id from Pricebook2 where IsStandard = true limit 1];   
    // Creating Opportuntiy   
       newOpp=TestingSetupDataUtil.createOpportunity(Acc.Id, 'ApttusOppty', system.today()+ 30);
       newOpp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
       newOpp.Route_To_Market__c='Direct';
       newOpp.Managed_By__c='HP';
       insert newOpp;  
    // Creating Product
       Product2 apttusProd=TestingSetupDataUtil.createProduct(true ,'ApttusProduct3','USD',null);
          insert apttusProd;
    // Creating PriceBook
       PricebookEntry newEntry=TestingSetupDataUtil.createPricebookEntry(apttusProd.Id,true,pb.Id,1000,'USD'); 
          insert newEntry;     
    // Creating OpportuntiyLineItem         
       newOppLineItem = new OpportunityLineItem(OpportunityId = newOpp.Id, PricebookEntryId = newEntry.Id,
                    ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);
          insert newOppLineItem ;
    // Creating Support Request   
       supp.Request_Type__c='New Agreement(HW,SW,support,servies)';
       supp.RecordTypeId=Schema.SObjectType.Support_Request__c.getRecordTypeInfosByName().get('FunctionalSupport-Legal').getRecordTypeId();
       supp.Opportunity__c=newOpp.id;
          insert supp;  
           test.startTest();
  
    // Creating attachemnts
        attachment.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attachment.body=bodyBlob;
        attachment.parentId=supp.id;
        insert attachment ;
    // Creating Notes
        note.body='ApttusBody';
        note.title='ApttusTitle';
        note.isPrivate=True;
        note.parentId=supp.id;     
        insert note;
        
    // Updating support Request     
       supp.isSRUpdate__c =true;
        update supp;  
        test.stopTest(); 
       
    // Creating Agreement
       agreement.name='ApttusAgreeName';
       agreement.Apttus__Related_Opportunity__c=newOpp.id;
       agreement.Apttus__Account__c=acc.id;
       agreement.SR_id__c=supp.id;
       agreement.ownerId=[Select id,QueueId from QueueSobject where SobjectType = 'Apttus__APTS_Agreement__c' AND Queue.Name = 'Support Request'].QueueId;
       agreement.RecordTypeId=Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Not yet selected').getRecordTypeId();
       insert agreement; 
       agreement.Apttus__Status__c='Request Closed';
       agreement.Legal_Owner__c =userInfo.getUserId();
       update  agreement; 
     
  }
}