trigger OpportunityTeamMemberAfterDelete on OpportunityTeamMember(after delete){
    /*
       The below trigger is added to capture deleted records  and stored into Opportunity_Product_Delete_Capture__c
   */
   Map<Id,Id> oppTeamMemberIdMap = new Map<Id,Id>();
   List<Opportunity_Product_Delete_Capture__c> histObjList = new List<Opportunity_Product_Delete_Capture__c>();
    
    for(OpportunityTeamMember otm: Trigger.old)
    {
        oppTeamMemberIdMap.put(otm.Id,otm.OpportunityId);
    }

    if(oppTeamMemberIdMap.size()>0)
    {
        for(Id otmId : oppTeamMemberIdMap.keySet())
        {
            Opportunity_Product_Delete_Capture__c histObj = new Opportunity_Product_Delete_Capture__c();
            histObj.Deleted_Record_Id__c = otmId;
            histObj.Deleted_Record_Parent_Id__c = oppTeamMemberIdMap.get(otmId);
            histObj.Deleted_Record_Object_Type__c = 'OpportunityTeamMember';
            histObjList.add(histObj);
        }
    }
    
    if(histObjList.size()>0)
    {
        insert histObjList;
    }
    }