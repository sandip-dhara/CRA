/* Trigger Name: DealRegOpptyBeforeInsertManagedByField
  * Release : HP R3
  * Author: HP
  * Date:  
  * Requirement # Request Id: 
  * Description: Whenever the Partner creates Opportunity MangedBy field is set to 'Partner'.
  */

trigger DealRegOpptyBeforeInsertManagedByField on Opportunity (before insert) {
    
    //quang.vu@hp.com added 10/30/2012
    //ignore for HPFS opportunities
    Id HPFSrt = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('HPFS').getRecordTypeId();
    if (trigger.new[0].recordtypeid == HPFSrt){
             return;
         }

    Global_Config__c globalConfig = Global_Config__c.getInstance(); 
     if(null!=globalConfig){        
       // Do nothing if mute triggers set to true
        if( globalConfig.Mute_Triggers__c == True ) {
           return; 
        }
     }
    User partnerUser=[select name,IsportalEnabled,Partner_account_ID__c from user where id=:UserInfo.getUserId()]; 
     if(partnerUser.IsportalEnabled==true){
     for(opportunity opp:trigger.new)
     opp.Managed_By__c='Partner';
     }
  }