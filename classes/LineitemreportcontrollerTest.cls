/************************************************************************
        Purpose     : Test Class                  
        Parameters  : None
        Returns     : None
***********************************************************************/
@isTest(SeeAllData=true) 
public class LineitemreportcontrollerTest
{
static testmethod void testlineitemreportcontroller(){ 

       
       Account acc=new Account();
       acc.Name='test';
       acc.Source_System_Account_ID__c='0987';
       acc.ShippingCountry='India';
       insert acc;
       
       Opportunity opp = new Opportunity(AccountId = acc.id, StageName = '01 - Understand Customer', Name = 'abc', CloseDate = system.today(),CurrencyIsoCode='AUD');
       insert opp;
       Product2  products=new Product2(Name='test ppp',Business_Group__c='ESSN',GBU__c = 'Technology Support',Product_Line__c = 'Technology Support PL',Sub_Product_Line__c = 'Technology Support Sub-PL');
       insert products;              
       Pricebook2 pricebook= [select id from Pricebook2 where isStandard=true limit 1];

       PricebookEntry pricebookentry=TestingSetupDataUtil.createPricebookEntry(products.Id,true,pricebook.Id,100,'AUD');
       insert pricebookentry;                        
       
       OpportunityLineItem opplineitem = new OpportunityLineItem(OpportunityId = Opp.Id, PricebookEntryId = pricebookentry.Id,ServiceDate = system.Today()+ 35,Status__c='Approved',First_Fiscal_Year_Value__c=30.00,Margin_Amount__c=20.00,UnitPrice=100);   
       insert opplineitem;            
       system.currentPageReference().getParameters().put('id',opp.id);                           
       Lineitemreportcontroller lineitem=new Lineitemreportcontroller();
       
       
       
       Opportunity opp1 = new Opportunity(AccountId = acc.id, StageName = '01 - Understand Customer', Name = 'abc', CloseDate = system.today(),CurrencyIsoCode='EUR');
       insert opp1;
       Product2  products1=new Product2(Name='test ppp',Business_Group__c='ESSN',GBU__c = 'Technology Support',Product_Line__c = 'Technology Support PL',Sub_Product_Line__c = 'Technology Support Sub-PL');
       insert products1;              

       PricebookEntry pricebookentry1=TestingSetupDataUtil.createPricebookEntry(products1.Id,true,pricebook.Id,100,'EUR');
       insert pricebookentry1;                        
       
       OpportunityLineItem opplineitem1 = new OpportunityLineItem(OpportunityId = Opp1.Id, PricebookEntryId = pricebookentry1.Id,ServiceDate = system.Today()+ 35,Status__c='Approved',First_Fiscal_Year_Value__c=60.00,UnitPrice=100);   
       insert opplineitem1; 
       system.currentPageReference().getParameters().put('id',opp1.id);                           
       Lineitemreportcontroller lineitem1=new Lineitemreportcontroller();
   
       
       
       }
      }