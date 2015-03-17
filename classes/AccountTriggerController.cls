/**
* Class Name: AccountTriggerController
* Author: Accenture
* Date: 23-APR-2012 
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on Account object
*/
public class AccountTriggerController {
    /**
    * @description: To get 15 digit Id 
    */
    public static String convertTo15Digit(String paramID){
        try {
            if (paramID.length() > 15) {
                paramID = paramID.substring(0,15);
            }
        } catch (Exception eX) {
            CreateApexErrorLog.insertHandledExceptions(ex, null, 'String', 'AccountTriggerController', 'Class');
        }
        return paramID;
    }   
    
    /**
    * @description: Method to validate permissions on Account object
    */
    public static void validatePermissions() {
        /* Bypass Admin Profiles mentioned in Custom Settings to allow him to make changes to account */
        Map<String,Admin_Profiles__c> adminProfilesMap = Admin_Profiles__c.getAll();
        Set<Id> setAdminProfiles = new Set<Id>();
        String currentProfileId = Userinfo.getProfileId();
        currentProfileId = convertTo15Digit(currentProfileId);
        
        /* To check whether any profile have permission to change owner of the account */
        for (Admin_Profiles__c prof : adminProfilesMap.values()) {
            if (prof.Module__c != null) {
                if (prof.Module__c.equalsIgnoreCase('AccountOwnerChange') || prof.Module__c.equalsIgnoreCase('AccountChange')) {
                    if (prof.Profile_ID__c != null) {
                        setAdminProfiles.add(convertTo15Digit(prof.Profile_ID__c));
                    }
                }
            }
        }
        
        /* For all other users-They should not be able to make any chnages to account */
        List<Account> accounts = (List<Account>)Trigger.new;
        Map<String, Schema.SObjectField> accFieldMap = Schema.SObjectType.Account.fields.getMap();
        for (Account accObj : accounts) {
            for (String accFName: accFieldMap.keySet()) {
                // Check if any field value on Account is getting modified by user.If yes- then throw an error message.
                if (accObj.get(accFName)!=Trigger.oldMap.get(accObj.Id).get(accFName)) {
                    if (setAdminProfiles.contains(currentProfileId)) {
                        return;
                    } else {
                        accObj.addError(System.Label.NO_ACCESS_FOR_MODIFY_ACOOUNT);
                    }
                } 
            }
        }
    }
    
    //Commenting the below method as a part of R5
    /**
    * @description: Action after Account Update 
    */
    /*public static void afterUpdate(Map<Id, Account> newAccounts, Map<Id, Account> oldAccounts) {
        PartnerCollabAccountUtil.UpdatePartnerEnabledAccounts(newAccounts, oldAccounts);
    }*/
}