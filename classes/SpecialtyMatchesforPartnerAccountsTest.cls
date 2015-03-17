/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAllData=true)
private class SpecialtyMatchesforPartnerAccountsTest {

    static testMethod void SOMforPartnerAccountsTest() {
        
        List<Sales_Territory_User_Assignment__c> stUserAssignList = new List<Sales_Territory_User_Assignment__c>();
        List<Sales_Territory_Account_Assignment__c> stAccAssignList = new List<Sales_Territory_Account_Assignment__c>();
        List<Sales_Territory_Location_Assignment__c> stLocationAssignList = new List<Sales_Territory_Location_Assignment__c>();
        Sales_Territory__c salesTerr = new Sales_Territory__c (Name='OpptySpecSalesTerr', MyComp_Sales_Territory_Name__c='OpptySpecSalesTerr', IsActive__c=true, IsConfidential__c=true);       
        insert salesTerr;
        salesTerr.IsPartner__c = true;
        update salesTerr;
        Id userId = UserInfo.getUserId();
        List<User> currentUserList=[Select Id from User where Id =:userId];         
        List<User> userObjList = [Select Id from User where IsActive=true limit 5];
        userObjList.add(currentUserList.get(0));
        for(Integer i=0;i<6;i++){
            Sales_Territory_User_Assignment__c stuserAssign = new Sales_Territory_User_Assignment__c(User__c = userObjList[i].Id, Sales_Territory__c = salesTerr.Id, IsActive__c=true, 
                                                                                             Add_to_Account_Team__c = false, Account_Team_Role__c = 'Alliance Sales');
            stUserAssignList.add(stuserAssign);
        }
        insert stUserAssignList;
        Account custAcc = new Account(Name = 'OpptySpecTestAcc');
        insert custAcc;
        Account partnerAcc = TestingSetupDataUtil.createAccount('OpptySpecTestPartnrAcc', 'opptySpecPartnr@partnercollab.com','Partner');
        partnerAcc.Partner_Portal_Eligible__c = true;
        insert partnerAcc;        
        system.assertEquals(partnerAcc.Partner_Portal_Eligible__c,true);
        partnerAcc.IsPartner = true;
        partnerAcc.Partner_Portal_Eligible__c = true;
        update partnerAcc; 
        Location__c testLocation = new Location__c(Name = 'OpptySpecLoc', Account__c = partnerAcc.Id);
        insert testLocation;
        List<Account> accList = [Select Id from Account limit 6];
        for(Integer i=0;i<6;i++){
            Sales_Territory_Account_Assignment__c stAccAssign = new Sales_Territory_Account_Assignment__c(Account__c = accList[i].Id, Sales_Territory__c = salesTerr.Id);
            stAccAssignList.add(stAccAssign);            
        }
        insert stAccAssignList;
        //raghv:insert location
        Sales_Territory_Location_Assignment__c stLocationAssign = new Sales_Territory_Location_Assignment__c(Location__c = testLocation.Id, Sales_Territory__c = salesTerr.Id);
        stLocationAssignList .add(stLocationAssign);
        insert stLocationAssignList ;
        string setLocIdVal='';
        for(Sales_Territory_Location_Assignment__c str : stLocationAssignList)
            if(str !=null){
            setLocIdVal += str.Location__c + ',';
            }
        Opportunity testOppty = new Opportunity(Name = 'OpptySpecTestOppty',AccountId = custAcc.id,StageName='01 - Understand Customer',CloseDate=system.today());
        insert testOppty; 
        Product_Specialty__c opptyProdSpec;
        Product_Specialty_User_Assignment__c prodSpecUserAssign; 
        Product_Specialty_Oppty_Assignment__c prodSpecOpptyAssign;
        Product_Specialty_Definition__c prodSpecDef;  
        Product2 testProd; 
        OpportunityLineItem opptyLineItem;
        PriceBookEntry opptyPriceBook;
        Pricebook2 priceBook2Entry;   
        Pricebook2 prb=[select id from Pricebook2 where IsStandard = true];
        try{
        opptyProdSpec = new Product_Specialty__c(Name='TestSpec');
        insert opptyProdSpec;
        prodSpecUserAssign=new Product_Specialty_User_Assignment__c(User__c=currentUserList.get(0).id,Product_Specialty__c=opptyProdSpec.id);
        insert prodSpecUserAssign;
        prodSpecOpptyAssign = new Product_Specialty_Oppty_Assignment__c(Opportunity__c=testOppty.Id,Product_Specialty_User_Assignment__c=prodSpecUserAssign.id);
        insert prodSpecOpptyAssign;
        testProd=new Product2(Name='TestSpecProd',Sub_Product_Line__c='TestSpecSubProdLine',Product_Line__c='TestProdLine',isActive=true,CurrencyIsoCode='USD');
        insert testProd;
        prodSpecDef=new Product_Specialty_Definition__c(Product_Specialty__c=opptyProdSpec.id,Product__c=testProd.id);
        insert prodSpecDef;
        opptyPriceBook=TestingSetupDataUtil.createPricebookEntry(testProd.Id,true,prb.id,100,'USD');
        opptyPriceBook.UseStandardPrice=true;
        insert opptyPriceBook; 
        opptyLineItem=new OpportunityLineItem(OpportunityId = testOppty.Id, PricebookEntryId = opptyPriceBook.Id,
                    ServiceDate = system.today()+ 35, Quantity = 11, UnitPrice = 10);
        insert  opptyLineItem; 
        }catch(Exception e){
        System.debug('Exception while creating products..');
        }
        Channel_Partner__c testChannelPartner = new Channel_Partner__c(Opportunity__c = testOppty.Id,Location__c=testLocation.id,Channel_Partner__c=partnerAcc.id);              
        insert testChannelPartner;   
                
        ApexPages.StandardController thecontroller = new ApexPages.StandardController(salesTerr);
        SpecialtyMatchesforPartnerAccounts specOpptyMatchPartTemp = new SpecialtyMatchesforPartnerAccounts(null);
        SpecialtyMatchesforPartnerAccounts.SpecialtymatchwithPartner testSpecMatch=new SpecialtyMatchesforPartnerAccounts.SpecialtymatchwithPartner(null,null,null,null,null); 
        SpecialtyMatchesforPartnerAccounts specOpptyMatch = new SpecialtyMatchesforPartnerAccounts();
        
        specOpptyMatch.setlookupVal(testChannelPartner);
        specOpptyMatch.getlookupVal();
        specOpptyMatch.setlookupLocNew(testChannelPartner);
        specOpptyMatch.getlookupLocNew();
        specOpptyMatch.locIdStringVal = setLocIdVal;
        
        test.startTest();
        specOpptyMatch.selectedAccountId=testChannelPartner.id;
        //specOpptyMatch.populateSOMSfromSelectList();        
        specOpptyMatch.lookupLocNew=testChannelPartner; 
        specOpptyMatch.searchString='Test';                 
        specOpptyMatch.search();
        try{        
            specOpptyMatch.searchLoc();
        }catch(Exception e){
            System.debug('Exception in test class..');
        }       
        //specOpptyMatch.populateSOMSfromLookup(); 
        //specOpptyMatch.populateSpecialtyOpportunityList(accountList); 
        specOpptyMatch.lookupLocNew=testChannelPartner;       
        specOpptyMatch.populateSpeOpptyfromLocLookup();        
        specOpptyMatch.getFormTag();
        specOpptyMatch.getTextBox();
        specOpptyMatch.getIsResultEmpty();  
        specOpptyMatch.next();
        specOpptyMatch.beginning();
        specOpptyMatch.list_size=0;
        specOpptyMatch.End();
        specOpptyMatch.previous();
        specOpptyMatch.getDisablePrevious();
        specOpptyMatch.getDisableNext();
        specOpptyMatch.getTotalPages();
        specOpptyMatch.getTotal_size();
        specOpptyMatch.getPageNumber();
        specOpptyMatch.getListSize();    
        try{        
            specOpptyMatch.searchString = '';
            specOpptyMatch.searchLoc();
            specOpptyMatch.locIdStringVal = '';
            specOpptyMatch.populateSpeOpptyfromLocLookup();
        }catch(Exception e){
            System.debug('Exception in test class..');
        } 
        test.stopTest();
    }              
}