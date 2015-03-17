/**********************************************************
* Class Name: LocationTriggerController
* Author: HP 
* Date: 13-Mar-2013 
* Description: To Update the strike count to zero when the HP Lead Status value changed from 
              'Non compliant' to either 'Active','Inactive' or 'Disqualified'
***********************************************************/

public class LocationTriggerController{

    /*
    *@description: Update the demerit count of the user to zero when location status changed from "Non Compliant" to "Active/Inactive/Disqualified"
    */

public static void toUpdateStrikeCount(Map<Id,Location__c> newLocationMap, Map<Id,Location__c> oldLocationMap){

List<Id> locationIdList= new List<Id>();
List<User> userList = new List<User>();
List<User> toUpdateUserList= new List<User>();

    for(Id updatedLocId : newLocationMap.keyset()){
        if((oldLocationMap.get(updatedLocId).HP_Lead_Status__c =='Non compliant') && (newLocationMap.get(updatedLocId).HP_Lead_Status__c !='Non compliant') && (newLocationMap.get(updatedLocId).HP_Lead_Status__c !=NULL)){
        locationIdList.add(newLocationMap.get(updatedLocId).Id);
        newLocationMap.get(updatedLocId).demerit_count__c=0;
        }
    }
    
    if(locationIdList.size() > 0){
        userList=[select id,Strike_Count__c from User where Location_Record_Id__c in :locationIdList];
        system.debug('user list'+userList.size());
        }
        
    if (userList.size() > 0){
        for(User user:userList){
        user.Strike_Count__c=0;
        toUpdateUserList.add(user);
        }
        Update toUpdateUserList;
    }
        
}

    /*
    *@description: To restrict the user to change the "HP Lead Status" value from "Inactive" to "Non Compliant"
    */

public static void locationStatusNotInactiveToNoncompliant(Map<Id,Location__c> newLocationMap, Map<Id,Location__c> oldLocationMap){

    for(Location__c loc:newLocationMap.values()){
        if(oldLocationMap.get(loc.id).HP_Lead_Status__c=='Inactive' && loc.HP_Lead_Status__c=='Non compliant'){
        loc.addError(System.Label.Cannot_Change_Lead_Status_from_Inactive_to_Non_compliant);
         return;
         }
     }
  }
  
/**
    * @description: This method is called from before update trigger
    *               It identifies Locations which are updated
    *               & set evaluate territory flag to true . 
    * @param: List of new Location__c records
    * TM: Vinay M: Req:6021 Apr 8,2013
    **/
public static void beforeUpdate(Map<Id,Location__c> newLocationMap, Map<Id,Location__c> oldLocationMap){
    
    List<Location__c> locationsToUpdateList = new List<Location__c>();
    
    if(newLocationMap != null && newLocationMap.size() > 0 && oldLocationMap != null && oldLocationMap.size() > 0){
        for(Id locationId: newLocationMap.keyset()){
            if(newLocationMap.get(locationId).Business_Relationship__c != oldLocationMap.get(locationId).Business_Relationship__c ||
               newLocationMap.get(locationId).Country__c != oldLocationMap.get(locationId).Country__c ||
               newLocationMap.get(locationId).Location_Name__c != oldLocationMap.get(locationId).Location_Name__c ||
               newLocationMap.get(locationId).MDCP_Organization_ID__c != oldLocationMap.get(locationId).MDCP_Organization_ID__c ||
               newLocationMap.get(locationId).State__c != oldLocationMap.get(locationId).State__c ||
               newLocationMap.get(locationId).World_Region1__c != oldLocationMap.get(locationId).World_Region1__c ||
               newLocationMap.get(locationId).Postal_Code__c != oldLocationMap.get(locationId).Postal_Code__c){
               locationsToUpdateList.add(newLocationMap.get(locationId));
            }
        }
    }
    
    if(locationsToUpdateList.size() > 0){
        for(Location__c loc: locationsToUpdateList){
            loc.EvaluateTerritory__c = true;
        }
    }
}
    
}