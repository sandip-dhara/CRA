/**********************************************************
* Class Name: UniqueIMforOppTest
* Author: HP
* Date: 18-FEB-2013 
* Description: This class does the test coverage for UniqueIMforOppTest Trigger.
***********************************************************/

@isTest(SeeAlldata = True)
private class UniqueIMforOppTest{
    public static String queueId = '';
    public static Opportunity opportunity;
    public static Account newAccount;
    public static Installation_Management__c IM;
    public static Installation_Management__c IM1;
    public static Installation_Management__c IM2;
    public static Installation_Management__c IM3;
    public static List<Installation_Management__c> IMList;
    
    static testMethod void IM() {
        opportunity = new Opportunity();
        newAccount = new Account();
        IM =  new Installation_Management__c();
        IMList =  new  List<Installation_Management__c>();
        //Create new Account        
        newAccount = TestingSetupDataUtil.createAccount('HP', 'test@test.com', 'Customer');              
        insert newAccount;
        //Create new Opportunity
        Date newDate = Date.today(); 
        opportunity = TestingSetupDataUtil.createOpportunity(newAccount.Id, newAccount.Name, newDate);      
        insert opportunity;
        
        //Create new Installation Managemnet
        IM = TestingSetupDataUtil.createIM(opportunity.Id,'5b - Agreement Validated','Move Close');
        insert IM ;
        
        
        //Create new Installation Managemnet
        IM1 = TestingSetupDataUtil.createIM(opportunity.Id,'5b - Agreement Validated','Move Close');
        
        try{
        insert IM1;
        }
        catch(Exception e){
            e.getMessage();
        }
        
        //Create new Installation Managemnet
        IM2 = TestingSetupDataUtil.createIM(opportunity.Id,'5b - Agreement Validated','Move Close');
        
        //Create new Installation Managemnet
        IM3 = TestingSetupDataUtil.createIM(opportunity.Id,'5b - Agreement Validated','Move Close');
        
        IMList.add(IM2);
        IMList.add(IM3);
        
        try{
        insert IMList;
        }
        catch(Exception e){
            e.getMessage();
        }
        }
    }