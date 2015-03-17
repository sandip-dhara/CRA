/**********************************************************
* Trigger Name: DealRegAutoApproval 
* Author: HP
* Date: 05-OCT-2012 
* Description:Trigger to Auto Approve the record
***********************************************************/
trigger DealRegAutoApproval on Deal_Registration__c (after Update) {

    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
// Hidden Auto Approve flag is updated from Time Based Workflow (checked/Unchecked based on Dead Line date)
    for (Integer i = 0; i < Trigger.new.size(); i++)
      {
       try{ 
          if(Trigger.new[i].Status__c == 'Review Initiated' && Trigger.new[i].Level_2_Approval_Deadline__c !=NULL && Trigger.new[i].Hidden_Auto_Approve__c==true){
          DealReg_DealAutoApprove autoapprove=new DealReg_DealAutoApprove();
          autoapprove.approveRecord(Trigger.new[i]); }
          }catch(Exception e)
          {
           Trigger.new[i].addError(e.getMessage());
          } 
     }
}