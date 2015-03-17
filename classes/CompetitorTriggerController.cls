/**
* Class Name: CompetitorTriggerController
* Author: HP
* Date: 17-JUL-2012 
* Requirement # Request Id: 
* Description: Contains support action methods for trigger on Competitors__c object
*/
public class CompetitorTriggerController{
    
    /* @description: Action After Competitors__c Update   */
    public static void afterInsert(Map<id,Competitors__c> CompetitorNewMap){
        CompetitorTriggerUtil.checkIsPrimaryFlagOnInsert(CompetitorNewMap);
    }
    
    /* @description: Action After Competitors__c Update   */
    public static void afterUpdate(Map<id,Competitors__c> CompetitorOldMap,Map<id,Competitors__c> CompetitorNewMap){
        CompetitorTriggerUtil.checkIsPrimaryFlagOnUpdate(CompetitorOldMap,CompetitorNewMap);
    }
    
    
    /* @description: Action After Competitors__c Insert   */
    public static void beforeInsert(List<Competitors__c> CompetitorsNewList){
        
        CompetitorTriggerUtil.setPrimaryFlag(CompetitorsNewList);
         
    }
    
    
    /* @description: Action After Competitors__c Insert    */
    public static void afterDelete(){
        
        
        CompetitorTriggerUtil.setPrimaryCompetitorAfterdelete();
        
    }
}