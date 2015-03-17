/**********************************************************
 * Class Name:JBP_SubPlanTriggerController 
 * Author: HP  
 * Date: 25-July-2013
 * Requirement # Request Id: 5472
 * Description:This is a controller for the Metrics__c before Insert Trigger.
 **********************************************************/

public class JBP_SubPlanTriggerController{

/* ReqNumber -- 5472 Added by Amala --  STARTS
 *  @description: This method is used to check if there are any records with the same BG Same GBU exists for sub-plan. 
 *                If found then an error is thrown.
 *  @Params: trigger.new (list<GBU_Specialization_Plans__c>)
 *  @return: void
*/
public static void beforeInsert(List<GBU_Specialization_Plans__c> subPlanNewRecord){
//Variable declaration
List<String> subplanBGList = new List<String>(); 
List<String> subplanGBUList= new List<String>();
Map<Id, List<GBU_Specialization_Plans__c>> newSubPlan = new Map<Id, List<GBU_Specialization_Plans__c>>();
Set<Id> JBPIDSet = new Set<ID>();
 //Check for duplicacy in the data supplied. 
    for(GBU_Specialization_Plans__c subPlan : subPlanNewRecord){
        JBPIDSet.add(subPlan.Joint_Business_Plan__c);
        subplanBGList.add(subPlan.Business_Group__c);
        subplanGBUList.add(subPlan.GBU_Specialization__c);
        if(newSubPlan.containsKey(subPlan.Joint_Business_Plan__c)) {
            for(GBU_Specialization_Plans__c gbu: newSubPlan.get(subPlan.Joint_Business_Plan__c)){
                if(subPlan.Business_Group__c == gbu.Business_Group__c && gbu.GBU_Specialization__c== subPlan.GBU_Specialization__c){
                    subPlan.addError(system.Label.Inconsistent_Data);
                }
            }
            list<GBU_Specialization_Plans__c> tempGBUList = newSubPlan.get(subPlan.Joint_Business_Plan__c);
            tempGBUList.add(subPlan);
            newSubPlan.put(subPlan.Joint_Business_Plan__c, tempGBUList);
        }else{
            list<GBU_Specialization_Plans__c> tempGBUList= new list<GBU_Specialization_Plans__c>();
            tempGBUList.add(subPlan);
            newSubPlan.put(subPlan.Joint_Business_Plan__c, tempGBUList);
        }
    }
    if(JBPIDSet.size()>0){
        checkDuplicateSubplan(subplanBGList, JBPIDSet, subPlanNewRecord, subplanGBUList);
    }
}
//ReqNumber -- 5472 Added by Amala --  Ends

/* ReqNumber -- 5472 Added by Amala --  STARTS
     *  @description: This method is used to check if there are any change in BG and GBU for the existing records in sub-plan. 
     *                If changed then pass those records to check duplicate subplan
     *  @Params: trigger.new (list<GBU_Specialization_Plans__c>), trigger.old (list<GBU_Specialization_Plans__c>)
     *  @return: void
 */
public Static void beforeUpdate(Map<Id,GBU_Specialization_Plans__c> subPlanNewRecord, Map<Id,GBU_Specialization_Plans__c> subPlanOldRecord){
List<String> subplanBGList = new List<String>(); 
List<String> subplanGBUList= new List<String>();
Set<Id> JBPIDSet = new Set<ID>();
List<GBU_Specialization_Plans__c> gbuRecordList = new List<GBU_Specialization_Plans__c>();
    for(Id gbu:subPlanNewRecord.keyset()){
        if(subPlanOldRecord.get(gbu).Business_Group__c != subPlanNewRecord.get(gbu).Business_Group__c || subPlanOldRecord.get(gbu).GBU_Specialization__c != subPlanNewRecord.get(gbu).GBU_Specialization__c){
            subplanBGList.add(subPlanNewRecord.get(gbu).Business_Group__c);
            subplanGBUList.add(subPlanNewRecord.get(gbu).GBU_Specialization__c);
            JBPIDSet.add(subPlanNewRecord.get(gbu).Joint_Business_Plan__c);
            gbuRecordList.add(subPlanNewRecord.get(gbu));
            
        }
    }
    if(subplanBGList.size() > 0  || subplanGBUList.size() > 0 || JBPIDSet.size()>0){
        checkDuplicateSubplan(subplanBGList, JBPIDSet, gbuRecordList, subplanGBUList);
    }
}
//ReqNumber -- 5472 Added by Amala --  Ends

/* ReqNumber -- 5472 Added by Amala --  STARTS
     *  @description: This method is used to check if there are any change duplicate subplan exists for same BG same GBU. 
     *                If found then an error is thrown.
     *  @Params: List<String> subplanBGList, Set<Id> JBPIDSet, List<GBU_Specialization_Plans__c> subPlanNewRecord, List<String> subplanGBUList
     *  @return: void
 */
Public static void checkDuplicateSubplan(List<String> subplanBGList, Set<Id> JBPIDSet, List<GBU_Specialization_Plans__c> subPlanNewRecord, List<String> subplanGBUList){
List<GBU_Specialization_Plans__c> GBUList = new List<GBU_Specialization_Plans__c>();
Map<Id, String> JBPBGMap = new Map<Id, String>();
    if(JBPIDSet.size()>0){
        List<JBP__c> jbprec = [Select id, BG__c from JBP__c where Id In: JBPIDSet];
        for(JBP__c jbp: jbprec){
            JBPBGMap.put(jbp.Id, jbp.BG__c);
        }
    }
    if(subplanBGList.size()>0){
        GBUList=[Select Id, GBU_Specialization__c, Business_Group__c, Joint_Business_Plan__c 
                                                        from GBU_Specialization_Plans__c 
                                                            Where GBU_Specialization__c IN: subplanGBUList
                                                                AND Business_Group__c IN: subplanBGList
                                                                    AND Joint_Business_Plan__c IN: JBPIDSet];
    }
    for(GBU_Specialization_Plans__c newgbu:subPlanNewRecord ){
        if(JBPBGMap.containsKey(newgbu.Joint_Business_Plan__c)){
           if(newgbu.Business_Group__c == JBPBGMap.get(newgbu.Joint_Business_Plan__c)){
                for(GBU_Specialization_Plans__c existingGBUList: GBUList){
                    if(newgbu.Business_Group__c == existingGBUList.Business_Group__c && newgbu.GBU_Specialization__c == existingGBUList.GBU_Specialization__c && newgbu.Joint_Business_Plan__c == existingGBUList.Joint_Business_Plan__c){
                    newgbu.addError(System.Label.JBP_SubplanDuplicateAssociation);
                    }
                }
            }else{
                newgbu.addError(System.Label.JBP_SubplanBGMatch);
            }
        }   
    }
}
////ReqNumber -- 5472 Added by Amala --  Ends
}