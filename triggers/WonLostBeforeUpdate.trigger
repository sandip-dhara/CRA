/***********************************************************
* Trigger Name: WonLostBeforeUpdate
*Author: HPIT
* Date: 19-July-2012 
* Requirement # Request Id: 
* Description: This trigger fatches primary partner,primary competitor,Incumbent Competitor form opprotunity
  to Won/Lost Analysis record on Edit of a existing record
***********************************************************/


trigger WonLostBeforeUpdate on Won_Lost_Analysis__c (before update) {
Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }

//WonLostAnalysisPrimaryCompititor_Partner.PrimaryCompititor_Partner(Trigger.New);
Set<id> setOptyIds = WonLostAnalysisPrimaryCompititor_Partner.setOptyIds(trigger.New);
WonLostAnalysisPrimaryCompititor_Partner.populateLookupFields(trigger.New,setOptyIds);
  
}