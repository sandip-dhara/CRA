@isTest(SeeAllData=True)
public class ClosePlanAfterInsertTest{

 

static testMethod void testCloseplan() {
         //usercreation();
        List<Account> listAccount = new List<Account>();
        
        //Create Account for Opportunity 
        Account account1 = TestingSetupDataUtil.createAccount('Test Test Account1', 'Test@test1.com','Customer');
        listAccount.add(account1);
        insert listAccount;
        
        
        //Create Opty
        Opportunity opty = TestingSetupDataUtil.createOpportunity(account1.Id,'tarunOppty1',System.today().addMonths(1));
        //opty.OwnerId= useroptyowner.Id;
        insert opty;
        System.assertEquals(opty.Name,'tarunOppty1');
        
        //Create Opportunity plan record and get the Opty plan ID    
        id OptyplanId = CreateOpportunityPlan.CreateOpptyPlan(opty.Id);
         system.debug('OptyplanId*****'+OptyplanId);
        //PageReference pg = Page.closeplanpage;
        //Test.setCurrentPage(pg);
       
         id OptyplanId1 = CreateOpportunityPlan.CreateOpptyPlan(opty.Id);
         id OptyplanId2 = CreateOpportunityPlan.CreateOpptyPlan('006800090809QTuIAM');
         system.debug('OptyplanId1*****'+OptyplanId1);
         
         Opportunity_Plan__c oppplan =new Opportunity_Plan__c ();
         oppplan.Opportunity__c=opty.Id;
         oppplan.close_plan_count__c=0;
         insert oppplan;
         system.debug('oppplan.id*****'+oppplan.id);
            
       
          
          Close_Plan__c cplt =new Close_Plan__c(Opportunity_Plan__c = oppplan.Id,DESCRIPTION__c = 'Test Close Plan',Status1__c = 'New');
          insert cplt;
          
          Close_Plan__c cplt1 =new Close_Plan__c(Opportunity_Plan__c = oppplan.Id,DESCRIPTION__c = 'Test Close Plan',Status1__c = 'New');
          insert cplt1;
          
          Close_Plan__c cplt2 =new Close_Plan__c(Opportunity_Plan__c = oppplan.Id,DESCRIPTION__c = 'Test Close Plan',Status1__c = 'New');
          insert cplt2;
          
          delete cplt;
          delete cplt1;
          delete cplt2;
          
          
         
          
          test.startTest();
}
}