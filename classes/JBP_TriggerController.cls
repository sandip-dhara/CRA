/**********************************************************
* Class Name:JBP_TriggerController 
* Author: HP  
* Date: 
* Requirement #:7025
* Description: To Populate the Portal Contact User where users should be Active and have JBP Capability
**********************************************************/
public class JBP_TriggerController{

/* ReqNumber -- 7025 Added by Amala --  STARTS
     *  @description: This method is called from JBP_beforeInsert Trigger to get  the Partner Approvers Id's.
     *  @Params: trigger.new (list<JBP__c>)
     *  @return: void
*/
public static void beforeInsert(List<JBP__c> JBPNewRecord){
Set<Id> jbpContactIdSet = new Set<Id>();
Set<Id> jbpContact2IdSet = new Set<Id>();
    for(JBP__c jbp :JBPNewRecord ){
        if(String.valueOf(jbp.Partner_Approver__c) != '' && jbp.Partner_Approver__c != null){
            jbpContactIdSet.add(jbp.Partner_Approver__c);
        }if(String.valueOf(jbp.Partner_Approver_2__c) != '' && jbp.Partner_Approver_2__c != null){
            jbpContact2IdSet.add(jbp.Partner_Approver_2__c);
        }
    }
    if(jbpContactIdSet.size()>0){
        updatePartnerApproverUser(jbpContactIdSet, jbpContact2IdSet, JBPNewRecord);
    }
}
//ReqNumber -- 7025 Added by Amala --  END
 
/* ReqNumber -- 7025 Added by Amala --  STARTS
     *  @description: This method is called from JBP_beforeUpdate Trigger to get  the Partner Approvers Id's.
     *  @Params: trigger.newMap (list<JBP__c>), trigger.oldMap (list<JBP__c>)
     *  @return: void
*/
public Static void beforeUpdate(Map<Id,JBP__c> JBPNewRecord, Map<Id,JBP__c> JBPOldRecord){
        List<JBP__c> jbpnewRecList = new List<JBP__c>();
        Set<Id> jbpContact1IdSet = new Set<Id>();
        Set<Id> jbpContact2IdSet = new Set<Id>();

        for(Id jbpnew:JBPNewRecord.keyset()){
            if(JBPOldRecord.get(jbpnew).Partner_Approver__c != JBPNewRecord.get(jbpnew).Partner_Approver__c &&(String.valueOf(JBPNewRecord.get(jbpnew).Partner_Approver__c) != '' && JBPNewRecord.get(jbpnew).Partner_Approver__c != null )){
               jbpContact1IdSet.add(JBPNewRecord.get(jbpnew).Partner_Approver__c); 
               jbpnewRecList.add(JBPNewRecord.get(jbpnew));
            }
        }
        for(Id jbpnew:JBPNewRecord.keyset()){
            if(JBPOldRecord.get(jbpnew).Partner_Approver_2__c != JBPNewRecord.get(jbpnew).Partner_Approver_2__c &&(String.valueOf(JBPNewRecord.get(jbpnew).Partner_Approver_2__c) != '' && JBPNewRecord.get(jbpnew).Partner_Approver_2__c != null )){
               jbpContact2IdSet.add(JBPNewRecord.get(jbpnew).Partner_Approver_2__c); 
               jbpnewRecList.add(JBPNewRecord.get(jbpnew));
            }
        }
        if(jbpContact2IdSet.size() > 0  || jbpContact1IdSet.size() > 0){
            updatePartnerApproverUser(jbpContact1IdSet,jbpContact2IdSet,jbpnewRecList);
        }
}
//ReqNumber -- 7025 Added by Amala --  END
 
/* ReqNumber -- 7025 Added by Amala --  STARTS
     *  @description: This method will Populate the Portal Contact User if users are Active and have JBP Capability.
     *  @Params: Set<Id> jbpcontact1Ids, Set<Id> jbpContact2IdSet, List<JBP__c> JBPNewRecord
     *  @return: void
*/
public static void updatePartnerApproverUser(Set<Id> jbpcontact1Ids, Set<Id> jbpContact2IdSet, List<JBP__c> JBPNewRecord){
Map<Id, Id> contactUserMap = new Map<Id, Id>();
Map<Id, Boolean> userActiveMap = new Map<Id, Boolean>();
Map<Id, string> userPortalAccessMap = new Map<Id, string>();
Map<Id, Id> contactUser2Map = new Map<Id, Id>();
Map<Id, Boolean> user2ActiveMap = new Map<Id, Boolean>();
Map<Id, string> user2PortalAccessMap = new Map<Id, string>();
List<User> portalUser1List = new List<User>();
List<User> portalUser2List = new List<User>();
String tabAccess;
Boolean noUser;

if(jbpcontact1Ids.size()>0){
    portalUser1List =[Select Contactid, id,IsActive, Portal_Tab_Access__c from user where Contactid IN : jbpcontact1Ids];
}
if(jbpContact2IdSet.size()>0){
    portalUser2List =[Select Contactid, id,IsActive, Portal_Tab_Access__c from user where Contactid IN : jbpContact2IdSet];
}
for(Id conId: jbpcontact1Ids ){
    for(User usr: portalUser1List){
        if(conId == usr.Contactid){
            contactUserMap.put(usr.contactId, usr.id);
            userActiveMap.put(usr.id,usr.IsActive); 
            userPortalAccessMap.put(usr.id, usr.Portal_Tab_Access__c);
        }
    }
}
for(Id conId: jbpContact2IdSet ){
    for(User usr: portalUser2List){
        if(conId == usr.Contactid){
            contactUser2Map.put(usr.contactId, usr.id);
            user2ActiveMap.put(usr.id,usr.IsActive); 
            user2PortalAccessMap.put(usr.id, usr.Portal_Tab_Access__c);
        }
    }
}  
for(JBP__c jbp: JBPNewRecord){
    if(jbpcontact1Ids.size()>0){
        if(contactUserMap.containsKey(jbp.Partner_Approver__c)){
            Boolean UserActive = userActiveMap.get(contactUserMap.get(jbp.Partner_Approver__c));
            tabAccess = userPortalAccessMap.get(contactUserMap.get(jbp.Partner_Approver__c));
            if(UserActive== true){
                if(tabAccess!= null && tabAccess.contains('JBP')){
                    jbp.Partner_ApproverUser_Account_Manager__c = contactUserMap.get(jbp.Partner_Approver__c);     
                }
                else{
                    jbp.Partner_Approver__c.addError(System.Label.JBP_NoJBPCapability);
                }
            }else{
                jbp.Partner_Approver__c.addError(System.Label.JBP_AssociatedUserInactive);
            }
        }else{
            jbp.Partner_Approver__c.addError(System.Label.JBP_NoUserAssociated);
        } 
    }   
    if(jbpContact2IdSet.size()>0){
        if(contactUser2Map.containsKey(jbp.Partner_Approver_2__c)){
            Boolean UserActive = user2ActiveMap.get(contactUser2Map.get(jbp.Partner_Approver_2__c));
            tabAccess = user2PortalAccessMap.get(contactUser2Map.get(jbp.Partner_Approver_2__c));
            if(UserActive== true){
                if(tabAccess!= null && tabAccess.contains('JBP')){
                    jbp.Partner_ApproverUser_Principal_Sponsor__c = contactUser2Map.get(jbp.Partner_Approver_2__c);
                }else{
                    jbp.Partner_Approver_2__c.addError(System.Label.JBP_NoJBPCapability);
                }
            }else{
                jbp.Partner_Approver_2__c.addError(System.Label.JBP_AssociatedUserInactive);
            }
        }
        else{
            jbp.Partner_Approver_2__c.addError(System.Label.JBP_NoUserAssociated);
        }
    }
}
//ReqNumber -- 7025 Added by Amala --  END
 
}
}