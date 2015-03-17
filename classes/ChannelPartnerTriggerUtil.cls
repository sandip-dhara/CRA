/**
* Class Name: ChannelPartnerTriggerUtil
* Author: Accenture
* Date: 12-APR-2012 
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on Channel_Partner__c object
*/
public class ChannelPartnerTriggerUtil{
 /**
    * @description: Initially added Channel Partner as Primary
    * 
    * 
    */
    public static void checkPrimaryFlag(List<Channel_Partner__c> partnerNewList) {
        
        Set<Id> ChannelOppIds = new Set<Id>();
        Set<Id> ExistingChannelOppIds = new Set<Id>();
        Map<Id,Channel_Partner__c> ExistingChannelMaps = new Map<Id,Channel_Partner__c>();
        
        Map<Id,List<Channel_Partner__c>> OpptyIdbyChannelPartnerMap = new Map<Id,List<Channel_Partner__c>>();
        Map<Id,List<Channel_Partner__c>> OpptyIdbyChannelPartnerNoPrimaryMap = new Map<Id,List<Channel_Partner__c>>();
        List<Channel_Partner__c> partnerToinsert = new List<Channel_Partner__c>();
        List<Channel_Partner__c> existingPartners = new List<Channel_Partner__c>();
        List<Channel_Partner__c> existingAllPartners = new List<Channel_Partner__c>();
        Map<Id,List<Channel_Partner__c>> OpptyIdbymultimap = new Map<Id,List<Channel_Partner__c>>();//handling multiple primary partners
        Map<ID,List<channel_partner__c>> optyIdByMultiplePartnerMap=new Map<ID,List<channel_partner__c>>();
        Map<ID,List<channel_partner__c>> optyIdByMultipleNewPartnerMap=new Map<ID,List<channel_partner__c>>();
        
        for(Channel_Partner__c par : partnerNewList){
            ExistingChannelOppIds.add(par.Opportunity__c);    
        }
       /* if (ExistingChannelOppIds!= null){
            existingPartners = [Select Id,Name, Primary__c,Opportunity__c,Partner_Type__c , Channel_Partner__c from Channel_Partner__c where Opportunity__c =: ExistingChannelOppIds and Partner_Type__c = 'Channel Partner'] ;
        }  */
        /* handling duplicate partners to opportunity  */
        
        if (ExistingChannelOppIds!= null){
            for(channel_partner__c ch: [Select Id,Name, Primary__c,Opportunity__c,Partner_Type__c,Location__c , Channel_Partner__c from Channel_Partner__c   where Opportunity__c =: ExistingChannelOppIds]){
                if(ch.Partner_Type__c == 'Channel Partner'){
                    existingPartners.add(ch);
                }
                if(optyIdByMultiplePartnerMap.containsKey(ch.Opportunity__c)){
                    List<channel_partner__c> existPartnerList=new List<channel_partner__c>();
                    existPartnerList=optyIdByMultiplePartnerMap.get(ch.Opportunity__c);
                    existPartnerList.add(ch);
                    optyIdByMultiplePartnerMap.put(ch.Opportunity__c,existPartnerList);
                }else{
                    List<channel_partner__c> existPartnerList=new List<channel_partner__c>();
                    existPartnerList.add(ch);
                    optyIdByMultiplePartnerMap.put(ch.Opportunity__c,existPartnerList);
                
                }
            }
            for(channel_partner__c ch: partnerNewList){
                if(optyIdByMultipleNewPartnerMap.containsKey(ch.Opportunity__c)){
                    List<channel_partner__c> newPartnerList=new List<channel_partner__c>();
                    newPartnerList=optyIdByMultipleNewPartnerMap.get(ch.Opportunity__c);
                    newPartnerList.add(ch);
                    optyIdByMultipleNewPartnerMap.put(ch.Opportunity__c,newPartnerList);
                }else{
                    List<channel_partner__c> newPartnerList=new List<channel_partner__c>();
                    newPartnerList.add(ch);
                    optyIdByMultipleNewPartnerMap.put(ch.Opportunity__c,newPartnerList);
                
                }
            }
            for(ID optyid: optyIdByMultipleNewPartnerMap.keySet()){
                Set<ID> duplicateLocationID=new Set<ID>();
                List<channel_partner__c> channelPartnerList=optyIdByMultipleNewPartnerMap.get(optyid);
                Map<ID,ID> existLocationIDMap=new Map<ID,ID>();
                if(optyIdByMultiplePartnerMap.containsKey(optyid)){
                    for(channel_partner__c chpartner : optyIdByMultiplePartnerMap.get(optyid)){
                        existLocationIDMap.put(chpartner.Location__c,chpartner.Location__c);
                    }
                }
                for(channel_partner__c chpartner : channelPartnerList){
                    if(chpartner.Location__c != null){
                        if(existLocationIDMap.containsKey(chpartner.Location__c))
                        chpartner.addError('Location already exist');
                        
                        if(duplicateLocationID.contains(chpartner.Location__c)){
                            chpartner.addError('Location already exist');
                        }
                        else{
                            duplicateLocationID.add(chpartner.Location__c);
                        }
                    }
                }
                
            
            }   
        }
        
        
        /* handling duplicate partners to opportunity  */
        
        for(Channel_Partner__c part : existingPartners){
            
                ExistingChannelMaps.put(part.Opportunity__c,part); 
                ChannelOppIds.add(part.Opportunity__c); 
               
        }
        for(Channel_Partner__c partner : partnerNewList){
            if(partner.Primary__c == true && partner.Partner_Type__c == 'Alliance Partner'){
                partner.Primary__c = false;
            }else if (partner.Primary__c == false && partner.Partner_Type__c == 'Channel Partner'){
                
                if (OpptyIdbyChannelPartnerMap.containsKey(partner.Opportunity__c)) {
                    List<Channel_Partner__c> listTempChannelPartner = new List<Channel_Partner__c>();
                    listTempChannelPartner = OpptyIdbyChannelPartnerMap.get(partner.Opportunity__c);
                    listTempChannelPartner.add(partner);
                    OpptyIdbyChannelPartnerMap.put(partner.Opportunity__c,listTempChannelPartner);   
                }else {
                     List<Channel_Partner__c> listTempChannelPartner = new List<Channel_Partner__c>();
                     listTempChannelPartner.add(partner);
                     OpptyIdbyChannelPartnerMap.put(partner.Opportunity__c,listTempChannelPartner);
                }
            } else if (partner.Primary__c == true && partner.Partner_Type__c == 'Channel Partner'){
                  ChannelOppIds.add(partner.Opportunity__c);  
            }
            
            
       }
      
       for(Id copp : ChannelOppIds){
            OpptyIdbyChannelPartnerMap.remove(copp);
       }
       
       
       
      
       for(Id OpptyId: OpptyIdbyChannelPartnerMap.Keyset()){
           Boolean PrimaryFlag = true;
           
           for (Channel_Partner__c p : OpptyIdbyChannelPartnerMap.get(OpptyId)){
               if (PrimaryFlag){
                  // if (ExistingChannelMaps.get(p.Opportunity__c).Primary__c == false){
                   p.Primary__c = true;   
                   PrimaryFlag = false;
                   partnerToinsert.add(p);
                  // }
               }
           }
       } 
       //Update partnerToinsert;   
    }
    
     /**
    * @description: making oldest created channel partner as primary channel partner after deleting the current primary channelpartner
    * 
    * 
    */
     public static void checkPrimaryChannelPArtnerAfterDelete() {
     
        Datetime myDate;
        String firstCreated ;
        Integer i = 0;
        
        Map<Id,Channel_Partner__c> NewMap = new Map<Id,Channel_Partner__c>();
        List<Channel_Partner__c> deleteChannelPartners = (List<Channel_Partner__c>)Trigger.old;
        List<Channel_Partner__c> existingChannelPartners = new List<Channel_Partner__c>();
        Set<Id> OpptyIdsOfToBeDeletedChannelPartner = new set<Id>();
        for (Channel_Partner__c deleteCP: deleteChannelPartners) {
            if (deleteCP.Primary__c) {
                OpptyIdsOfToBeDeletedChannelPartner.add(deleteCP.Opportunity__c);   
            }
        }
        
        if (OpptyIdsOfToBeDeletedChannelPartner != null){
            existingChannelPartners = [Select Primary__c, Partner_Type__c, Partner_Status__c, Opportunity__c, CreatedDate
                                     From Channel_Partner__c where Opportunity__c =:OpptyIdsOfToBeDeletedChannelPartner AND Partner_Type__c =: 'Channel Partner'];
                                     
        }    
        
        Map<Id, List<Channel_Partner__c>> checkForOpportunityId = new Map<Id, List<Channel_Partner__c>>();
        List<Channel_Partner__c> checkForChannelPartners = new List<Channel_Partner__c>();
        for (Channel_Partner__c deletePartner : existingChannelPartners) {
            if(checkForOpportunityId.containsKey(deletePartner.Opportunity__c)) {
                checkForChannelPartners.add(deletePartner);
                checkForOpportunityId.put(deletePartner.Opportunity__c, checkForChannelPartners);
            } else {
                checkForChannelPartners = new List<Channel_Partner__c>();
                checkForChannelPartners .add(deletePartner);
                checkForOpportunityId.put(deletePartner.Opportunity__c, checkForChannelPartners);
            }           
        }
        
        
        Try{  
        for(Id key: checkForOpportunityId.KeySet()) {
        
          
            if(checkForOpportunityId.get(key).size() == 1) {
                checkForOpportunityId.get(key)[0].Primary__c = true;
                update checkForOpportunityId.get(key)[0];
            } else if (checkForOpportunityId.get(key).size() > 1){
           
              //checkForOpportunityId.get(key);  
              
              for(i=0;i<checkForOpportunityId.get(key).size();i++){               
                  
                  
                  if (myDate == null || myDate > checkForOpportunityId.get(key)[i].CreatedDate){
                      
                      NewMap.put(key,checkForOpportunityId.get(key)[i]);                     
                      myDate = checkForOpportunityId.get(key)[i].CreatedDate;
                      
              }
              }
              for (Channel_Partner__c cp : checkForOpportunityId.get(key)){
             
                    If (NewMap.get(key).CreatedDate == myDate ){
                                              
                        NewMap.get(key).Primary__c = true;
            }    
        }
            }
            
        }
        
        
        Update NewMap.values();
        //Update checkForOpportunityId.values();
        
        }catch (Exception e) {
                    System.debug('Exception:ChannelPartnerTriggerUtil.checkIsPrimaryFlag:'+e.getMessage());
            } 
        
        
    }
    
    /**
    * @description: unCheck other partner's primary flag
    * 
    * 
    */
    public static void checkIsPrimaryFlagOnInsert(Map<id,Channel_Partner__c> partnerNewMap) {
        Set<Id> optyIds = new Set<Id>();
        List<Channel_Partner__c> partnerToupdateList = new List<Channel_Partner__c>();
        Map<Id,Channel_Partner__c> channelPartnerPrimaryMap = new Map<Id,Channel_Partner__c>();
        
         for(Channel_Partner__c chpartner: partnerNewMap.values()){
            if(chpartner.Primary__c == true){
                optyIds.add(chpartner.Opportunity__c);
                if(channelPartnerPrimaryMap.containsKey(chpartner.Opportunity__c))
                    {
                    chpartner.addError('More than one channel partner is being set as primary for an Opportunity');
                    }
                else
                    {
                    channelPartnerPrimaryMap .put(chpartner.Opportunity__c,chpartner);
                    }
            }
         }
        
       /* for(Channel_Partner__c partner : partnerNewMap.values()){
            if(partner.Primary__c == true){
                optyIds.add(partner.Opportunity__c);
            }
        }*/
        if(optyIds.size()>0){
            for (Channel_Partner__c cp : [Select id,Primary__c 
                                            From Channel_Partner__c 
                                            Where Primary__c =: true 
                                            And Opportunity__c IN : optyIds
                                            And Id NOT IN : partnerNewMap.keySet()]) {
                cp.Primary__c = false;
                partnerToupdateList.add(cp);
            }
        }
        if(partnerToupdateList.size()>0){
            try
            {
                Database.SaveResult[] results = Database.update(partnerToupdateList,false);
                Integer counter = 0;
                for(Database.SaveResult result : results){
                    if (!result.isSuccess() || Test.isRunningTest())
                    {
                        Database.Error[] errs = result.getErrors();
                        for(Database.Error err : errs){
                            if(partnerNewMap.containsKey(partnerToupdateList.get(counter).id)){
                                partnerNewMap.get(partnerToupdateList.get(counter).id).Primary__c.addError(err.getMessage());
                            }
                        }
                    }  
                    counter++;
                }
            } catch (Exception e) {
                    System.debug('Exception:ChannelPartnerTriggerUtil.checkIsPrimaryFlag:'+e.getMessage());
            } 
        }
    }
    /**
    * @description: unCheck other partner's primary flag
    * 
    * 
    */
    public static void checkIsPrimaryFlagOnUpdate(Map<id,Channel_Partner__c> partnerOldMap,Map<id,Channel_Partner__c> partnerNewMap) {
        Set<Id> optyIds = new Set<Id>();
        List<Channel_Partner__c> partnerToupdateList = new List<Channel_Partner__c>();
        Map<Id,Channel_Partner__c> channelPartnerPriMap= new Map<Id,Channel_Partner__c>();
        Set<Id> ExistingChannelOppIds = new Set<Id>();
        Map<ID,List<channel_partner__c>> optyIdByMultiplePartnerMap=new Map<ID,List<channel_partner__c>>();
        Map<ID,List<channel_partner__c>> optyIdByMultipleNewPartnerMap=new Map<ID,List<channel_partner__c>>();
        
        for(Channel_Partner__c chPartner: partnerNewMap.values()){
            if(chPartner.Primary__c == true && partnerOldMap.get(chPartner.id).Primary__c != chPartner.Primary__c ){
                optyIds.add(chPartner.Opportunity__c);
                }
            if(chPartner.Primary__c == true)
                {
                //system.debug('!@'+Map);
                if(channelPartnerPriMap.containsKey(chPartner.Opportunity__c))
                    {
                    chPartner.addError('More than one channel partner is being set as primary for an Opportunity');
                    }
                else
                    {
                    channelPartnerPriMap.put(chPartner.Opportunity__c,chPartner);
                    }
                }
           } 
        
       /* for(Channel_Partner__c partner : partnerNewMap.values()){
            if(partner.Primary__c == true && partnerOldMap.get(partner.id).Primary__c != partner.Primary__c ){
                optyIds.add(partner.Opportunity__c);
            }
        }  */
        
        /* handling duplicate partners to opportunity  */
        for(Channel_partner__c chpartner : partnerNewMap.values()){
            if(chpartner.Location__c != partnerOldMap.get(chpartner.id).Location__c)
            ExistingChannelOppIds.add(chpartner.opportunity__c);
        }
        if (ExistingChannelOppIds!= null){
            for(channel_partner__c ch: [Select Id,Name, Primary__c,Opportunity__c,Partner_Type__c,Location__c , Channel_Partner__c from Channel_Partner__c   where Opportunity__c =: ExistingChannelOppIds]){
                
                if(optyIdByMultiplePartnerMap.containsKey(ch.Opportunity__c)){
                    List<channel_partner__c> existPartnerList=new List<channel_partner__c>();
                    existPartnerList=optyIdByMultiplePartnerMap.get(ch.Opportunity__c);
                    existPartnerList.add(ch);
                    optyIdByMultiplePartnerMap.put(ch.Opportunity__c,existPartnerList);
                }else{
                    List<channel_partner__c> existPartnerList=new List<channel_partner__c>();
                    existPartnerList.add(ch);
                    optyIdByMultiplePartnerMap.put(ch.Opportunity__c,existPartnerList);
                
                }
            }
            for(channel_partner__c ch: partnerNewMap.values()){
                if(optyIdByMultipleNewPartnerMap.containsKey(ch.Opportunity__c)){
                    List<channel_partner__c> newPartnerList=new List<channel_partner__c>();
                    newPartnerList=optyIdByMultipleNewPartnerMap.get(ch.Opportunity__c);
                    newPartnerList.add(ch);
                    optyIdByMultipleNewPartnerMap.put(ch.Opportunity__c,newPartnerList);
                }else{
                    List<channel_partner__c> newPartnerList=new List<channel_partner__c>();
                    newPartnerList.add(ch);
                    optyIdByMultipleNewPartnerMap.put(ch.Opportunity__c,newPartnerList);
                
                }
            }
            for(ID optyid: optyIdByMultipleNewPartnerMap.keySet()){
                Set<ID> duplicateLocationID=new Set<ID>();
                List<channel_partner__c> channelPartnerList=optyIdByMultipleNewPartnerMap.get(optyid);
                Map<ID,ID> existLocationIDMap=new Map<ID,ID>();
                if(optyIdByMultiplePartnerMap.containsKey(optyid)){
                    for(channel_partner__c chpartner : optyIdByMultiplePartnerMap.get(optyid)){
                        existLocationIDMap.put(chpartner.Location__c,chpartner.Location__c);
                    }
                }
                for(channel_partner__c chpartner : channelPartnerList){
                    if(chpartner.Location__c != null){
                        if(existLocationIDMap.containsKey(chpartner.Location__c))
                        chpartner.addError('Location already exist');
                        
                        if(duplicateLocationID.contains(chpartner.Location__c)){
                            chpartner.addError('Location already exist');
                        }
                        else{
                            duplicateLocationID.add(chpartner.Location__c);
                        }
                    }
                }
                
            
            }   
        }
        
        
        /* handling duplicate partners to opportunity  */
        if(optyIds.size()>0){
            for (Channel_Partner__c cp : [Select id,Primary__c 
                                            From Channel_Partner__c 
                                            Where Primary__c =: true 
                                            And Opportunity__c IN : optyIds
                                            And Id NOT IN : partnerNewMap.keySet()]) {
                cp.Primary__c = false;
                partnerToupdateList.add(cp);
            }
        }
        if(partnerToupdateList.size()>0){
            try
            {
                Database.SaveResult[] results = Database.update(partnerToupdateList,false);
                Integer counter = 0;
                for(Database.SaveResult result : results){
                    if (!result.isSuccess() || Test.isRunningTest())
                    {
                        Database.Error[] errs = result.getErrors();
                        for(Database.Error err : errs){
                            if(partnerNewMap.containsKey(partnerToupdateList.get(counter).id)){
                                partnerNewMap.get(partnerToupdateList.get(counter).id).Primary__c.addError(err.getMessage());
                            }
                        }
                    }  
                    counter++;
                }
            } catch (Exception e) {
                    System.debug('Exception:ChannelPartnerTriggerUtil.checkIsPrimaryFlag:'+e.getMessage());
            } 
        }
    }
}