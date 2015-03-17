trigger SalesWinBeforeTrigger on roi__Sales_Win__c(before insert){
    
    Set<Id> opportunityIdSet = new Set<Id>();
    Map<Id,Id> oppSupportRequestMap = new Map<Id,Id>();
    
    for(roi__Sales_Win__c salesWin : Trigger.new)
    {
        //prepare a set with all opportunity ids where support request is empty for Sales Win
        if(salesWin.roi__Opportunity__c != null && salesWin.Support_Request__c == null)
        {
            opportunityIdSet.add(salesWin.roi__Opportunity__c);
        }
    }
    
    if(opportunityIdSet.size()>0)
    {
        List<Support_Request__c> supportReqList = [select Id, Opportunity__c from Support_Request__c
                                                    where Opportunity__c=:opportunityIdSet and 
                                                    Support_Type__c='Functional Support' and 
                                                    Sub_Type__c='Reference Success Center'];
        if(supportReqList != null && supportReqList.size()>0)
        {
            for(Support_Request__c supportReq : supportReqList)
            {
                //Prepare a map with key as opportunity id and value as it's Support Request id
                oppSupportRequestMap.put(supportReq.Opportunity__c,supportReq.Id);
                //Remove opportunity ids from set for which Support Request of Resource Success Center existed
                opportunityIdSet.remove(supportReq.Opportunity__c);
            }
        }
        if(opportunityIdSet.size()>0)
        {
            List<Support_Request__c> supportRequestListToCreate = new List<Support_Request__c>();
            Support_Request__c supportReqToCreate = null;
            Id rscRTId = SupportRequestRoutingRulesTriggerUtil.getRecordTypeIDByName('ES-Functional Support-RSC');
            for(Id oppId : opportunityIdSet)
            {
                supportReqToCreate = new Support_Request__c();
                supportReqToCreate.Opportunity__c = oppId;
                supportReqToCreate.Support_Type__c = 'Functional Support';
                supportReqToCreate.Sub_Type__c = 'Reference Success Center';
                supportReqToCreate.RecordTypeId = rscRTId;
                supportRequestListToCreate.add(supportReqToCreate);
            }
            if(supportRequestListToCreate.size()>0)
            {
                insert supportRequestListToCreate;
                for(Support_Request__c supportReq : supportRequestListToCreate)
                {
                    //Prepare a map with key as opportunity id and value as it's Support Request id
                    oppSupportRequestMap.put(supportReq.Opportunity__c,supportReq.Id);
                }
            }
        }
        //assign support request id to sales win for which it is not mapped
        for(roi__Sales_Win__c salesWin : Trigger.new)
        {
            if(salesWin.roi__Opportunity__c != null && salesWin.Support_Request__c == null 
                && oppSupportRequestMap.containsKey(salesWin.roi__Opportunity__c))
            {
                salesWin.Support_Request__c = oppSupportRequestMap.get(salesWin.roi__Opportunity__c);
            }
        }
    }
}