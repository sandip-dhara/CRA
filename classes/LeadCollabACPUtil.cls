/**
* Class Name: LeadCollabACPUtil
* Author: hp
* Date: 18-JULY-2012 
* Description: Contains helper methods for "LEAD" object trigger
*/
public  class LeadCollabACPUtil {
    public static Set<Id> grpIds = new Set<Id>();
    
    /**
    * @description: This method is called from trigger on Alliance & Channel partner records on after-insert event.
    *               Insert OpportunityShare record for corresponding parnter account territory group
    * @param: new Alliance & Channel partner records
    * 
    */
    public static void addLeadShareToPartners(Map<Id,Lead> LeadNewMap){
        Map<Id,List<String>> leadWithTerritoryGroups = new Map<id,List<String>>();
        List<LeadShare> newLeadSharing = new List<LeadShare>();
        Map<id,Location__c> acpNewMap=new Map<id,Location__c>();
        List<Lead> leadslist=new List<Lead>();
        set<ID> leadOwnerIDs=new Set<ID>();
        List<User> leadOwnersList=new List<USer>();
        set<ID> partnerLocations=new Set<ID>();
        List<Location__c> partnerLocationList=new List<Location__c>();
        Map<ID,Lead> ownerIDLeadMap=new Map<ID,Lead>();
        for(Lead leadObj: LeadNewMap.values()){
            String ownerid=leadObj.ownerid;
           //Lead Lobj=[ select id,account_name__c from Lead where id=:id];
           
           if(ownerid.substring(0,3)!= '00G' ){
               leadOwnerIDs.add(leadobj.ownerid);
               ownerIDLeadMap.put(leadObj.ownerID,leadObj);
           }
        }
        if(leadOwnerIDs!=null){
            leadOwnersList=[select id,name,Partner_account_ID__c,Location_Record_Id__c from user where id in :leadOwnerIDs];
        }
        
        for(User u: leadOwnersList){
            if(u.Location_Record_Id__c != null)
            partnerLocations.add(u.Location_Record_Id__c);
        
        }
        
        if(partnerLocations.size() > 0){
            partnerLocationList=[select id,name from Location__c where id in :partnerLocations];
        }
        
        for(Lead ld: LeadNewMap.values()){
            User us = new user();
            for(User u:leadOwnersList){
                if(ld.ownerid==u.id)
                us=u;
            }
            
        if(partnerLocationList.size() > 0 && us != null && us.location_Record_Id__c!=null && us.location_Record_Id__c!='' ){    
            for(Location__c loc: partnerLocationList){
                
               // if(us.Partner_account_ID__c== convertTo15Digit(acc.id))
                if(us.Location_Record_Id__c==loc.id)
                acpNewMap.put(ld.id,loc);
            }
        }
            
        }
        
           
        
        if(acpNewMap.size()>0 || acpNewMap != null){
        leadWithTerritoryGroups = getOpptyShareForLeads(acpNewMap);
        
        }
        
        if(leadWithTerritoryGroups == null || leadWithTerritoryGroups.isEmpty()){
            
            return;
        }
        
        leadslist=[select id,name,partner_owned__c from Lead where id in :leadWithTerritoryGroups.keySet()];
        
        for(Id LeadId : leadWithTerritoryGroups.keySet()){
            Boolean partnerOwned=false;
            for (Lead Ld:leadsList){
                if(Ld.id==LeadID){
                    
                    partnerOwned=Ld.partner_owned__c;
                    
                }
            }
            
            if(partnerOwned==true){
                
                for(Id groupId : leadWithTerritoryGroups.get(LeadId)){
                    LeadShare newShareRec = new LeadShare(LeadAccessLevel = 'Read');
                    newShareRec.LeadId = LeadId;
                    newShareRec.UserOrGroupId = groupId;
                    newLeadSharing.add(newShareRec);
                    
                    
                }
            }
        }       
        
        if(newLeadSharing != null && newLeadSharing.size() >0 ){
            Database.SaveResult[] newShareResults;
            try{
                newShareResults = database.insert(newLeadSharing,false);  
            }catch (Exception e){
                CreateApexErrorLog.insertHandledExceptions(e, newShareResults, 'Account', 'LeadCollabACPUtil', 'Class');
            }
        }
    }
    
  
    
    /**
    * @description: get parnter account territory group corresponding to Opportunities  
    * @param: new Alliance & Channel partner records
    * 
    */
    public static Map<Id,List<String>> getOpptyShareForLeads(Map<id,Location__c> acpNewMap){
        
        Set<Id> partnerLocIds = new Set<Id>();
        Set<Id> terrIdsOfLead = new Set<Id>();      
        Map<Id,Sales_Territory_Location_Assignment__c> locWithTerritory;
        Map<Id,Sales_Territory__c> partnerTerritories;
        Map<Id,List<Id>> leadWithTrritories = new Map<id,List<Id>>();
        Map<Id,List<String>> leadWithTerritoryGroups = new Map<id,List<String>>();
        
        
        for(Location__c newAcpRec : acpNewMap.values()){
            if(newAcpRec.id != null && String.valueOf(newAcpRec.id) != ''){
                partnerLocIds.add(newAcpRec.id);
            }
        }
        
        locWithTerritory = new Map<Id,Sales_Territory_Location_Assignment__c>([Select Id, Location__c, Sales_Territory__c from Sales_Territory_Location_Assignment__c where Location__c in : partnerLocIds]);
        
        if(locWithTerritory == null || locWithTerritory.isEmpty()){
            return null;
        }
        
        for(Location__c newAcpRec : acpNewMap.values()){
            ID LeadId;
            for(Id LID: acpNewMap.keyset()){
                if(acpNewMap.get(lID).id ==newAcpRec.id){
                    LeadId=Lid;
                }
                
            }
            for(Sales_Territory_Location_Assignment__c locWithTerritoryRec : locWithTerritory.values()){
                if((newAcpRec.id == locWithTerritoryRec.Location__c) && (locWithTerritoryRec.Sales_Territory__c != null) 
                && (String.valueOf(locWithTerritoryRec.Sales_Territory__c) != '')){
                    terrIdsOfLead.add(locWithTerritoryRec.Sales_Territory__c);
                    if(LeadWithTrritories.containsKey(LeadId)){
                        List<ID> relTerrIds = leadWithTrritories.get(LeadId);
                        relTerrIds.add(locWithTerritoryRec.Sales_Territory__c);
                        leadWithTrritories.put(LeadId,relTerrIds);
                    }else{
                        leadWithTrritories.put(LeadId,new List<ID>{locWithTerritoryRec.Sales_Territory__c});
                    }
                }
            }           
        }
        
        partnerTerritories = new Map<Id,Sales_Territory__c>([select Id, GroupID__c from Sales_Territory__c where Id in: terrIdsOfLead]);
        
        if(partnerTerritories == null || partnerTerritories.isEmpty()){
            return null;
        }
        
        for(Id LeadId : leadWithTrritories.keySet()){
            List<String> relGpIds = new List<String>();
            for(Id territoryId : leadWithTrritories.get(LeadId)){
                if (partnerTerritories.get(territoryId).GroupID__c != null && String.valueOf(partnerTerritories.get(territoryId).GroupID__c) != ''){
                    relGpIds.add(partnerTerritories.get(territoryId).GroupID__c);
                    grpIds.add(partnerTerritories.get(territoryId).GroupID__c);
                }
            }
            leadWithTerritoryGroups.put(LeadId,relGpIds);
        }
        
        if(leadWithTerritoryGroups != null || leadWithTerritoryGroups.size()>0 ){
            return leadWithTerritoryGroups;
        }else {
            return null;
        }   
    
    }
    /*public Static String convertTo15Digit(String paramID){
        try{
            if(paramID.length()>15){
                paramID = paramID.substring(0,15);
            }
        }catch(Exception e){
        }
        return paramID;
    }*/

}