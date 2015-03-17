/*****************************************
Author: Venkatesh S/Abrar Mohammed
Date: 26-05-2013
Release: R5
Capability: Deal Governance
Description: Schedule Apex for reassignment to Queue for approval request.
*****************************************/

global class DGBatchSchedulerReassignToQueue implements Schedulable {
Schedule_Job_Status__c StartJob = Schedule_Job_Status__c.getInstance('DGReassignToQueue');
String jobStatus = StartJob.Job_Status__c;
    global void execute(SchedulableContext sc)
        {
            Set<id> setUser = new Set<id>();
            List<ProcessInstanceWorkitem>  listWorkItem = new List<ProcessInstanceWorkitem>();
             if(jobStatus == 'Complete')
            {
                system.debug('Inside Start');
                for (user u:[Select id from user where name in ('Pending Assignment 01','Pending Assignment 02','Pending Assignment 03','Pending Assignment 04')])
                    {
                    setUser.add(u.id);
                    }
                listWorkItem = [Select p.ProcessInstance.TargetObjectId From ProcessInstanceWorkitem p where p.actorid = :setUser and processInstance.status = 'Pending'];
                if(listWorkItem.size() > 0)
                    {
                   StartJob.Job_Status__c= 'InProgress';
                  //Setting the variable to InProgress before start of a schedule job
                    update StartJob;
                    DGApprovalReassignApprover.reassignToQueue(listWorkItem);
                    StartJob.Job_Status__c= 'Complete';
                  //Setting the variable to Complete after end of a schedule job to allow next schedule to run
                    update StartJob;
                    }
            }
            
                
        }
}