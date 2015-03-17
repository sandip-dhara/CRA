/*****************************************
Author: Venkatesh S
Date: 29-03-2013
Capability: OM Deal Governance
Description: Controller for listing Queues in the system
*****************************************/

public class ApprovalQueueListing {
Public String QueueId {get;set;}
Public String ApproverId {get;set;}
    public PageReference initialize() {
        QueueId = System.currentPageReference().getParameters().get('QueueId');
        ApproverId = System.currentPageReference().getParameters().get('ApproverId');
        return null;
    }


List<QueueSobject> QueueList;

public List<QueueSobject> getQueueList()
{
List<QueueSobject> QueueList = [Select Id, q.Queue.Name,q.Queue.ID, SobjectType from QueueSobject q where SobjectType = 'Approval__c'  ORDER BY q.Queue.Name];
return QueueList;
}

}