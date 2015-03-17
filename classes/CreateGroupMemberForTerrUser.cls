/*
* Class Name : CreateGroupMemberForTerrUser
* Event : Future Call
* Desc : Creates/Deletes GroupMember For Users added/deleted to User Territory Assignment.
*/

public class CreateGroupMemberForTerrUser {

@future
    public static void createGroupMember(Set<Id> stId){
        try{
            Map<Id, Set<Id>> terrIdUserMap = new Map<Id, Set<Id>>();
            List<GroupMember> grpMemberList = new List<GroupMember>();
            
            for(Sales_Territory_User_Assignment__c stUAObj : [Select Id, Sales_Territory__r.GroupId__c , User__c from Sales_Territory_User_Assignment__c where Id in : stId]){
            
                GroupMember grpMemObj = new GroupMember(GroupId = stUAObj.Sales_Territory__r.GroupId__c , UserOrGroupId = stUAObj.User__c);
                grpMemberList.add(grpMemObj);
            }
            
            if (Test.isRunningTest()) {
                if(!grpMemberList.isEmpty()){
                    
                    User thisUser = [Select Id from User where Id = :UserInfo.getUserId() ];   
                    // start new context via system.runAs() for the same user for test code only
                    System.runAs(thisUser) {
                        insert grpMemberList;
                    }
               }
            } else{         
                if(!grpMemberList.isEmpty()){
                    insert grpMemberList;
                }
            }
        }
         catch (Exception e){
            system.debug('****Exception in createGroupMember future call ****' + e.getMessage());
        }
      }

    
@future
    public static void deleteGroupMember(Set<Id> gmToDelete){
        
        try{
            List<GroupMember> gmToDeleteList = new List<GroupMember>();
            for(GroupMember gmObj : [Select Id from GroupMember where Id In : gmToDelete]){
                    gmToDeleteList.add(gmObj);
            }
            if (Test.isRunningTest()) {
                if(!gmToDeleteList.isEmpty()){
                
                    User thisUser = [Select Id from User where Id = :UserInfo.getUserId() ];   
                    // start new context via system.runAs() for the same user for test code only
                    System.runAs(thisUser) {
                        delete gmToDeleteList;
                    }
               }
            } else{         
                if(!gmToDeleteList.isEmpty()){
                    delete gmToDeleteList;
                }
            }

        } catch (Exception e){
            system.debug('****Exception in deleteGroupMember future call ****' + e.getMessage());
        }
    }
    
    //Call to delete Group when Sales Territory is marked as Inactive.
@future
    public static void deleteGroup(Set<Id> grpToDelete){
        
        try{
            List<Group> grpToDeleteList = new List<Group>();
            for(Group gmObj : [Select Id from Group where Id In : grpToDelete]){
                    grpToDeleteList.add(gmObj);
            }
            
            if (Test.isRunningTest()) {
            if(!grpToDeleteList.isEmpty()){
                
                User thisUser = [Select Id from User where Id = :UserInfo.getUserId() ];   
                // start new context via system.runAs() for the same user for test code only
                    System.runAs(thisUser) {
                        delete grpToDeleteList;
                    }
               }
            } else{         
                if(!grpToDeleteList.isEmpty()){
                    delete grpToDeleteList;
                }
            }

        } catch (Exception e){
            system.debug('****Exception in deleteGroup future call ****' + e.getMessage());
        }
    }
    
    //TM:Debmalya:Cr3737: 27th Nov,2012: commenting code, funtionality moved to batch:Start
    //Call to remove Account Team For STerr User marked as Inactive.
    /*public static void removeAccountTeamForSTUser(List<Sales_Territory_User_Assignment__c> stua){
        try{
            Set<Id> accIdSet = new Set<Id>();
            Set<Id> accIdAllSet = new Set<Id>();
            Set<Id> salesTerrSet = new Set<Id>();
            Set<String> userAccountKeySet = new Set<String>();
            
            List<AccountTeamMember> acntTeamList = new List<AccountTeamMember>();
            
            for(Sales_Territory_Account_Assignment__c staa : [Select Id, Account__c, Sales_Territory__c from Sales_Territory_Account_Assignment__c where Sales_Territory__c =: stua[0].Sales_Territory__c AND Assignment_Type__c = 'Territory Engine']){
                accIdAllSet.add(staa.Account__c);
                userAccountKeySet.add(''+ stua[0].User__c + '-' + staa.Account__c);
            }
            
            for(Sales_Territory_User_Assignment__c stua1 : [Select Id, Sales_Territory__c from Sales_Territory_User_Assignment__c where Sales_Territory__c != : stua[0].Sales_Territory__c AND User__c =: stua[0].User__c AND Add_To_Account_team__c = true]){
                salesTerrSet.add(stua1.Sales_Territory__c);
            }
            
            if(!salesTerrSet.isEmpty()){
                for(Sales_Territory_Account_Assignment__c staa : [Select Id, Account__c, Sales_Territory__c from Sales_Territory_Account_Assignment__c where Sales_Territory__c IN : salesTerrSet AND Account__c IN : accIdAllSet]){
                    if(userAccountKeySet.contains(''+ stua[0].User__c + '-' + staa.Account__c)){
                        accIdSet.add(staa.Account__c);
                        accIdAllSet.removeALL(accIdSet);
                    }
                }
            }
            
            if(!accIdAllSet.isEmpty()){
                for(AccountTeamMember atm : [Select Id from AccountTeamMember where AccountId IN : accIdAllSet AND UserId =: stua[0].User__c]){
                    acntTeamList.add(atm);
                }
                if(!acntTeamList.isEmpty()){
                    delete acntTeamList;
                }
            }
        } catch(Exception e){
            system.debug('*****Exception in removeAccountTeamForSTUser****' + e.getMessage());
            
        }
        
    }
    
    //Call to add Account Team For STerr User marked as Active again.
    public static void addAccountTeamForSTUser(List<Sales_Territory_User_Assignment__c> stua){
        try{
            List<AccountTeamMember> accountTeamList = new List<AccountTeamMember>(); 
            
            for(Sales_Territory_Account_Assignment__c staa : [Select Id, Account__c from Sales_Territory_Account_Assignment__c where Sales_Territory__c =: stua[0].Sales_Territory__c AND Assignment_Type__c = 'Territory Engine']){
                
                accountTeamList.add(new AccountTeamMember (UserId = stua[0].User__c, TeamMemberRole= stua[0].Account_Team_Role__c , AccountId = staa.Account__c));
            }
            if(!accountTeamList.isEmpty()){
                    insert accountTeamList;
            }
            
        }catch(Exception e){
            system.debug('*****Exception in addAccountTeamForSTUser****' + e.getMessage());
        }
    }*/
    //TM:Debmalya:Cr3737: 27th Nov,2012: commenting code, funtionality moved to batch:End
    
     //Call to add Account Team For STerr User marked as Active again.
    //TM:Debmalya:Cr3737: 27th Nov,2012: modify function to work with batch. This process will no longer be handled from Trigger:Start
    public static void addAccountTeamForSTUsers(Map<Id,Set<Id>> stAccntIdMap, Map<Id,Set<Sales_Territory_User_Assignment__c>> stUserMap){
        try{
            List<AccountTeamMember> accountTeamList = new List<AccountTeamMember>();
            for(Id stId : stUserMap.keySet()){
                Set<Sales_Territory_User_Assignment__c> stuaSet =  stUserMap.get(stId);
                for(Sales_Territory_User_Assignment__c stuarec : stuaSet){
                    for(Id accntId : stAccntIdMap.get(stId)){
                        accountTeamList.add(new AccountTeamMember (UserId = stuarec.User__c, TeamMemberRole= stuarec.Team_Role__c , AccountId = accntId));
                    }
                }
            }
            if(!accountTeamList.isEmpty()){
                    system.debug('sree'+accountTeamList);
                    insert accountTeamList;
            }
        }catch(Exception e){
            system.debug('*****Exception in addAccountTeamForSTUser****' + e.getMessage());
        }
    }
    
    
    public static void delAccountTeamForSTUsers(Map<Id,Set<Id>> stAccntIdMap, Map<Id,Set<Id>> stUserMap){
        try{
            Set<Id> uniqueUserSet = new Set<Id>();
            Set<Id> uniqueAccSet = new Set<Id>();
            Set<Id> stSet = new Set<Id>(); 
            //Map<Id,Set<Id>> userAccMap = new Map<Id,Set<Id>>();
            Set<String> userAcckeySettoDel = new Set<String>();
            List<AccountTeamMember> accntMemtoDel = new List<AccountTeamMember>();
            Map<Id,Set<Id>> stUserAcctTeamTrueMap = new Map<Id,Set<Id>>();
            
            for(Id stId : stUserMap.keyset()){
                uniqueUserSet.addAll(stUserMap.get(stId));
                if(stAccntIdMap.get(stId) != null){
                    uniqueAccSet.addAll(stAccntIdMap.get(stId));
                }
                for(Id userId : stUserMap.get(stId)){
                    /*Set<Id> accIdSet = userAccMap.get(userId);
                    if(accIdSet == null){
                        accIdSet = new Set<Id>();
                    }
                    accIdSet.addAll(stAccntIdMap.get(stId));
                    userAccMap.put(userId,accIdSet);*/
                    for(Id accId : stAccntIdMap.get(stId)){
                        userAcckeySettoDel.add(''+ userId + '-' + accId);
                    }
                }
            }
            
            for(Sales_Territory_User_Assignment__c stua : [Select Id, User__c, Sales_Territory__c, Add_to_Account_Team__c from Sales_Territory_User_Assignment__c where Add_to_Account_Team__c = true and User__c IN: uniqueUserSet and IsActive__c = true]){
                stSet.add(stua.Sales_Territory__c);
                Set<Id> tempUserSet = stUserAcctTeamTrueMap.get(stua.Sales_Territory__c);
                if(tempUserSet == null){
                    tempUserSet = new Set<Id>();
                }
                tempUserSet.add(stua.User__c);
                stUserAcctTeamTrueMap.put(stua.Sales_Territory__c,tempUserSet);
            }
            
            for(Sales_Territory_Account_Assignment__c stacc : [Select Id, Account__c, Sales_Territory__c from Sales_Territory_Account_Assignment__c where Sales_Territory__c IN: stSet and Account__c IN: uniqueAccSet and Assignment_Type__c = 'Territory Engine']){
                Set<String> userAccSet = new Set<String>();
                for(Id userId : stUserAcctTeamTrueMap.get(stacc.Sales_Territory__c)){
                    if(userAcckeySettoDel.contains(''+ userId + '-' + stacc.Account__c)){
                        userAccSet.add(''+ userId + '-' + stacc.Account__c);
                    }
                }
                userAcckeySettoDel.removeAll(userAccSet);
            }
            
            for(AccountTeamMember atm : [Select Id, UserId, AccountId from AccountTeamMember where UserId IN : uniqueUserSet and AccountId IN : uniqueAccSet]){
                if(userAcckeySettoDel.contains(''+ atm.UserId + '-' + atm.AccountId)){
                    accntMemtoDel.add(atm);
                }
            }
            
            if(!accntMemtoDel.isEmpty()){
                delete accntMemtoDel;
            }
        }catch(Exception e){
            system.debug('*****Exception in delAccountTeamForSTUsers*****' + e.getMessage());
        }
    }
    //TM:Debmalya:Cr3737: 27th Nov,2012: modify function to work with batch. This method will no longer be called from Trigger:End
}