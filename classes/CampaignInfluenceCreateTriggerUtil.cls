/**
* Class Name: CampaignInfluenceCreateTriggerUtil
* Author: HP
* Date: 02-APR-2013 
* Requirement # Request Id: 
* Description:
*/
public with sharing class CampaignInfluenceCreateTriggerUtil{
    public static boolean CIVar = False;
    public static void resetExistingPrimaryAndInsertOrUpdateCIPrimary(Map<Id,Id> mapOpportunityWithCampaignId,String triggeredFrom){
        List<Campaign_Influence__c> listCampaignInfluence = new List<Campaign_Influence__c>();
        List<Campaign_Influence__c> listInsertCampaignInfluence = new List<Campaign_Influence__c>();
        Map<Id,Id> mapOpptyIdCampaignIdForDuplicateCheck = new Map<Id,Id>();
        if(triggeredFrom == 'Update'){

            for(Campaign_Influence__c objCampaignInfluence : [Select Id,Primary_Campaign_Source__c,Opportunity__c,Campaign__c from Campaign_Influence__c where  Opportunity__c IN: mapOpportunityWithCampaignId.keySet()]){
                for(Id opptyID : mapOpportunityWithCampaignId.keyset()){
                    if(objCampaignInfluence.Opportunity__c == opptyID){
                        if(objCampaignInfluence.Campaign__c != mapOpportunityWithCampaignId.get(objCampaignInfluence.Opportunity__c)){
                            objCampaignInfluence.Primary_Campaign_Source__c = False;
                            listCampaignInfluence.add(objCampaignInfluence);
                        }
                        else{
                            objCampaignInfluence.Primary_Campaign_Source__c = True;
                            mapOpptyIdCampaignIdForDuplicateCheck.put(objCampaignInfluence.Opportunity__c,objCampaignInfluence.Campaign__c);
                            listCampaignInfluence.add(objCampaignInfluence);
                        }
                    }
                }
            }
        }
        for(Id OpptyId : mapOpportunityWithCampaignId.keySet()){
            if(!mapOpptyIdCampaignIdForDuplicateCheck.isEmpty()){
                if(mapOpptyIdCampaignIdForDuplicateCheck.get(OpptyId) != mapOpportunityWithCampaignId.get(OpptyId)){
                    Campaign_Influence__c objCampaignInfluence = new Campaign_Influence__c();
                    objCampaignInfluence.Opportunity__c = OpptyId;
                    objCampaignInfluence.Campaign__c = mapOpportunityWithCampaignId.get(OpptyId);
                    objCampaignInfluence.Primary_Campaign_Source__c = True;
                    listInsertCampaignInfluence.add(objCampaignInfluence);
                }
            }
            else{
                Campaign_Influence__c objCampaignInfluence = new Campaign_Influence__c();
                objCampaignInfluence.Opportunity__c = OpptyId;
                objCampaignInfluence.Campaign__c = mapOpportunityWithCampaignId.get(OpptyId);
                objCampaignInfluence.Primary_Campaign_Source__c = True;
                listInsertCampaignInfluence.add(objCampaignInfluence);
            }
        }
        if(!listInsertCampaignInfluence.isEmpty()){
            //if(triggeredFrom == 'Insert'){
                CIVar =true;
                Database.SaveResult[] srList = Database.insert(listInsertCampaignInfluence, false);
            //}
        }
        system.debug('**********listCampaignInfluence1*****'+listCampaignInfluence);
        if(!listCampaignInfluence.isEmpty()){
            If(triggeredFrom == 'Update'){
                CIVar =true;
                system.debug('**********listCampaignInfluence*****'+listCampaignInfluence);
                Database.SaveResult[] srList = Database.update(listCampaignInfluence);
                system.debug('*********srList*****'+srList);
                
            }
        }
    }
/*
Map<Id,Id> opptyCIMap = new Map<Id,Id>();
Map<Id,Id> opptyCIMapT = new Map<Id,Id>();
Map<Id,Campaign_Influence__c> opptyCIMapF = new Map<Id,Campaign_Influence__c>();
List<Campaign> campaignList =  new List<Campaign>();
Campaign_Influence__c CI ;
List<Campaign_Influence__c> CIList =  new List<Campaign_Influence__c>();
Map<Id,Campaign_Influence__c> CIListUpd =  new Map<Id,Campaign_Influence__c>();
public static boolean CIVar = False;
    
        
    
    public void createCIBeforeInsert(List<Opportunity> oppListNew){
        
        for(Opportunity opp : oppListNew){
        if(opp.CampaignId != null){
            opptyCIMap.put(opp.Id,opp.CampaignId);//Map of Opportunity Id and Campaign Id
        }
    }
    
   insertUpdateCI(opptyCIMap,oppListNew); 
       
    
   }
   
   
    public void createCIBeforeUpdate(List<Opportunity> oppListNew,List<Opportunity> oppListOld){
    if(HPUtils.CampaignInfluenceFlag == False){
         if(test.isRunningTest()== true){
            HPUtils.CampaignInfluenceFlag = True;
        }
        for(Opportunity oppNew : oppListNew){
            for(Opportunity oppOld : oppListOld){
                if(oppNew.CampaignId != oppOld.CampaignId && oppNew.CampaignId != null){
                 opptyCIMap.put(oppNew.Id,oppNew.CampaignId);
                } 
                if(oppNew.CampaignId != oppOld.CampaignId && oppNew.CampaignId == null){
                 opptyCIMapT.put(oppNew.Id,oppNew.CampaignId);
                 System.debug('********opptyCIMapT***'+opptyCIMapT);
                }
            }
        }
    
   
    insertUpdateCI(opptyCIMap,oppListNew);
     } 
   }
  
  public void insertUpdateCI(Map<Id,Id> opptyCIMap,List<Opportunity> oppListNew){
     
     //If already existing CI with Primary Checked, retrieve CI to set Primary as False
     for(Campaign_Influence__c CIF:[Select Id,Primary_Campaign_Source__c,Campaign__c,Opportunity__c from Campaign_Influence__c where Opportunity__c IN:opptyCIMap.keySet() AND Campaign__c IN:opptyCIMap.values()]){
         opptyCIMapF.put(CIF.Campaign__c,CIF);
     }
     
    System.debug('**************opptyCIMapF*****'+opptyCIMapF);       
    System.debug('**************opptyCIMap*****'+opptyCIMap);
    
    List<Campaign_Influence__c> CItempList = [Select Id,Primary_Campaign_Source__c from Campaign_Influence__c where Primary_Campaign_Source__c = TRUE AND (Opportunity__c IN: opptyCIMap.keySet() OR Opportunity__c IN: opptyCIMapT.keySet())];
  for(Opportunity opp : oppListNew){
     // for(Id camp : opptyCIMap.values()){
          if(opptyCIMap.get(opp.Id) == opp.CampaignId && opp.CampaignId != null){
           if(!opptyCIMapF.containsKey(opp.CampaignId)){ 
           System.debug('**********Create New CI');          
           CI = new Campaign_Influence__c(Opportunity__c =opp.Id ,Campaign__c = opp.CampaignId,Primary_Campaign_Source__c = TRUE);
           CIList.add(CI);   
          }
          else{
              System.debug('**********Update primary of Existing CI');  
              opptyCIMapF.get(opp.CampaignId).Primary_Campaign_Source__c = TRUE;
              CIListUpd.put(opptyCIMapF.get(opp.CampaignId).Id,opptyCIMapF.get(opp.CampaignId));
          }
          }
      
   }
   System.debug('********opptyCIMapT***'+opptyCIMapT);
     //for(Campaign_Influence__c CItemp:CItempList){
       //  CItemp.Primary_Campaign_Source__c = False;
         //CIListUpd.put(CItemp.Id,CItemp);
     //}
     
     try{
     CIVar = TRUE;
    System.debug('*************In try Block****');
        if (!CIList.isEmpty()){
              System.debug('********wil be Inserted********');
               insert CIList;
               System.debug('*********Inserted********');
               CIVar = False;
            }
         
        if (!CIListUpd.values().isEmpty()){
                CIVar = TRUE;
               System.debug('********wil be Updated********');
               update CIListUpd.values();
               System.debug('*********Updated********');
               CIVar = False;
            }
        }
        catch (DMLException ex) {
            CreateApexErrorLog.insertHandledExceptions(ex, null, 'Opportunity', 'createNewCI ', 'Trigger');
        }
     
      
  }*/
   
  
}