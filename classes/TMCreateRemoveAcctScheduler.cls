/**********************************************************
* Class Name: TMCreateRemoveAcctScheduler
* Author: HP:Debmalya:CR3737
* Description: This is a scheduled class which calls for 
*              TMCreateRemoveAccountTeam class to add/delete 
*              Users to Account Team member object.
***********************************************************/
global class TMCreateRemoveAcctScheduler implements Schedulable {
       
     /**
    * @description: Executes 'Addition/Deletion of User in Sales Territories to AccountTeams' Batch
    * @param: SchedulableContext
    **/
    global void execute(SchedulableContext sc){
    
        TMEngineScheduledFlag__c specialtyFlag = TMEngineScheduledFlag__c.getInstance('SpecialtyBatchFlag');
        TMEngineScheduledFlag__c obj = TMEngineScheduledFlag__c.getValues('CreateRemAcctTeam');
        boolean flag = obj.SchedularFlag__c;
        if(!flag){
            obj.SchedularFlag__c = true;
            update obj;
            Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('CreateRemoveAccountTeam').Batch_Size__c);
            Id batchId = Database.executeBatch(new TMCreateRemoveAccountTeam(), batchSize);
            //system.abortJob(sc.getTriggerId());
        }else{
             if(specialtyFlag != null && !specialtyFlag.SchedularFlag__c){
                try{
                    //Update to true
                    specialtyFlag.SchedularFlag__c = true;
                    update specialtyFlag;
                }catch(Exception exp){
                    system.debug('Exception Occured while updating Specialty Flag to true '+exp.getMessage());
                }
                SpecialtyBatchScheduler specialtySc = new SpecialtyBatchScheduler();
                
                datetime currentDateTime = datetime.now();
                String min = String.valueOf(math.mod((currentDateTime.minute() + 2),60));
                
                String schExp = '0 '+min+' * * * ? ';
                system.schedule(Label.Specialty_Batch_Job+datetime.now(), schExp, specialtySc);
            }
        }
        system.abortJob(sc.getTriggerId());
    }
}