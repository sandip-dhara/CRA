/***********************************************************
* Trigger Name: WonLostBeforeInsert
*Author: HPIT
* Date: 19-July-2012 
* Requirement # Request Id: 
* Description: This trigger fatches primary partner,primary competitor,Incumbent Competitor form opprotunity
  and prevents form creating more than one Won/Lost Analysis record on insert of a new record
***********************************************************/

trigger WonLostBeforeInsert on Won_Lost_Analysis__c (before insert) {
Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }
//WonLostAnalysisPrimaryCompititor_Partner.wonlostcreationPrevent(Trigger.New);
//WonLostAnalysisPrimaryCompititor_Partner.PrimaryCompititor_Partner(Trigger.New);
WonLostAnalysisPrimaryCompititor_Partner.wonlostcreationPrevent(Trigger.New);
Set<id> setOptyIds = WonLostAnalysisPrimaryCompititor_Partner.setOptyIds(trigger.New);
WonLostAnalysisPrimaryCompititor_Partner.populateLookupFields(trigger.New,setOptyIds);
  
}