/**
* Class Name: ApttusAgreementRequestAfterUpdate
* Author: HP(Sreekanth)
* Date: 26-March-2012 
* Requirement # Request Id: 5801
* Description:Update the Support Request whenever the agrrement Status is updated.
*/

trigger ApttusAgreementRequestAfterUpdate on Apttus__APTS_Agreement__c (after update) 
{
   Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
 // Update the Support Request whenever the agrrement Status is updated.
      Map<Id,Apttus__APTS_Agreement__c> agreementNewMap=new Map<Id,Apttus__APTS_Agreement__c>();
      Map<Id,Apttus__APTS_Agreement__c> agreementOldMap=new Map<Id,Apttus__APTS_Agreement__c>();
      List<Apttus__APTS_Agreement__c> agreementList=new List<Apttus__APTS_Agreement__c>();
      for(Id agreeId: trigger.newMap.keySet()){
          if((null!=trigger.newMap.get(agreeId).SR_Id__c) || ('' == trigger.newMap.get(agreeId).SR_Id__c)){
             agreementNewMap.put(agreeId,trigger.newMap.get(agreeId));
             agreementOldMap.put(agreeId,trigger.oldMap.get(agreeId));
             agreementList.add(trigger.newMap.get(agreeId));
          }
      }
      if(agreementNewMap.size()>0 && agreementOldMap.size()>0 && agreementList.size()>0){
      Apttus_AgreementRequestTriggerController.afterUpdate(agreementList,agreementOldMap,agreementNewMap);
      }
     
 }