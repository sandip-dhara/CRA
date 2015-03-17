@isTest 
private class MDCPControllerTestClass {
    static testMethod void validateMDCPController() {
    List<Account> accounts = new List<Account>{};
Account testAccount = new Account(Name='Test Company Name123');
            accounts.add(testAccount);
          //  insert accounts;
Test.setCurrentPageReference(new PageReference('Page.MDCPDynamicSearchPage')); 
System.currentPageReference().getParameters().put('MDCPEntity','Competitor');          
ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(accounts);
MDCPController MDCPobj = new MDCPController(ssc);

MDCPobj.MDCPQuery='organizationExtendedName:"cissell"'; 
string response='<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Header /><SOAP-ENV:Body><ns0:organizationAccountSearchResponse xmlns:ns0="http://www.tibco.com/schemas/MDCP2SFDC-LookUp/Schemas/accountSearchList.xsd"><ns0:organizationAccountSearchDocuments><ns0:totalDocuments>5</ns0:totalDocuments><ns0:documents><ns0:organizationAccountSearchResult><ns0:organizationExtendedName>RYDALL BAY PTY. LTD.</ns0:organizationExtendedName><ns0:organizationNonLatinExtendedName /><ns0:organizationId>108821910</ns0:organizationId><ns0:duns>752929356</ns0:duns><ns0:globalDuns ns1:nil="true" xmlns:ns1="http://www.w3.org/2001/XMLSchema-instance" /><ns0:domesticDuns ns2:nil="true" xmlns:ns2="http://www.w3.org/2001/XMLSchema-instance" /><ns0:latinStreet1LongName>395 COLLINS ST</ns0:latinStreet1LongName><ns0:nonlatinStreet1LongName ns3:nil="true" xmlns:ns3="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countryName>Australia</ns0:countryName><ns0:state>Victoria</ns0:state><ns0:latinCity>MELBOURNE</ns0:latinCity><ns0:nonlatinCity ns4:nil="true" xmlns:ns4="http://www.w3.org/2001/XMLSchema-instance" /><ns0:postalCode>3000</ns0:postalCode><ns0:amid2 ns5:nil="true" xmlns:ns5="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countOfEmployee ns6:nil="true" xmlns:ns6="http://www.w3.org/2001/XMLSchema-instance" /><ns0:onlyPresaleCustomer>false</ns0:onlyPresaleCustomer><ns0:deletionIndicator>false</ns0:deletionIndicator><ns0:isOutOfBusiness>false</ns0:isOutOfBusiness><ns0:isGlobalAccount>false</ns0:isGlobalAccount><ns0:worldRegion>Australia</ns0:worldRegion><ns0:taxId ns7:nil="true" xmlns:ns7="http://www.w3.org/2001/XMLSchema-instance" /><ns0:siteId>6143010</ns0:siteId><ns0:countryCode>AU</ns0:countryCode></ns0:organizationAccountSearchResult><ns0:organizationAccountSearchResult><ns0:organizationExtendedName>Rydall, Darwin Builder</ns0:organizationExtendedName><ns0:organizationNonLatinExtendedName /><ns0:organizationId>47226338</ns0:organizationId><ns0:duns>200200488</ns0:duns><ns0:globalDuns ns1:nil="true" xmlns:ns1="http://www.w3.org/2001/XMLSchema-instance" /><ns0:domesticDuns ns2:nil="true" xmlns:ns2="http://www.w3.org/2001/XMLSchema-instance" /><ns0:latinStreet1LongName>278 RYDALL MILL RD</ns0:latinStreet1LongName><ns0:nonlatinStreet1LongName ns3:nil="true" xmlns:ns3="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countryName>Canada</ns0:countryName><ns0:state ns4:nil="true" xmlns:ns4="http://www.w3.org/2001/XMLSchema-instance" /><ns0:latinCity>ECHO BAY</ns0:latinCity><ns0:nonlatinCity ns5:nil="true" xmlns:ns5="http://www.w3.org/2001/XMLSchema-instance" /><ns0:postalCode>P0S 1C0</ns0:postalCode><ns0:amid2 ns6:nil="true" xmlns:ns6="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countOfEmployee ns7:nil="true" xmlns:ns7="http://www.w3.org/2001/XMLSchema-instance" /><ns0:onlyPresaleCustomer>false</ns0:onlyPresaleCustomer><ns0:deletionIndicator>false</ns0:deletionIndicator><ns0:isOutOfBusiness>true</ns0:isOutOfBusiness><ns0:isGlobalAccount>false</ns0:isGlobalAccount><ns0:worldRegion>Canada</ns0:worldRegion><ns0:taxId ns8:nil="true" xmlns:ns8="http://www.w3.org/2001/XMLSchema-instance" /><ns0:siteId>4248031</ns0:siteId><ns0:countryCode>CA</ns0:countryCode></ns0:organizationAccountSearchResult><ns0:organizationAccountSearchResult><ns0:organizationExtendedName>Rydall, Darwin Builder</ns0:organizationExtendedName><ns0:organizationNonLatinExtendedName /><ns0:organizationId>47226338</ns0:organizationId><ns0:duns>200200488</ns0:duns><ns0:globalDuns ns1:nil="true" xmlns:ns1="http://www.w3.org/2001/XMLSchema-instance" /><ns0:domesticDuns ns2:nil="true" xmlns:ns2="http://www.w3.org/2001/XMLSchema-instance" /><ns0:latinStreet1LongName>278 RYDALL MILL RD</ns0:latinStreet1LongName><ns0:nonlatinStreet1LongName ns3:nil="true" xmlns:ns3="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countryName>Canada</ns0:countryName><ns0:state>Ontario</ns0:state><ns0:latinCity>ECHO BAY</ns0:latinCity><ns0:nonlatinCity ns4:nil="true" xmlns:ns4="http://www.w3.org/2001/XMLSchema-instance" /><ns0:postalCode>P0S 1C0</ns0:postalCode><ns0:amid2 ns5:nil="true" xmlns:ns5="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countOfEmployee ns6:nil="true" xmlns:ns6="http://www.w3.org/2001/XMLSchema-instance" /><ns0:onlyPresaleCustomer>false</ns0:onlyPresaleCustomer><ns0:deletionIndicator>false</ns0:deletionIndicator><ns0:isOutOfBusiness>false</ns0:isOutOfBusiness><ns0:isGlobalAccount>false</ns0:isGlobalAccount><ns0:worldRegion>Canada</ns0:worldRegion><ns0:taxId ns7:nil="true" xmlns:ns7="http://www.w3.org/2001/XMLSchema-instance" /><ns0:siteId>6046104</ns0:siteId><ns0:countryCode>CA</ns0:countryCode></ns0:organizationAccountSearchResult><ns0:organizationAccountSearchResult><ns0:organizationExtendedName>Rydall Penthos School</ns0:organizationExtendedName><ns0:organizationNonLatinExtendedName /><ns0:organizationId>93954111</ns0:organizationId><ns0:duns>233445894</ns0:duns><ns0:globalDuns ns1:nil="true" xmlns:ns1="http://www.w3.org/2001/XMLSchema-instance" /><ns0:domesticDuns ns2:nil="true" xmlns:ns2="http://www.w3.org/2001/XMLSchema-instance" /><ns0:latinStreet1LongName>PWLLYCROCHAN AVENUE</ns0:latinStreet1LongName><ns0:nonlatinStreet1LongName ns3:nil="true" xmlns:ns3="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countryName>United Kingdom</ns0:countryName><ns0:state ns4:nil="true" xmlns:ns4="http://www.w3.org/2001/XMLSchema-instance" /><ns0:latinCity>COLWYN BAY</ns0:latinCity><ns0:nonlatinCity ns5:nil="true" xmlns:ns5="http://www.w3.org/2001/XMLSchema-instance" /><ns0:postalCode>LL29 7BT</ns0:postalCode><ns0:amid2 ns6:nil="true" xmlns:ns6="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countOfEmployee ns7:nil="true" xmlns:ns7="http://www.w3.org/2001/XMLSchema-instance" /><ns0:onlyPresaleCustomer>true</ns0:onlyPresaleCustomer><ns0:deletionIndicator>false</ns0:deletionIndicator><ns0:isOutOfBusiness>false</ns0:isOutOfBusiness><ns0:isGlobalAccount>false</ns0:isGlobalAccount><ns0:worldRegion>UK &amp; I</ns0:worldRegion><ns0:taxId ns8:nil="true" xmlns:ns8="http://www.w3.org/2001/XMLSchema-instance" /><ns0:siteId>10694615</ns0:siteId><ns0:countryCode>GB</ns0:countryCode></ns0:organizationAccountSearchResult><ns0:organizationAccountSearchResult><ns0:organizationExtendedName>RYDALL BAY PTY. LTD.</ns0:organizationExtendedName><ns0:organizationNonLatinExtendedName /><ns0:organizationId>108821910</ns0:organizationId><ns0:duns>752929356</ns0:duns><ns0:globalDuns ns1:nil="true" xmlns:ns1="http://www.w3.org/2001/XMLSchema-instance" /><ns0:domesticDuns ns2:nil="true" xmlns:ns2="http://www.w3.org/2001/XMLSchema-instance" /><ns0:latinStreet1LongName>395 COLLINS ST</ns0:latinStreet1LongName><ns0:nonlatinStreet1LongName ns3:nil="true" xmlns:ns3="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countryName>Australia</ns0:countryName><ns0:state ns4:nil="true" xmlns:ns4="http://www.w3.org/2001/XMLSchema-instance" /><ns0:latinCity>MELBOURNE</ns0:latinCity><ns0:nonlatinCity ns5:nil="true" xmlns:ns5="http://www.w3.org/2001/XMLSchema-instance" /><ns0:postalCode>3000</ns0:postalCode><ns0:amid2 ns6:nil="true" xmlns:ns6="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countOfEmployee ns7:nil="true" xmlns:ns7="http://www.w3.org/2001/XMLSchema-instance" /><ns0:onlyPresaleCustomer>false</ns0:onlyPresaleCustomer><ns0:deletionIndicator>false</ns0:deletionIndicator><ns0:isOutOfBusiness>true</ns0:isOutOfBusiness><ns0:isGlobalAccount>false</ns0:isGlobalAccount><ns0:worldRegion>Australia</ns0:worldRegion><ns0:taxId ns8:nil="true" xmlns:ns8="http://www.w3.org/2001/XMLSchema-instance" /><ns0:siteId>2521543</ns0:siteId><ns0:countryCode>AU</ns0:countryCode></ns0:organizationAccountSearchResult></ns0:documents></ns0:organizationAccountSearchDocuments></ns0:organizationAccountSearchResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
MDCPobj.search();
Test.setMock(HttpCalloutMock.class, new MDCPMockHttpResponseGenerator());
MDCPobj.totalPages=0;
MDCPobj.search();
//parsing completin
MDCPCalloutHelper webclass = new MDCPCalloutHelper();
webclass.Parserequest(response);
// for the sorting of the list
list<MDCPResult__c> searchresult=new list<MDCPResult__c>();
MDCPResult__c val=new MDCPResult__c();
val.name='abc';
val.MDCP_Id__c='628475589';
val.siteId__c='10665196';
searchresult.add(val);
system.debug('searchresult======='+searchresult);
MDCPobj.searchResultByPage =new list<MDCPResult__c>();
MDCPobj.searchResultByPage.add(val);
MDCPobj.searchResult =new list<MDCPResult__c>();
MDCPobj.searchResult.add(val);
MDCPobj.sortBy ='name';
MDCPobj.Flipsort='asc';
try{
MDCPobj.SortByFieldName();
MDCPobj.SortByFieldName(); 
//for the pagination part
MDCPobj.selectedPage ='1';
MDCPobj.totalRecords =1;
MDCPobj.showpagehashtop(); 
//testing for detail part
MDCPobj.DetailFieldName='Name';
MDCPobj.DetailRowValue='0';
MDCPobj.GetDetails();
MDCPobj.DetailFieldName='Domestic_DUNS__c';
MDCPobj.GetDetails();
MDCPobj.DetailFieldName='Global_DUNS__c';
MDCPobj.GetDetails();
MDCPCalloutHelper.CAccount CAccDisplay=new MDCPCalloutHelper.CAccount();
CAccDisplay.Name='testcase';
CAccDisplay.City='testcity';
CAccDisplay.Country ='testcountry';
CAccDisplay.Street='teststreet';
CAccDisplay.State='teststate';
CAccDisplay.PostalCode='123456';
CAccDisplay.OutofBusinessIndicator =true;
CAccDisplay.Region ='teststate';
MDCPobj.setCAccDisplay(CAccDisplay);
//MDCPobj.accLink();
MDCPobj.hidecaselink();
//MDCPobj.showPopup();

MDCPobj.createNewUnverifiedAccount();
MDCPobj.IsNewAccountCreated=false;
MDCPobj.createNewCase();
MDCPobj.MDCPEntity='Competitor';
MDCPobj.competitorRegion='Americas';
MDCPobj.createNewCase();
MDCPobj.MDCPEntity='Competitor';
MDCPobj.competitorRegion='EMEA'; 
MDCPobj.createNewCase();
MDCPobj.MDCPEntity='Competitor';
MDCPobj.competitorRegion='Asia Pacific';
MDCPobj.createNewCase();
MDCPobj.DetailFieldName='MDCPId';  
//MDCPobj.accLink();
MDCPobj.MDCPEntity='';
//MDCPobj.accLink();
MDCPobj.getIsMDCPDown();
MDCPobj.getsearchResultByPage();
MDCPobj.getPagenumberRequested();
MDCPobj.getCurrentPageDisplayed();
MDCPobj.gettotalPages();
MDCPobj.getoptionsList();
MDCPobj.geterrormessage();
MDCPobj.getCAccDisplay();
MDCPobj.getisCompetitorSearch();
MDCPobj.getcaseRequestMsg();
MDCPobj.getdetailsection();
MDCPobj.getCurrentPageDisplayed();
MDCPobj.getselectedPage();
MDCPobj.getIsNewAccountCreated();
MDCPobj.getnewUnverifiedAccountID();
MDCPobj.getaccountID();
MDCPobj.getPopupInfo_Rows();
MDCPobj.getshowAvailabilyStatus();
MDCPobj.getshowRecordStatus();
MDCPobj.getpermissionCreateAccount();
MDCPobj.getisSFDCAccount();
MDCPobj.hideAccountlink();
}
catch(exception e){}
}
}