/**********************************************************
* Trigger Name: RelationshipSuiteBeforeUpdate
* Author: HP/Mousumi Panda
* Date: 14th Aug 2012 
* Requirement # Request Id: 
* Description: Trigger  to get total score on detail page.
              
***********************************************************/

trigger RelationshipSuiteBeforeUpdate on Relationship_Suite__c (Before Update) {
Integer result;
Integer resultfinal;
Global_Config__c globalConfig = Global_Config__c.getInstance(); 
    if(globalConfig!=null){        
        // Do nothing if mute triggers set to true         
        if( globalConfig.Mute_Triggers__c == True ) {
            return; 
        }
    }

RelationshipMeterTotalScore.RelationshipMeter(Trigger.New);
system.debug('resultfinal:'+resultfinal);
}