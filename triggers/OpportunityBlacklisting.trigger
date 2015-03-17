trigger OpportunityBlacklisting on Opportunity (Before Insert, Before Update) {

    //quang.vu@hp.com, 10/30/2012
    //if triggered by HPFS engagement on old opportunity, skip trigger
    if (OpportunityTriggerUtil.triggeredByHPFS()){
        return;
    }

    if(HPUtils.OpportunityBlacklisting==false){
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    
    OpportunityBlacklisting obj=new OpportunityBlacklisting();
    //String usertype=User.User_Type_Text__c;
    //String usertype=UserInfo.getUser_Type_Text__c();
    User u=[Select id, User_Type_Text__c From User Where id=:UserInfo.getUserId()];
    for(Opportunity o: trigger.new){
        if(u.User_Type_Text__c == 'PARTNER'){
            o.Last_Modified_by_Partner__c= DateTime.now();
        }
    }
    if(Trigger.isInsert)
    obj.filterwords(Trigger.new);
    if(Trigger.isUpdate){
    for(Opportunity opty : trigger.new)
    {
    if(opty.Name != trigger.oldmap.get(opty.id).Name || opty.Description!=trigger.oldmap.get(opty.id).Description || opty.Opportunity_Update__c!=trigger.oldmap.get(opty.id).Opportunity_Update__c)
    obj.filterwords(Trigger.new);
    }
    }
    HPUtils.OpportunityBlacklisting=True;
    }
}