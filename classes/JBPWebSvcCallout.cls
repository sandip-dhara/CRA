/**********************************************************
* Class Name: JBPWebSvcCallout
* Author: HP Release 5
* Date: 05-March-2013 
* Auth:- HP 
* Requirement # Request Id:5414
* Description: Controller class used to generate the ppt via SFDC->Tibco->JMS Queue->HP exstream.
***********************************************************/
public class JBPWebSvcCallout{
 
 public static String callWebservice(String sId,String userEmail,String pptLanguage,String pptLanguageCode, String loggedInUserLanguageCode, String country, String currencyCode,String currencySymbol, Double conversionCode1,Double ConversionCode2,String isFieldDefinitionForExport,String isStrategicInitiativesSummarySelectedForExport,String isCompetitiveLandscapeSelectedForExport,String isMetricsSelectedForExport,String IsPartnerEnabled,String isStrategicInitiativesDetailForExport){
        String status ='';

           // Below created date and nonce string we need to send along with the Tibco user name and password details to the stub          
           DateTime dateObject = System.now();
           String createdStr = dateObject.formatGmt('yyyy-MM-dd HH:mm:ss.SSSSSS');
           String nonceStr = String.valueOf(Crypto.getRandomInteger());                            
           Blob nonceBlob = Blob.valueOf(nonceStr);
           nonceStr=EncodingUtil.base64Encode(nonceBlob); 
           
        // Calling the webserivce callout..  
          JBPExtreamWebserviceStub.HPExtreamJBP stub = new JBPExtreamWebserviceStub.HPExtreamJBP();   
                   
           stub.endpoint_x=Label.JBP_SRP_Proxy_Url;
           stub.timeout_x=40000;
           stub.clientCertName_x='SFDC_Certificate';
           stub.inputHttpHeaders_x = new Map<String, String>();
           stub.inputHttpHeaders_x.put('Content-Type', 'application/soap+xml');
         //This action value is from WSDL
           stub.inputHttpHeaders_x.put('SOAPAction','/BusinessProcess/Services/WSDL-service.serviceagent/HPExtreamEndpoint/HPExtream_JBP'); 
               
           status = stub.HPExtream_JBP(sId, userEmail, pptLanguage,pptLanguageCode, loggedInUserLanguageCode,country, currencyCode,currencySymbol,conversionCode1,ConversionCode2,isFieldDefinitionForExport,isStrategicInitiativesSummarySelectedForExport,isCompetitiveLandscapeSelectedForExport,isMetricsSelectedForExport,isPartnerEnabled,isStrategicInitiativesDetailForExport,Label.JBP_TIBCO_USERNAME,Label.JBP_TIBCO_PASSWORD,nonceStr,createdStr) ;

           return status;
    }
}