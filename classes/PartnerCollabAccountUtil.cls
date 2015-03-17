/**
* Class Name: PartnerCollabAccountUtil
* Author: Accenture
* Date: 18-JULY-2012 
* Description: Contains support action methods for trigger on account object for partner collaboration
*/

public with sharing class PartnerCollabAccountUtil {
    public PartnerCollabAccountUtil (){
    }
        /**
    * @description - This method will be called from account trigger for after-update event. To pickup accounts which are enabled as partners in current context.
    */
    /*public static void UpdatePartnerEnabledAccounts(map<id, account> newAccountMap, map<id, account> oldAccountMap){
        set<Id> partnerEnabledAccountIDs = new set<Id>();
        for(Id updatedAccID: newAccountMap.keyset()){
            if(oldAccountMap.get(updatedAccID).IsPartner == false && newAccountMap.get(updatedAccID).IsPartner == true ){
                partnerEnabledAccountIDs.add(updatedAccID);
            }
        }
        if(partnerEnabledAccountIDs.size() > 0){
            system.debug('Enter_IF');
            createPartnerAccountQueue(partnerEnabledAccountIDs);
        }
    }
    

    @future
    public static void createPartnerAccountQueue(set<Id> partEnbledAccIds){
        set<id> partGrpIds = new set<Id>();
        list<Group> partnerAccQueues = new list<Group>(); 
        for(account partAcc: [SELECT Id, Name FROM account WHERE Id IN :partEnbledAccIds]){
            string partAccName = string.valueOf(partAcc.Name);
            Group queueGrp = new Group();           
            queueGrp.Type = 'Queue';
           

            if(partAccName.length()> 32){
                queueGrp.Name = 'Partner_' + partAccName.substring(0,32); // changed to 32 from 33 - CR's -443 & - CR-0451
                //queueGrp.DeveloperName = 'Partner_Queue_'+ partAccName.substring(0,33).replaceAll('[^a-zA-Z0-9]+','') + '_' + partAcc.Id; commented - CR's -443 & - CR-0451
                queueGrp.DeveloperName = 'Partner_Queue_'+ partAcc.Id; // Added CR's -443 & - CR-0451
            }
            else{
                queueGrp.Name = 'Partner_' + partAccName;
                //queueGrp.DeveloperName = 'Partner_Queue_'+ partAccName.replaceAll('[^a-zA-Z0-9]+','') + '_' + partAcc.Id; Commented - CR's -443 & - CR-0451
                queueGrp.DeveloperName = 'Partner_Queue_'+ partAcc.Id; // Added CR's -443 & - CR-0451
            }
            
            partnerAccQueues.add(queueGrp);
        }
        
        try{
            insert partnerAccQueues;
        }
        Catch(exception e){
            CreateApexErrorLog.insertHandledExceptions(e, null, 'Account', 'PartnerCollabAccountUtil', 'Class');
        }
        insertGrpIDInQSObject(partnerAccQueues);
        
    }
    

    public static void insertGrpIDInQSObject(list<Group> partAccQs){
        list<QueueSobject> QSObjList = new list<QueueSobject>();
        for(Group grp: partAccQs){
            List<QueueSobject> newQobjs = new List<QueueSobject>{
            new QueueSobject(QueueId = grp.ID, SobjectType = 'Lead'),
            new QueueSobject(QueueId = grp.ID, SobjectType = 'Strike_Count_Track__c')};         
            QSObjList.add(newQobjs[0]);
            QSObjList.add(newQobjs[1]);
        }
        try{
            insert QSObjList;
        }
        Catch(exception e){ 
            CreateApexErrorLog.insertHandledExceptions(e, null, 'Account', 'PartnerCollabAccountUtil', 'Class');
        }
    }*/
    
    
    
}