/**********************************************************
* Class Name: DGApprovalsInfoController
* Author: Praveen Kumar Reddy
* Date: 15-MaAprr-2013
* Requirement # Request Id:
* Description: Controller class displaying the approval request information like pendig approval request, approval request information for Deal Governance
***********************************************************/

public class DGApprovalsInfoController{
    public Boolean isResultEmpty { get; set; }
    public List<WrapperApproval> wrapperList{set;get;}
    public String viewName{set;get;}
    public Boolean isLinksToShow{set;get;}
    public Boolean assignedTo{set;get;}
    public Boolean isApprovedDate{set;get;}
    public Boolean isStatus{set;get;}
    public Boolean isFinalStatus{set;get;}
    public List<SelectOption> viewVals{set;get;}
    public String searchByName{set;get;}
    public Date   searchByDate{set;get;}
    public String SearchByAssignedTo{set;get;}
    public user u;
    public Date dateFrom{set;get;}
    public Date dateTo{set;get;}
    
    public DGApprovalsInfoController(ApexPages.StandardController controller) {
        PickListValues();
        viewName='My Pending Approvals';
        isApprovedDate=true;
        isLinksToShow=true;
        isStatus=true;
        assignedTo=true;
        isFinalStatus=true;
        myApprovalList();

    }

    public PageReference myApprovalList(){
        
        wrapperList=new List<WrapperApproval> ();
        isResultEmpty =false;
        Set<ID> userIdSet=new Set<ID>();
        userIdSet.add(userInfo.getUSerID());
        String Query;
        //getting queue id of the current users belong to 
        for(GroupMember  gm: [SELECT GroupId,Id,SystemModstamp,UserOrGroupId FROM GroupMember WHERE GroupId in (select id from group where type='Queue') and UserOrGroupId=:userInfo.getUSerID()]){
            userIDSet.add(gm.GroupId);
        }
        
        String selectQuery='SELECT Id,TargetObjectID,status,(SELECT Id, StepStatus,ActorId,OriginalActorId,Comments,ProcessInstance.status,ProcessInstance.TargetObjectID FROM StepsAndWorkitems ' ;
        String whereCondition;
        String parentQuery;
        // preparing where clause dyancamically based on the search values given
        if(searchByName != null && searchByName !=''){
            searchByName=searchByName.replaceAll('\\*','%');
            searchByName =searchByName +'%';
            parentQuery=' select id from Approval__c  where ( Opportunity_Name__c like \''+searchByName +'\' or  Account_Name__c like \''+searchByName +'\' ) and (RecordType.name=\'Opportunity Business Review\' OR RecordType.name=\'Opportunity Review\') )' ;
        }


        if(searchByName != null && searchByName !='' && dateFrom!=null && dateTo != null ){
            parentQuery = parentQuery.subString(0,parentQuery.length()-1) + ' and (RecordType.name in ' +Label.MyApprovalRecordTypes+ ' ) and (submitted_Date__c >=' +DateTime.newInstance(dateFrom.year(),dateFrom.Month(),dateFrom.Day(),0,0,0).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'')+ ' and submitted_Date__c <=  '+DateTime.newInstance(dateTo.year(),dateTo.Month(),dateTo.Day(),0,0,0).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'')+' ) ) ';
        }else if((searchByName == null || searchByName =='') && String.valueOf(dateFrom) !='' && dateFrom!=null   && dateTo != null &&  String.valueOf(dateTo)!='' ){
            parentQuery = ' select id from Approval__c where (RecordType.name in (' +Label.MyApprovalRecordTypes+ ' )) and  (submitted_Date__c >=' +DateTime.newInstance(dateFrom.year(),dateFrom.Month(),dateFrom.Day(),0,0,0).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'')+ ' and submitted_Date__c <=  '+DateTime.newInstance(dateTo.year(),dateTo.Month(),dateTo.Day(),0,0,0).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'')+' ) ) ';
        }
        else if((searchByName == null || searchByName =='') && (dateFrom!=null && String.valueOf(dateFrom)!='')   && (dateTo == null || String.valueOf(dateTo)=='') ){
            parentQuery = ' select id from Approval__c where (RecordType.name in (' +Label.MyApprovalRecordTypes+ ' ) ) and (submitted_Date__c >=' +DateTime.newInstance(dateFrom.year(),dateFrom.Month(),dateFrom.Day(),0,0,0).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'')+' ) ) ';
        }
        else if((searchByName == null || searchByName =='') && (dateFrom==null || String.valueOf(dateFrom)=='' ) && (dateTo != null &&  String.valueOf(dateTo)!='') ){
            parentQuery = ' select id from Approval__c where  (RecordType.name in (' +Label.MyApprovalRecordTypes+ ' ) ) and (submitted_Date__c <=  '+DateTime.newInstance(dateTo.year(),dateTo.Month(),dateTo.Day(),0,0,0).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'')+' ) ) ';
        }
        else if((searchByName != null || searchByName !='') && (dateFrom==null || String.valueOf(dateFrom)=='' ) && (dateTo != null && String.valueOf(dateTo)!='' ) ){
            parentQuery = ' select id from Approval__c where (RecordType.name in (' +Label.MyApprovalRecordTypes+ ' )) and  ( ( Opportunity_Name__c like \''+searchByName +'\' or  Account_Name__c like \''+searchByName +'\') and submitted_Date__c <=  '+DateTime.newInstance(dateTo.year(),dateTo.Month(),dateTo.Day(),0,0,0).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'')+' ) ) ';
        }
        else if((searchByName != null || searchByName !='') && (dateFrom!=null && String.valueOf(dateFrom)!='')   && (dateTo == null || String.valueOf(dateTo)=='')  ){
            parentQuery = ' select id from Approval__c where (RecordType.name in ('+Label.MyApprovalRecordTypes+ ' )) and  (( Opportunity_Name__c like \''+searchByName +'\' or  Account_Name__c like \''+searchByName +'\') and submitted_Date__c >=  '+DateTime.newInstance(dateFrom.year(),dateFrom.Month(),dateFrom.Day(),0,0,0).format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'')+' ) ) ';
        }
        
        if(parentQuery==null || parentQuery=='')
            parentQuery=' select id from Approval__c where  (RecordType.name in (' +Label.MyApprovalRecordTypes+ ' ) ) ) ';  
            
            system.debug('&&&&&&&&&&  '+ parentQuery );
        if(viewName == 'My Pending Approvals'){
            if(SearchByAssignedTo!=null && SearchByAssignedTo!=''){
                SearchByAssignedTo=SearchByAssignedTo+'%';
                whereCondition=' where ActorId in :userIdSet and  stepStatus = \'Pending\' and actor.name like \''+SearchByAssignedTo+'\' )  FROM ProcessInstance where TargetObjectID in ( '+parentQuery + ' and status=\'Pending\' order by TargetObjectID Desc ';
            }
            else{
                whereCondition=' where ActorId in :userIdSet and  stepStatus = \'Pending\'  )  FROM ProcessInstance where TargetObjectID in ( '+parentQuery + ' and status=\'Pending\'  order by TargetObjectID Desc  ';
            }
            isLinksToShow=true;
            assignedTo=true;
            isApprovedDate=false;
            isStatus=true;
            isFinalStatus=false;

        }   
        if(viewName == 'My Related Open Approvals'){
            if(SearchByAssignedTo!=null && SearchByAssignedTo!=''){
                SearchByAssignedTo=SearchByAssignedTo+'%';
                whereCondition='where ActorId = :userIDSet and stepstatus=\'Approved\' and actor.name like \''+SearchByAssignedTo+'\' )  FROM ProcessInstance where TargetObjectID in ( '+parentQuery + ' and status=\'Pending\'  order by TargetObjectID Desc  ';
            }    
            else{
                whereCondition='where ActorId = :userIDSet and stepstatus=\'Approved\'  )  FROM ProcessInstance where TargetObjectID in ( '+parentQuery + ' and status=\'Pending\' order by TargetObjectID Desc  ';
            }
            Query=selectQuery+whereCondition;
            List<ProcessInstance> MyProcessInstanceList =new List<ProcessInstance> ();
            Set<ID> myTargetObjectID=new Set<ID>();
            system.debug('***query '+query);
            try{
                MyProcessInstanceList =database.query(query);
            }Catch(Exception e){ }
            for(ProcessInstance pi: MyProcessInstanceList ){
                for(ProcessInstanceHistory pih: pi.StepsAndWorkitems){
                    myTargetObjectID.add(pih.ProcessInstance.TargetObjectID );
                }
            }


            whereCondition= ' Where stepstatus=\'Pending\'  )  FROM ProcessInstance where TargetObjectID in :myTargetObjectID  order by TargetObjectID Desc ';

            isLinksToShow=false;
            assignedTo=true;
            isStatus=false;
            isFinalStatus=true;
            isApprovedDate=false;

        }
        if(viewName == 'My Approval History'){
                        
            parentQuery=parentQuery.subString(0,parentQuery.length()-2)+ ' and (status__c=\'Approved\' or status__c=\'Rejected\' or status__c=\'Recalled\') )  ';
            if(SearchByAssignedTo!=null && SearchByAssignedTo!=''){
                SearchByAssignedTo=SearchByAssignedTo+'%';
                whereCondition='where ActorId in :userIDSet and (stepstatus=\'Approved\' or stepstatus=\'Rejected\' ) and actor.name like \''+SearchByAssignedTo+'\' ) FROM ProcessInstance where TargetObjectID in ( ' +parentQuery + ' and ( status=\'Approved\' or status=\'Rejected\' or status=\'Removed\') order by TargetObjectID Desc limit 2000 ';
            }    
            else{
                whereCondition='where ActorId in :userIDSet and (stepstatus=\'Approved\' or stepstatus=\'Rejected\' )) FROM ProcessInstance where TargetObjectID in ( ' +parentQuery + ' and ( status=\'Approved\' or status=\'Rejected\' or status=\'Removed\') order by TargetObjectID Desc limit 2000 ';
            }
            //and ( ( stepStatus = \'Approved\') or ( stepStatus = \'Rejected\'))
            isLinksToShow=false;
            assignedTo=true;
            isApprovedDate=false;
            isStatus=false;
            isFinalStatus=true;

        }
        //and  (stepStatus not in (\'Started\') and stepStatus = \'Pending\')
        Query=selectQuery+whereCondition;
        
        List<ProcessInstance> ProcessInstanceList =new List<ProcessInstance> ();
        try{
            
            ProcessInstanceList=database.query(query);

        }Catch(Exception e){ isResultEmpty =true;}

        if(ProcessInstanceList.size()>0){
            Set<ID> targetObjectId=new Set<ID>();
            Set<ID> processinstanceIdSet=new Set<ID>();
            for(ProcessInstance pi: ProcessInstanceList){

                targetObjectId.add(pi.TargetObjectID); 
                processinstanceIdSet.add(pi.id);
            }  

            Map<ID,ID> pipwIDMap=new Map<ID,ID>();
            if(viewName == 'My Pending Approvals'){
                for(ProcessInstanceWorkitem pw : [select id,ProcessInstanceId  from ProcessInstanceWorkitem where ProcessInstanceId in : processinstanceIdSet]){
                    pipwIDMap.put(pw.ProcessInstanceId,pw.id);
                }
            }
            Map<ID,Approval__c> approvalIDNameMap=new Map<ID,Approval__c >();

            for(Approval__c a: [select id,Approval_Long_Name__c,RecordType.name,opportunity__r.name,opportunity__r.Account.name,opportunity__r.Account.ShippingState,Submitted_Date__c,Submitter__r.name,status__C,Approved_Date__c from Approval__c where id in :targetObjectId]){
                approvalIDNameMap.put(a.id,a);
            }  

            for(ProcessInstance pi: ProcessInstanceList){
                Approval__c approvalRec=approvalIDNameMap.get(pi.TargetObjectID);
                for(ProcessInstanceHistory pih: pi.StepsAndWorkitems){
                    if(viewName == 'My Pending Approvals'){
                        wrapperList.add(new WrapperApproval(approvalRec.id,approvalRec.Approval_Long_Name__c,approvalRec.RecordType.name,approvalRec.opportunity__r.name,approvalRec.opportunity__r.Account.name,approvalRec.opportunity__r.Account.ShippingState,approvalRec.Submitted_Date__c,approvalRec.Submitter__r.name ,approvalRec.status__c,approvalRec.Approved_Date__c ,pipwIDMap.get(pi.id), pih));//a.getSObject('opportunity__r').name,//,a.getSObject('opportunity__r').getSObject('Account').name
                    }else{
                        wrapperList.add(new WrapperApproval(approvalRec.id,approvalRec.Approval_Long_Name__c,approvalRec.RecordType.name,approvalRec.opportunity__r.name,approvalRec.opportunity__r.Account.name,approvalRec.opportunity__r.Account.ShippingState,approvalRec.Submitted_Date__c,approvalRec.Submitter__r.name ,approvalRec.status__c,approvalRec.Approved_Date__c ,null, pih));//a.getSObject('opportunity__r').name,//,a.getSObject('opportunity__r').getSObject('Account').name
                    }   

                }
            }
        }
        if(wrapperList.size()<=0)
            isResultEmpty =true; 
        searchByName=''; 
        return null;
    }

    public PageReference nullifySearch() {
        searchByName=null;
        SearchByAssignedTo=null;
        dateFrom=null;
        dateTo=null;
        return null;
    }

    public void PickListValues(){

        viewvals=new List<SelectOption>();
        viewvals.add(new SelectOption('My Pending Approvals','My Pending Approvals'));
        viewvals.add(new SelectOption('My Related Open Approvals','My Related Open Approvals'));
        viewvals.add(new SelectOption('My Approval History','My Approval History'));


    }
    // wrapper class to display information form approval and process instance history 
    private class WrapperApproval{
        public String approvalName{set;get;}
        public String approvalType{set;get;}
        Public String opptyName{set;get;}
        public String accountName{set;get;}
        public DateTime SubmittedDate{set;get;}
        public DateTime approvedDate{set;get;}
        Public String Submitter{set;get;}
        public String overAllStatus{set;get;}
        public ID winstanceID{set;get;}
        public ProcessInstanceHistory  pi{set;get;}
        Public ID appID{set;get;}
        Public String accountState{set;get;}
        WrapperApproval(ID approvID,String name,String type,String opName,String accName,String accState,DateTime SDate,String submitter,String ovstatus,DateTime approvedDate,ID wid,ProcessInstanceHistory pih){
            approvalName=name;
            approvalType=type;
            opptyName=opname;
            accountName=accName;
            SubmittedDate=SDate;
            this.Submitter=submitter;
            overAllStatus=ovstatus;
            this.approvedDate=approvedDate;
            winstanceID=wid;
            pi=pih;
            appID=approvID;
            accountState=accState;
        }
    }
}