/*****************************************
    Author:Mousumi Panda/HP
    Date: 26-04-2013
    Release: R5
    Capability: Deal Governance
    Description: Called from DGBatchSchedulerReminderOR and DGBatchSchedulerReminderOBR scheduler to send reminder email to Approvers
 *****************************************/

Global class DGApprovalReminder {

     /****************Called from DGBatchSchedulerReminderOR *************/
    public static void remindermailvalidationOR(List<ProcessInstance> PendingProcessInstanceList)
    {

        DG_Remainder_mail__c dgmailapp= DG_Remainder_mail__c.getInstance('Approver');
        DG_Remainder_mail__c dgmailco= DG_Remainder_mail__c.getInstance('Coordinator');
        Decimal timeappleadtyimeOR=dgmailapp.OR_Approval_Lead_Time__c;
        Decimal timecoleadtymOR=dgmailco.OR_Approval_Lead_Time__c; 
        Map<id, List<Id>> finalMapToSendReminderOR = new Map<id, List<Id>>();
        List<ProcessInstance> PendingProcessInstanceListOR = new List<ProcessInstance> ();
        
        Set<Id> approversId = new Set<Id>();
        Set<Id> CoordinatorsId = new Set<Id>();
        
        //Put all Approvers and Coordinator in different map in the System
        for(User u: [Select id,Approver_Type__c,Email From User where Approver_Type__c='Approver' Or Approver_Type__c='Coordinator']){

            if(u.Approver_Type__c=='Approver')
               approversId.add(u.id);
            else
               CoordinatorsId.add(u.id);
        }
        
         //All Queue Member for Approval object
        Map<id,List<id>> ApprovalQueueUserMap = new Map<id,List<id>>();
        Set<id> ApprovalQueueSet= new Set<id>();
        for(queueSobject q:[select id,queueID from queueSobject where SobjectType='Approval__c' and queueId in  (select id from group where type='Queue')])
        {
        ApprovalQueueSet.add(q.queueID);
        }
        
        List<GroupMember> ApprovalQueueList=new List<GroupMember>();
        ApprovalQueueList=[SELECT GroupId,Id,SystemModstamp,UserOrGroupId FROM GroupMember WHERE GroupId IN: ApprovalQueueSet];
        
        
        
    Map<id,List<id>> ApprovalQueueUseridMap = new Map<id,List<id>>();   
        
        for(GroupMember  gm: ApprovalQueueList){
            
                       if(ApprovalQueueUseridMap.containsKey(gm.GroupId))  {           
                            List<Id> memberIdList=new List<Id>();
                            memberIdList=ApprovalQueueUseridMap.get(gm.GroupId);
                            if(String.valueOf(gm.UserOrGroupId).startswith('005')){
                            memberIdList.add(gm.UserOrGroupId);
                            }
                            ApprovalQueueUseridMap.put(gm.GroupId, memberIdList);
                           
                        }else{
                            List<Id> memberIdList=new List<Id>();
                            if(String.valueOf(gm.UserOrGroupId).startswith('005')){
                            memberIdList.add(gm.UserOrGroupId);
                            }
                            ApprovalQueueUseridMap.put(gm.GroupId, memberIdList);
                           
                        }
            
            system.debug('ApprovalQueueUseridMap**********'+ApprovalQueueUseridMap);
            
        }


        if(PendingProcessInstanceList.size() > 0){
            Map<id, List<id>> approverMap = new Map<id, List<id>>();
            Map<id, List<id>> coordinatorMap = new Map<id, List<id>>();
            datetime todayDate = datetime.now();
            Set<id> PendingProcessInstanceSet = new Set<id>();
            
             for(ProcessInstance pi: PendingProcessInstanceList){
              PendingProcessInstanceSet.add(pi.TargetObjectID);
             }

                for(ProcessInstanceWorkitem pih:[select id,actorid,originalactorid,createddate,ProcessInstance.targetObjectId
                                                 from ProcessInstanceWorkitem where processinstance.targetObjectId IN :PendingProcessInstanceSet]){
                    
                    integer intDays = ( pih.createddate.Date()).daysBetween(todayDate.Date());
                    datetime sameDaytodayDate = pih.createddate.addDays(intDays);
                    decimal decHours = ((todayDate.getTime())/1000/60/60) - ((sameDaytodayDate.getTime())/1000/60/60);
                    integer totalhours=(intDays*24)+Integer.valueof(decHours);
                    system.debug('totalhours*********'+totalhours);
                    
                    //Creating a map of Approval Id and pending Approver's id
                    if(approversId.contains(pih.originalactorid) && totalhours >=Integer.valueof(timeappleadtyimeOR)){

                        if(approverMap.containsKey(pih.processinstance.TargetObjectID))  {           
                            List<ID> approveroriginalActorIdList=new List<ID>();
                            approveroriginalActorIdList=approverMap.get(pih.processinstance.TargetObjectID);
                            approveroriginalActorIdList.add(pih.originalactorid);
                            approverMap.put(pih.processinstance.TargetObjectID, approveroriginalActorIdList);
                        }else{
                            List<ID> approveroriginalActorIdList=new List<ID>();
                            approveroriginalActorIdList.add(pih.originalactorid);
                            approverMap.put(pih.processinstance.TargetObjectID, approveroriginalActorIdList);
                            
                        }
                    }
                    
                    //Creating a map of Approval Id and pending Coordinator's id
                    if((CoordinatorsId.contains(pih.originalactorid) || ApprovalQueueUseridMap.containsKey(pih.actorid))&& totalhours>=Integer.valueof(timecoleadtymOR)){
                        if(coordinatorMap.containsKey(pih.processinstance.TargetObjectID))  {           
                            List<id> approveroriginalActorIdList=new List<Id>();
                            approveroriginalActorIdList=coordinatorMap.get(pih.processinstance.TargetObjectID);
                            approveroriginalActorIdList.add(pih.originalactorid);
                             if(String.valueof(pih.actorid).startswith('00G')){
                             
                            approveroriginalActorIdList.addall(ApprovalQueueUseridMap.get(pih.actorid));
                            
                            }
                            coordinatorMap.put(pih.processinstance.TargetObjectID, approveroriginalActorIdList);
                            
                        }else{
                            List<Id> approveroriginalActorIdList=new List<Id>();
                            approveroriginalActorIdList.add(pih.originalactorid);
                             if(String.valueof(pih.actorid).startswith('00G')){
                            approveroriginalActorIdList.addall(ApprovalQueueUseridMap.get(pih.actorid));
                            }
                            coordinatorMap.put(pih.processinstance.TargetObjectID, approveroriginalActorIdList);
                           
                        }  
                    }
                }
                
                //put it in a set to avoid repetation of Approvalids
                Set<Id> approvalidSet= new Set<Id>();
                for(Id approvalapproverid:approverMap.keySet()){ 
                    approvalidSet.add(approvalapproverid);
                }
                for(Id approvalcoordnid:coordinatorMap.keySet()){ 
                    approvalidSet.add(approvalcoordnid);
                }

                //List of Approval ids from the Set
                List<Id> approvalIdList = new List<Id>();
                approvalIdList.addall(approvalidSet);

                //Put all Approval Ids and  approver's&co-ordinator's ids in a map to Send Email
                for(Id appId: approvalIdList){
               List<Id> finalListApprovers=new List<Id>();
                if(approverMap.containsKey(appId)){
                    finalListApprovers.addall(approverMap.get(appId));
                    }
                if(coordinatorMap.containsKey(appId)){
                    finalListApprovers.addall(coordinatorMap.get(appId));
                    }
                  finalMapToSendReminderOR.put(appId,finalListApprovers);
                }


            
        }  
        //Call SendreminderEmail method and pass the map containing Approval ids and Approver's id to send Email for OR
        SendreminderEmail(finalMapToSendReminderOR);
    }

    
    /***************Called from DGBatchSchedulerReminderOBR******************/ 
    
    public static void remindermailvalidationOBR(List<ProcessInstance> PendingProcessInstanceList)
    {

        DG_Remainder_mail__c dgmailapp= DG_Remainder_mail__c.getInstance('Approver');
        DG_Remainder_mail__c dgmailco= DG_Remainder_mail__c.getInstance('Coordinator');
        Decimal timeappleadtyimeOBR=dgmailapp.OBR_Approval_Lead_Time__c;
        Decimal timecoleadtymOBR=dgmailco.OBR_Approval_Lead_Time__c; 
         Map<id, List<Id>> finalMapToSendReminderOBR = new Map<id, List<Id>>();
        List<ProcessInstance> PendingProcessInstanceListOBR = new List<ProcessInstance> ();
        
        Set<Id> approversId = new Set<Id>();
        Set<Id> CoordinatorsId = new Set<Id>();
        
        //Put all Approvers and Coordinator in different map in the System
        for(User u: [Select id,Approver_Type__c From User where Approver_Type__c='Approver' Or Approver_Type__c='Coordinator']){
                  
                   if(u.Approver_Type__c=='Approver')
                   approversId.add(u.id);
                   else
                   CoordinatorsId.add(u.id);
        }
        
         //All QueueMember for Approval object
        Map<id,List<id>> ApprovalQueueUserMap = new Map<id,List<id>>();
        Set<id> ApprovalQueueSet= new Set<id>();
        for(queueSobject q:[select id,queueID from queueSobject where SobjectType='Approval__c' and queueId in  (select id from group where type='Queue')])
        {
        ApprovalQueueSet.add(q.queueID);
        }
        
        List<GroupMember> ApprovalQueueList=new List<GroupMember>();
        ApprovalQueueList=[SELECT GroupId,Id,SystemModstamp,UserOrGroupId FROM GroupMember WHERE GroupId IN: ApprovalQueueSet];
        
        
        
    Map<id,List<id>> ApprovalQueueUseridMap = new Map<id,List<id>>();   
        
        for(GroupMember  gm: ApprovalQueueList){
            
                       if(ApprovalQueueUseridMap.containsKey(gm.GroupId))  {           
                            List<Id> memberIdList=new List<Id>();
                            memberIdList=ApprovalQueueUseridMap.get(gm.GroupId);
                            if(String.valueOf(gm.UserOrGroupId).startswith('005')){
                            memberIdList.add(gm.UserOrGroupId);
                            }
                            ApprovalQueueUseridMap.put(gm.GroupId, memberIdList);
                           
                        }else{
                            List<Id> memberIdList=new List<Id>();
                            if(String.valueOf(gm.UserOrGroupId).startswith('005')){
                            memberIdList.add(gm.UserOrGroupId);
                            }
                            ApprovalQueueUseridMap.put(gm.GroupId, memberIdList);
                           
                        }
            
            system.debug('ApprovalQueueUseridMap**********'+ApprovalQueueUseridMap);
            
        }


        if(PendingProcessInstanceList.size() > 0){

            Map<id, List<id>> approverMap = new Map<id, List<id>>();
            Map<id, List<id>> coordinatorMap = new Map<id, List<id>>();
            Set<id> PendingProcessInstanceSet = new Set<id>();
            datetime todayDate = datetime.now();

            for(ProcessInstance pi: PendingProcessInstanceList){
             PendingProcessInstanceSet.add(pi.targetObjectId);
            }

                for(ProcessInstanceWorkitem pih:[select id,actorid,originalactorid,createddate,ProcessInstance.targetObjectId
                                                 from ProcessInstanceWorkitem where processinstance.targetObjectId IN : PendingProcessInstanceSet]){

                    
                    integer intDays = ( pih.createddate.Date()).daysBetween(todayDate.Date());
                    datetime sameDaytodayDate = pih.createddate.addDays(intDays);
                    decimal decHours = ((todayDate.getTime())/1000/60/60) - ((sameDaytodayDate.getTime())/1000/60/60);
                    integer totalhours=(intDays*24)+Integer.valueof(decHours);
                    
                    //Creating a map of Approval Id and pending Approver's Email addresses 
                    if(approversId.contains(pih.originalactorid) && totalhours >=Integer.valueof(timeappleadtyimeOBR)){

                        if(approverMap.containsKey(pih.processinstance.TargetObjectID))  {           
                            List<Id> approveroriginalActorIdList=new List<Id>();
                            approveroriginalActorIdList=approverMap.get(pih.processinstance.TargetObjectID);
                            approveroriginalActorIdList.add(pih.originalactorid);
                            approverMap.put(pih.processinstance.TargetObjectID, approveroriginalActorIdList);
                           
                        }else{
                            List<Id> approveroriginalActorIdList=new List<Id>();
                            approveroriginalActorIdList.add(pih.originalactorid);
                            approverMap.put(pih.processinstance.TargetObjectID, approveroriginalActorIdList);
                            
                        }


                    }
                    //Creating a map of Approval Id and pending Coordinator's Email addresses
                    if((CoordinatorsId.contains(pih.originalactorid) || ApprovalQueueUseridMap.containsKey(pih.actorid))&& totalhours>=Integer.valueof(timecoleadtymOBR)){

                        if(coordinatorMap.containsKey(pih.processinstance.TargetObjectID))  {           
                            List<Id> approveroriginalActorIdList=new List<Id>();
                            approveroriginalActorIdList=coordinatorMap.get(pih.processinstance.TargetObjectID);
                            approveroriginalActorIdList.add(pih.originalactorid);
                             if(String.valueof(pih.actorid).startswith('00G')){
                            approveroriginalActorIdList.addall(ApprovalQueueUseridMap.get(pih.actorid));
                            }
                            coordinatorMap.put(pih.processinstance.TargetObjectID, approveroriginalActorIdList);
                            
                        }else{
                            List<Id> approveroriginalActorIdList=new List<Id>();
                            approveroriginalActorIdList.add(pih.originalactorid);
                             if(String.valueof(pih.actorid).startswith('00G')){
                            approveroriginalActorIdList.addall(ApprovalQueueUseridMap.get(pih.actorid));
                            }
                            coordinatorMap.put(pih.processinstance.TargetObjectID, approveroriginalActorIdList);
                            
                        } 

                    }

                }

            



            //put it in a set to avoid repetation of Approvalids
            Set<Id> approvalidSet= new Set<Id>();


            for(Id approvalapproverid:approverMap.keySet()){ 
                approvalidSet.add(approvalapproverid);
            }
            for(Id approvalcoordnid:coordinatorMap.keySet()){ 
                approvalidSet.add(approvalcoordnid);
                
            }
            system.debug('approvalidSet*****'+approvalidSet);

            //List of Approval ids from the Set
            List<Id> approvalIdList = new List<Id>();
            approvalIdList.addall(approvalidSet);

            //Put all Approval Ids and  approver's&co-ordinator's ids in a map to Send Email
                for(Id appId: approvalIdList){
               List<Id> finalListApprovers=new List<Id>();
                if(approverMap.containsKey(appId)){
                    finalListApprovers.addall(approverMap.get(appId));
                    }
                if(coordinatorMap.containsKey(appId)){
                    finalListApprovers.addall(coordinatorMap.get(appId));
                    }
                  finalMapToSendReminderOBR.put(appId,finalListApprovers);
                }


        }    

        //Call SendreminderEmail method and pass the map containing Approval ids and Email Addresses to send Email for OBR
        SendreminderEmail(finalMapToSendReminderOBR);
    }


   //Method to send the Email for OR and OBR
    public static void SendreminderEmail(Map<Id, List<Id>> appMap)
    {
       //OrgWideEmailAddress to Set setOrgWideEmailAddressId for Email
          OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress where DisplayName=:Label.DgremindermailAddress] ;
          System.debug('OrgWideEmailAddress id'+owa.id);
          EmailTemplate et=[Select id from EmailTemplate where name=:'DG Approval Request Reminder Email'];
      //Generating Single Email  
          List<Messaging.SingleEmailMessage> mailList =new List<Messaging.SingleEmailMessage>();
        

        for(Id approvalid:appMap.keySet()){  
       
        for(Id originalActID :appMap.get(approvalid)){

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(originalActID);
            mail.setWhatId(approvalid);
            mail.setTemplateId(et.id);
            mail.setOrgWideEmailAddressId(owa.id);
            mail.saveAsActivity = false;
            maillist.add(mail);
            System.debug('****maillist******'+maillist);
            
         }
        }
        //Send Email
        if(mailList.size()>0){
            Messaging.sendEmail( mailList );              
        }


    }
}