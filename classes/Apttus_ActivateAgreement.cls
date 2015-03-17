/*
    R5: HP Apttus-Axiom Apttus Integration 
    Callout class to invoke Apttus Agreement web services.
    
    Operations used: 
        Activate Agreement (activateAgreement(..)) 
        Publish to Content repository (publishToContentRepository(...))
    
*/



global class Apttus_ActivateAgreement
{
    @future (callout=true)
    public static void activate(Id agreementId, String sessionID)
    {
                      
              soapSforceComSchemasClassApttusAgr.AgreementWebService stub = new soapSforceComSchemasClassApttusAgr.AgreementWebService();
              soapSforceComSchemasClassApttusAgr.SessionHeader_element SessionHeader = new soapSforceComSchemasClassApttusAgr.SessionHeader_element();

              
              SessionHeader.sessionId = sessionID; 
              
            
              try{
                List<Attachment> attch = [select Id from Attachment where ParentId =:agreementId ORDER BY LastModifiedDate DESC LIMIT 1 ];
                   // String[] selectdDocIds =  new String[attch.size()];
                String publishDocId ; 
                String[] activateDocIds = new String[1];  // We need to activate and publish only the last modified doc. (attachment) 
                String[] remDocIds = new String[]{};             
          
            for(Attachment att: attch)
            {
                // activate and publish  only the last modified attachment            
                 activateDocIds[0] = att.Id;
               //  selectdDocIds[0] = att.Id;
                 publishDocId = att.Id; 
            }
                
                stub.SessionHeader = SessionHeader; 
                boolean response = stub.activateAgreement(agreementId, activateDocIds, remDocIds);
                if(!response)
                    System.debug('Failed to activate agreement : '+agreementId);
             
                
                // publish latest modified attachments 
                //contentStub.SessionHeader = contentSessionHeader; 
                //boolean contentResponse ;  // = contentStub.publishToContentRepository(agreementId,selectdDocIds[0]);
                
             
                if(publishDocId !=null)
                    publish(agreementId, sessionID, publishDocId); 
                
           // }

            }
            catch(Exception e){
                System.debug(e.getMessage());
                return; 
            }
        
        
    }
    
    
  
    public static void publish(Id agreementId, String sessionID, String publishDocId){
    
        try{
             soapSforceComSchemasApttusContentStub.AgreementWebService contentStub = new soapSforceComSchemasApttusContentStub.AgreementWebService(); 
             soapSforceComSchemasApttusContentStub.SessionHeader_element contentSessionHeader = new soapSforceComSchemasApttusContentStub.SessionHeader_element();
             contentSessionHeader.sessionId = sessionID; 
             contentStub.SessionHeader = contentSessionHeader; 
              
             boolean ContentResponse = contentStub.publishToContentRepository(agreementId,publishDocId);
             if(!contentResponse)
                System.debug('Publish to Content response: '+contentResponse);
        
        }
        catch(Exception e){
            System.debug(e.getMessage()); 
            return; 
        }
    
    
    }
    
}