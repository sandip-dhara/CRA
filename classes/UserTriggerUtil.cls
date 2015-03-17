/**
* Class Name: UserTriggerUtil
* Author: Accenture
* Date: 12-APR-2012 
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on User object
*/
public class UserTriggerUtil{
    
    public static Map<Id, User> userBUGBUById;
    /**
    * @description: Populate/Update Legacy_Employee_Ref__c field with EmployeeNumber
    */
    public static void updateEmployeeNumber(List<User> lstUsers) {
        if (lstUsers != null && lstUsers.size() > 0) {
            for (User user : lstUsers) {
                //If Legacy Employee Reference is different than employee number, populate it 
                // Abrar 13-05-12 R1-EF01 Commenting the below code as per the ALM 1104
                //if(user.EmployeeNumber != null && user.EmployeeNumber != user.Legacy_Employee_Ref__c)
                //  user.Legacy_Employee_Ref__c = user.EmployeeNumber;
                  system.debug(user.EmployeeNumber);
                  system.debug(lstUsers);
                  user.EmployeeNumber = '.';
                
            }
        }
    }

    /**
    * @description: Populate Legacy Id
       @Owner: Deepak Saxena CO R5.0 EF
    */
 public static void updateFederationIdentifierForChatter(List<User> lstUsers) {
        if (lstUsers != null && lstUsers.size() > 0) {
            Profile p = [Select Id From Profile Where Name = 'Chatter Free User'];
            for (User user : lstUsers) {
                if(user.ProfileId == p.Id)
                  user.FederationIdentifier = user.Email;
                
            }
        }
    }
    /**
    * @description: Updating Lead BU and Lead GBU if user's BU and GBU is changing and user is owner of the lead 
    */
    public static void updateBUandGBUonLead(Map<Id, User> newUsers, Map<Id, User> oldUsers) {
        if (newUsers != null && newUsers.size() > 0 && oldUsers != null && oldUsers.size() > 0) {
            userBUGBUById = new Map<Id, User>();
            for (User user : newUsers.values()) {
                
                if (oldUsers.get(user.Id) != null && (user.Business_Group__c != oldUsers.get(user.Id).Business_Group__c ||
                                                    user.Global_Business_Unit__c != oldUsers.get(user.Id).Global_Business_Unit__c)) {
                                                    
                        userBUGBUById.put(user.Id, user);
                }
            }   
        } 
        if (userBUGBUById != null && userBUGBUById.size() > 0) {
            updateLeadBuandGBU();
        }           
    }
    /**
    * @description: Updating Lead BU and Lead GBU  
    */
    public static void updateLeadBuandGBU() {
        if (userBUGBUById != null && userBUGBUById.size() > 0) {
            List<Lead> leads = new List<Lead>();
            try{
                for (Lead lead : [Select id, ownerId, Lead_BU__c, Lead_GBU__c
                                    From Lead
                                    Where ownerId IN :userBUGBUById.keySet()]) {
                    lead.Lead_BU__c = userBUGBUById.get(lead.ownerId).Business_Group__c;  
                    lead.Lead_GBU__c = userBUGBUById.get(lead.ownerId).Global_Business_Unit__c;                       
                    leads.add(lead);
                }
            
                if (leads.size() > 0) {
                    Database.SaveResult[] result = Database.update(leads);
                }
            }
            catch(Exception e) {
                CreateApexErrorLog.insertHandledExceptions(e, null, 'Lead', 'UserTriggerUtil', 'Class');
            }
            
        }
    }
    
    /**
    * @description: Update Lead Owner Manager field on Lead based on User Manager
    * @param - List<User> lstUsers = List of users Trigger.new
    */
    public static void updateLeadOwnerManager(Map<Id, User> newUsers, Map<Id, User> oldUsers) {        
        Set<Id> userIds = new Set<Id>();

        Map<Id, Id> managerIdByUSerId = new Map<Id, Id>();
        if (newUsers != null && newUsers.size() > 0 && oldUsers != null) {
            for (User user : newUsers.values()) {
                User oldUser = oldUsers.get(user.Id);
                if(oldUser != null && user.ManagerId != oldUser.ManagerId) {
                    userIds.add(user.Id);
                    if (user.ManagerId != null) {
                        managerIdByUSerId.put(user.Id, user.ManagerId);
                    }
                }
            }
            system.debug('managerIdByUSerId>>>'+managerIdByUSerId);
            List<Lead> fetchedLeads = new List<Lead>();
            List<Lead> leadsToUpdate = new List<Lead>();
            fetchedLeads = fetchAssignedLeads(userIds);
            system.debug('fetchedLeads : ' + fetchedLeads);
            for(Lead lead : fetchedLeads) {
                lead.Lead_Owner_Manager__c = managerIdByUSerId.get(lead.OwnerId);
                system.debug('lead.Lead_Owner_Manager__c : ' + lead.Lead_Owner_Manager__c);
                leadsToUpdate.add(lead);
            }
           
            try{
                if (leadsToUpdate.size() > 0) {
                    Database.SaveResult[] result = Database.update(leadsToUpdate,false);
                }
            }
            catch(Exception e) {
                CreateApexErrorLog.insertHandledExceptions(e, null, 'Lead', 'UserTriggerUtil', 'Class');
            }
        }
    } 
    
    /**
    * @description: Populate/Update Email_Address__c field with Email
    * @param - Set<Id> userIds - set Of user ids
    */ 
    public static List<Lead> fetchAssignedLeads(Set<Id> userIds) {
        List<Lead> fetchLeads = new List<Lead>();
        if (userIds != null && userIds.size() > 0) {
            fetchLeads = [Select Id, Lead_Owner_Manager__c, OwnerId
                            From Lead
                            Where OwnerId IN :userIds
                            /* And Lead_State__c = 'Assigned' */
                            Limit :(Limits.getLimitQueryRows()- 100)];
        }
        return fetchLeads;
    }   
    /**
    * @description: Populate/Update Email_Address__c field with Email
    * 
    * 
    */
    /*public static void updateEmailID(List<User> lstUsers) {
        if (lstUsers != null && lstUsers.size() > 0) {
            for (User user : lstUsers) {
                //If Custom field Email Address is different from standard Email Field, populate it 
                if(user.Email!= null && user.Email!= user.Email_Address__c) {
                    user.Email_Address__c = user.Email;
                }
            }
        }
    }*/
}