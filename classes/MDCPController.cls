/**********************************************************
* Class Name: MDCPController 
* Author: Vijay Ranjan
* Date: 28-May-2013 
* Description: Controller class to search Accounts in MDCP
*               in MDCP. 
***********************************************************/
public class MDCPController{
public String MDCPQuery{get;set;}
public List<MDCPResult__c>searchResult {get;set;}
public Integer startIndexDisplayed {get;set;}
public Integer endIndexDisplayed {get;set;}
public Boolean detailSection{get;set;}
public Boolean getdetailSection(){
    return detailSection;
}
public List<MDCPResult__c>searchResultByPage {get;set;}
public List<MDCPResult__c>getsearchResultByPage(){
    return searchResultByPage;
}
public Integer PagenumberRequested{get;set;}
public Integer getPagenumberRequested(){
return PagenumberRequested;} 
public Integer CurrentPageDisplayed {get;set;}
public Integer getCurrentPageDisplayed(){
return CurrentPageDisplayed ;}
public Integer totalPages {get;set;}
public Integer gettotalPages(){
return totalPages;
}
public Integer totalRecords {get;set;}
public Integer currentPageListSize {get;set;}
public Integer SelectedSearchRow;
public String sortBy {get;set;}
public List<String> listFieldToShow {get;set;}
public Map<String , String> mapFieldToShow{get;set;}
public String flipSort {get;set;}
public List<SelectOption> optionsList {get;set;}
public List<SelectOption> getoptionsList(){
return optionsList;
}
public String selectedPage{get;set;}
public String getselectedPage(){
return selectedPage;}
public String errorMessage{get;set;}
public String geterrorMessage(){
return errorMessage;}
public Boolean IsMDCPDown{get;set;}
public Boolean getIsMDCPDown(){
return IsMDCPDown;
}
Public Boolean isSFDCAccount{get;set;}
public Boolean getisSFDCAccount(){
return isSFDCAccount;
}
Public Boolean permissionCreateAccount{get;set;}
public Boolean getpermissionCreateAccount(){
return permissionCreateAccount;
}
Public Boolean showRecordStatus{get;set;}
public Boolean getshowRecordStatus(){
return showRecordStatus;
}
Public Boolean showAvailabilyStatus{get;set;}
public Boolean getshowAvailabilyStatus(){
return showAvailabilyStatus;
}

public String PopupInfo_Rows{get;set;}
public String getPopupInfo_Rows(){
return PopupInfo_Rows;
}
public  String lastSortDirection;//variable to check sort direction
public String DetailFieldName {get;set;}
public String DetailFieldValue {get;set;}
public String DetailRowValue {get;set;}
public String DetailsiteId {get;set;}
public String accountID{get;set;}
public String getaccountID(){
return accountID;
}
public String newUnverifiedAccountID{get;set;}
public String getnewUnverifiedAccountID(){
return newUnverifiedAccountID;
}
public String orgId{get;set;}
public Boolean displayPopup {get;set;}   
public MDCPCalloutHelper.CAccount CAccDisplay{get;set;}
public MDCPCalloutHelper.CAccount getCAccDisplay(){
    return CAccDisplay;
}
public void setCAccDisplay(MDCPCalloutHelper.CAccount val){
    CAccDisplay=val;
}
public Boolean isCompetitorSearch{get;set;}
public Boolean getisCompetitorSearch(){
return isCompetitorSearch;
}
public String caseRequestMsg{get;set;}
public String getcaseRequestMsg(){
return caseRequestMsg;
}
public Boolean isCaseNeeded{get;set;}
public Boolean isCaseCreated{get;set;}
public Boolean IsNewAccountCreated{get;set;}
public Boolean getIsNewAccountCreated(){
return IsNewAccountCreated;
}
public Boolean isCaseCreationFailed{get;set;}
public String failureMessage{get;set;}
public Case caseRecord{get;set;} 
public Case caseRecordRet{get;set;}
public String competitorRegion {get;set;}
public String MDCPEntity{get;set;}

/************@constructor for Mdcp Controller*****************************/
public MDCPController(ApexPages.StandardSetController controller) {
    CurrentPageDisplayed =1;
    PagenumberRequested =1;
    IsMDCPDown=false;
    detailSection=false;
    flipSort='desc'; 
    lastSortDirection='';
    SelectedSearchRow=0;
    showRecordStatus=false;
    showAvailabilyStatus=false;
/**************@Detai part's initialization****************/
    isCaseNeeded = false;
    isCaseCreated = false;
    isCaseCreationFailed = false;
    //caseRecord = new Case();
    caseRecordRet = new Case();
    MDCPEntity= apexpages.currentpage().getparameters().get('entity');
    if(MDCPEntity=='Competitor'){
        competitorRegion = apexpages.currentpage().getparameters().get('Region');
        isCompetitorSearch=true;
    }
}
/**************@Function to perform the Seach******************************/
public void search() {
    IsMDCPDown=false;
    CurrentPageDisplayed =1;
    PagenumberRequested =1;
    selectedPage='1';
    CheckAccountCreatePermission();
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
        listFieldToShow.add('CityRegion__c');        
        listFieldToShow.add('State__c');
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
        mapFieldToShow.put( 'CityRegion__c','CityRegion__c');        
        mapFieldToShow.put( 'State__c','State__c');
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
           PopupInfo_Rows='';
           for(Integer i=(CurrentPageDisplayed-1)*15;i<endIndexDisplayed ;i++){
           searchResultByPage.add(searchResult.get(i));
           if(searchResult[i].Non_LatinName__c!=null){ 
           PopupInfo_Rows=PopupInfo_Rows+searchResult[i].Non_LatinName__c+'+$';
           }else{
           PopupInfo_Rows=PopupInfo_Rows+'NA+$';           
           }
           if(searchResult[i].Organization_ReportingName__c!=null){
           PopupInfo_Rows=PopupInfo_Rows+searchResult[i].Organization_ReportingName__c+'+$';
           }else{
           PopupInfo_Rows=PopupInfo_Rows+'NA+$';
           }
           if(searchResult[i].Organization_LegalName__c!=null){
           PopupInfo_Rows=PopupInfo_Rows+searchResult[i].Organization_LegalName__c+'+$';
           }else{
           PopupInfo_Rows=PopupInfo_Rows+'NA+$';
           }
   
           } 
    currentPageListSize=searchResultByPage.size();
    }
  //  system.debug('searchResultByPage====='+searchResultByPage);
}
/************@Function to  Send Http Request *******************************/
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
        system.debug('responseXML=='+responseXML);
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


/***********@Function to display requested page within the result************/
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
           PopupInfo_Rows='';
           for(Integer i=(CurrentPageDisplayed-1)*15;i<endIndexDisplayed ;i++){
           searchResultByPage.add(searchResult.get(i));
           if(searchResult[i].Non_LatinName__c!=null){ 
           PopupInfo_Rows=PopupInfo_Rows+searchResult[i].Non_LatinName__c+'+$';
           }else{
           PopupInfo_Rows=PopupInfo_Rows+'NA+$';           
           }
           if(searchResult[i].Organization_ReportingName__c!=null){
           PopupInfo_Rows=PopupInfo_Rows+searchResult[i].Organization_ReportingName__c+'+$';
           }else{
           PopupInfo_Rows=PopupInfo_Rows+'NA+$';
           }
           if(searchResult[i].Organization_LegalName__c!=null){
           PopupInfo_Rows=PopupInfo_Rows+searchResult[i].Organization_LegalName__c+'+$';
           }else{
           PopupInfo_Rows=PopupInfo_Rows+'NA+$';
           }
              
           }  
        currentPageListSize=searchResultByPage.size();
}  
/************@Function to  sort the list with given field name  ************/
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
        PopupInfo_Rows='';
        if(searchResult.size()<15){
             for(Integer i=0;i<searchResult.size();i++){
               searchResultByPage.add(searchResult.get(i));
               if(searchResult[i].Non_LatinName__c!=null){ 
               PopupInfo_Rows=PopupInfo_Rows+searchResult[i].Non_LatinName__c+'+$';
               }else{
               PopupInfo_Rows=PopupInfo_Rows+'NA+$';           
               }
               if(searchResult[i].Organization_ReportingName__c!=null){
               PopupInfo_Rows=PopupInfo_Rows+searchResult[i].Organization_ReportingName__c+'+$';
               }else{
               PopupInfo_Rows=PopupInfo_Rows+'NA+$';
               }
               if(searchResult[i].Organization_LegalName__c!=null){
               PopupInfo_Rows=PopupInfo_Rows+searchResult[i].Organization_LegalName__c+'+$';
               }else{
               PopupInfo_Rows=PopupInfo_Rows+'NA+$';
               }
                                 
             }  
        }else{
             for(Integer i=0;i<15;i++){
               searchResultByPage.add(searchResult.get(i));
               if(searchResult[i].Non_LatinName__c!=null){ 
               PopupInfo_Rows=PopupInfo_Rows+searchResult[i].Non_LatinName__c+'+$';
               }else{
               PopupInfo_Rows=PopupInfo_Rows+'NA+$';           
               }
               if(searchResult[i].Organization_ReportingName__c!=null){
               PopupInfo_Rows=PopupInfo_Rows+searchResult[i].Organization_ReportingName__c+'+$';
               }else{
               PopupInfo_Rows=PopupInfo_Rows+'NA+$';
               }
               if(searchResult[i].Organization_LegalName__c!=null){
               PopupInfo_Rows=PopupInfo_Rows+searchResult[i].Organization_LegalName__c+'+$';
               }else{
               PopupInfo_Rows=PopupInfo_Rows+'NA+$';
               }
                  
             } 
        }           
    currentPageListSize=searchResultByPage.size();   
}
/************@Function to  check Account availability in SFDC  ************/
public void checkAccountSFDC(){
isSFDCAccount=false;
accountID=null; 
    try{
        if(DetailFieldName  ==  'MDCPId'){
            String searchvalue='';
            if(MDCPEntity=='Competitor'){
                searchvalue='Co#'+String.valueof(DetailFieldValue);
                accountID = [Select Id from Account where Userkey__c =:searchvalue limit 1].Id;
                }else{
                 searchvalue='Cu#'+String.valueof(DetailFieldValue);
                accountID = [Select Id from Account where Userkey__c =:searchvalue limit 1].Id;
            }
            }else if(DetailFieldName  ==  'DUNS'){
                accountID = [Select Id from Account where DUNS__c=:String.valueof(DetailFieldValue) limit 1].Id;   
            }
       }catch(Exception e){
            e.getMessage();
        }
        if(accountID != null && accountID != ''){
            isSFDCAccount=true;
        }
system.debug('isSFDCAccount====='+isSFDCAccount+'accountID ==='+accountID );
}
/*****************@function to Check permission to Create Account*******************************/
Public void CheckAccountCreatePermission() {
permissionCreateAccount=false;

//logic to determine permission to Create Account or  Case
if(MDCPEntity=='Customer'){
    try{
    Id MDCPPermissionSetID=[SELECT Id FROM PermissionSet where label='Create Unverified Account' limit 1].id;
    list<PermissionSetAssignment> AssignedPermissionset=[SELECT PermissionSetId FROM PermissionSetAssignment where AssigneeId =: UserInfo.getUserId()];
        if(!AssignedPermissionset.isempty()){
            for(PermissionSetAssignment var:AssignedPermissionset){
                if(var.PermissionSetId==MDCPPermissionSetID ){
                permissionCreateAccount=true;
                }
            }
        }
    }catch(exception e){system.debug('Exceptin occured in PermissionCheck:::'+e.getMessage());}
}
}


/*****************@function to get the detail of the record*******************************/
Public void GetDetails() {
detailSection=true;
IsNewAccountCreated=false;
isCaseCreated =false;
CheckAccountCreatePermission();
System.debug('permissionCreateAccount=='+permissionCreateAccount);
Integer listrowindex=Integer.valueof(DetailRowValue);
    if(DetailFieldName=='Name') {
        listrowindex=listrowindex/14;
        SelectedSearchRow=listrowindex;
        DetailFieldName='MDCPId';
        DetailFieldValue=searchResultByPage.get(listrowindex).MDCP_Id__c; 
    }else if(DetailFieldName=='Domestic_DUNS__c'){
        DetailFieldName='DUNS';
        listrowindex=(listrowindex-9)/14;
        SelectedSearchRow=listrowindex;        
        DetailFieldValue=searchResultByPage.get(listrowindex).Domestic_DUNS__c; 
    }else if(DetailFieldName=='Global_DUNS__c'){
        DetailFieldName='DUNS';
        listrowindex=(listrowindex-10)/14;
        SelectedSearchRow=listrowindex;        
        DetailFieldValue=searchResultByPage.get(listrowindex).Global_DUNS__c; 
    }
DetailsiteId=searchResultByPage.get(listrowindex).siteId__c;
    if(DetailFieldName=='MDCPId'){
        detailOrgIdSearch();
    }else if(DetailFieldName=='DUNS'){
        detailDUNSSearch();
    }
/**********************loading legal and Reporting Name from WM1*****************************/
if(!IsMDCPDown){
 CAccDisplay.LegalName=searchResultByPage.get(SelectedSearchRow).Organization_LegalName__c; 
 CAccDisplay.ReportingName=searchResultByPage.get(SelectedSearchRow).Organization_ReportingName__c;  
 CAccDisplay.CityRegion=searchResultByPage.get(SelectedSearchRow).CityRegion__c;   
 }
/********************end loading legal and Reporting Name from WM1 **************************/    
}
/*****************@Function to Search Account based on DUNS Number*****************/
 public void detailDUNSSearch(){
        IsMDCPDown=false;
        //check current Account Availabily in salesforce
        checkAccountSFDC(); 
        if(isSFDCAccount){
        showRecordStatus=false;
        showAvailabilyStatus=true;
        }else{
        showRecordStatus=true; 
        showAvailabilyStatus=false;       
        }   
        String responseXML;
        String body1='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:acc="http://www.tibco.com/schemas/MDCP2SFDC-LookUp/Schemas/accountSearchByDun.xsd"><soapenv:Header><wsse:Security soap:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soap="soap"><wsse:UsernameToken><wsse:Username>'+Label.MDCP_TIBCO_Username+'</wsse:Username><wsse:Password Type="wsse:PasswordText">'+Label.MDCP_TIBCO_Password+'</wsse:Password></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><acc:accountSearchByDunsInput><acc:duns>';
        String body2='</acc:duns><acc:otherPartySiteId>';
        String body3='</acc:otherPartySiteId></acc:accountSearchByDunsInput></soapenv:Body></soapenv:Envelope>';
        String requestXML=body1+DetailFieldValue+body2+DetailsiteId+body3; 
        responseXML=sendRequest(requestXML,Label.MDCPDetailEndPoint,Label.MDCPRequestActionDUNS,'Detail');
        if(responseXML!=null){
            if(responseXML=='faultyinput'){
            IsMDCPDown=true;
             errorMessage='fault input';
            }else{
            XmlStreamReader reader = new XmlStreamReader(responseXML);
            MDCPCalloutHelper.CAccount CAccDisplay=new MDCPCalloutHelper.CAccount();
            MDCPCalloutHelper parser=new MDCPCalloutHelper(); 
            CAccDisplay=parser.parseCAccount(reader);
            setCAccDisplay(CAccDisplay);
          
            }
        }else{
         IsMDCPDown=true;
        }
}
  
/***********************@Function to Search Account based on MDCP Org Id**********************/
 public void detailOrgIdSearch(){
        IsMDCPDown=false;
        //check current Account Availabily in salesforce
        checkAccountSFDC(); 
        if(isSFDCAccount){
        showRecordStatus=false;
        showAvailabilyStatus=true;
        }else{
        showRecordStatus=true; 
        showAvailabilyStatus=false;       
        }   
        String responseXML;
        String body1='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:look="http://www.tibco.com/schemas/MDCP2SFDC-LookUp/Schemas/LookUpDetail.xsd"><soapenv:Header><wsse:Security soap:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soap="soap"><wsse:UsernameToken><wsse:Username>'+Label.MDCP_TIBCO_Username+'</wsse:Username><wsse:Password Type="wsse:PasswordText">'+Label.MDCP_TIBCO_Password+'</wsse:Password></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><look:LookUpDetailRequest><look:OrganizationId>';
        String body2='</look:OrganizationId><look:otherPartySiteId>';
        String body3='</look:otherPartySiteId></look:LookUpDetailRequest></soapenv:Body></soapenv:Envelope>';
        String requestXML=body1+DetailFieldValue+body2+DetailsiteId+body3; 
        System.debug('*********requestXML****'+requestXML);       
        responseXML=sendRequest(requestXML,Label.MDCPDetailEndPoint,Label.MDCPRequestActionOrgId,'Detail');
        if(responseXML!=null){
            if(responseXML=='faultyinput'){
            IsMDCPDown=true;
             errorMessage='fault input';
            }else{
            XmlStreamReader reader = new XmlStreamReader(responseXML);
            MDCPCalloutHelper.CAccount CAccDisplay=new MDCPCalloutHelper.CAccount();
            MDCPCalloutHelper parser=new MDCPCalloutHelper(); 
            CAccDisplay=parser.parseCAccount(reader);
            setCAccDisplay(CAccDisplay);
            }
        }else{
         IsMDCPDown=true;
        }
}

/********@Method to Create New Unverified Account*************************/
public void createNewUnverifiedAccount() { 
    IsNewAccountCreated=false; 
    newUnverifiedAccountID=null;
    try{
        Account var=new Account();
        ID CustomerRecordTypeId=[SELECT Id FROM RecordType where name='Customer' limit 1].id;
        var.OwnerId =[Select Id,Country,Region__c,Business_Group__c,Name from User where Alias=:Label.MDCPUnverifiedAccountOwner limit 1].id;
        var.recordTypeID=CustomerRecordTypeId;
        var.MDCP_Organization_ID__c=CAccDisplay.MDCPOrgId; 
       
        var.Regions__c=CAccDisplay.Region; 
        var.Mdcp_SiteId__c=DetailsiteId; 
        var.MDCP_Site_Instance_Id__c=searchResultByPage.get(SelectedSearchRow).SiteInstanceId__c; 
        var.Domestic_Ultimate_Duns__c=CAccDisplay.DomesticDUNS; 
        var.Global_Ultimate_DUNS_Number__c=CAccDisplay.GlobalDUNS; 
        var.Organization_DUNS_Number__c=CAccDisplay.OrganizationDUNS;                   
        var.DUNS__c=CAccDisplay.DUNS; 
        var.Sic=CAccDisplay.SICCode; 
        var.SicDesc=CAccDisplay.SICName; 
        var.Industry_Segment__c=CAccDisplay.IndustrySegmentName;         
        if(CAccDisplay.AnnualRevenue!=null){
        var.AnnualRevenue=decimal.valueOf(CAccDisplay.AnnualRevenue);   
        }
        if(CAccDisplay.NumberOfEmployees!=null){
        var.NumberOfEmployees= Integer.valueof(CAccDisplay.NumberOfEmployees); 
        }
        var.Alternate_Name__c=CAccDisplay.tradeStyleName1; 
        var.Trade_Style_Name_2__c=CAccDisplay.tradeStyleName2;  
        var.Trade_Style_Name_3__c=CAccDisplay.tradeStyleName3; 
        var.Trade_Style_Name_4__c=CAccDisplay.tradeStyleName4;  
        var.Trade_Style_Name_5__c=CAccDisplay.tradeStyleName5;      
        var.AMID_L2__C=CAccDisplay.AMID2; 
        var.Userkey__c='Cu#'+CAccDisplay.MDCPOrgId;                       
        if(CAccDisplay.Street==null || CAccDisplay.Street==''){                 
           var.ShippingStreet='-';
           }else{
              var.ShippingStreet=CAccDisplay.Street; 
        }
        if(CAccDisplay.PostalCode==null || CAccDisplay.PostalCode==''){                   
           var.ShippingPostalCode='-';
          }else{
              var.ShippingPostalCode=CAccDisplay.PostalCode; 
        }
        if(CAccDisplay.City==null || CAccDisplay.City==''){                  
           var.ShippingCity='-';
         }else{
              var.ShippingCity=CAccDisplay.City; 
        }  
        if(CAccDisplay.State==null || CAccDisplay.State==''){                 
            var.ShippingState='-';            
           }else{
              var.ShippingState=CAccDisplay.State; 
        }
        if(CAccDisplay.Country==null || CAccDisplay.Country==''){                    
           var.ShippingCountry='-';
         }else{
              var.ShippingCountry=CAccDisplay.Country; 
        }
        if(CAccDisplay.NonLatinName!=null){
        var.Name=CAccDisplay.NonLatinName; 
        var.Account_Phonetical_Name_Capture_Latin__c=CAccDisplay.Name;           
        }else{
        var.Name=CAccDisplay.Name;         
        }   
        var.MDCP_Subscribed_Flag__c='false'; 
        system.debug('var++++++++++++'+var);
        insert var;     
               if(var.id != null){
                    IsNewAccountCreated=true;
                    newUnverifiedAccountID=var.id;
                }
        system.debug('Inserted accout ID============'+var.id);            
    }catch(Exception e){system.debug('Exception occured in Account Creation:::::: '+e.getmessage());}
  if(IsNewAccountCreated){
    createNewCase();
  }  
}       
       
/********@Method to Create New Case if Account does not exist in SFDC******/
public void createNewCase() { 
isCaseCreated =false; 
Map<String,Schema.RecordTypeInfo> rtMapByName;
Id caseRecordordTypeId;
String caseId;
    caseRecord=new case();
    User usr = [Select Id,Country,Region__c,Business_Group__c,Name from User where Id =: UserInfo.getUserId()];
    rtMapByName = Case.SObjectType.getDescribe().getRecordTypeInfosByName();
    caseRecordordTypeId = rtMapByName.get(Label.Account_Request).getRecordTypeId();
    caseRecord.RecordTypeId = caseRecordordTypeId;
    caseRecord.Origin = 'SFDC';
    caseRecord.IsSelfServiceClosed = False ;
    caseRecord.IsEscalated = False;
    caseRecord.Priority = 'Medium';
    caseRecord.Status = 'New';
    caseRecord.BG__c=usr.Business_Group__c;
    caseRecord.Request_Type__c = 'Single Record';
    caseRecord.New_Account_Name__c = CAccDisplay.Name;
    caseRecord.Country_of_Submitter__c = usr.Country;
    caseRecord.City__c = CAccDisplay.City;
    if(CAccDisplay.Country!=null){
        caseRecord.Country__c =CAccDisplay.Country ;
    }else{
        caseRecord.Country__c =usr.Country;
    }
    if( CAccDisplay.Street!=null){
    caseRecord.Street__c = CAccDisplay.Street;
    }else{
    caseRecord.Street__c = 'NA';
    }
    system.debug('street===='+CAccDisplay.Street);
    if(CAccDisplay.State!=null){
    caseRecord.State_Province__c = CAccDisplay.State;
    }else{
    caseRecord.State_Province__c = 'NA';
    }
    caseRecord.Zip_Postal_Code__c = CAccDisplay.PostalCode;
    caseRecord.IsVisibleInSelfService = False;
    caseRecord.Country_of_Submitter__c =usr.Country ;
 
    //checking to create for competitor or customer
    if(MDCPEntity=='Competitor'){
        caseRecord.OwnerId = Label.Master_Data_Back_Office_SFDC;
        caseRecord.Reason = 'Competitor - Create a new account';
        caseRecord.Description = 'Competitor Lookup request, MDCP ID = '+CAccDisplay.MDCPOrgId+ ', Name = '+ CAccDisplay.Name ;
        caseRecord.Scenario__c = 'Account exists in MDCP but not in SFDC';
        caseRecord.Subject = 'Account Lookup for '+CAccDisplay.Name;        
        if(competitorRegion!=null&&MDCPEntity=='Competitor'){
            if(competitorRegion=='Americas'){
                caseRecord.Region__c='AMS';
            }else if(competitorRegion=='EMEA'){
                caseRecord.Region__c='EMEA';
            }else if(competitorRegion=='Asia Pacific'){
                caseRecord.Region__c='APJ';
            }
        }
    }else{
        caseRecord.OwnerId = Label.Master_Data_Back_Office_SFDC;
        caseRecord.Region__c =usr.Region__c ;           
          if(IsNewAccountCreated){
            caseRecord.Reason = 'Customer - Create a new account';
            caseRecord.AccountId=newUnverifiedAccountID; 
            caseRecord.Subject = 'account with MDCP Org Id ' +CAccDisplay.MDCPOrgId+ ' requires subscription follow-up in Master Data system.';
            caseRecord.Description = 'Record with MDCP Org ID ' +CAccDisplay.MDCPOrgId+ ', OPS ID = '+DetailsiteId+', OPSI ID = '+searchResultByPage.get(SelectedSearchRow).SiteInstanceId__c+' has been created in SFDC via Unverified Account Creation Process  by '+usr.name ;
            caseRecord.Scenario__c = 'UVA created & MDCP Org ID found';
    
           }else{  

            caseRecord.Reason = 'Create a new account';
            caseRecord.Subject = 'Account Lookup for '+CAccDisplay.Name;
                if(CAccDisplay.OutofBusinessIndicator == true){
                    caseRecord.Description = 'Account Lookup request, MDCP ID = '+CAccDisplay.MDCPOrgId+ ', Name = '+ CAccDisplay.Name+ ' Out of Business Recordin MDCP' ;
                }else{
                    caseRecord.Description = 'Account Lookup request, MDCP ID = '+CAccDisplay.MDCPOrgId+ ', Name = '+ CAccDisplay.Name;
                 }
             caseRecord.Scenario__c = 'Account exists in MDCP but not in SFDC'; 
           }



    }
     try{
     System.debug('caseRecord===='+caseRecord);
        insert caseRecord;
        caseRecordRet = [Select Id,CaseNumber from Case where id =:caseRecord.Id];
        isCaseCreated = True;
        showRecordStatus=false;
        }catch (Exception e) { isCaseCreationFailed = True;failureMessage = e.getMessage();
        }
}
/**********************@method to hide case created link*********************************/
public void hidecaselink() {
    isCaseCreated =false;
}
/**********************@method to hide Account created link*********************************/
public void hideAccountlink() {
    IsNewAccountCreated=false;
} 
/**********************@method to close popup*********************************/
public void closePopup() {
} 
/**********************@method to show popup*********************************/
public void showPopup() {
} 
/**********************@method to create Account Link*********************************/
public void accLink() {
}        
}