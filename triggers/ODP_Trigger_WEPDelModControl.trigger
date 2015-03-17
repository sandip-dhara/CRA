trigger ODP_Trigger_WEPDelModControl on Stage_Work_Element_Predecessor__c (Before Delete, Before Update) {
    if(Trigger.isUpdate){
        for(Stage_Work_Element_Predecessor__c WEPObjNew : Trigger.old){
            string error = '';
            if(WEPObjNew.Work_Element__c != null || WEPObjNew.Stage_Work_Element__r.Work_Element_ID__c != null)
            {
                error +=  'You are not allowed to Edit this work element predecessor, for it is predefined in the Flight Plan';   
                if(!String.isEmpty(error))
                {
                    trigger.oldMap.get(WEPObjNew.Id).addError('Modify Work Element Predecessor Failed: ' + error);
                }
            }
        }
    }
    if(Trigger.isDelete){
        for(Stage_Work_Element_Predecessor__c WEPObjOld : Trigger.old){
            string error = '';
            if(WEPObjOld.Work_Element__c != null || WEPObjOld.Stage_Work_Element__r.Work_Element_ID__c != null)
            {
                error +=  'You are not allowed to Delete this work element predecessor, for it is predefined in the Flight Plan';   
                if(!String.isEmpty(error))
                {
                    trigger.oldMap.get(WEPObjOld.Id).addError('Delete Work Element Predecessor Failed: ' + error);
                }
            }

        }
    }    
}