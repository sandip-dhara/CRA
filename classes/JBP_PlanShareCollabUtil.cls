/************************************************************************************
 * Class Name: JBP_PlanShareCollabUtil
 * Author: HP  
 * Date: 03-04-2013 
 * Requirement #:6249, 5429
 * Description: To share the JBP Record for the Approver
 *               and to share the Plan to non external territory Group of Account
 *************************************************************************************/
public Class JBP_PlanShareCollabUtil{
    /**
     * @description: To share the JBP Record to the HP Management Approver in order to apporve the record
     * @param:Trigger Old Map and Trigger New Map
     */
  
    public static void afterInsert(List<JBP__c> JBPNewRecord){
        List<JBP__Share> sharelist=new List<JBP__Share>(); 
        for(JBP__c jbp :JBPNewRecord){
            if(jbp.Named_HP_Management_Approver__c != NULL && jbp.Named_HP_Management_Approver__c!= jbp.OwnerId){
                JBP__Share toShare=new JBP__Share(); 
                toShare.ParentId= jbp.Id;
                toShare.UserOrGroupId=jbp.Named_HP_Management_Approver__c;
                toShare.AccessLevel='edit';
                toShare.RowCause=Schema.JBP__Share.RowCause.Approval_Sharing__c;
                sharelist.add(toShare);
            }
        }
        if(sharelist.size()>0 && sharelist!= NULL){
            try{
            Insert sharelist;
            }Catch(Exception e){
                System.debug('**Exception in JBP_PlanShareCollabUtil ****' + e.getTypeName() + ': ' + e.getMessage() + ' -- ' + e.getCause()+'##'+e.getStackTraceString());
            }
        }
    }
    /**
     * @description: when Updating the approver Name delete the sharing for old approver and add sharing to the new Approver
     * @param:Trigger Old Map and Trigger New Map
     */
    public static void afterUpdate(List<JBP__c> JBPNewRecord, List<JBP__c> JBPOldRecord){
        List<JBP__Share> sharelist=new List<JBP__Share>();
        List<JBP__Share> deleteShareList= new List<JBP__Share>();
        List<id> allUserList = new List<Id>();
        map<id, Set<id>> jbpUserMap = new map<id, Set<id>>();
        Set<id> tempSet;
        for(Integer i=0;i<JBPNewRecord.size();i++){
            if(JBPNewRecord[i].Named_HP_Management_Approver__c != JBPOldRecord[i].Named_HP_Management_Approver__c && JBPNewRecord[i].Named_HP_Management_Approver__c !=NULL){
                JBP__Share toShare=new JBP__Share();
                toShare.ParentId= JBPNewRecord[i].Id;
                toShare.UserOrGroupId=JBPNewRecord[i].Named_HP_Management_Approver__c;
                toShare.AccessLevel='edit';
                toShare.RowCause=Schema.JBP__Share.RowCause.Approval_Sharing__c;
                sharelist.add(toShare); 
            }
            /*Fetching the sharing record for the updated Apprver and adding to deleteShareList
            * R6 : Requirement Id : 5387
            */
            if(JBPNewRecord[i].Named_HP_Management_Approver__c != JBPOldRecord[i].Named_HP_Management_Approver__c || (JBPNewRecord[i].Named_HP_Management_Approver__c == Null && JBPOldRecord[i].Named_HP_Management_Approver__c!= Null)){
                if(jbpUserMap.keySet().contains(JBPOldRecord[i].Id)){
                    tempSet = new Set<id>();
                    tempSet=jbpUserMap.get(JBPOldRecord[i].Id);
                    tempSet.add(JBPOldRecord[i].Named_HP_Management_Approver__c);
                    jbpUserMap.put(JBPOldRecord[i].Id, tempSet);
                }else{
                    tempSet = new Set<id>();
                    tempSet.add(JBPOldRecord[i].Named_HP_Management_Approver__c);
                    jbpUserMap.put(JBPOldRecord[i].Id, tempSet);
                }
            }
            if(JBPOldRecord[i].Partner_ApproverUser_Account_Manager__c != JBPOldRecord[i].Partner_ApproverUser_Principal_Sponsor__c){
                if(JBPNewRecord[i].Partner_ApproverUser_Account_Manager__c != JBPOldRecord[i].Partner_ApproverUser_Account_Manager__c || (JBPNewRecord[i].Partner_Approver__c == Null && JBPOldRecord[i].Partner_Approver__c!= Null)){
                    if(jbpUserMap.keySet().contains(JBPOldRecord[i].Id)){
                        tempSet = new Set<id>();
                        tempSet=jbpUserMap.get(JBPOldRecord[i].Id);
                        tempSet.add(JBPOldRecord[i].Partner_ApproverUser_Account_Manager__c);
                        jbpUserMap.put(JBPOldRecord[i].Id, tempSet);
                    }else{
                        tempSet = new Set<id>();
                        tempSet.add(JBPOldRecord[i].Partner_ApproverUser_Account_Manager__c);
                        jbpUserMap.put(JBPOldRecord[i].Id, tempSet);
                    }
                }
                if(JBPNewRecord[i].Partner_ApproverUser_Principal_Sponsor__c != JBPOldRecord[i].Partner_ApproverUser_Principal_Sponsor__c || (JBPNewRecord[i].Partner_Approver_2__c == Null && JBPOldRecord[i].Partner_Approver_2__c!= Null)){
                    if(jbpUserMap.keySet().contains(JBPOldRecord[i].Id)){
                        tempSet = new Set<id>();
                        tempSet=jbpUserMap.get(JBPOldRecord[i].Id);
                        tempSet.add(JBPOldRecord[i].Partner_ApproverUser_Principal_Sponsor__c);
                        jbpUserMap.put(JBPOldRecord[i].Id, tempSet);
                    }else{
                        tempSet = new Set<id>();
                        tempSet.add(JBPOldRecord[i].Partner_ApproverUser_Principal_Sponsor__c);
                        jbpUserMap.put(JBPOldRecord[i].Id, tempSet);
                    }
                }
            }
            /* End of Code change. R6: Requirement Id: 5387 */
        }
        if(jbpUserMap.size()>0){
            for(id jbpId : jbpUserMap.keySet()){
                allUserList.addAll(jbpUserMap.get(jbpId));
            }
            List<JBP__Share> jbpShareList = [Select Id,ParentId,UserOrGroupId from JBP__Share where ParentId IN:jbpUserMap.keySet() and UserOrGroupId IN:allUserList and RowCause='Approval_Sharing__c'];
            if(jbpShareList.size()>0){
                for(JBP__Share jbpShare : jbpShareList){
                    Set<id> newSet = jbpUserMap.get(jbpShare.ParentId);
                    if(newSet.contains(jbpShare.UserOrGroupId)){
                        deleteShareList.add(jbpShare);
                    }
                }
            }
        }
        if(sharelist.size()>0 && sharelist!= NULL){
                Insert sharelist;
        }
        if(deleteShareList.size()>0 && deleteShareList!=NULL){
        try{
            delete deleteShareList;
        }Catch(Exception e){
               System.debug('**Exception in JBP_PlanShareCollabUtil ****' + e.getTypeName() + ': ' + e.getMessage() + ' -- ' + e.getCause()+'##'+e.getStackTraceString());
            }
        }
    }
    /**
     * @description: To share the JBP plan to non external territories of the plan Account
     * @return: List of Extended profile category Item Asgn records
     * @Requirement:6249
     */
    public static void sharePlantoNonExternalTerritories(Map<Id,JBP__c> newPlansMap){
        Map<Id,set<Id>> planWithTerrGroups = new Map<Id,set<Id>>();
        planWithTerrGroups = getPartnerAccShareGroups(newPlansMap);
        List<jbp__share> newPlanshareList = new List<jbp__share>();
        /* Checking if planWithTerrGroups is null or isEmpty */
        if(planWithTerrGroups == null || planWithTerrGroups.isEmpty()){ 
            return;
        }
        /* creating the share records for JBP plan with the non external territory groups*/
        for(Id planId: newPlansMap.KeySet()){
            if(planWithTerrGroups != null && planWithTerrGroups.size()>0 && planWithTerrGroups.containsKey(planId)){
                for(Id groupId: planWithTerrGroups.get(planId)){
                    jbp__Share planshare = new jbp__share();
                    planshare.parentId = planId;
                    planshare.UserOrGroupId = groupId;
                    planshare.AccessLevel = 'Read';
                    //planshare.RowCause=Schema.JBP__Share.RowCause.TerritorySharing__c;
                    newPlanshareList.add(planshare);
                }
            }
        }
        /* Inserting the sharing records that have been created */
        if(newPlanshareList != null || newPlanshareList.size()>0){
            Database.saveResult[] newShareResults;
            try{
                system.debug('newplansharein try:'+ newPlanshareList);
                newShareResults = database.insert(newPlanshareList,false);
            }catch(Exception e){
                CreateApexErrorLog.insertHandledExceptions(e,newShareResults,'JBP__c','PlancollabUtil','class');
            }
        }      
    }
    /**
     * @description: To get the territory groups of the JBP plan Accounts
     * @return: Map of Plan Id and TerritoryGroup Ids
     * @param:Map of Plan Id,Plan record
     *
     */
    public static Map<Id,set<Id>> getPartnerAccShareGroups(Map<Id,JBP__c> PlansMap){
        Set<Id> partnerAccountSet = new Set<Id>();
        Map<Id,Set<Id>> planTerrGroups = new Map<Id,Set<Id>>();
        Map<Id,Sales_Territory_Account_Assignment__c> acctWithTerritory;
        for(JBP__c partnerplan: PlansMap.values()){
            partnerAccountSet.add(partnerplan.Partner_Account__c);
        }
        /* Fetching the Territories that are associated with the Plan Account*/
        if(partnerAccountSet.size()>0)
            acctWithTerritory = new Map<Id,Sales_Territory_Account_Assignment__c>([Select Id, Account__c, Sales_Territory__r.GroupID__c from Sales_Territory_Account_Assignment__c where Account__c in : partnerAccountSet AND Sales_Territory__r.isExternal__c=false AND Sales_Territory__r.isPartner__c= true AND Sales_Territory__r.IsActive__c=true]);
            System.debug('Partner:'+acctWithTerritory );
            if(acctWithTerritory == null || acctWithTerritory.isEmpty()){
                return null;
            }
            /* Populating the PlanTerrGroup Map with Plan Id and GroupIds */
            for(jbp__c plan: PlansMap.values()){
                for(Sales_Territory_Account_Assignment__c acctWithTerritoryRec:acctWithTerritory.values()){
                    if(plan.Partner_Account__c == acctWithTerritoryRec.account__c && acctWithTerritoryRec.account__c != null){
                        if(planTerrGroups.containsKey(plan.Id)){
                            planTerrGroups.get(plan.Id).add(acctWithTerritoryRec.Sales_Territory__r.GroupID__c);
                        }else{
                            planTerrGroups.put(plan.Id,new Set<Id>{acctWithTerritoryRec.Sales_Territory__r.GroupID__c});
                        }
                    }   
                }           
            }
            if(planTerrGroups != null || planTerrGroups.size()>0 ){
                return planTerrGroups;
            }else {
                return null;
            }         
    }    
}