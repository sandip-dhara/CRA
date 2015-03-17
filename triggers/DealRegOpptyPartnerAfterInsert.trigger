/**
  * Trigger Name: DealRegOpptyPartnerAfterInsert
  * Release : HP R3
  * Author: HP
  * Date:  
  * Requirement # Request Id: 
  * Description: Whenever the Partner creates Opportunity Partner account will add on Alliance and Channel Partners related List on Opportunity.
  */

 trigger DealRegOpptyPartnerAfterInsert on Opportunity (after insert) {

    //quang.vu@hp.com, 10/30/2012
    Id HPFSrt = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('HPFS').getRecordTypeId();
    if (trigger.new[0].recordtypeid == HPFSrt){
             return;
         }
 
     Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }

    list<Channel_Partner__c> channelPartnerList=new list<Channel_Partner__c>();  
    User partnerUser=[select IsportalEnabled,Partner_account_ID__c from user where id=:UserInfo.getUserId()]; 
  if(partnerUser.IsportalEnabled==true){
     Account account=[select id,Partner_Type__c from account where id=:partnerUser.Partner_account_ID__c ];
  if(account.Partner_Type__c=='Alliance Partner'){
     Channel_Partner__c channelPartner=new Channel_Partner__c(Partner_Type__c='Alliance Partner',Channel_Partner__c=account.id);
     channelPartner.Opportunity__c=trigger.new[0].id;
     channelPartnerList.add(channelPartner);
     }
  if(account.Partner_Type__c=='Channel Partner'){
     Channel_Partner__c channelPartner=new Channel_Partner__c(Partner_Type__c='Channel Partner',Channel_Partner__c=account.id);       
     channelPartner.Opportunity__c=trigger.new[0].id;
     channelPartnerList.add(channelPartner);
   }
     insert channelPartnerList; 
  }
  
}