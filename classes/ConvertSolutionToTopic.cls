public class ConvertSolutionToTopic {
  
    public Solution soln {get;set;}
    public GETSAT_TOPIC__Topic__c Topic {get;set;}
    
    public ConvertSolutionToTopic(ApexPages.StandardController stdController) {
        soln = new Solution();
        Topic = new GETSAT_TOPIC__Topic__c();
        if (ApexPages.CurrentPage().getParameters().get('id') != null) {
            for(Solution s : [Select Id,SolutionName,SolutionNote From Solution Where Id = : ApexPages.CurrentPage().getParameters().get('id')]){
                soln = s;
                Topic.GETSAT_TOPIC__Subject__c = s.SolutionName;
                Topic.GETSAT_TOPIC__Description__c = s.SolutionNote;
            }
        }
    }

    public pageReference DoSubmit(){
      
      pageReference pr = null;
      
      try{
        // webservices callouts to post on the GetSat API
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        Blob headerValue = Blob.valueOf('verticafaq@hp.com:VerticaNumb3r1');
        req.setHeader('Authorization', EncodingUtil.base64Encode(headerValue));
        req.setEndpoint('https://api.getsatisfaction.com/topics');

        JSONGenerator gen = JSON.createGenerator(false); // pass true for prettified content
        gen.writeStartObject();
        gen.writeFieldName('topic');
            gen.writeStartObject();
            gen.writeStringField('style', Topic.GETSAT_TOPIC__Style__c.toLowerCase());
            gen.writeStringField('subject', Topic.GETSAT_TOPIC__Subject__c);
            gen.writeStringField('additional_detail', Topic.GETSAT_TOPIC__Description__c);
            gen.writeStringField('company_domain', 'vertica');
            gen.writeEndObject();
        gen.writeEndObject();

        String payload = gen.getAsString();
//        String payload =  '{\"topic\": {\"style\": \"'+ Topic.GETSAT_TOPIC__Style__c.toLowerCase() + '\", \"subject\": \"'+ Topic.GETSAT_TOPIC__Subject__c + '\", \"additional_detail\": \"'+ Topic.GETSAT_TOPIC__Description__c + '\", \"company_domain\": \"vertica\"}}';

        req.setBody(payload);
        System.debug(payload);
        Http http = new Http();
        
        try {
              HTTPResponse res = http.send(req);
              
              System.debug('STATUS:'+res.getStatus());
              System.debug('STATUS_CODE:'+res.getStatusCode());
        
        } catch(System.CalloutException e) {
            // Exception handling goes here....
            System.debug('Error from POST request.');
            System.debug(e);
        }

  //      upsert Topic;
 
        pr = new PageReference('/501/o');
        
      }
      catch(Exception ex){
        
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage())); 
      }

      return pr;
    }
    
     
}