/***********************************************************
* Class Name: HPQuoteControllerTest
* Author: HP
* Date: 09-May-2012 
* Requirement # Request Id: R5
* Description: This class does the test coverage for HP Quote Related List Functionality
***********************************************************/

@isTest(SeeAllData=true)
private class HPQuoteControllerTest{
    //Test Method 
    public static testMethod void QuoteRelatedListTest() {
        Test.startTest();
         List<HPQuoteController.QuoteWrapperClass> quoteWrapper = new  List<HPQuoteController.QuoteWrapperClass>();
         User objUser = [select Business_Group__c,Country,Region__c from user where id=:userinfo.getuserid()];
            objUser.Business_Group__c = 'ESSN';
            objUser.Region__c = 'EMEA';
            objUser.Country = 'Germany';
            update objUser;
            
            Account objAccount = TestingSetupDataUtil.createAccount('Test Partner Account1', 'partner1211@partnercollab.com','Customer');
            objAccount.ShippingStreet = 'Test Street';
            objAccount.ShippingState = 'Test State';
            objAccount.ShippingCity = 'Test City';
            objAccount.ShippingCountry = 'Test Country';
            objAccount.ShippingPostalCode = 'Test Postal';
            insert objAccount;
            
            Opportunity objOpportunity = TestingSetupDataUtil.createOpportunity(objAccount.Id, 'test Oppty',system.today()+30);
            objOpportunity.Route_To_Market__c = 'Direct';
            objOpportunity.CurrencyIsoCode = 'EUR';
            try{
            insert objOpportunity;
            }catch(Exception e){}

            //Create HP Quote
            HP_Quote__c objQuote = new HP_Quote__c(Quote_IDS_ID__c ='TestClass' ,Synced_To_Opportunity__c = true,Opportunity_Name__c = objOpportunity.Id,Name='testQuote', Hide_Record__c = false);
            objQuote.AMPID_TS__c = 'Test';
            objQuote.Group_Contract_SW__c = 'Test';
            objQuote.Name = 'Test';
            objQuote.Synced_To_Opportunity__c = true;
            insert objQuote;
            HP_Quote__c objQuote2 = new HP_Quote__c(Quote_IDS_ID__c ='TestClass' ,Synced_To_Opportunity__c = true,Opportunity_Name__c = objOpportunity.Id,Name='testQuote', Hide_Record__c = false);
            insert objQuote2;
            
            //HPQuoteController
            ApexPages.StandardController HPQStandrd = new ApexPages.StandardController(objOpportunity);            
            HPQuoteController HPQuote = new HPQuoteController(HPQStandrd);
            List<HPQuoteController.QuoteWrapperClass> quoteWrapper1= HPQuote.getHPQuotes();
            
            HPQuote.CheckedAGIds.add('AMP');
            HPQuote.CheckedAGIds.add('QUN');
            HPQuote.CheckedAGIds.add('GRC');
            HPQuote.isShowMore=false;
            HPQuote.isCustomSort=false;
            HPQuote.Searchorder='AMP:';
            HPQuote.Albetsresults();
            HPQuote.hideSelectedQuotes();
            HPQuote.ShowAllHiddenRecords();
            HPQuote.showAllRecords();
            HPQuote.showPreviousVersionQuotes();
            HPQuote.requestNewQuote();
            HPQuote.getSortDirection();
            HPQuote.setSortDirection('DESC');
            HPQuote.setSortDirection('ASC');
            HPQuote.ClearAllFilters();
            HPQuote.CheckedAGIds.add('AMP');
            HPQuote.CheckedAGIds.add('QUN');
            HPQuote.CheckedAGIds.add('GRC');
            HPQuote.redirctToSelectedQuoteType();
            HPQuote.redirctToNewRequestPageBasedonBG();
            HPQuote.redirctToNewRequestPage();
            HPQuote.showMoreAMPS();
            HPQuote.gettypeOfQuote();
            HPQuote.settypeOfQuote('SelfService');
            HPQuote.ViewData();
            //R6 methods
            HPQuote.Beginning();
            HPQuote.Next();
            HPQuote.Previous();
            HPQuote.End();
            HPQuote.getDisablePrevious();
            HPQuote.getDisableNext();
            HPQuote.getTotal_size();
            HPQuote.getPageNumber();
            HPQuote.getTotalPages();
            
            HPQuote.isQuoteName =true;
            HPQuote.Searchorder='QUN:';
            HPQuote.showQN();
            HPQuote.getAmpORGroupValues();
            HPQuote.isAMPID = true;
            HPQuote.isGroupContract = true;
            HPQuote.isQuoteName = true;
            HPQuote.AGQuoteList[0].selected=true;
            HPQuote.AGQuoteList[1].selected=true;
            HPQuote.closePopup();
            
            HPQuote.cancelPopup();
            HPQuote.ClearAllFilters();
            HPQuote.CheckedAGIds.add('QUN');
            HPQuote.CheckedAGIds.add('GRC');
            HPQuote.CheckedAGIds.add('AMP');
            HPQuote.isAMPID=true;
            HPQuote.Searchorder='AMP:';
            HPQuote.showAMPID();
            HPQuote.getAmpORGroupValues();
            HPQuote.closePopup();
            HPQuote.cancelPopup();
            
            HPQuote.isGroupContract =true;
            HPQuote.Searchorder='GRC:';
            HPQuote.showGC();
            HPQuote.getAmpORGroupValues();
            HPQuote.closePopup();
            HPQuote.cancelPopup();
            HPQuote.ClearAllFilters();
            HPQuote.CheckedAGIds.add('GRC');
            HPQuote.CheckedAGIds.add('AMP');
            HPQuote.CheckedAGIds.add('QUN');
            HPQuote.Searchorder='AMP:GRC:';
            HPQuote.showQN();
            HPQuote.getAmpORGroupValues();
            HPQuote.closePopup();
            HPQuote.cancelPopup();
            
            HPQuote.Searchorder='QUN:AMP:';
            HPQuote.showAMPID();
            HPQuote.getAmpORGroupValues();
            HPQuote.closePopup();
            HPQuote.cancelPopup();
            
            HPQuote.Searchorder='QUN:GRC:';
            HPQuote.getAmpORGroupValues();
            HPQuote.closePopup();
            HPQuote.cancelPopup();
            HPQuote.SearchRetSring='AMP456:AMP123:';
            PageReference HPQuoteCtrl = Page.HPQuoteRelatedList;
            HPQuoteCtrl.getParameters().put('clickedFrom','showPrevious');
            HPQuoteCtrl.getParameters().put('SearchRetSring','AMP456:AMP123:');
            HPQuoteCtrl.getParameters().put('AMSearchRetSring','AMP456:AMP123:');
            HPQuoteCtrl.getParameters().put('GCSearchRetSring','GCS456:GCS123:');
            HPQuoteCtrl.getParameters().put('QNSearchRetSring','QNS456:QNS123:');
            HPQuoteCtrl.getParameters().put('viewMode','showPrevious');
            HPQuoteCtrl.getParameters().put('selectedIds',objQuote.Id);
            HPQuoteCtrl.getParameters().put('sortExpression','');
            HPQuoteCtrl.getParameters().put('sortDirection','ASC');
            HPQuoteCtrl.getParameters().put('buttonClicked','SelfService');
            Test.setCurrentPage(HPQuoteCtrl);
            ApexPages.StandardController HPQStandrd1 = new ApexPages.StandardController(objOpportunity);            
            HPQuoteController HPQuote1 = new HPQuoteController(HPQStandrd1);
            HPQuote1.redirctToSelectedQuoteType();
            HPQuoteCtrl.getParameters().put('buttonClicked','NotSure');
            HPQuote1.redirctToSelectedQuoteType();
            HPQuoteCtrl.getParameters().put('buttonClicked','cancel');
            HPQuote1.redirctToSelectedQuoteType();
            
            //==========
            HPQuote1.Searchorder='AMP:';
            HPQuote1.SearchAMValue.Add('Test');
            HPQuote1.SearchAMValue.Add('');
            HPQuote1.isAMPID=false;
            HPQuote1.getAmpORGroupValues();
            
        Test.stopTest();
}

}