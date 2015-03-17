public class DealReg_WebSvcCallout {
    public static void callWebservice(Account accountObject,List<Account> accountList,String mdcpQuery) {
        
       // Below created date and nonce string we need to send along with the Tibco user name and password details to the stub
         DateTime d = System.now();
         String createdStr = d.formatGmt('yyyy-MM-dd HH:mm:ss.SSSSSS');
         String nonceStr = String.valueOf(Crypto.getRandomInteger());                            
         Blob nonceBlob = Blob.valueOf(nonceStr);
         nonceStr=EncodingUtil.base64Encode(nonceBlob);
        
       // Calling the webserivce callout..  
         SearchAccountMDCPLookUpStub.MDCPLookUpSearch stub = new SearchAccountMDCPLookUpStub.MDCPLookUpSearch();   
         stub.endpoint_x=Label.MDCP_SRP_Proxy_Url;
         stub.timeout_x=25000;
         stub.clientCertName_x='SFDC_Certificate';
         stub.inputHttpHeaders_x = new Map<String, String>();
         stub.inputHttpHeaders_x.put('Content-Type', 'application/soap+xml');
         //This action value is from WSDL
         stub.inputHttpHeaders_x.put('SOAPAction','/SFDCServices/MDCPLookUpSearch.serviceagent/MDCPLookUp/MDCPLookUpSearch');
 
         SearchAccountMDCPLookUpService.organizationAccountSearchResponse_element accountSearchOutputElementList = stub.MDCPLookUpSearch(mdcpQuery,0,30,Label.MDCPTibcoUserName,Label.MDCPTibcoPassword,nonceStr,createdStr);         
         SearchAccountMDCPLookUpService.organizationAccountSearchDocuments_element organizationAccountSearchDocuments=accountSearchOutputElementList.organizationAccountSearchDocuments;         
         SearchAccountMDCPLookUpService.documents_element documents = organizationAccountSearchDocuments.documents;
       
       // Below code used to add Record type for each record retrieved from the MDCP   
         Id recordId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
         
        if(documents.organizationAccountSearchResult!=null){
          for(SearchAccountMDCPLookUpService.organizationAccountSearchResult_element accountSearchObject:documents.organizationAccountSearchResult){
                
                   accountObject=new Account();  
                                
                  if(String.valueOf(accountSearchObject.organizationId) !=null || String.valueOf(accountSearchObject.organizationId)!=''){
                     accountObject.MDCP_Organization_ID__c=String.valueOf(accountSearchObject.organizationId);
                     accountObject.Userkey__c = 'Cu#'+String.valueOf(accountSearchObject.organizationId);
                   }
                               
                  if(accountSearchObject.organizationExtendedName !=null || accountSearchObject.organizationExtendedName!=''){
                     accountObject.Name=accountSearchObject.organizationExtendedName;
                     
                   }
                   else{
                     accountObject.Name=' ';
                   }
                   
                 if(accountSearchObject.latinStreet1LongName !=null || accountSearchObject.latinStreet1LongName!=''){
                   accountObject.ShippingStreet=accountSearchObject.latinStreet1LongName;
                   }
                 else{
                   accountObject.ShippingStreet=' ';
                   }
                   
                if(accountSearchObject.postalCode !=null || accountSearchObject.postalCode!=''){    
                   accountObject.ShippingPostalCode=accountSearchObject.postalCode;
                   }
                 else{   
                   accountObject.ShippingPostalCode=' ';
                  }
                 
                if(accountSearchObject.latinCity !=null || accountSearchObject.latinCity!=''){     
                   accountObject.ShippingCity=accountSearchObject.latinCity;     
                  }
                else{
                   accountObject.ShippingCity=' ';
                 }  
                                  
                 if(accountSearchObject.state !=null || accountSearchObject.state!=''){
                   accountObject.ShippingState=accountSearchObject.state; 
                  }
                 else{
                    accountObject.ShippingState=' ';            
                   }
                  
                 if(accountSearchObject.countryName !=null || accountSearchObject.countryName!=''){  
                  accountObject.ShippingCountry=accountSearchObject.countryName;
                  }
                 else{
                   accountObject.ShippingCountry=' ';
                 }
                 
                 if(accountSearchObject.onlyPresaleCustomer !=null || accountSearchObject.onlyPresaleCustomer!=''){   
                  accountObject.MDCP_Subscribed_Flag__c=accountSearchObject.onlyPresaleCustomer;  
                  }
                 else
                 {
                  accountObject.MDCP_Subscribed_Flag__c='false';
                 }
                 
                if(String.valueOf(accountSearchObject.siteId) !=null || String.valueOf(accountSearchObject.siteId)!=''){
                     accountObject.Mdcp_SiteId__c=String.valueOf(accountSearchObject.siteId);
                   }
                //added for R6 (OPSI ID from MDCP into MDCP site instance ID)  
                if(String.valueOf(accountSearchObject.siteInstanceId) !=null || String.valueOf(accountSearchObject.siteInstanceId)!=''){
                    accountObject.MDCP_Site_Instance_Id__c=String.valueOf(accountSearchObject.siteInstanceId);
                   }   
                   
                if(accountSearchObject.worldRegion!=null || accountSearchObject.worldRegion!=''){   
                  accountObject.World_Region__c=accountSearchObject.worldRegion;  
                  }    
                  accountObject.recordtypeId=recordId;
                  accountList.add(accountObject);  
                  }         
                  }
    }   
}