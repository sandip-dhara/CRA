@isTest(SEEALLDATA=True)
private class PickOpportunityJunctionTest{
    

    static testMethod void CbpListPositiveTest(){
         String searchString='aa*';
    
        /* Account */ 
        Account acc = new Account(Name='testacc1',Source_System_Account_ID__c='56544565');
        insert acc ;
        System.assertEquals(acc.Name,'testacc1');
        
        Account account2 = TestingSetupDataUtil.createAccount('testAccount1 child 2', 'accountEmail@email.com','Customer');
        account2.ParentId = acc.id;
        insert account2 ;
        Account account3 = TestingSetupDataUtil.createAccount('testAccount1 child 3', 'accountEmail@email.com','Customer');
        account3.ParentId = account2.id;
        insert account3 ;
        Account account4 = TestingSetupDataUtil.createAccount('testAccount1 child 4', 'accountEmail@email.com','Customer');
        account4.ParentId = account3.id;
        insert account4 ;
        Account account5 = TestingSetupDataUtil.createAccount('testAccount1 child 5', 'accountEmail@email.com','Customer');
        account5.ParentId = account4.id;
        insert account5 ;
        
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
       
       /*Opportunity*/
       Opportunity   newCbp = new Opportunity(AccountId=acc.Id,CloseDate=system.today()+ 30,StageName='01 - Understand Customer',CurrencyIsoCode= 'USD',Name='testcbp1');
        insert newCbp;
        System.assertEquals(newCbp.Name,'testcbp1');
     
        List<Strategic_Initiative__c > strInit = new List<Strategic_Initiative__c >([Select s.Name, s.Id, s.CreatedById, s.Account_Plan__c From Strategic_Initiative__c s]);
        ApexPages.StandardSetController controller = new ApexPages.StandardSetController(strInit);
        List<PickOpportunityJunction.Opty> optyList=new List<PickOpportunityJunction.Opty>();
               for(Opportunity c: [Select  Name, Id, CloseDate, AccountId From Opportunity  where AccountId in (:str) and StageName Not in('06 - Won, Deploy & Expand','Lost','HP Not Pursued','Error') limit 50000]) {
                    optyList.add(new PickOpportunityJunction.Opty(c));
                }
                PageReference pageRef = Page.PickOpportunityJunction;      
        ApexPages.currentPage().getParameters().put('id',newSI.Id);
        
       PickOpportunityJunction poj= new PickOpportunityJunction(controller);   
        List<PickOpportunityJunction.Opty> ccon = poj.getopps();
       Strategic_Opportunity_Junction__c soj=new Strategic_Opportunity_Junction__c();
          soj.Strategic_Initiative__c= newSI.Id;
           PickOpportunityJunction.Opty c1;
           c1 = new PickOpportunityJunction.Opty(newCbp);
        test.startTest();
        optyList.add(c1);
        c1.selected=true;
        ccon.add(c1); 
        poj.processSelected();
        poj.Cancel();
        poj.getIsPickOptyListEmpty();
        poj.search();
        poj.runsearch(searchString);
   test.stopTest();
    }

}