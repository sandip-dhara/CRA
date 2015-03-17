/**
* Class Name: UserTriggerControllerForPermissionSet
* Author: HP 
* R6 : Requirement # : 6897 
* Description: Contains support action methods for trigger on user object
*/
public class UserTriggerControllerForPermissionSet{
    
    /**
    * @description: Action After user Update 
    *               Added Logic to grant or revoke permission set based on the Portal Tab Access field values. Added as part of R6
    * 
    */    
    public static void afterUpdate(Map<Id, User> newUsersMap, Map<Id, User> oldUsersMap) {
        
        List<id> JBPUserList = new List<id>();
        List<id> DealRegUserList = new List<id>();
        List<id> PCLMUserList = new List<id>();
        List<id> revokeDealRegList = new List<id>();
        List<id> revokeJBPList = new List<id>();
        List<id> revokePCLMList = new List<id>();
        for(id usrId : newUsersMap.keySet()){
            if(newUsersMap.get(usrId).isActive && newUsersMap.get(usrId).isPortalEnabled){
                if(newUsersMap.get(usrId).Portal_Tab_Access__c != NULL && oldUsersMap.get(usrId).Portal_Tab_Access__c != NULL){
                    if(newUsersMap.get(usrId).Portal_Tab_Access__c.contains('Deal Reg') && !oldUsersMap.get(usrId).Portal_Tab_Access__c.contains('Deal Reg')){
                        DealRegUserList.add(usrId);
                    }else if(!newUsersMap.get(usrId).Portal_Tab_Access__c.contains('Deal Reg') && oldUsersMap.get(usrId).Portal_Tab_Access__c.contains('Deal Reg')){
                        revokeDealRegList.add(usrId);
                    }
                    if(newUsersMap.get(usrId).Portal_Tab_Access__c.contains('JBP') && !oldUsersMap.get(usrId).Portal_Tab_Access__c.contains('JBP')){
                        JBPUserList.add(usrId);
                    }else if(!newUsersMap.get(usrId).Portal_Tab_Access__c.contains('JBP') && oldUsersMap.get(usrId).Portal_Tab_Access__c.contains('JBP')){
                        revokeJBPList.add(usrId);
                    }
                    if(newUsersMap.get(usrId).Portal_Tab_Access__c.contains('PCLM') && !oldUsersMap.get(usrId).Portal_Tab_Access__c.contains('PCLM')){
                        PCLMUserList.add(usrId);
                    }else if(!newUsersMap.get(usrId).Portal_Tab_Access__c.contains('PCLM') && oldUsersMap.get(usrId).Portal_Tab_Access__c.contains('PCLM')){
                        revokePCLMList.add(usrId);
                    }
                }
                if(newUsersMap.get(usrId).Portal_Tab_Access__c != NULL && oldUsersMap.get(usrId).Portal_Tab_Access__c == NULL){
                    if(newUsersMap.get(usrId).Portal_Tab_Access__c.contains('Deal Reg')){
                        DealRegUserList.add(usrId);
                    }
                    if(newUsersMap.get(usrId).Portal_Tab_Access__c.contains('JBP')){
                        JBPUserList.add(usrId);
                    }
                    if(newUsersMap.get(usrId).Portal_Tab_Access__c.contains('PCLM')){
                        PCLMUserList.add(usrId);
                    }
                }
                if(oldUsersMap.get(usrId).Portal_Tab_Access__c != NULL && newUsersMap.get(usrId).Portal_Tab_Access__c == NULL){
                    if(oldUsersMap.get(usrId).Portal_Tab_Access__c.contains('Deal Reg')){
                        revokeDealRegList.add(usrId);
                    }
                    if(oldUsersMap.get(usrId).Portal_Tab_Access__c.contains('JBP')){
                        revokeJBPList.add(usrId);
                    }
                    if(oldUsersMap.get(usrId).Portal_Tab_Access__c.contains('PCLM')){
                        revokePCLMList.add(usrId);
                    }
                }
            }
        }
        if(DealRegUserList.size()>0)
            PartnerCollabUserUtil.addPermissionSetToUsers(System.Label.Deal_Reg_Tab_Permission_Set,DealRegUserList);
        if(JBPUserList.size()>0)
            PartnerCollabUserUtil.addPermissionSetToUsers(System.Label.JBP_Tab_Permission_Set,JBPUserList);
        if(PCLMUserList.size()>0)
            PartnerCollabUserUtil.addPermissionSetToUsers(System.Label.PCLM_Tab_Permission_Set,PCLMUserList);
        if(revokeDealRegList.size()>0)
            PartnerCollabUserUtil.revokePermission(System.Label.Deal_Reg_Tab_Permission_Set,revokeDealRegList);
        if(revokeJBPList.size()>0)
            PartnerCollabUserUtil.revokePermission(System.Label.JBP_Tab_Permission_Set,revokeJBPList);
        if(revokePCLMList.size()>0)
            PartnerCollabUserUtil.revokePermission(System.Label.PCLM_Tab_Permission_Set,revokePCLMList);
    }
    
    /**
    * @description: Action After user Insert 
    *               Added Logic to grant permission set based on the Portal Tab Access field values. Added as part of R6
    * 
    */ 
    public static void afterInsert(Map<Id, User> newUserMap, Map<Id, User> oldUserMap) {
        
        List<id> JBPUserList = new List<id>();
        List<id> DealRegUserList = new List<id>();
        List<id> PCLMUserList = new List<id>();
        for(id usrId : newUserMap.keySet()){            
            if(newUserMap.get(usrId).Partner_account_ID__c!=NULL && newUserMap.get(usrId).Portal_Tab_Access__c != NULL){
                if(newUserMap.get(usrId).Portal_Tab_Access__c.contains('Deal Reg')){
                    DealRegUserList.add(usrId);
                }
                if(newUserMap.get(usrId).Portal_Tab_Access__c.contains('JBP')){
                    JBPUserList.add(usrId);
                }
                if(newUserMap.get(usrId).Portal_Tab_Access__c.contains('PCLM')){
                    PCLMUserList.add(usrId);
                }
            }
        }
        if(DealRegUserList.size()>0)
            PartnerCollabUserUtil.addPermissionSetToUsers(System.Label.Deal_Reg_Tab_Permission_Set,DealRegUserList);
        if(JBPUserList.size()>0)
            PartnerCollabUserUtil.addPermissionSetToUsers(System.Label.JBP_Tab_Permission_Set,JBPUserList);
        if(PCLMUserList.size()>0)
            PartnerCollabUserUtil.addPermissionSetToUsers(System.Label.PCLM_Tab_Permission_Set,PCLMUserList);
    }
}