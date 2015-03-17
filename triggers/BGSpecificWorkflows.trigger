/**
 * Class Name: OpportunityAfterInsert
 * Author: Abrar
 * Date: 25-Sept-2012 
 * Requirement # Request Id: 
 * Description: Calls After Insert support action methods for trigger on opportunity object
 */
trigger BGSpecificWorkflows on Opportunity (After insert, After update) {
    
    //quang.vu@hp.com added 10/30/2012
    //if triggered by HPFS engagement, skip trigger
    if(OpportunityTriggerUtil.triggeredByHPFS()){
        return;
    }

    //if(HPUtils.BGSpecificWorkflows == False){
    list<Opportunity> opList= new List<Opportunity>();
    list<Opportunity> opListES= new List<Opportunity>();
    list<Opportunity> opListES1= new List<Opportunity>();
    List<Opportunity> renewalOppList= new List<Opportunity>();
    // OpList=trigger.new;
    list<Opportunity> opListOld= new List<Opportunity>();
    opListOld=trigger.old;
    OpportunityTriggerController.neverBypassMethod();

    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
    
    Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('HPFS').getRecordTypeId();
    if (trigger.new[0].recordtypeid == RecordTypeId){
             return;
         }
    
    if(Trigger.isInsert)
    {
        
        for(Opportunity opt : Trigger.New)
        {
            if(opt.Record_Type_Name__c=='Renewal')
                renewalOppList.add(opt);
            else{
                 if(opt.Business_Group2__c =='TS')
                    opList.add(opt);
                  else
                      if(opt.Business_Group2__c =='ES' && opt.Amount>0)
                          opList.add(opt);
            }


        }
        OpportunityBGActivityPlan.CreateActivityForOptyUpdation(opList,0);
        
        
        if(renewalOppList.size()>0)
            OpportunityBGActivityPlan.CreateActivityForOptyUpdation(renewalOppList,1);
    
    }
    


    if(Trigger.isUpdate){
        for(opportunity objoppty:trigger.new){
            
            if(objoppty.Record_Type_Name__c=='Renewal')
                renewalOppList.add(objoppty);
            else{
                if(objoppty.Business_Group2__c=='ES')
                {
                    system.debug('Current '+objoppty.Amount+'Old Value'+trigger.oldmap.get(objoppty.id).amount);
    
                    if(objoppty.Amount != trigger.oldmap.get(objoppty.id).amount || objoppty.StageName!=trigger.oldmap.get(objoppty.id).StageName)
                    {
                        opList.add(objoppty);
                        system.debug('Inside condidtion of Amount##');
                    }
                }
                else if(objoppty.Business_Group2__c=='TS')
                    {
                        opList.add(objoppty);
                    }
                }
            }
        

        system.debug('Size of oplist'+opList.size());
        if(opList.size()>0)
        {
            OpportunityBGActivityPlan.CreateActivityForOptyUpdation(opList,0);
            system.debug('Inside the Oplist IF condition '+opList[0]);
        }
        
        
        if(renewalOppList.size()>0){
            OpportunityBGActivityPlan.CreateActivityForOptyUpdation(renewalOppList,1);
        }

    }
    //HPUtils.BGSpecificWorkflows = True;
    //}
}