public with sharing class CallPlanExtension{
public Call_Plan__c cp;
public String retURL {get;set;}
public String OppPlanId;
public Boolean new_flag = false;
ApexPages.StandardController cp_controller;


    public CallPlanExtension(ApexPages.StandardController controller) {
        cp_controller = controller;
        this.cp = (Call_Plan__c)cp_controller.getRecord();

        retURL = ApexPages.currentPage().getParameters().get('retURL');
        oppPlanId = ApexPages.currentPage().getParameters().get('OppPlanId');
        system.debug('OpPId'+oppPlanId);
    }
    
    Public PageReference Save()
    {
        
            if (oppPlanId != null){
                cp.Opportunity_Plan__c = oppPlanId;
            }else if (oppPlanId == null){
                oppPlanId = cp.Opportunity_plan__c;
            }
            cp_controller.save();
            
            PageReference pr = new PageReference('/apex/cp_list?id='+oppPlanId);
            pr.setRedirect(true);
            return pr;
         
            
    }
       Public PageReference SaveoppPlan()
    {
        try{
             system.debug('OpPId'+oppPlanId);
            if (oppPlanId != null){
                cp.Opportunity_Plan__c = oppPlanId;
            }else if (oppPlanId == null){
                oppPlanId = cp.Opportunity_plan__c;
            }
            
            upsert cp;
            PageReference pr = new PageReference('/apex/cp_list?id='+oppPlanId);
            //pr.setRedirect(true);
            return pr;
          }catch(System.DmlException e){
          ApexPages.Message mymsgs=new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage());
          ApexPages.addMessages(e);
          oppPlanId=null;
          return null;
          }
            
    }
     public pageReference cancel(){
        pageReference pr = new pageReference(retURL);
        pr.setRedirect(true);
        return pr;
    }
    
}