/**********************************************************
* Class Name: CampaignInfluenceController
* Author: HP
* Date: 20-SEP-2012 
* Requirement # Request Id: 
* Description: Controller to add Campains to CI
***********************************************************/

public class CampaignInfluenceController{
    
    public Campaign_Influence__c campaignInfluence{get;set;}    
    public String oppId{get;set;}
    public Opportunity oppty{get; set;}
    
    public Campaign_Influence__c CIRec{get;set;}
    public String CIId{get;set;}
    public Boolean hasEditAccess {get;set;}
    
    // R6 
    public List<Campaign_Influence__c> lstCampaignInfluence;
 
    
    public CampaignInfluenceController(ApexPages.StandardController controller) {
        campaignInfluence= new Campaign_Influence__c(); 
        if (ApexPages.currentPage().getParameters().get('Id') != null) {
        CIId = ApexPages.currentPage().getParameters().get('Id');
        CIRec = [Select Id,Name,Opportunity__c,Opportunity__r.Name,Campaign__c,Campaign__r.Name,Primary_Campaign_Source__c from Campaign_Influence__c where Id=: CIId];
        }
        if (ApexPages.currentPage().getParameters().get('oppId') != null) {
            oppId= ApexPages.currentPage().getParameters().get('oppId');
            campaignInfluence.Opportunity__c = oppId;
            oppty = [Select Id,Name from Opportunity where Id=: oppId];
        }
    }
     /**
    * @description: Checks if logged in user has edit access on current opportunity record
    * 
    */
    public void checkOptyEditAccessCI() {
    System.debug('************************In checkOptyEditAccess');
        hasEditAccess = true;
        if (oppId != null) {
                String editAccessResult = CheckOptyAccess.checkOptyEditAccessCI(oppId);

                if (editAccessResult != Label.SUCCESS) {
                        hasEditAccess = false;
                }
        }
    }

    /**
    * @description: Save method to add Lead Products to Lead
    * @return: Redirects to Lead Page after save
    */
    public PageReference saveOppCI() {   
        try {
      /* Modified for R6
            if (campaignInfluence!= null) {
                insert campaignInfluence;  
                
      */
      
              if (campaignInfluence!= null) {
                   // CampaignInfluenceTriggerUtil.CIbeforeUpdateChk = TRUE;
              
                    ID marketingCampaignRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Marketing Campaign').getRecordTypeId(); 

//                    ID salesInitiativesRT =  Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Sales Initiatives').getRecordTypeId(); 

//                    System.debug('Marketing RT: '+marketingCampaignRT);
                    System.debug('Primary campaign source: '+campaignInfluence.Primary_Campaign_Source__c);
//                    System.debug('********Campaign Name*********'+campaignInfluence.Campaign__c);
                    lstCampaignInfluence = [SELECT Id,Opportunity__c, Primary_Campaign_Source__c FROM Campaign_Influence__c WHERE Opportunity__c = :oppId]; 
  //                  System.debug('lstCampaignInfluence size: '+lstCampaignInfluence.size());
                    if(lstCampaignInfluence.size()==0)
                        campaignInfluence.Primary_Campaign_Source__c = true; 
                    else{
                        lstCampaignInfluence.clear();
                        lstCampaignInfluence = [SELECT Id,Campaign__c, Opportunity__c, Primary_Campaign_Source__c FROM Campaign_Influence__c WHERE Opportunity__c = :oppId and Primary_Campaign_Source__c = true];
                        // Karthik : Debug Statement : Start
                        System.debug('****************oppId = ' + oppId);
                        // Karthik : Debug Statement : End
                       
                    //    if(lstCampaignInfluence.size() > 0  &&  campaignInfluence.Primary_Campaign_Source__c == true )
                      //      campaignInfluence.Primary_Campaign_Source__c = false; 
                    
                            for(Campaign_Influence__c campInf:lstCampaignInfluence){
                                System.debug(' campInf Id: '+campInf.Id);
                                Campaign  camp = [SELECT Id, RecordTypeId,  Marketing_Campaign_flag__c FROM Campaign where Id = :campInf.Campaign__c]; 
                                Campaign campType = [SELECT Id, RecordTypeId, Marketing_Campaign_flag__c FROM Campaign where Id = :campaignInfluence.Campaign__c]; 
                        
                              //  if(camp.Marketing_Campaign_flag__c == false && campType.Marketing_Campaign_flag__c == true ){
                              
                                  if(camp.RecordTypeId!= marketingCampaignRT  && campType.RecordTypeId == marketingCampaignRT ){
                                     
                                    campaignInfluence.Primary_Campaign_Source__c = true; 
                                   // campInf.Primary_Campaign_Source__c = false; 
                                }
                           // update campInf;
                            }
                      }
                                
                insert campaignInfluence;  
            }      
                            
                     
        } 
        catch (DMLException dmlEx) {
            CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Campaign_Influence__c', 'CampaignInfluenceController', '');
            for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
            }
            return null;
        }           
        PageReference retPage = null;
        if (oppId!= null && oppId!= '') {
            retPage = new PageReference('/'+oppId);
        }
        return retPage;              
    }
    
    /**
    * @description: Save method to add Lead Products to Lead
    * @return: Redirects to Lead Page after save
    */
    public PageReference saveCI() {   
        try {
            if (CIRec!= null) {
                update CIRec;  
            }           
        } catch (DMLException dmlEx) {
            CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Campaign_Influence__c', 'CampaignInfluenceController', '');
            for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
            }
            return null;
        }           
        PageReference retPage = null;
            retPage = new PageReference('/'+CIRec.Opportunity__c);
        return retPage;              
    }
        
    /**
    * @description: Cancel method 
    * @return: Redirects to Lead Page 
    */
    public PageReference Cancel() {   
          PageReference retPage ;  
          retPage = new PageReference('/'+oppId);
        return retPage;            
    }
    
    /**
    * @description: Cancel method 
    * @return: Redirects to Opportunity Page 
    */
    public PageReference cancelCI() {     
        PageReference retPage ;
        if (oppId != null ) {   
            retPage = new PageReference('/'+oppId);
            }
            else if(CIRec.Opportunity__c!= null){
                retPage = new PageReference('/'+CIRec.Opportunity__c);
            }
        
        return retPage;              
     }
    /**
    * @description: Link for Opportunity 
    * @return: Redirects to Opportunity Page 
    */

     public PageReference OpportunityId() {   
        PageReference pgref = null;
        if(oppId != null){
        pgref = new Pagereference('/'+oppId);
        }
        else if(CIRec.Opportunity__c != null){
           pgref = new Pagereference('/'+CIRec.Opportunity__c);
        }
        pgref.setRedirect(true);        
        return pgref;            
    }

}