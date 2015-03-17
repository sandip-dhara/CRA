/**********************************************************
* Class Name: MDCPCalloutHelper
* Author: Vijay Ranjan
* Date: 28-May-2013 
* Description: Class to Support parsing Response for MDCPController
*                
***********************************************************/
Global  class MDCPCalloutHelper{
public CAccount CAccDisplay{get;set;}
Public static  Boolean IsMDCPDown{get;set;}
public MDCPCalloutHelper() { 
CAccDisplay = new CAccount();
}
/********************@Method to create Sobject list from parsed object list*********************/ 
   
public List<MDCPResult__c> Parserequest(String requestxml) {
IsMDCPDown=false;
MDCPCalloutHelper genericcall=new MDCPCalloutHelper();
XmlStreamReader reader = new XmlStreamReader(requestxml);
reader.setCoalescing(true); 
long dt1 = system.now().getTime();
transient  Book[] books = genericcall.parseBooks(reader);
      transient  List<MDCPResult__c> resultset=new List<MDCPResult__c>();
        transient   MDCPResult__c val;
         transient   Integer fieldcount=0;
            for (Book book : books) {
                if(math.mod(fieldcount, 19)==0){
                    val=new MDCPResult__c();
                }
                if(book.FieldName=='organizationExtendedName'){
                    val.Name=book.value;
                    fieldcount++;
                }else if(book.FieldName=='countryName'){
                    val.Country__c=book.value;
                    fieldcount++;
                }else if(book.FieldName=='state'){
                    val.State__c=book.value;
                    fieldcount++;
                }else if(book.FieldName=='cityRegion'){
                    val.CityRegion__c=book.value;
                    fieldcount++;
                }else if(book.FieldName=='latinCity'){
                    val.City__c=book.value;
                    fieldcount++;
                }else if(book.FieldName=='latinStreet1LongName'){
                    val.Address__c=book.value;
                    fieldcount++;
                }else if(book.FieldName=='organizationNonLatinExtendedName'){
                    val.Non_LatinName__c=book.value;
                    fieldcount++;
                }else if(book.FieldName=='organizationId'){
                    val.MDCP_Id__c=book.value;
                    fieldcount++;
                }else if(book.FieldName=='siteDuns'){
                    val.DUNS__c=book.value;
                    fieldcount++;
                }else if(book.FieldName=='siteId'){

                    val.siteId__c=book.value;
                    fieldcount++;
                }else if(book.FieldName=='siteInstanceId'){
                    val.SiteInstanceId__c=book.value;
                    fieldcount++;
                }else if(book.FieldName=='globalDuns'){
                    val.Global_DUNS__c=book.value;
                    fieldcount++;
                }else if(book.FieldName=='domesticDuns'){
                    val.Domestic_DUNS__c=book.value;
                    fieldcount++;
                }else if(book.FieldName=='taxId'){
                if(book.value==null) {
                book.value = '';
                }else{
                val.Tax_ID__c= book.value.replace('|',' : '); 
                }
                fieldcount++;
                }else if(book.FieldName=='postalCode'){
                val.Postal_code__c=book.value;                    
                fieldcount++;
                }else if(book.FieldName=='isCompetitor'){
                    if(book.value=='true'){
                        val.Is_Competitor__c=true;
                    }else{
                        val.Is_Competitor__c=false;
                    }  
                    fieldcount++;
                }else if(book.FieldName=='isOutOfBusiness'){
                    if(book.value=='true'){
                        val.isOutOfBusiness__c=true;
                    }else{
                        val.isOutOfBusiness__c=false;
                    }  
                    fieldcount++;
                }else if(book.FieldName=='organizationReportingName'){
                    val.Organization_ReportingName__c=book.value;
                    fieldcount++;
                }else if(book.FieldName=='organizationLegalName'){
                    val.Organization_LegalName__c=book.value;
                    fieldcount++;
                }    
                if((math.mod(fieldcount,19)==0)&&(fieldcount>0)){
                resultset.add(val);
                }
           }
system.debug('fieldcount==='+fieldcount);
long dt2 = system.now().getTime();
double d = dt2 - dt1;
system.debug('Time to Parse the Records===========>'+d);
if(IsMDCPDown==true){
return null;
}else{
system.debug('resultset returned==='+resultset);
return resultset;
}
}
/*************************@Wrapper  class to create parsed object list*************/
public class Book{
String value;
String FieldName;
}
/***************************@ methos to parse the request given ********************/

Book[] parseBooks(XmlStreamReader reader) {
transient  Book[] books = new Book[0];
transient  Integer fieldcount=0;
        while(reader.hasNext()) {
              if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if ('organizationExtendedName' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }else if ('state' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }else  if ('countryName' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }else if('cityRegion' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }else if('postalCode' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }else if('latinCity' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }else if ('latinStreet1LongName' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }else if('organizationNonLatinExtendedName' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }else if ('taxId' == reader.getLocalName()) {
                 Book book = parseBook(reader,reader.getLocalName());
                 books.add(book);
                }else if ('organizationId' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }else if('siteDuns' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }else if('siteId' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }else if('siteInstanceId' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }else if('globalDuns' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }else if('domesticDuns' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }else if('isOutOfBusiness' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }else if('isCompetitor' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }else if ('organizationReportingName' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }else if ('organizationLegalName' == reader.getLocalName()) {
                Book book = parseBook(reader,reader.getLocalName());
                books.add(book);
                }                
                if ('errorMessage' == reader.getLocalName()) {
                IsMDCPDown=true;
                }                
            }
            reader.next();
        }
system.debug('books===='+books.size()); 
return books;
}
/*****************@method to Identify element and its value********************************/

Book parseBook(XmlStreamReader reader,String fieldname) {
transient  Book book = new Book();
book.FieldName= fieldname;
    while(reader.hasNext()) {
        if (reader.getEventType() == XmlTag.END_ELEMENT) {
        break;
        }else if (reader.getEventType() == XmlTag.CHARACTERS) {
        book.value= reader.getText().trim();
        }
    reader.next();
    }
return book;
}
/****************************************@Detail Parsing Section****************************/
String parseCAccount(XmlStreamReader reader,String column) {
        String columnValue = null;      
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                columnValue = reader.getText();
            }
            reader.next();
        }
        return columnValue;
}
/****************@Parsser for Detail result**************************/
 Global  CAccount parseCAccount(XmlStreamReader reader) {
 IsMDCPDown=false;
 reader.setCoalescing(true); 
        while(reader.hasNext()) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if ('organizationExtendedName' == reader.getLocalName()) {
                    CAccDisplay.Name = parseCAccount(reader,reader.getLocalName());
                }else if ('Address' == reader.getLocalName()) {
                    CAccDisplay.Address = parseCAccount(reader,reader.getLocalName());
                }else if('addressCountryLanguagStreet1LongName' == reader.getLocalName()) {
                    CAccDisplay.Street= parseCAccount(reader,reader.getLocalName());
                }else if('addressCountryLanguageCityLongName' == reader.getLocalName()) {
                    CAccDisplay.City = parseCAccount(reader,reader.getLocalName());
                }else if('countrySubDivisionName' == reader.getLocalName()) {
                    CAccDisplay.State= parseCAccount(reader,reader.getLocalName());
                }else if ('siteCountryName' == reader.getLocalName()) {
                    CAccDisplay.Country = parseCAccount(reader,reader.getLocalName());
                }else if('addressCountryLanguagPostalCodeName' == reader.getLocalName()) {
                    CAccDisplay.PostalCode = parseCAccount(reader,reader.getLocalName());
                }else if ('otherPartyObjectSystemAssetUid' == reader.getLocalName()) {
                    CAccDisplay.AMID2 = parseCAccount(reader,reader.getLocalName());
                }else if ('siteDuns' == reader.getLocalName()) {
                    CAccDisplay.DUNS = parseCAccount(reader,reader.getLocalName());
                }else if('domesticOrganizationRelationshipExternalSourceUid' == reader.getLocalName()) {
                    CAccDisplay.DomesticDUNS = parseCAccount(reader,reader.getLocalName());
                }else if('organizationExternalSourceUid' == reader.getLocalName()) {
                    CAccDisplay.OrganizationDUNS= parseCAccount(reader,reader.getLocalName());
                }else if ('globalOrganizationRelationshipExternalSourceUid' == reader.getLocalName()) {
                    CAccDisplay.GlobalDUNS = parseCAccount(reader,reader.getLocalName());
                }else if('otherPartySiteHeadcountQty' == reader.getLocalName()) {
                    CAccDisplay.NumberOfEmployees = parseCAccount(reader,reader.getLocalName());
                }else if('organizationId' == reader.getLocalName()) {
                    CAccDisplay.MDCPOrgId = parseCAccount(reader,reader.getLocalName());
                }else if('otherPartySiteOrganizationOutOfBusinessIndicator' == reader.getLocalName()) {
                    if(parseCAccount(reader,reader.getLocalName())=='Y'||parseCAccount(reader,reader.getLocalName())=='y')
                        CAccDisplay.OutofBusinessIndicator =true;
                    else
                        CAccDisplay.OutofBusinessIndicator =false;                    
                }else if('organizationTradingName1' == reader.getLocalName()) {                    
                    CAccDisplay.tradeStyleName1 = parseCAccount(reader,reader.getLocalName());    
                }else if('organizationTradingName2' == reader.getLocalName()) {
                    CAccDisplay.tradeStyleName2 = parseCAccount(reader,reader.getLocalName());
                }else if('organizationTradingName3' == reader.getLocalName()) {  
                    CAccDisplay.tradeStyleName3 = parseCAccount(reader,reader.getLocalName());
                }else if('organizationTradingName4' == reader.getLocalName()) {
                    CAccDisplay.tradeStyleName4 = parseCAccount(reader,reader.getLocalName());
                }else if('organizationTradingName5' == reader.getLocalName()) {
                    CAccDisplay.tradeStyleName5 = parseCAccount(reader,reader.getLocalName());
                }else if('annualRevenue' == reader.getLocalName()) {
                    CAccDisplay.AnnualRevenue = parseCAccount(reader,reader.getLocalName());
                }else if('industryVerticalName' == reader.getLocalName()) {
                    CAccDisplay.IndustryVerticalName = parseCAccount(reader,reader.getLocalName());
                }else if('industrySegmentName' == reader.getLocalName()) {
                    CAccDisplay.IndustrySegmentName = parseCAccount(reader,reader.getLocalName());
                }else if('standardIndustryClassificationLineofBusinessCode' == reader.getLocalName()) {
                    CAccDisplay.SICCode = parseCAccount(reader,reader.getLocalName());
                }else if('standardIndustryClassificationLineofBusinessName' == reader.getLocalName()) {
                    CAccDisplay.SICName = parseCAccount(reader,reader.getLocalName());
                }else if('organizationNonLatinExtendedName' == reader.getLocalName()) {
                    CAccDisplay.NonLatinName= parseCAccount(reader,reader.getLocalName());
                }else if('errorMessage' == reader.getLocalName()) {
                    IsMDCPDown=true;
                }
                }
            reader.next();
        }
if(IsMDCPDown==true){
return null;
}else{
return CAccDisplay;
}

}
/***********************@ Wrapper  class to parse the  ResponseXML and store all values***/
Global class CAccount{
    Public String Name{get;set;}
    Public String NonLatinName{get;set;}
    Public String LegalName{get;set;}   
    Public String ReportingName{get;set;}   
    Public String Address{get;set;}
    Public String Street{get;set;}
    Public String City{get;set;}
    Public String CityRegion{get;set;}  
    Public String State{get;set;}
    Public String Country{get;set;}
    Public String PostalCode{get;set;}
    Public String Region{get;set;}
    Public String AMID2{get;set;}
    Public String DUNS{get;set;}
    Public String DomesticDUNS{get;set;}
    Public String OrganizationDUNS{get;set;}    
    Public String GlobalDUNS{get;set;}
    Public String NumberOfEmployees{get;set;}
    Public string MDCPOrgId{get;set;}
    Public Boolean OutofBusinessIndicator{get;set;}
    Public String tradeStyleName1{get;set;}
    Public String tradeStyleName2{get;set;}
    Public String tradeStyleName3{get;set;}
    Public String tradeStyleName4{get;set;}
    Public String tradeStyleName5{get;set;}
    Public String AnnualRevenue{get;set;}
    Public String IndustryVerticalName{get;set;}
    Public String IndustrySegmentName{get;set;}
    Public String SICCode{get;set;}
    Public String SICName{get;set;}
}
}