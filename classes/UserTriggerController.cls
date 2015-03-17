/**
* Class Name: UserTriggerController
* Author: Accenture
* Date: 12-APR-2012 
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on user object
*/
public class UserTriggerController{
    
    /**
    * @description: Action Before user Insert 
    * 
    * 
    */
    public static void beforeInsert(){
        UserTriggerUtil.updateEmployeeNumber(trigger.new);
        
        //UserTriggerUtil.updateEmailID(trigger.new);
    }
    
    /**
    * @description: Action Before user Update 
    * 
    * 
    */
    public static void beforeUpdate(){
        UserTriggerUtil.updateEmployeeNumber(trigger.new);        
    }
   /**
    * @description: Action Before user Update 
    * 
    * 
    */
    public static void beforeUpdate(Map<Id, User> newUsers, Map<Id, User> oldUsers){
            for(User userData : newUsers.values()){         
                if((newUsers.get(userData.Id).isActive != oldUsers.get(userData.Id).isActive) && newUsers.get(userData.Id).isActive == false){
                    newUsers.get(userData.Id).InactiveUser_Remove_from_Territory__c = true;
                   // newUsers.get(userData.Id).User_Inactivated_Time__c = system.now();
                }
            }        
    }
    /**
    * @description: Action After user Update 
    * 
    * 
    */    
    public static void afterUpdate(Map<Id, User> newUsersMap, Map<Id, User> oldUsersMap) {
        UserTriggerUtil.updateLeadOwnerManager(newUsersMap, oldUsersMap);
        UserTriggerUtil.updateBUandGBUonLead(newUsersMap, oldUsersMap);
    }
    
    /**
    * Author: Accenture
    * Date: 24-JULY-2012 
    * Modification: Added method for action after user insert 
    * Last Modified on 19th Dec : Developed for R4 by HP for action after Partner User insert.
    *        
    */
    public static void afterInsert(Map<Id, User> newUserMap, Map<Id, User> oldUserMap) {
        PartnerCollabUserUtil.addPartnerToQueue(newUserMap);
    }
}