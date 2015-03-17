trigger ClosePlanAfterInsert on Close_Plan__c (after Insert, after delete) {
   
   List<Opportunity_Plan__c> oppPlanList=new List<Opportunity_Plan__c>();
   Set<ID> oppPlanIDSet=new Set<ID>();
   Map<ID,List<Close_plan__c>> closePlanMap=new Map<ID,List<Close_plan__c>>();
   Map<ID,Close_plan__c> DeleteNocloseplanMap=new Map<ID,Close_plan__c>();
   If(Trigger.isInsert){
                   for(Close_plan__c cp: trigger.new){
                   system.debug('Opportunity_Plan__c Value'+cp.Opportunity_Plan__c);
                                oppPlanIDSet.add(cp.Opportunity_Plan__c);
                   }
                   }
                
                If(Trigger.isDelete){
                                for(Close_plan__c cp: trigger.old){
                                oppPlanIDSet.add(cp.Opportunity_Plan__c);
                                DeleteNocloseplanMap.put(cp.Opportunity_Plan__c,cp);
                }
                }
   List<Close_plan__c> cpList=[select id,Opportunity_Plan__c from Close_plan__c where Opportunity_Plan__c in : oppPlanIDSet];
                for(Close_plan__c cp: cpList){
                
                                if(closePlanMap.containsKey(cp.Opportunity_Plan__c)){
                                   List<Close_plan__c> closePlanList=new List<Close_plan__c>();
                                  closePlanList=closePlanMap.get(cp.Opportunity_Plan__c);
                                   closePlanList.add(cp);
                                   closePlanMap.put(cp.Opportunity_Plan__c,closePlanList);
                   }
                   else{
                                   List<Close_plan__c> closePlanList=new List<Close_plan__c>();
                                   closePlanList.add(cp);
                                   closePlanMap.put(cp.Opportunity_Plan__c,closePlanList);
                   }
                }
                
                
                for(ID opPlanID: closePlanMap.keyset()){
                                if(DeleteNocloseplanMap.containsKey(opPlanID))
                                DeleteNocloseplanMap.remove(opPlanID);
                                integer count=0;
                                for(Close_plan__c cpl: closePlanMap.get(opPlanID)){
                                                count =count+1;
                                }
                                Opportunity_Plan__c opl=new Opportunity_Plan__c(id=opPlanID,close_plan_count__c=count);
                                oppPlanList.add(opl);
                                
                                
                }
                
                
                
                if(DeleteNocloseplanMap.size()>0){   
                for(ID opPlanID : DeleteNocloseplanMap.keySet()){
                Opportunity_Plan__c opl=new Opportunity_Plan__c(id=opPlanID,close_plan_count__c=0);
                oppPlanList.add(opl);
        }
    }   
                
                try{
                                if(oppPlanList.size()>0)
                                update oppPlanList;
                }catch(Exception e){}
                
   
   
   
}