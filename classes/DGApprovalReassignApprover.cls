/*****************************************
Author: Venkatesh S/Abrar Mohammed
Date: 26-04-2013
Release: R5
Capability: Deal Governance
Description: Batch Apex for dynamic assigment of Queues to approval request.
*****************************************/

Global class DGApprovalReassignApprover {

public static void reassignToQueue(List<ProcessInstanceWorkitem> WorkItem)
    {        
    //Store Approval id and current approval queue name in a map
    Map<String, approval__c> AppMap = new Map<String, approval__c> {};
    
    //declare set to store Queue Names
    Set<String> QueueSet = new Set<String>();
    
    //Loop through the scope and create approval id list
    Set<id> ApprovalSet = new Set<id>();
    for (ProcessInstanceWorkitem WI: WorkItem)
        ApprovalSet.add(WI.ProcessInstance.TargetObjectId);
    
    system.debug('!@'+ApprovalSet);
    
    //Declare a approval object list and assingn approval records to it.
    List<approval__c> applist = new List<approval__c>();
    applist = [select id,Current_Approval_level__c,approver1__c, approver2__c, approver3__c, approver4__c, approver5__c, approver6__c, approver7__c, approver8__c, 
              approver9__c, approver10__c, approver11__c, approver12__c, approver13__c, approver14__c, approver15__c, approver16__c, approver17__c, approver18__c, approver19__c, approver20__c,
              Queue_Level_1__c, Queue_Level_2__c, Queue_Level_3__c, Queue_Level_4__c, Queue_Level_5__c, Queue_Level_6__c, Queue_Level_7__c, Queue_Level_8__c,
              Queue_Level_9__c, Queue_Level_10__c, Queue_Level_11__c, Queue_Level_12__c, Queue_Level_13__c, Queue_Level_14__c, Queue_Level_15__c, Queue_Level_16__c, 
              Queue_Level_17__c, Queue_Level_18__c, Queue_Level_19__c, Queue_Level_20__c,Approval_Flow_Type__c from approval__c where id in :ApprovalSet];
    
    
    //Loop through each approval record SOQL from trigger context to add the approval id and the queue name to a map 
        for (approval__c app: applist)
        {         
            If(app.Queue_Level_1__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_1__c));
            }            
            if(app.Queue_Level_2__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_2__c));
            }            
            if(app.Queue_Level_3__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_3__c));
            }            
            if(app.Queue_Level_4__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_4__c));
            }            
            if(app.Queue_Level_5__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_5__c));
            }            
            if(app.Queue_Level_6__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_6__c));
            }            
            if(app.Queue_Level_7__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_7__c));
            }            
            if(app.Queue_Level_8__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_8__c));
            }
            if(app.Queue_Level_9__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_9__c));
            }            
            if(app.Queue_Level_10__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_10__c));
            }            
            if(app.Queue_Level_11__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_11__c));
            }            
            if(app.Queue_Level_12__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_12__c));
            }
            if(app.Queue_Level_13__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_13__c));
            }            
            if(app.Queue_Level_14__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_14__c));
            }            
            if(app.Queue_Level_15__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_15__c));
            }            
            if(app.Queue_Level_16__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_16__c));
            }
            if(app.Queue_Level_17__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_17__c));
            }            
            if(app.Queue_Level_18__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_18__c));
            }            
            if(app.Queue_Level_19__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_19__c));
            }            
            if(app.Queue_Level_20__c != null)
            {
            QueueSet.add(string.valueof(app.Queue_Level_20__c));
            }
        AppMap.put(string.valueof(app.id), app);
        }
    system.debug('!@'+AppMap);
        
    //Store User id and user info in a map
    Map<String, String> UserMap = new Map<String, String> {};
    for (user userinfo :[Select Name,id from user where name in ('Pending Assignment 01','Pending Assignment 02','Pending Assignment 03','Pending Assignment 04')])
        {
        UserMap.put(string.valueof(userinfo.Name),string.valueof(Userinfo.id));
        }
        
    system.debug('!@'+UserMap);
            
    //Create Queue Name and Id map
    system.debug('###'+AppMap);        
    Map<String, string> QueueMap = new Map<String, string> {};
    for (QueueSobject q :[Select queueid,queue.name from QueueSobject where SobjectType = 'Approval__c' and Queue.Name in:QueueSet])
        {
        QueueMap.put(q.queue.name,string.valueof(q.queueid));
        }
    system.debug('###'+QueueMap);
    
    //get approval history
    List<ProcessInstanceWorkitem> UpdateworkItemList = new List<ProcessInstanceWorkitem>();
    List<ProcessInstanceWorkitem> workItemList = [Select p.ProcessInstance.TargetObjectId,p.ActorId From ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId in :AppMap.keySet() and p.actorid in :(UserMap.Values()) and processInstance.status = 'Pending' order by createddate asc];
    system.debug('!@'+workItemList);
    for(ProcessInstanceWorkitem  wlist: workItemList)
        {
        if(AppMap.get(wlist.ProcessInstance.TargetObjectId).approval_flow_type__c == 'Unanimous')
            {
            system.debug('!@'+'Unanimous'+wlist.ProcessInstance.TargetObjectId);
            system.debug('!@'+AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_1__c);
            system.debug('!@'+wlist.ActorId);
            system.debug('!@'+UserMap.get('Pending Assignment 01'));
            if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_1__c != null && wlist.ActorId == UserMap.get('Pending Assignment 01'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_1__c);
                if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'1');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_2__c != null && wlist.ActorId == UserMap.get('Pending Assignment 02'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_2__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'2');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_3__c != null && wlist.ActorId == UserMap.get('Pending Assignment 03'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_3__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'3');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_4__c != null && wlist.ActorId == UserMap.get('Pending Assignment 04'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_4__c);
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'4');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_5__c != null && wlist.ActorId == UserMap.get('Pending Assignment 05'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_5__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'5');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_6__c != null && wlist.ActorId == UserMap.get('Pending Assignment 06'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_6__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'6');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_7__c != null && wlist.ActorId == UserMap.get('Pending Assignment 07'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_7__c);
                 if(Wlist.actorid !=null)               
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'7');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_8__c != null && wlist.ActorId == UserMap.get('Pending Assignment 08'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_8__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'8');
                }
            }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).approval_flow_type__c == 'Sequential')
            {
            If(AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 1 && AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_1__c != null )
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_1__c);
                if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'S'+'1');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 2 && AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_2__c != null)
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_2__c);
                if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'S'+'2');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 3 && AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_3__c != null)
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_3__c);
                if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'S'+'3');
                }
            else If(AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 4 && AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_4__c != null)
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_4__c);
                if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'S'+'4');
                }
            else If(AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 5 && AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_5__c != null)
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_5__c);
                if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'S'+'5');
                }
            else If(AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 6 && AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_6__c != null)
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_6__c);
                if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'S'+'6');
                }
            else If(AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 7 && AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_7__c != null)
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_7__c);
                if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'S'+'7');
                }
            else If(AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 8 && AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_8__c != null)
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_8__c);
                if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'S'+'8');
                }           
            }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).approval_flow_type__c == 'Hybrid')
            {
            
            if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_1__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 1 && wlist.ActorId == UserMap.get('Pending Assignment 01'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_1__c);
                if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'1');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_2__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 1 && wlist.ActorId == UserMap.get('Pending Assignment 02'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_2__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'2');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_3__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 1 && wlist.ActorId == UserMap.get('Pending Assignment 03'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_3__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'3');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_4__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 1 && wlist.ActorId == UserMap.get('Pending Assignment 04'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_4__c);
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'4');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_5__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 2 && wlist.ActorId == UserMap.get('Pending Assignment 01'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_5__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'5');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_6__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 2 && wlist.ActorId == UserMap.get('Pending Assignment 02'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_6__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'6');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_7__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 2 && wlist.ActorId == UserMap.get('Pending Assignment 03'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_7__c);
                 if(Wlist.actorid !=null)               
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'7');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_8__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 2 && wlist.ActorId == UserMap.get('Pending Assignment 04'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_8__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'8');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_9__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 3 && wlist.ActorId == UserMap.get('Pending Assignment 01'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_9__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'9');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_10__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 3 && wlist.ActorId == UserMap.get('Pending Assignment 02'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_10__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'10');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_11__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 3 && wlist.ActorId == UserMap.get('Pending Assignment 03'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_11__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'11');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_12__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 3 && wlist.ActorId == UserMap.get('Pending Assignment 04'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_12__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'12');
                }   
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_13__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 4 && wlist.ActorId == UserMap.get('Pending Assignment 01'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_13__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'13');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_14__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 4 && wlist.ActorId == UserMap.get('Pending Assignment 02'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_14__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'14');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_15__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 4 && wlist.ActorId == UserMap.get('Pending Assignment 03'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_15__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'15');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_16__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 4 && wlist.ActorId == UserMap.get('Pending Assignment 04'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_16__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'16');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_17__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 5 && wlist.ActorId == UserMap.get('Pending Assignment 01'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_17__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'17');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_18__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 5 && wlist.ActorId == UserMap.get('Pending Assignment 02'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_18__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'18');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_19__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 5 && wlist.ActorId == UserMap.get('Pending Assignment 03'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_19__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'19');
                }
            else if(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_20__c != null && AppMap.get(wlist.ProcessInstance.TargetObjectId).Current_Approval_level__c == 5 && wlist.ActorId == UserMap.get('Pending Assignment 04'))
                {
                wlist.ActorId = QueueMap.get(AppMap.get(wlist.ProcessInstance.TargetObjectId).Queue_Level_20__c);
                 if(Wlist.actorid !=null)
                UpdateworkItemList.add(wlist);
                system.debug('!@'+'20');
                }                                       
            }
            
            system.debug('!@'+UpdateworkItemList);
            
        }
        update UpdateworkItemList;
    }

}