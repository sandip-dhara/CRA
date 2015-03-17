public class MDCPSyncController {
    private final Account account;
    private RecordType recordType;
    public String message {get; private set;}
    public String link {get; set;}
    public String MDCP_ID {get; set;}
    public String queryResult {get; set;}
    public LIST<Error_Log__c> resultQuery {get;set;}
    public LIST<Account> CurrentAccount;    
    public String selectedRecordType {get;set;}
    public String LabelInfo {get; set;}//Added to show Dynamic Label
    public Boolean continueRequired {get; set;}
    public Boolean Ispartnerrecord{get;set;}

    public MDCPSyncController(ApexPages.StandardController controller) {
       this.account = (Account) controller.getRecord();
       this.recordType = [SELECT Name From RecordType Where Id =:account.RecordTypeId][0];
       this.selectedRecordType = this.recordType.Name;
       system.debug('account.ID ==='+account.ID );
       CurrentAccount=[select MDCP_Business_Relationship_ID__c,MDCP_Last_Synced__c from Account where id=:account.ID limit 1];
       Datetime AccountLastSyncdae=CurrentAccount[0].MDCP_Last_Synced__c;
       Datetime ErrorlogGeneratedDate;
       if(AccountLastSyncdae==null){
       AccountLastSyncdae=datetime.newInstance(1900,1, 1);
       }
       system.debug('AccountLastSyncdae==='+AccountLastSyncdae);
       if(recordType.Name!='Partner'){
       
           LabelInfo='MDCP Organization Id';
           this.MDCP_ID =account.MDCP_Organization_ID__c;
       }else{
           Ispartnerrecord=true;
           LabelInfo='MDCP Business Relationship Id';
           this.MDCP_ID =[select MDCP_Business_Relationship_ID__c from Account where id=:account.ID limit 1][0].MDCP_Business_Relationship_ID__c ;
       }
       if(this.MDCP_ID==''||this.MDCP_ID==null){
        continueRequired=true;
        }else{
        continueRequired=false;
        } 
  //Query Error_Log Object for failed record    
       try{
          // resultQuery  = [SELECT Error_Message__c,name,Generated_On_Date__c FROM Error_Log__c WHERE Record_Id__c =:MDCP_ID  ORDER BY Generated_On_Date__c Desc LIMIT 1  ];
             resultQuery  = [SELECT Error_Message__c,name,Generated_On_Date__c FROM Error_Log__c WHERE Record_Id__c =:MDCP_ID  ORDER BY CreatedDate Desc LIMIT 1  ];
           system.debug('resultQuery  ===='+resultQuery  );
           ErrorlogGeneratedDate=Resultquery[0].Generated_On_Date__c;
           queryResult =Resultquery[0].Error_Message__c;
            link=Resultquery[0].name; 
            if(ErrorlogGeneratedDate!=null&&AccountLastSyncdae!=null){
            long dt1=0,dt2=0;  
                dt1 = ErrorlogGeneratedDate.getTime();
                dt2 =AccountLastSyncdae.getTime();
                if(dt2>dt1){
                 queryResult=null;
                }  
                  
              }
        } catch(Exception ex){
            queryResult = null;
        }
   //Handling null returns          
       if (queryResult != null){
      
          queryResult = 'This record having MDCP Id '+ this.MDCP_ID + ' has failed with message "' + queryResult + '". You may need to fix the record in MDCP if the error is due to missing or invalid data. ';
       }
       else {
       queryResult = '';
              }
        
     }
 // using pg ref     
public PageReference processLinkClick() {
               
        return new PageReference('/' + this.link);
        
   }

   public List<SelectOption> getRecordTypeOptions() {
     
        //SELECT Name FROM RecordType WHERE SobjectType = 'Account'
        
      List<SelectOption> optionsRecordType = new List<SelectOption>();
        List<RecordType> recordTypes;
        try{
        /************** Updated on 29/04/2013 to support partner accounts   ************/
           // recordTypes = [SELECT Name FROM RecordType WHERE SobjectType = 'Account' and Name <> 'Partner'];
             recordTypes = [SELECT Name FROM RecordType WHERE SobjectType = 'Account' ];
            for(RecordType recordType : recordTypes){
                optionsRecordType.add(new SelectOption(recordType.Name,recordType.Name));
            }
            
        } catch(Exception ex){ queryResult = null;
        } 
         return optionsRecordType;
   }

   public PageReference getSync(){
      this.message = getResponse(account.id);
      return null;
    }
 
   private String getResponse(String account_id) {  
       String output, responseXML, requestXML, RecordID, RecordType, body1, body2, body3, endPoint, result, SOAPAction;
        Integer responseCode;
     try{           
            HttpRequest request = new HttpRequest();
            DOM.Document responseBody = new DOM.Document();
            request.setMethod('POST');
            //request.setEndpoint(Label.MDCPRequestEndPoint);
            endPoint = Label.MDCP_Sync_EndPoint;
            request.setEndpoint(endPoint);
            
            request.setHeader('Content-Type', 'text/xml');
            //request.setHeader('SOAPAction',Label.MDCPRequestAction);
            SOAPAction = '/SharedResources/Services/AccountSync.serviceagent/AccountSyncEndpoint1/Account';
            request.setHeader('SOAPAction',SOAPAction);
            request.setTimeout(10000);
            request.setClientCertificateName(Label.SFDC_Certificate);
            
            RecordID = this.MDCP_ID;
            RecordType = this.selectedRecordType;
         //   output = RecordType;
            body1='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:acc="http://www.tibco.com/schemas/CustomerRefreshWS/SharedResources/AccountSync.xsd"><soapenv:Header><wsse:Security soap:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soap="soap"><wsse:UsernameToken><wsse:Username>'+Label.MDCP_Sync_UserName+'</wsse:Username><wsse:Password Type="wsse:PasswordText">'+Label.MDCP_Sync_Password+'</wsse:Password></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><acc:GetAccountSyncRequest><acc:RecordID>';
            body2='</acc:RecordID><acc:RecordType>';
            body3='</acc:RecordType></acc:GetAccountSyncRequest></soapenv:Body></soapenv:Envelope>';
            requestXML=body1+RecordID+body2+RecordType+body3; 
            system.debug('requestXML===='+requestXML);
            request.setBody(requestXML);
            Http http = new Http();
            HttpResponse response = null;
            response = http.send(request);
            responseBody = response.getBodyDocument();
            responseCode = response.getStatusCode(); 
// system.debug('response code====================='+responseCode);
            if(responseCode!=200) {
                responseXML= responseBody.toXmlString();
                responseXML = 'FAILED =>' + responseXML;
            } else {
                responseXML= responseBody.toXmlString();
                XmlStreamReader reader = new XmlStreamReader(responseXML);
                result = getCount(reader); 
                output = RecordID + ' is submitted successfully. There are ' + result + ' messages in ' + RecordType + ' queue.';
            }
            System.debug(responseXML);
        } catch (Exception ex) {
            System.debug('exception message =='+ this.selectedRecordType + '==' + this.MDCP_ID + '--' + ex.getMessage());
            responseXML = 'EXCEPTION =>' + ex.getMessage();
            //responseXML = responseBody;
            //responseXML = ex.getMessage().contains('timed out') ? 'mdcpdown' : 'faultyinput';
        }
        return(output);
    }
 
    private String getCount (XmlStreamReader reader) {
        String output = '';
        while (reader.hasNext()) {
            if ('PendingMessageCount' == reader.getLocalName() && reader.getEventType() == XmlTag.START_ELEMENT) {
                reader.next();
                output = reader.getText();
                break;
            }
        reader.next();
        }
        return output;
    }
  
}