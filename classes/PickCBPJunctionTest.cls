@isTest
private class PickCBPJunctionTest{
 

 
 
    
/**
    * @description: Setting Test Data
    */
    static testMethod void CbpListPositiveTest(){
         
    
        /* Account */ 
        Account acc = new Account(Name='testacc1',Source_System_Account_ID__c='56544565');
        insert acc ;
        System.assertEquals(acc.Name,'testacc1');
        
         /* Account Plan */
        Account_Plan__c newAP = new Account_Plan__c(Name='Sample Account plan',Primary_AccountAccount__c=acc.id);
        insert newAP;
        System.assertEquals(newAP.Name,'Sample Account plan');

        /* Strategic Initiative */ 
        Strategic_Initiative__c newSI = new Strategic_Initiative__c(Name='Sample',Account_Plan__c=newAp.Id);
        insert newSI ;
        System.assertEquals(newSI.Name,'Sample');
        
        String strategicId = newSI.Id;
         List<Account_Plan__c> listacc=new List<Account_Plan__c>();
        listAcc=[Select a.id,a.Primary_AccountAccount__c,a.Name,a.CurrencyIsoCode From Account_Plan__c a where a.Id in (Select s.Account_Plan__c From Strategic_Initiative__c s where s.Id = :strategicId )];
        String str= newAP.Primary_AccountAccount__c;  
       
       /*Customer Business Priority */
       Customer_Business_Priority__c newCbp = new Customer_Business_Priority__c(Account_Plan__c=newAp.Id,Name='testcbp1');
        insert newCbp;
        System.assertEquals(newCbp.Name,'testcbp1');
     
        List<Strategic_Initiative__c > strInit = new List<Strategic_Initiative__c >([Select s.Name, s.Id, s.CreatedById, s.Account_Plan__c From Strategic_Initiative__c s]);
        ApexPages.StandardSetController controller = new ApexPages.StandardSetController(strInit);
        List<PickCBPJunction.CustomerPriority> cbList=new List<PickCBPJunction.CustomerPriority>();
        List<Customer_Business_Priority__c > cbplis = new List<Customer_Business_Priority__c >([Select  Name, Id,Account_Plan__c,Short_Description__c,Priority__c,Timing__c From Customer_Business_Priority__c where Account_Plan__c=: newAP.id]);
          for(Customer_Business_Priority__c customBP : [Select Name, Id,Account_Plan__c,Short_Description__c,Priority__c,Timing__c From Customer_Business_Priority__c  where Account_Plan__c in (:str) limit 50000]) {
                    cbList.add(new PickCBPJunction.CustomerPriority(customBP));
                }
                PageReference pageRef2 = Page.PickCBPPage;      
        ApexPages.currentPage().getParameters().put('id',newSI.Id);
        String searchString='a*';
       PickCBPJunction cbp = new PickCBPJunction(controller);   
        List<PickCBPJunction.CustomerPriority> ccon = cbp.getBusinessPriorities();
        Related_CustomerBusiness__c rcb=new Related_CustomerBusiness__c();
          rcb.Strategic_Initiative__c= newSI.Id;
           PickCBPJunction.CustomerPriority c= new PickCBPJunction.CustomerPriority(newCbp);
         test.startTest();
         cbList.add(c);
         c.selected=true;
          ccon.add(c); 
          cbp.getBusinessPriorities();     
          cbp.processSelected();
          cbp.Cancel();
       cbp.getIsPickCbpListEmpty();
       cbp.search();
       cbp.runsearch(searchString);
        test.stopTest();
    }

}