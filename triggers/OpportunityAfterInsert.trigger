trigger OpportunityAfterInsert on Opportunity (After Insert) {

 /*
 * Desc : BG Specific Workflow for After Insert
 */
 
    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
        if(globalConfig!=null){        
            // Do nothing if mute triggers set to true         
            if( globalConfig.Mute_Triggers__c == True ) {
                return; 
            }
        }
    
    //quang.vu@hp.com added 10/30/2012
    //if triggered by HPFS engagement, skip trigger
    if(OpportunityTriggerUtil.triggeredByHPFS()){
        return;
    }
    
    
      /**
  * Trigger Name: opptyClone
  * Release : HP R4
  * Author: HP
  * Date: 25/01/2013  
  * Requirement # Request Id: 
  * Description: Whenever the an opportunity is cloned, all the partners/competitors of the current opportunity is added the new opportunity.
  */ 
  
     for(Opportunity opp : Trigger.New){
            System.debug('****************opp.NextStep'+opp.NextStep);
            if(opp.NextStep != null && opp.NextStep != '')
                OpptyCloneTriggerController.opptyCloneTrigCon(opp.NextStep,opp.id);
            } 
              
    
    
    //PRM:Vinay R4:Req:4043:Start
    //This is used update the sharing to the territory when an Opportunity is created by a Partner User.
    /*OpportunityTriggerUtil.afterInsertTerritoryUpdate(Trigger.NewMap);*/
    OpportunityTriggerUtil.afterOptyInsertTerritoryUpdateForLocation(Trigger.NewMap);
    //PRM:Vinay R4:Req:4043:End
    if(HPUtils.BGSpecificWorkflows == False){
    
    list<Opportunity> opList= new List<Opportunity>();
    list<Opportunity> opListES= new List<Opportunity>();
    list<Opportunity> opListES1= new List<Opportunity>();
    List<Opportunity> renewalOppList= new List<Opportunity>();
    // OpList=trigger.new;
    list<Opportunity> opListOld= new List<Opportunity>();
    opListOld=trigger.old;
 
   
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
                  if(opt.Business_Group2__c =='ES' && opt.Amount>0)
                          opList.add(opt);
                   else
                       if(opt.Business_Group2__c !='ES')
                        opList.add(opt);
            }


        }
        if(opList.size()>0)
        OpportunityBGActivityPlan.CreateActivityForOptyUpdation(opList,0);
        
        
        if(renewalOppList.size()>0)
            OpportunityBGActivityPlan.CreateActivityForOptyUpdation(renewalOppList,1);
        }    
    }
    
 
 /**
  * Trigger Name: DealRegOpptyPartnerAfterInsert
  * Release : HP R3
  * Author: HP
  * Date:  
  * Requirement # Request Id: 
  * Description: Whenever the Partner creates Opportunity Partner account will add on Alliance and Channel Partners related List on Opportunity.
  */
      
    list<Channel_Partner__c> channelPartnerList=new list<Channel_Partner__c>();      
     if(HPUtils.partnerUser.IsportalEnabled==true){
        /* Account account=[select id,Channel_Partner_Flag__c from account where id=:HPUtils.partnerUser.Partner_account_ID__c ];
      if(account.Channel_Partner_Flag__c){
         Channel_Partner__c channelPartner=new Channel_Partner__c(Partner_Type__c='Channel Partner',Channel_Partner__c=account.id);  */     
         if(HPUtils.partnerUser.contact.Account.Channel_Partner_Flag__c){
           /* Channel_Partner__c channelPartner=new Channel_Partner__c(Partner_Type__c='Channel Partner',Channel_Partner__c=HPUtils.partnerUser.AccountId,Location__c=HPUtils.partnerUser.Location_Record_Id__c);       
            channelPartner.Opportunity__c=trigger.new[0].id;
            channelPartnerList.add(channelPartner);*/
            PCLM_FutureInsertACP.insertACP(HPUtils.partnerUser.AccountId, trigger.new[0].id, HPUtils.partnerUser.Location_Record_Id__c);

         }
       //  insert channelPartnerList; 
      } 
    
}