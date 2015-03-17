/**
* Class Name: CampaignInfluenceTriggerUtil
* Author: HP
* Date: 01-OCT-2012 
* Requirement # Request Id: 
* Description:
*/
public with sharing class CampaignInfluenceTriggerUtil{


    List<String> CIList = new List<String>();
    Map<Id,List<String>> oppCampMap = new Map<Id,List<String>>();
    Map<Id,Id>oppCampMapUpd  = new Map<Id,Id>();
    List<String> CIIdRest = new List<String>();
    List<String> CIId = new List<String>();
    List<Campaign_Influence__c> CIListToUpdate = new List<Campaign_Influence__c>();
    
    Map<Id,Id> oppCamp = new Map<Id,Id>();
    Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
    List<Campaign_Influence__c> campListUpd = new List<Campaign_Influence__c>();
    List<Campaign_Influence__c> campList= new List<Campaign_Influence__c>();
    Map<Id,Id> PCSTrueMap = new Map<Id,Id>();
    Map<Id,Campaign_Influence__c> PCSFalse = new Map<Id,Campaign_Influence__c>();
    Map<Id,Id> PCSTrue = new Map<Id,Id>();
    Map<Id,Id> dupOppty = new Map<Id,Id>();
    
    Set<Id> opptyId = new Set<Id>();
    List<Opportunity> optyList = new List<Opportunity>();
    public static boolean CIvarChk = False;
 //   public static boolean CIbeforeUpdateChk = False; 
    
    
    public void checkPrimaryFlagAfterInsert(List<Campaign_Influence__c> CINewList){
    CIvarChk = True;
        for(Campaign_Influence__c CI: CINewList){
            if(CI.Primary_Campaign_Source__c == True){
                oppCamp.put(CI.Opportunity__c,CI.campaign__c);//Map of Oppty and Campaign with Primary Campaign=True                                              
                
                //Map of Opportunity and CI, if more than one CI are Primary
                if(oppCampMap.containsKey(CI.Opportunity__c)){
                List<String> CIList1 = oppCampMap.get(CI.Opportunity__c);
                    CIList1.add(CI.campaign__c);
                    oppCampMap.put(CI.Opportunity__c,CIList1);
                }
                else{
                    List<String> CIList1 = new List<String>();
                    CIList1.add(CI.campaign__c);
                    oppCampMap.put(CI.Opportunity__c,CIList1);
                    }               
                
                }
            }
   
        for(Opportunity opp :[Select Id,CampaignId from Opportunity where Id IN: oppCamp.keySet()]){
         System.debug('********oppCampMap*******'+oppCampMap); 
         if(oppCampMap.containsKey(opp.Id)){
            CIIdRest = oppCampMap.get(opp.Id);
            opp.CampaignId = CIIdRest[0]; //Link Opportunity to Campaign if Primary is checked
            oppMap.put(opp.Id,opp);
            oppCampMapUpd.put(opp.Id,CIIdRest[0]); //All Primary Campains and Opportunity Map
        }
     }
System.debug('********oppCampMap111111111111*******'+oppCampMap);
System.debug('********oppCampMapUpd*******'+oppCampMapUpd);
    for(Campaign_Influence__c camp:[Select Id,Primary_Campaign_Source__c from  Campaign_Influence__c where Opportunity__c IN: oppCamp.keySet() 
                                    AND Primary_Campaign_Source__c = True AND Campaign__c NOT IN: oppCampMapUpd.values()]){
        System.debug('******camp'+camp);
        camp.Primary_Campaign_Source__c = False;
        campList.add(camp);
    } 
    try{    
         if(campList != null){
            update campList;
         }   
       }

    catch(Exception ex) {
        CreateApexErrorLog.insertHandledExceptions(ex, null, 'Campaign_Influence__c', 'CampaignInfluenceTriggerUtil', 'Class');
    }
     try{
         if(oppMap.values() != null){
         System.debug('*********CIvarChk*'+CIvarChk);
         CIvarChk = True;
            update oppMap.values();
             
         }
      }
     catch(DMLException dmlEx) {
     for(Campaign_Influence__c CI : CINewList){
     for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
      CI.addError(dmlEx.getDmlMessage(i));
      }
     }
        CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Opportunity', 'CampaignInfluenceTriggerUtil', 'Class');
    } 
    CIvarChk = False;
 }
  
  public void checkDuplicateCampaignBeforeInsert(List<Campaign_Influence__c> CINewList)
  
  {System.debug('##################CINewList'+CINewList);
        CIvarChk = True;
        List<Campaign_Influence__c> campListOpp = new List<Campaign_Influence__c>();
      
       
        
        for(Campaign_Influence__c CI: CINewList){
            dupOppty.put(CI.Opportunity__c,CI.Campaign__c);
        }
   campListOpp = [Select Id,Opportunity__c,Campaign__c,Opportunity__r.CloseDate from Campaign_Influence__c where Opportunity__c IN: dupOppty.keySet()];
            for(Campaign_Influence__c CI : CINewList){
            for(Campaign_Influence__c CIRec:campListOpp){
                 if(CIRec.Campaign__c == CI.Campaign__c && (CIRec.Opportunity__c == CI.Opportunity__c && CI.Opportunity__c != null)){ 
                 CI.Campaign__c.addError('This Campaign is already associated with this Opportunity');
            }
         }       
     }
     CIvarChk = False;

}
  
   public void checkPrimaryFlagAfterUpdate(List<Campaign_Influence__c> CINewList,Map<Id,Campaign_Influence__c> CIOldMap){
    CIvarChk = True;
       for(Campaign_Influence__c CI : CINewList){
         if(CI.Primary_Campaign_Source__c != CIOldMap.get(CI.Id).Primary_Campaign_Source__c){
             if(CI.Primary_Campaign_Source__c == True){
                 PCSTrue.put(CI.Opportunity__c,CI.Campaign__c);//On Change of PCS to True                 
                
                 //Map of Opportunity and CI, if more than one CI are Primary
                if(oppCampMap.containsKey(CI.Opportunity__c)){
                List<String> CIList1 = oppCampMap.get(CI.Opportunity__c);
                    CIList1.add(CI.campaign__c);
                    oppCampMap.put(CI.Opportunity__c,CIList1);
                }
                else{
                    List<String> CIList1 = new List<String>();
                    CIList1.add(CI.campaign__c);
                    oppCampMap.put(CI.Opportunity__c,CIList1);
                }
                  

             }
             else{
                   PCSFalse.put(CI.Opportunity__c,CI);//On Change of PCS to false
                   System.debug('*********PCSFalse************'+PCSFalse);
             }
         }
         System.debug('*********PCSTrue************'+PCSTrue);
         System.debug('*********oppCampMap.keySet()************'+oppCampMap.keySet());
     } 
     
    List<Opportunity> oppList = [Select Id,CampaignId from Opportunity where Id IN :PCSFalse.keySet() OR Id IN :oppCampMap.keySet()];
    
    for(Opportunity opp:oppList){
        //For CI checked as False
        if(PCSFalse.values() != null){
            if(PCSFalse.containsKey(opp.Id)){
                opp.CampaignId = null;
                oppMap.put(opp.Id,opp);
            }           
        }
        //For CI checked as Primary
        if(oppCampMap.values() != null){
            if(oppCampMap.containsKey(opp.Id)){
                CIIdRest = oppCampMap.get(opp.Id);
                opp.CampaignId = CIIdRest[0]; //Link Opportunity to Campaign if Primary is checked
                oppMap.put(opp.Id,opp);
                oppCampMapUpd.put(opp.Id,CIIdRest[0]); //All Primary Campains and Opportunity Map
            }           
        }
    }

    
     System.debug('*********oppMap************'+oppMap);
     
         
     //All CI which are currently not Primary
     for(Campaign_Influence__c camp:[Select Id,Primary_Campaign_Source__c from  Campaign_Influence__c where Primary_Campaign_Source__c = True AND Opportunity__c IN: PCSTrue.keySet() AND Campaign__c NOT IN:oppCampMapUpd.values()]){
        camp.Primary_Campaign_Source__c = False;
        PCSFalse.put(camp.Opportunity__c,camp);
        campListUpd.add(camp);
    }
         
       
    //Update All Campaigns
    try{
        if(campListUpd.size()>0){
            update campListUpd;    
        }
    }
    catch(Exception ex) {
        CreateApexErrorLog.insertHandledExceptions(ex, null, 'Campaign_Influence__c', 'CampaignInfluenceTriggerUtil', 'Class');
    } 
    
      //Update all Opportunities
         try{
            if(oppMap.values() != null){
            CIvarChk = True;
                update oppMap.values(); 
         }
      }
     catch(DMLException dmlEx) {
        for(Campaign_Influence__c CI : CINewList){
            for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                CI.addError(dmlEx.getDmlMessage(i));
            }
        }
        CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Opportunity', 'CampaignInfluenceTriggerUtil', 'Class');
    } 
    CIvarChk = False;
       
  }
  public void checkPrimaryFlagBeforeUpdate(List<Campaign_Influence__c> CINewList,Map<Id,Campaign_Influence__c> CIOldMap){

   //     System.debug('*********CIbeforeUpdateChk: '+CIbeforeUpdateChk);
        for(Campaign_Influence__c CI : CINewList){
            Id primaryCampaignId ;
            List<Campaign_Influence__c> lstCampaignInfluence = [SELECT Id,Opportunity__c, Primary_Campaign_Source__c, Campaign__c  FROM Campaign_Influence__c WHERE Opportunity__c = :CI.Opportunity__c AND Primary_Campaign_Source__c= True AND Id != :CI.Id];
            
            
            
           if(lstCampaignInfluence.size()==0){ 
             if(CI.Primary_Campaign_Source__c != CIOldMap.get(CI.Id).Primary_Campaign_Source__c){
                if(CIOldMap.get(CI.Id).Primary_Campaign_Source__c == True && CI.Primary_Campaign_Source__c==False){           
                 System.debug('****** CIOldMap.get(CI.Id).Primary_Campaign_Source__c: '+CIOldMap.get(CI.Id).Primary_Campaign_Source__c);
                 System.debug('****** CI.Primary_Campaign_Source__c: '+CI.Primary_Campaign_Source__c);
                 
                 CI.addError('This is a primary CI. To unset as primary, choose a different CI and set its Primary Campaign Source flag. ');
                 
                }
            }
          }
      
      }
  }
  //Delete Event
  public void removeOpptyAssociationAfterDelete(List<Campaign_Influence__c> CIList){
          CIvarChk = True;     
       for(Campaign_Influence__c CI : CIList){
           if(CI.Primary_Campaign_Source__c == True){
               opptyId.add(CI.Opportunity__c);
           }
       
       }
     for(Opportunity opp : [Select id,CampaignId from Opportunity where Id In:opptyId]){
         opp.CampaignId = null;
         optyList.add(opp);
     }
     
     
     //Update all Opportunities
         try{
            if(OptylIst != null){
                update OptylIst; 
         }
      }
     catch(DMLException dmlEx) {
        for(Campaign_Influence__c CI : CIList){
            for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                CI.addError(dmlEx.getDmlMessage(i));
            }
        }
        CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Opportunity', 'CampaignInfluenceTriggerUtil', 'Class');
    } 
    CIvarChk = False;   
} 

// 
/**  R6 
    * @description: Check campaign before delete
    */
public static void checkPrimaryCampaignBeforeDelete() {
    
        List<Campaign_Influence__c> deleteCIs = (List<Campaign_Influence__c>)Trigger.old;
    
         ID marketingCampaignRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Marketing Campaign').getRecordTypeId(); 
         ID salesInitiativesRT =  Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Sales Initiatives').getRecordTypeId();        
          for(Campaign_Influence__c delCI : deleteCIs){
        
            System.debug('Primary flag is '+delCI.Primary_Campaign_Source__c +' for CI '+delCI.Id);
            
            List<Campaign_Influence__c> lstCampaignInfluence = new List<Campaign_Influence__c>();   
            List<Campaign_Influence__c> CIToUpdateAsPrimary = new List<Campaign_Influence__c>(); 
            
            Set<Id> campaignIds  = new Set<Id>();
            Set<Id> marketingCampaigns =  new Set<Id>();
            Set<Id> salesInitiativeCampaigns =  new Set<Id>(); 
            Set<Id> partnerCampaigns = new Set<Id>();   
                    
            
            if(delCI.Primary_Campaign_Source__c){
            
                lstCampaignInfluence = [SELECT Id,Opportunity__c, Primary_Campaign_Source__c, Campaign__c  FROM Campaign_Influence__c WHERE Opportunity__c = :delCI.Opportunity__c];
            
                // Check if this is the only CI record. If yes, do not allow delete. 
                
                if(lstCampaignInfluence.size()>1){
                
                System.debug(' Campaigns for this oppty: '+lstCampaignInfluence.size());
                    // select another CI record to update as primary 
                    
                    // Create a list of campaigns for this oppty.
                    for(Campaign_Influence__c campaigns : lstCampaignInfluence){
                        if(campaigns.Campaign__c != delCI.Campaign__c)
                                campaignIds.add(campaigns.Campaign__c);   
                    }
                    
                                    
                    // Check for marketing and SI campaigns
                    
                    List<Campaign>  camp = [SELECT Id, RecordTypeId, Marketing_Campaign_flag__c FROM Campaign where Id IN :campaignIds]; 
                

                    
                    for(Campaign c :camp){
                    
                        System.debug('********Campaign Id: '+c.Id +'  ***** Marketing_Campaign_flag__c: '+c.Marketing_Campaign_flag__c );
                        
                        if(c.RecordTypeId== marketingCampaignRT ){
                            marketingCampaigns.add(c.Id); 
                            System.debug('Added Marketing campaign: '+c.Id);
                        }
                        else if(c.RecordTypeId== salesInitiativesRT){
                            salesInitiativeCampaigns.add(c.Id);
                            System.debug('Added SI campaign');
                            }
                            
                       // else
                         //    partnerCampaigns.add(c.Id);                                                   
                    }
                    
                
                    if(marketingCampaigns.size() > 0 )
                        CIToUpdateAsPrimary = [SELECT Id , Campaign__c FROM Campaign_Influence__c WHERE Campaign__c IN :marketingCampaigns AND Opportunity__c =:delCI.Opportunity__c  ORDER BY CreatedDate DESC];
                        
                    else if(salesInitiativeCampaigns.size() > 0 ){
                        CIToUpdateAsPrimary = [SELECT Id , Primary_Campaign_Source__c, Campaign__c FROM Campaign_Influence__c WHERE Campaign__c IN :salesInitiativeCampaigns AND Opportunity__c =:delCI.Opportunity__c  ORDER BY CreatedDate DESC];
                    }
                  //  else 
                    //    CIToUpdateAsPrimary = [SELECT Id , Primary_Campaign_Source__c, Campaign__c FROM Campaign_Influence__c WHERE Campaign__c IN :partnerCampaigns ORDER BY LastModifiedDate DESC];

               // }
                    System.debug('CIToUpdateAsPrimary.size():'+CIToUpdateAsPrimary.size() );
                    if(CIToUpdateAsPrimary.size()>0){
                        try{
                        System.debug('*******CIToUpdate : '+CIToUpdateAsPrimary[0].Id +' -Campaign__c:'   +CIToUpdateAsPrimary[0].Campaign__c);
                        CIToUpdateAsPrimary[0].Primary_Campaign_Source__c = true; 
                        update CIToUpdateAsPrimary[0];
                        }
                        catch(DMLException dmlEx) {
                            for(Campaign_Influence__c CI : deleteCIs){
                                  for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                                        CI.addError(dmlEx.getDmlMessage(i));
                                  }
                            }
                            CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Opportunity', 'CampaignInfluenceTriggerUtil', 'Class');
                        } 
    
                    }
                
                }
                
                
                
                
                
            }
            
        }
    
    }
  
}