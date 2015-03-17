/**********************************************************
* Class Name: DealReg_NewOpptyOverrideController
* Author: HP
* Date: 18-Sep-2012 
* Requirement # Request Id:
* Description: Controller class to override New oppty button as per the logged user
***********************************************************/
public with sharing class DealReg_NewOpptyOverrideController{
        public User partnerUser=new User();
        list<Program_Location_Association__c> programLocationAssociation=new list<Program_Location_Association__c> ();
        
        public DealReg_NewOpptyOverrideController(ApexPages.StandardController controller) {
        }
 /*
  * @Description:Canceling opportunity
  * @Return: Opportunity page list view page
 */     
        public PageReference doCancel(){
           return new pagereference('/apex/HP_OpportunityTabOverride?save_new=1&sfdc.override=1');
        }   
 /*
  * @Description:Redireting to the customer search page if logged user is eligible for that
  * @Return: Opportunity page list view page
 */       
        public PageReference redirect(){         
            partnerUser=[select IsportalEnabled,Partner_account_ID__c,Location_Record_Id__c from user where id=:UserInfo.getUserId()];
            programLocationAssociation=[Select  Program__c, Program__r.name  from Program_Location_Association__c where Location__c=:partnerUser.Location_Record_Id__c];            
            if(partnerUser.IsportalEnabled==true){
               if(programLocationAssociation.size()==0){
                  Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.NOT_AUTHORISED_USER));
                  return null;
               }else{
                 return new pagereference('/apex/DealReg_CustomerSearchPage');
                }
             }else{
                   Pagereference pgRef;
                   String navigationURL = Label.HP_New_Opty_URL;
                   pgRef = new Pagereference(navigationURL);
                   map<String, String> mapUrlParam = Apexpages.currentPage().getParameters();
                   if(mapUrlParam != null && mapUrlParam.size() > 0) {
                        if(mapUrlParam.containskey('sfdc.override')) {
                            mapUrlParam.remove('sfdc.override');
                        }
                        if(mapUrlParam.containskey('save_new')) {
                            mapUrlParam.remove('save_new');
                        }
                        for(String key : mapUrlParam.keyset()){
                          pgRef.getParameters().put(key,mapUrlParam.get(key));
                        }    
                   }
                   pgRef.setRedirect(true);
                   return pgRef;
             }
       }
}