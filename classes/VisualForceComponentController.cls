public class VisualForceComponentController {
public String learningBoard{get;set;}
public List<Learning_Board__c> lbList = new List<Learning_Board__c>();

    public VisualForceComponentController(ApexPages.StandardController controller) {
        lbList = [select name,description__c from Learning_Board__c where id =:learningBoard];
        for(Learning_Board__c lb: lbList) {
            
        }

    }

   
   
   Public VisualForceComponentController(){
       
   }
    
}