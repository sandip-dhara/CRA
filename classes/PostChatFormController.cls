public class PostChatFormController {

public String DisconnectedBy {get;set;}

public String CurrentRequestTime {get;set;}
public String CurrentStartTime {get;set;}
public String CurrentDisconnectedBy {get;set;}

    public PostChatFormCOntroller(ApexPages.StandardController controller) {
         
         DisconnectedBy = ApexPages.currentPage().getParameters().get('disconnectedBy');
         system.debug('!!!#'+DisconnectedBy);
         
         PostChatParam(); 
        
    }
    
    Public void PostChatParam(){
         if(DisconnectedBy=='error'){
            CurrentDisconnectedBy = 'Sorry!! No Agents';
            system.debug('@@@'+CurrentDisconnectedBy);
         }
         else
            CurrentDisconnectedBy = DisconnectedBy;
        
        CurrentRequestTime = '<script> ReqTimeFunc(); </script>';
        CurrentStartTime = '<script> StartTimeFunc(); </script>';
    
    }
    
    
    

}