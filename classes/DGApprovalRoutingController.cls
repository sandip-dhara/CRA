/********************************************************
Author: Mousumi Panda
Created Date: 26-APR-2013
Release: R5
Capability: Deal Governance
Description:Conroller is used to overridding  the View and Edit for Approval 
 ************************************************************/
public with sharing class DGApprovalRoutingController {

    ID ApprovalID;
    public Set<Id> UserList;
    Public boolean HasAccess;
    public boolean showStandradPage{get;set;}
    public Opportunity Opp{get;set;}
    public boolean hasOptyAccess{get;set;}
    public boolean bIsOptyVisible;
        
    public DGApprovalRoutingController (ApexPages.StandardController controller) {
        ApprovalID=ApexPages.currentPage().getParameters().get('id');
        Approval__c App = (approval__c)controller.getrecord();
        Approval__c appRec=[select id,opportunity__r.id,createdbyid  from Approval__c where id = :ApprovalID];
        showStandradPage = false;
        Set<ID> userIdSet=new Set<ID>();
        userIdSet.add(userInfo.getUSerID());
        for(GroupMember  gm: [SELECT GroupId,Id,SystemModstamp,UserOrGroupId FROM GroupMember WHERE GroupId in (select id from group where type='Queue') and UserOrGroupId=:userInfo.getUSerID()])
        {
            userIDSet.add(gm.GroupId);
        }
        List<ProcessInstance> ProcessInstanceList =new List<ProcessInstance> ();
        List<ProcessInstanceHistory> ProcessInstanceHistoryList = new List<ProcessInstanceHistory>();
        
        ProcessInstanceList = [SELECT Id,TargetObjectID,(SELECT Id, StepStatus,ActorId,OriginalActorId,Comments FROM StepsAndWorkitems where ActorId in :userIdSet) FROM ProcessInstance where TargetObjectID in (select id from Approval__c where id = :ApprovalID)];
        for(ProcessInstance pi: ProcessInstanceList ){
                for(ProcessInstanceHistory pih: pi.StepsAndWorkitems){
                   ProcessInstanceHistoryList.add(pih);
                }
            }
        Opp = new Opportunity();
        try
        {
            Opp = [select id from Opportunity where id =:appRec.Opportunity__r.Id];
            if(Opp != null)
            bIsOptyVisible = true;
        }
        catch(exception e)
        {
        bIsOptyVisible = false;
        }
        List<user> DelegatedUser =new list<User>([select DelegatedApproverId from user where id=:Userinfo.getUserId()]);
        If(ProcessInstanceHistoryList.size() > 0 || appRec.createdbyid == Userinfo.getUserId() || bIsOptyVisible == true || DelegatedUser.Size()>0)
        HasAccess = true;
        hasOptyAccess = true; 


    }
    /*method for View*/
    public PageReference routeToExactPage(){
        If(HasAccess==true)
        {
            Approval__c app=[select id,recordtype.name from Approval__c where id =:ApprovalID];
        
            if(app.id != null && ApprovalRecordType__c.getInstance(app.recordtype.name).isVisualforce__c && ApprovalRecordType__c.getInstance(app.recordtype.name).View_Page_Name__c != null)
            {
                string redirectviewpage = ApprovalRecordType__c.getInstance(app.recordtype.name).View_Page_Name__c;
                PageReference PDFPage= new PageReference('/apex/'+redirectviewpage+'?id='+ApprovalID);
                PDFPage.setRedirect(false); 
                return PDFPage;

            }
           
            else
            {
                showStandradPage = true; 
                return null;
            }
        }
        else
        {
            ApexPages.addmessage(new apexpages.message(apexpages.severity.error,'You do not have access to view this approval request'));
            return null;
        }

    }


    /*Method for Edit*/
    public PageReference routeToExactPageEdit(){
        String result=CheckOptyAccess.checkOptyEditAccess(Opp.Id);
        If(result == 'SUCCESS'){
            If(HasAccess==true)
            {
                Approval__c app=[select id,recordtype.name from Approval__c where id =:ApprovalID];
                
                 if(app.id != null && ApprovalRecordType__c.getInstance(app.recordtype.name).isVisualforce__c && ApprovalRecordType__c.getInstance(app.recordtype.name).Edit_Page_Name__c != null && ApprovalRecordType__c.getInstance(app.recordtype.name).Edit_Page_Name__c =='DGApprovalOpportunityReviewEdit')
               {
                string redirecteditpage = ApprovalRecordType__c.getInstance(app.recordtype.name).Edit_Page_Name__c;
                PageReference PDFPage= new PageReference('/apex/'+redirecteditpage+'?id='+ApprovalID);
                PDFPage.setRedirect(false); 
                return PDFPage;

                }
                
                
                if(app.id != null && ApprovalRecordType__c.getInstance(app.recordtype.name).isVisualforce__c && ApprovalRecordType__c.getInstance(app.recordtype.name).Edit_Page_Name__c != null)
               {
                string redirecteditpage = ApprovalRecordType__c.getInstance(app.recordtype.name).Edit_Page_Name__c;
                PageReference PDFPage= new PageReference('/apex/'+redirecteditpage+'?id='+Opp.Id+'&Appid='+ApprovalID);
                PDFPage.setRedirect(false); 
                return PDFPage;

                }
                
               
                else{
                  
                    String navigationURL ='/'+ApprovalID+'/e?retURL=/'+Opp.Id+'&nooverride=1';
                                         
                  PageReference PDFPage= new PageReference(navigationURL);
                   system.debug('***************'+navigationURL );
                PDFPage.setRedirect(false); 
                    return PDFPage;
                }
            }
            else
            {
                ApexPages.addmessage(new apexpages.message(apexpages.severity.error,'You do not have access to Edit this approval request'));
                return null;
            } 
        }
        Else{
            hasOptyAccess=false;
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'You do not have permission to modify Approval.')); 
            return null;
        }

    }

}