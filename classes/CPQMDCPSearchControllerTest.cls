@isTest (seeAllData=true)
private class CPQMDCPSearchControllerTest{
    static testMethod void validateMDCPController() {
        List<Support_Request__c> listSR = new List<Support_Request__c>{};
        Support_Request__c  sRequest = new Support_Request__c();
        listSR.add(sRequest);
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(listSR);
        CPQMDCPSearchController MDCPobj = new CPQMDCPSearchController(ssc);
        String response = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Header /><SOAP-ENV:Body><ns0:organizationAccountSearchResponse xmlns:ns0="http://www.tibco.com/schemas/MDCP2SFDC-LookUp/Schemas/accountSearchList.xsd"><ns0:organizationAccountSearchDocuments><ns0:totalDocuments>5</ns0:totalDocuments><ns0:documents><ns0:organizationAccountSearchResult><ns0:organizationExtendedName>RYDALL BAY PTY. LTD.</ns0:organizationExtendedName><ns0:organizationNonLatinExtendedName /><ns0:organizationId>108821910</ns0:organizationId><ns0:duns>752929356</ns0:duns><ns0:globalDuns ns1:nil="true" xmlns:ns1="http://www.w3.org/2001/XMLSchema-instance" /><ns0:domesticDuns ns2:nil="true" xmlns:ns2="http://www.w3.org/2001/XMLSchema-instance" /><ns0:latinStreet1LongName>395 COLLINS ST</ns0:latinStreet1LongName><ns0:nonlatinStreet1LongName ns3:nil="true" xmlns:ns3="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countryName>Australia</ns0:countryName><ns0:state>Victoria</ns0:state><ns0:latinCity>MELBOURNE</ns0:latinCity><ns0:nonlatinCity ns4:nil="true" xmlns:ns4="http://www.w3.org/2001/XMLSchema-instance" /><ns0:postalCode>3000</ns0:postalCode><ns0:amid2 ns5:nil="true" xmlns:ns5="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countOfEmployee ns6:nil="true" xmlns:ns6="http://www.w3.org/2001/XMLSchema-instance" /><ns0:onlyPresaleCustomer>false</ns0:onlyPresaleCustomer><ns0:deletionIndicator>false</ns0:deletionIndicator><ns0:isOutOfBusiness>false</ns0:isOutOfBusiness><ns0:isGlobalAccount>false</ns0:isGlobalAccount><ns0:worldRegion>Australia</ns0:worldRegion><ns0:taxId ns7:nil="true" xmlns:ns7="http://www.w3.org/2001/XMLSchema-instance" /><ns0:siteId>6143010</ns0:siteId><ns0:countryCode>AU</ns0:countryCode></ns0:organizationAccountSearchResult><ns0:organizationAccountSearchResult><ns0:organizationExtendedName>Rydall, Darwin Builder</ns0:organizationExtendedName><ns0:organizationNonLatinExtendedName /><ns0:organizationId>47226338</ns0:organizationId><ns0:duns>200200488</ns0:duns><ns0:globalDuns ns1:nil="true" xmlns:ns1="http://www.w3.org/2001/XMLSchema-instance" /><ns0:domesticDuns ns2:nil="true" xmlns:ns2="http://www.w3.org/2001/XMLSchema-instance" /><ns0:latinStreet1LongName>278 RYDALL MILL RD</ns0:latinStreet1LongName><ns0:nonlatinStreet1LongName ns3:nil="true" xmlns:ns3="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countryName>Canada</ns0:countryName><ns0:state ns4:nil="true" xmlns:ns4="http://www.w3.org/2001/XMLSchema-instance" /><ns0:latinCity>ECHO BAY</ns0:latinCity><ns0:nonlatinCity ns5:nil="true" xmlns:ns5="http://www.w3.org/2001/XMLSchema-instance" /><ns0:postalCode>P0S 1C0</ns0:postalCode><ns0:amid2 ns6:nil="true" xmlns:ns6="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countOfEmployee ns7:nil="true" xmlns:ns7="http://www.w3.org/2001/XMLSchema-instance" /><ns0:onlyPresaleCustomer>false</ns0:onlyPresaleCustomer><ns0:deletionIndicator>false</ns0:deletionIndicator><ns0:isOutOfBusiness>true</ns0:isOutOfBusiness><ns0:isGlobalAccount>false</ns0:isGlobalAccount><ns0:worldRegion>Canada</ns0:worldRegion><ns0:taxId ns8:nil="true" xmlns:ns8="http://www.w3.org/2001/XMLSchema-instance" /><ns0:siteId>4248031</ns0:siteId><ns0:countryCode>CA</ns0:countryCode></ns0:organizationAccountSearchResult><ns0:organizationAccountSearchResult><ns0:organizationExtendedName>Rydall, Darwin Builder</ns0:organizationExtendedName><ns0:organizationNonLatinExtendedName /><ns0:organizationId>47226338</ns0:organizationId><ns0:duns>200200488</ns0:duns><ns0:globalDuns ns1:nil="true" xmlns:ns1="http://www.w3.org/2001/XMLSchema-instance" /><ns0:domesticDuns ns2:nil="true" xmlns:ns2="http://www.w3.org/2001/XMLSchema-instance" /><ns0:latinStreet1LongName>278 RYDALL MILL RD</ns0:latinStreet1LongName><ns0:nonlatinStreet1LongName ns3:nil="true" xmlns:ns3="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countryName>Canada</ns0:countryName><ns0:state>Ontario</ns0:state><ns0:latinCity>ECHO BAY</ns0:latinCity><ns0:nonlatinCity ns4:nil="true" xmlns:ns4="http://www.w3.org/2001/XMLSchema-instance" /><ns0:postalCode>P0S 1C0</ns0:postalCode><ns0:amid2 ns5:nil="true" xmlns:ns5="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countOfEmployee ns6:nil="true" xmlns:ns6="http://www.w3.org/2001/XMLSchema-instance" /><ns0:onlyPresaleCustomer>false</ns0:onlyPresaleCustomer><ns0:deletionIndicator>false</ns0:deletionIndicator><ns0:isOutOfBusiness>false</ns0:isOutOfBusiness><ns0:isGlobalAccount>false</ns0:isGlobalAccount><ns0:worldRegion>Canada</ns0:worldRegion><ns0:taxId ns7:nil="true" xmlns:ns7="http://www.w3.org/2001/XMLSchema-instance" /><ns0:siteId>6046104</ns0:siteId><ns0:countryCode>CA</ns0:countryCode></ns0:organizationAccountSearchResult><ns0:organizationAccountSearchResult><ns0:organizationExtendedName>Rydall Penthos School</ns0:organizationExtendedName><ns0:organizationNonLatinExtendedName /><ns0:organizationId>93954111</ns0:organizationId><ns0:duns>233445894</ns0:duns><ns0:globalDuns ns1:nil="true" xmlns:ns1="http://www.w3.org/2001/XMLSchema-instance" /><ns0:domesticDuns ns2:nil="true" xmlns:ns2="http://www.w3.org/2001/XMLSchema-instance" /><ns0:latinStreet1LongName>PWLLYCROCHAN AVENUE</ns0:latinStreet1LongName><ns0:nonlatinStreet1LongName ns3:nil="true" xmlns:ns3="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countryName>United Kingdom</ns0:countryName><ns0:state ns4:nil="true" xmlns:ns4="http://www.w3.org/2001/XMLSchema-instance" /><ns0:latinCity>COLWYN BAY</ns0:latinCity><ns0:nonlatinCity ns5:nil="true" xmlns:ns5="http://www.w3.org/2001/XMLSchema-instance" /><ns0:postalCode>LL29 7BT</ns0:postalCode><ns0:amid2 ns6:nil="true" xmlns:ns6="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countOfEmployee ns7:nil="true" xmlns:ns7="http://www.w3.org/2001/XMLSchema-instance" /><ns0:onlyPresaleCustomer>true</ns0:onlyPresaleCustomer><ns0:deletionIndicator>false</ns0:deletionIndicator><ns0:isOutOfBusiness>false</ns0:isOutOfBusiness><ns0:isGlobalAccount>false</ns0:isGlobalAccount><ns0:worldRegion>UK &amp; I</ns0:worldRegion><ns0:taxId ns8:nil="true" xmlns:ns8="http://www.w3.org/2001/XMLSchema-instance" /><ns0:siteId>10694615</ns0:siteId><ns0:countryCode>GB</ns0:countryCode></ns0:organizationAccountSearchResult><ns0:organizationAccountSearchResult><ns0:organizationExtendedName>RYDALL BAY PTY. LTD.</ns0:organizationExtendedName><ns0:organizationNonLatinExtendedName /><ns0:organizationId>108821910</ns0:organizationId><ns0:duns>752929356</ns0:duns><ns0:globalDuns ns1:nil="true" xmlns:ns1="http://www.w3.org/2001/XMLSchema-instance" /><ns0:domesticDuns ns2:nil="true" xmlns:ns2="http://www.w3.org/2001/XMLSchema-instance" /><ns0:latinStreet1LongName>395 COLLINS ST</ns0:latinStreet1LongName><ns0:nonlatinStreet1LongName ns3:nil="true" xmlns:ns3="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countryName>Australia</ns0:countryName><ns0:state ns4:nil="true" xmlns:ns4="http://www.w3.org/2001/XMLSchema-instance" /><ns0:latinCity>MELBOURNE</ns0:latinCity><ns0:nonlatinCity ns5:nil="true" xmlns:ns5="http://www.w3.org/2001/XMLSchema-instance" /><ns0:postalCode>3000</ns0:postalCode><ns0:amid2 ns6:nil="true" xmlns:ns6="http://www.w3.org/2001/XMLSchema-instance" /><ns0:countOfEmployee ns7:nil="true" xmlns:ns7="http://www.w3.org/2001/XMLSchema-instance" /><ns0:onlyPresaleCustomer>false</ns0:onlyPresaleCustomer><ns0:deletionIndicator>false</ns0:deletionIndicator><ns0:isOutOfBusiness>true</ns0:isOutOfBusiness><ns0:isGlobalAccount>false</ns0:isGlobalAccount><ns0:worldRegion>Australia</ns0:worldRegion><ns0:taxId ns8:nil="true" xmlns:ns8="http://www.w3.org/2001/XMLSchema-instance" /><ns0:siteId>2521543</ns0:siteId><ns0:countryCode>AU</ns0:countryCode></ns0:organizationAccountSearchResult></ns0:documents></ns0:organizationAccountSearchDocuments></ns0:organizationAccountSearchResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
        CPQMDCPSearchController.searchWrapper wrapper = new CPQMDCPSearchController.searchWrapper();
        CPQMDCPSearchController.searchWrapper wrapper1 = new CPQMDCPSearchController.searchWrapper();
        MDCPobj.rowNumber = 0;
        MDCPobj.IsMDCPDown = false;
        wrapper.searchText = 'Raju';
        wrapper.selectedItem = 'Name';
        wrapper1.searchText = 'Ra';
        wrapper1.selectedItem = 'Country';
        MDCPobj.PagenumberRequested = 1;
        MDCPobj.selectedPage ='1';
        MDCPobj.setRowNumber(1);
        MDCPobj.getRowNumber();
        MDCPobj.getoptionsList();
        MDCPobj.getCurrentPageDisplayed();
        MDCPobj.gettotalPages();
        MDCPobj.geterrorMessage();
        MDCPobj.getdetailSection();
        MDCPobj.listWrap.add(wrapper);
        MDCPobj.searchResult();
        Test.setMock(HttpCalloutMock.class, new MDCPMockHttpResponseGenerator());
        MDCPobj.totalPages=0;
        MDCPobj.searchResult();
        MDCPobj.listWrap.add(wrapper1);
        MDCPobj.searchResult();
        wrapper.searchText = 'R';
        wrapper.selectedItem = 'Name';
        MDCPobj.searchResult();
        wrapper.searchText = 'R';
        wrapper.selectedItem = 'Is Competitor';
        MDCPobj.searchResult();
        //parsing completin
        MDCPCalloutHelper webclass = new MDCPCalloutHelper();
        webclass.Parserequest(response);
        MDCPobj.addrow();
        MDCPobj.delrow();
        MDCPobj.clearInputs();
        MDCPobj.getIsMDCPDown();
        MDCPobj.getsearchResultByPage();
        MDCPobj.getPagenumberRequested();
        list<MDCPResult__c> searchresult=new list<MDCPResult__c>();
        MDCPResult__c val=new MDCPResult__c();
        val.Address__c = 'abc';
        val.City__c = 'BLR';
        val.State__c = 'KA';
        searchresult.add(val);
        system.debug('searchresult======='+searchresult);
        MDCPobj.searchResultByPage =new list<MDCPResult__c>();
        MDCPobj.searchResultByPage.add(val);
        MDCPobj.searchResult =new list<MDCPResult__c>();
        MDCPobj.searchResult.add(val);
        MDCPobj.sortBy ='name';
        MDCPobj.Flipsort='asc';
        MDCPobj.addressPopulation();
        MDCPobj.showpagehashtop();
        MDCPobj.SortByFieldName();
    }
}