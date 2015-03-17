/*****************************************
Author: Mousumi Panda/HP
Date: 26-05-2013
Release: R5
Capability: Deal Governance
Description: Schedule Apex for Reminder mail for approval request on OBR.
*****************************************/

global class DGBatchSchedulerReminder implements Schedulable {
Schedule_Job_Status__c StartJob = Schedule_Job_Status__c.getInstance('DGRemainderEmails');
String jobStatus = StartJob.Job_Status__c;

DG_Remainder_mail__c dgmailapp= DG_Remainder_mail__c.getInstance('Approver');
DG_Remainder_mail__c dgmailco= DG_Remainder_mail__c.getInstance('Coordinator');
String eligiblebgApprover = dgmailapp.BG__c;
String eligiblebgCoordinator = dgmailco.BG__c;
//Combining Approver's and Coordinator's BGs
String BGs = eligiblebgApprover +';' +eligiblebgCoordinator;
String QueryOR;
String QueryOBR;

    global void execute(SchedulableContext sc)
        {
            //Start the job once the previous job is completed
            if(jobStatus == 'Complete')
             {
                String Eligiblebgs = splitNconvertToSet(';',BGs);
                system.debug('Inside Start');
                String selectQuery='SELECT Id,TargetObjectID,status,createddate,(SELECT Id,createddate,StepStatus,ActorId,OriginalActorId,Comments,ProcessInstance.status,ProcessInstance.TargetObjectID FROM StepsAndWorkitems ' ;
                String parentQueryOBR=' select id from Approval__c where  (RecordType.name=\'Opportunity Business Review\' AND ('+ Eligiblebgs +' )) ) ';
                String whereConditionOBR=' where stepStatus = \'Pending\'  )  FROM ProcessInstance where TargetObjectID in ( '+parentQueryOBR + ' and status=\'Pending\'  order by TargetObjectID Desc  ';
                QueryOBR=selectQuery+whereConditionOBR;
                List<ProcessInstance> PendingProcessInstanceListOBR =new List<ProcessInstance> ();
                PendingProcessInstanceListOBR =database.query(QueryOBR);
                
                
               String parentQueryOR=' select id from Approval__c where  (RecordType.name=\'Opportunity Review\' AND ('+ Eligiblebgs +' )) ) ';  
               String whereConditionOR=' where stepStatus = \'Pending\'  )  FROM ProcessInstance where TargetObjectID in ( '+parentQueryOR + ' and status=\'Pending\'  order by TargetObjectID Desc  ';
               QueryOR=selectQuery+whereConditionOR;
               System.debug('******QueryOR**********'+QueryOR);
               List<ProcessInstance> PendingProcessInstanceListOR =new List<ProcessInstance> ();
               PendingProcessInstanceListOR =database.query(QueryOR);
               
               StartJob.Job_Status__c= 'InProgress';
                    
                  //Setting the variable to InProgress before start of a schedule job
                     update StartJob;
                if(PendingProcessInstanceListOR.size() > 0)
                    {
                    DGApprovalReminder.remindermailvalidationOR(PendingProcessInstanceListOR);
                    }
                  
                
                if(PendingProcessInstanceListOBR.size() > 0)
                    {
                    DGApprovalReminder.remindermailvalidationOBR(PendingProcessInstanceListOBR);
                    }
                   StartJob.Job_Status__c= 'Complete';
                    //Setting the variable to true after end of a schedule job to allow next schedule to run
                     update StartJob;
               
            }
        }
        
       //Function to return BG required for Query
        public static String splitNconvertToSet(String pattern,String str){
            Set<String> retSetValues = null;
            if(str!=null && str.length()>0){
              retSetValues = new Set<String>();
              List<String> splitValues = str.split(pattern,0);
              for(String val: splitValues){
                retSetValues.add(val);
              }
           }
           String BGString ='';
           for(String s: retSetValues){
             BGString= BGString+'Owners_BG__c=\''+ s +'\' OR ';
           }
        BGString = BGString.substring(0,(BGString.length())-4);
        system.debug('********BGString****'+BGString);
        return BGString;
        
    }
    
    
}