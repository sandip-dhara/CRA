/**
 * Class Name: CPQMDCPSearchController
 * Author: HP - Nagaraju
 * Date: 27-June-2013 
 * Description: Contains CPQ MDCP Search Information used for CPQMDCPSearchPage
 */

public class CPQMDCPSearchController{
    public List<SelectOption> searchItems { get;set; }
    public List<searchWrapper> listWrap{ get;set;}
    public Set<String> listItems = new Set<String>();
    public Map<String,String> labelMaps;
    public String secName {get;set;}
    public Boolean errorMsg {get;set;}
    public Boolean errorMsg1;
    public Integer listSize {get;set;}
    public String countryName { get;set;}
    public Integer rowNumber;
    public String address {get;set;}
    public String city1 {get;set;}
    public String state {get;set;}
    public String postalCode {get;set;}
    public Map<String,String> mapCountryWithWorldRegion = new Map<String,String>();
    public Integer getRowNumber(){
        return rowNumber;
    }
    public void setRowNumber(Integer rowNumber){
        this.rowNumber = rowNumber;
    }
    public Integer totalRecords {get;set;}
    public Boolean IsMDCPDown{get;set;}
    public Integer currentPageListSize {get;set;}
    public List<String> listFieldToShow {get;set;}
    public Map<String , String> mapFieldToShow{get;set;}
    public String selectedPage {get;set;}
    public Integer startIndexDisplayed {get;set;}
    public Integer endIndexDisplayed {get;set;}
    public String sortBy {get;set;}
    public String flipSort {get;set;}
    public  String lastSortDirection;//variable to check sort direction
    public String DetailFieldName {get;set;}
    public String DetailRowValue {get;set;}

    public List<SelectOption> optionsList {get;set;}
    public List<SelectOption> getoptionsList(){
        return optionsList;
    }
    public Integer PagenumberRequested {get;set;}
    public Integer getPagenumberRequested(){
        return PagenumberRequested;} 
    public Integer CurrentPageDisplayed {get;set;}
    public Integer getCurrentPageDisplayed(){
        return CurrentPageDisplayed ;}
    public Integer totalPages {get;set;}
    public Integer gettotalPages(){
        return totalPages;
    }
    public String errorMessage{get;set;}
    public String geterrorMessage(){
        return errorMessage;
    }
    public Boolean detailSection{get;set;}
    public Boolean getdetailSection(){
        return detailSection;
    }
    public Boolean getIsMDCPDown(){
        return IsMDCPDown;
    }
    public List<MDCPResult__c>searchResult {get;set;}
    public List<MDCPResult__c>searchResultByPage {get;set;}
    public List<MDCPResult__c>getsearchResultByPage(){
        return searchResultByPage;
    }

    public class searchWrapper{
        public String selectedItem {get;set;}
        public String searchText {get;set;}
        public searchWrapper ( ){
        }
    }

    public CPQMDCPSearchController(ApexPages.StandardSetController controller) {
        secName = ApexPages.currentPage().getParameters().get('secName'); 
        listWrap= new List<searchWrapper>();
        searchItems = new List<SelectOption>();
        labelMaps = new Map<String,String>();
        IsMDCPDown=false;
        flipSort='desc'; 
        lastSortDirection='';
        searchItems.add(new SelectOption('' ,'<Choose Field>'));
        for(string labelValue : SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',Label.CPQMDCPSearchLabel)){
            List<String> listLabels = labelValue.split(':');
            listItems.add(listLabels[0]);
            labelMaps.put(listLabels[0],listLabels[1]);
        }    
        //listItems.sort();    
        for(string searchField : listItems){
            searchItems.add(new SelectOption(searchField,searchField));
        }
        for(World_Region__c objWorldRegion : [select id,Name,Region__c,Sub_Region1__c,Country_Name__c from World_Region__c where Country_Name__c != '' order by Country_Name__c]){
            mapCountryWithWorldRegion.put(objWorldRegion.Country_Name__c,objWorldRegion.Name);
        }
        searchItems.sort();
        searchWrapper wrapper = new searchWrapper();
        wrapper.searchText = ApexPages.currentPage().getParameters().get('MDCPID');
        wrapper.selectedItem = 'MDCP Id';
        listWrap.add(wrapper);
        errorMsg = false;
        searchResult();
    }

    public Pagereference addRow(){
        listWrap.add(new searchWrapper());
        return null;
    }
    public Pagereference delRow(){
        if(listWrap != null)
        listWrap.remove(rowNumber);   
        return null;
    }
    public Pagereference clearInputs(){
        for(Integer i = 0;i<listWrap.size();i++)
            listWrap.get(i).searchText = ' ';
        return null;
    }
    public pageReference searchResult(){
        String errorFields1 = '';
        String errorFields2 = '';
        IsMDCPDown=false;
        String MDCPQuery = ' ';
        CurrentPageDisplayed =1;
        PagenumberRequested =1;
        errorMsg = false;
        errorMsg1 = true;
        //CPQMDCPSearchController MDCPSearch = new CPQMDCPSearchController();
        List<String> searchInputs = new List<String>();
        List<String> searchInputs2 = new List<String>();
        for(searchWrapper wrapper:listWrap){
            if(wrapper.searchText != null && wrapper.searchText != ''){
                MDCPQuery = MDCPQuery+labelMaps.get(wrapper.selectedItem)+':(+'+wrapper.searchText+') AND ';
                if((wrapper.selectedItem  == 'City'  || wrapper.selectedItem  == 'Country') && wrapper.searchText.length()<3){
                    errorFields1 = errorFields1 +' '+wrapper.selectedItem+',';
                    errorMsg = true;
                }
                if((wrapper.selectedItem == 'Name' || wrapper.selectedItem == 'Postal Code' || wrapper.selectedItem == 'State / Province' || wrapper.selectedItem == 'Tax ID') && wrapper.searchText.length()<2){
                    errorFields2 = errorFields2 +' '+wrapper.selectedItem+',';
                    errorMsg = true;
                }
                if(wrapper.selectedItem == 'Is Competitor' && (!wrapper.searchText.equalsIgnoreCase('y') && !wrapper.searchText.equalsIgnoreCase('n'))){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Is Competitor values must be y or n'));
                    errorMsg = true;
                    return null;
                }
                if((wrapper.selectedItem == 'Name' || wrapper.selectedItem == 'Tax ID' || wrapper.selectedItem == 'DUNS' || wrapper.selectedItem == 'MDCP Id') && (wrapper.searchText != null && wrapper.searchText != '')){
                    errorMsg1 = false;
                }
            }
        }
        MDCPQuery = MDCPQuery.removeEnd(' AND ');
        if(errorMsg){
            if(errorFields1 != null && errorFields1 !=''){
                errorFields1 = errorFields1.removeEnd(',');
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorFields1+': Must be having minimum 3 charecters'));
            }
            if(errorFields2 != null && errorFields2 !=''){
                errorFields2 = errorFields2.removeEnd(',');
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorFields2+': Must be having minimum 2 charecters'));
            }
            return null;
        }
        if(errorMsg1){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'At least either one of Name, Tax, MDCP Id, or DUNS must be specified'));
            errorMsg = true;
            return null;
        }
        searchWrapper wrapper1 = new searchWrapper();
        //MDCPQuery = 'latinCity:(+'+MDCPSearch.City+') AND duns:(+'+MDCPSearch.DUNS+') AND organizationId:(+'+MDCPSearch.MDCP_ID+') AND organizationExtendedName:(+'+MDCPSearch.Name+') AND state:(+'+MDCPSearch.State_Prov+') AND postalCode:(+'+MDCPSearch.Postal_Code+') AND taxId:(+'+MDCPSearch.Tax_Id+') AND isCompetitor:(+'+MDCPSearch.Is_Competitor+') AND countryName:(+'+MDCPSearch.Country+')';
        System.debug('**Latest MDCP Query**'+MDCPQuery);
        String RequestHead='<soapenv:Envelope xmlns:acc="http://www.tibco.com/schemas/MDCP2SFDC-LookUp/Schemas/accountSearchList.xsd" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-1" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:Username>'+Label.MDCP_TIBCO_Username+'</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">'+Label.MDCP_TIBCO_Password+'</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">GP8scgWOc0eAEONuwIuknw==</wsse:Nonce><wsu:Created>2013-01-10T06:34:37.979Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><acc:accountSearchListInput><acc:query>';
        String RequestTail='</acc:query><acc:offset>0</acc:offset><acc:limit>200</acc:limit></acc:accountSearchListInput></soapenv:Body></soapenv:Envelope>';
        String RequestBody=RequestHead+MDCPQuery+RequestTail;
        String response=sendRequest(RequestBody,Label.MDCPRequestEndPoint,Label.MDCPRequestAction,'Search');
        //  String response='<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Header /><SOAP-ENV:Body><ns0:organizationAccountSearchResponse xmlns:ns0="http://www.tibco.com/schemas/MDCP2SFDC-LookUp/Schemas/accountSearchList.xsd"><ns0:errorMessage>No response from MDCP WS</ns0:errorMessage></ns0:organizationAccountSearchResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';  
        if(response!=null){
            if(response=='mdcpdown'){
                IsMDCPDown=true;currentPageListSize=null;errorMessage='The Account Lookup service is down. Please try your search again in 10 minutes. If the issue persists, please open a case to MDCP team';
            }else if(response=='faultyinput'){
                IsMDCPDown=true;
                currentPageListSize=null;
                errorMessage='Invalid Input';
            }else{
                if(totalRecords!=null){
                    searchResult.clear();
                }
                MDCPCalloutHelper webclass = new MDCPCalloutHelper();
                searchResult=webclass.Parserequest(response);
                if(searchResult!=null)
                {/*no action needed*/}else{
                    IsMDCPDown=true;currentPageListSize=null;errorMessage='The Account Lookup service is down. Please try your search again in 10 minutes. If the issue persists, please open a case to MDCP team';
                }
            }
        }else{
            currentPageListSize=null;
        }
        if(!IsMDCPDown){    
            totalRecords=searchResult.size();
            listFieldToShow = new List<String>();
            listFieldToShow.add('Name');
            listFieldToShow.add('Non_LatinName__c');   
            listFieldToShow.add('Address__c');
            listFieldToShow.add('City__c');
            listFieldToShow.add('State__c');
            listFieldToShow.add('Postal_Code__c');
            listFieldToShow.add('Country__c');                   
            listFieldToShow.add('MDCP_Id__c');
            listFieldToShow.add('DUNS__c');
            listFieldToShow.add('Domestic_DUNS__c');
            listFieldToShow.add('Global_DUNS__c');
            listFieldToShow.add('Tax_ID__c');
            listFieldToShow.add('Is_Competitor__c');        
            listFieldToShow.add('isOutOfBusiness__c');
            mapFieldToShow = new Map<String , String>();
            mapFieldToShow.put( 'Name','Name');
            mapFieldToShow.put('Non_LatinName__c','Non_LatinName__c');    
            mapFieldToShow.put( 'Address__c','Address__c');
            mapFieldToShow.put( 'City__c','City__c');
            mapFieldToShow.put( 'State__c','State__c');
            mapFieldToShow.put('Postal_Code__c','Postal_Code__c');
            mapFieldToShow.put( 'Country__c','Country__c');
            mapFieldToShow.put('MDCP_Id__c','MDCP_Id__c');
            mapFieldToShow.put('DUNS__c','DUNS__c');
            mapFieldToShow.put('Domestic_DUNS__c','Domestic_DUNS__c');
            mapFieldToShow.put('Global_DUNS__c','Global_DUNS__c');
            mapFieldToShow.put('Tax_ID__c','Tax_ID__c');
            mapFieldToShow.put('Is_Competitor__c','Is_Competitor__c');
            mapFieldToShow.put('isOutOfBusiness__c','isOutOfBusiness__c');
            totalRecords=searchResult.size();
            totalPages= Math.ceil((Double)(searchResult.size()) / 15).intValue();
            optionsList  = new List<SelectOption>();   
            for(Integer i=1;i<=totalPages;i++){
                optionsList.add(new SelectOption(String.valueof(i),String.valueof(i)));
            }
            PagenumberRequested=CurrentPageDisplayed;   
            if((PagenumberRequested)*15>searchResult.size()){
                endIndexDisplayed =(totalPages-1)*15+(15-(totalPages*15-searchResult.size()));
            }else{
                endIndexDisplayed =PagenumberRequested*15;
            }
            searchResultByPage =new List<MDCPResult__c>(); 
            for(Integer i=(CurrentPageDisplayed-1)*15;i<endIndexDisplayed ;i++){
                searchResultByPage.add(searchResult.get(i));    
            }   
            currentPageListSize=searchResultByPage.size();
        }
        return null;
    }
    public String sendRequest(String Requestbody,String EndPoint,String RequestAction,String method){
        String responseXML;
        Integer responsecode; 
        try{
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(EndPoint);
            req.setHeader('Content-Type','text/xml');
            req.setHeader('SOAPAction',RequestAction);
            req.setTimeout(40000);
            req.setClientCertificateName(Label.SFDC_Certificate);
            req.setBody(Requestbody);
            Http http = new Http();
            HttpResponse res = null;
            DOM.Document doc1 = new DOM.Document();
            res = http.send(req);  
            responsecode=res.getStatusCode(); 
            if(responsecode!=200){
                IsMDCPDown=true;
                if(method=='Search'){
                    errorMessage='The Account Lookup service is down. Please try your search again in 10  minutes. If the issue persists, please open a case to Tibco / SFDC team.';
                }else{
                    errorMessage='The Account Detail Lookup service is down. Please try  again in 10  minutes. If the issue persists, please open a case to Tibco / SFDC team.';
                }  
                return null;
            }else{
                doc1 = res.getBodyDocument();
                responseXML= doc1.toXmlString();
            } 
        }catch (Exception ex) {
            System.debug('exception message=========>'+ex.getMessage());
            if(ex.getMessage().contains('timed out')){ 
                responseXML=null;
                IsMDCPDown=true;
                if(method=='Search'){
                    errorMessage='The Account Lookup service is down. Please try your search again in 10  minutes. If the issue persists, please open a case to Tibco / SFDC team.';
                }else{
                    errorMessage='The Account Detail Lookup service is down. Please try  again in 10  minutes. If the issue persists, please open a case to Tibco / SFDC team.';
                }  
            }else {
                responseXML='faultyinput';
            }
        } 
        return responseXML;  
    }
    Public void showpagehashtop() {
        detailSection=false;
        searchResultByPage.clear();
        PagenumberRequested=Integer.valueof(selectedPage);
        CurrentPageDisplayed=PagenumberRequested;  
        startIndexDisplayed=(PagenumberRequested-1)*15;         
        if(((PagenumberRequested))*15>searchResult.size()){
            endIndexDisplayed =(totalPages-1)*15+(15-(totalPages*15-searchResult.size()));
        }else{
            endIndexDisplayed =(PagenumberRequested)*15;
        }
        searchResultByPage =new List<MDCPResult__c>(); 
        for(Integer i=startIndexDisplayed;i<endIndexDisplayed ;i++){
            searchResultByPage.add(searchResult.get(i));    
        } 
        currentPageListSize=searchResultByPage.size();
    }
    Public void SortByFieldName() {
        CurrentPageDisplayed=1;
        if((flipSort=='asc')&&(lastSortDirection.compareTo(sortBy)==0)){
            flipSort='desc';
        }else{
            flipSort='asc';
        }
        lastSortDirection=sortBy;
        selectedPage ='1';
        MDCPSortHelper.sortList(searchResult,sortBy,flipSort);
        searchResultByPage.clear();
        if(searchResult.size()<15){
            for(Integer i=0;i<searchResult.size();i++){
                searchResultByPage.add(searchResult.get(i));    
            }  
        }else{
            for(Integer i=0;i<15;i++){
                searchResultByPage.add(searchResult.get(i));    
            } 
        }       
        currentPageListSize=searchResultByPage.size();   
    }
    public void addressPopulation(){
        if(DetailFieldName == 'Address__c')
            rowNumber=(rowNumber-1)/14;
        else rowNumber = rowNumber/14;    
        address = searchResultByPage.get(rowNumber).Address__c;
        city1 = searchResultByPage.get(rowNumber).City__c;
        state = searchResultByPage.get(rowNumber).State__c;
        countryName = mapCountryWithWorldRegion.get(searchResultByPage.get(rowNumber).Country__c);        
        postalCode = searchResultByPage.get(rowNumber).Postal_code__c;
    } 
}