public class ODP_Extension_MitigationPlan {
    
    public List<Mitigation_Action__c> macList {get;set;}
    public Risks__c risk{get;set;}
    public Mitigation_Action__c mac {get;set;}
    public Offering_Release__c project {get;set;}
    public boolean IsPM{get;set;}
    public boolean IsOwner{get;set;}
    public boolean IsPending{get;set;}
    public boolean CanSubmitApproval{get;set;}
    public String CanNotSubmitApprovalReason{get;set;}
    public boolean RiskIsActive{get;set;}
    public String linkMAId{get;set;}
    public String RequestResult{get;set;}
    public integer StgMaxRPN{get;set;}
    public ProcessInstance PendingRisk{get;set;}
    public String Comments{get;set;}
    public List<Core_Team_Member__c> CTMList{get;set;}
    
    public ODP_Extension_MitigationPlan(ApexPages.StandardController controller) {
        StgMaxRPN = 0;
        risk = (Risks__c)controller.getRecord();
        risk = [select Id,Name__c,Description__c,Planned_Resolution_Date__c,Status__c,Risk_Priority_Number__c,Risk_Owner__c,Project_ID__c,
                Business_Impact_ID__r.Description__c,
                Business_Impact_ID__r.Business_Impact_Name__c,
                Business_Impact_ID__r.Severity__c,
                Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__c,
                Business_Impact_ID__r.Potential_Risk_ID__c,
                Process_Control_ID__r.Description__c,
                Process_Control_ID__r.Process_Control_Name__c,
                Process_Control_ID__r.Detection__c,
                Root_Cause_ID__r.Description__c,
                Root_Cause_ID__r.Occurance__c,
                Root_Cause_ID__r.Root_Cause_Name__c
                from Risks__c where Id=:risk.Id];
                
        //Ning Kang : Get Current Stage Max PRN
        //List <Release_Stage__c> stgList = [select id from release_stage__c where offering_release__c =:risk.Business_Impact_ID__r.Potential_Risk_ID__r.Project_ID__c]
                
        RiskIsActive = risk.Status__c == 'Active';
        Project = [select Id,Name__c,OwnerId,Owner.email,Owner.Name from Offering_Release__c where Id=:risk.Project_ID__c];
        CTMList = [select Id,User__c,User__r.Name,Role_Name__c from Core_Team_Member__c where Release_Role__r.Offering_Release__c=:risk.Project_ID__c];
        macList = [select Id,Name__c,Note__c,Status__c,Due_Date__c,
                   Mitigation_Action_Owner__c
                   from Mitigation_Action__c where Risk_ID__c=:risk.Id];
        mac = new Mitigation_Action__c(
            Risk_ID__c = risk.Id,
            Mitigation_Action_Owner__c = risk.Risk_Owner__c
        );
        String curUserId = UserInfo.getUserId();
        IsPM = curUserId == String.valueOf(project.OwnerId);
        IsOwner = curUserId == String.valueOf(risk.Risk_Owner__c);
        
        List<ProcessInstance> piList = [Select Id,Status,CreatedDate,CreatedById
                                    From ProcessInstance
                                    WHERE TargetObjectId =:risk.Id and status='Pending'];
        IsPending = piList.size() > 0;
        if(IsPending){
            PendingRisk = piList[0];
        }
        CanSubmitApproval = true;
        if(IsPending){
            CanSubmitApproval = false;
            CanNotSubmitApprovalReason = 'The approval request of this risk has already been submited to opportunity owner.';
        }
        if(risk.Status__c != 'New'){
            CanSubmitApproval = false;
            CanNotSubmitApprovalReason = 'Only new created risk can be submited to opportunity owner for approval.';
        }
    }
    
    public PageReference saveMA(){
        try{
            if(mac.Due_Date__c > risk.Planned_Resolution_Date__c){
                RequestResult = 'Mitigation Action Due Date cannot be later than risk Planned Resolution Date - ' + String.valueOf(risk.Planned_Resolution_Date__c);
                return null;
            }
            
            upsert mac;
            RequestResult = 'success';
            return null;
            /*PageReference pageRef = new PageReference('/apex/ODP_Page_MitigationPlan?id='+risk.id);
            PageRef.setRedirect(true);
            return pageRef;*/
        }
        catch(Exception e){
            //RequestResult = 'exception:' + e.getMessage();
            RequestResult = 'Mitigation Action Saving Failed, Please contact IT administrator.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Mitigation Action Saving Failed, Please contact IT administrator'));
            return null;
        }
    }
    
    public PageReference editSaveMA(){
        try{
            if(mac.Due_Date__c > risk.Planned_Resolution_Date__c){
                RequestResult = 'Mitigation Action Due Date cannot be later than risk Planned Resolution Date - ' + String.valueOf(risk.Planned_Resolution_Date__c);
                return null;
            }
            
            upsert mac;
            RequestResult = 'success';
            return null;
            /*PageReference pageRef = new PageReference('/apex/ODP_Page_MitigationPlan?id='+risk.id);
            PageRef.setRedirect(true);
            return pageRef;*/
        }
        catch(Exception e){
            //RequestResult = 'exception:' + e.getMessage();
            RequestResult = 'Mitigation Action Saving Failed, Please contact IT administrator.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Mitigation Action Saving Failed, Please contact IT administrator'));
            return null;
        }
    }    

    public PageReference changeOwnerSaveMA(){
        try{
            upsert mac;
            RequestResult = 'success';
            return null;
        }
        catch(Exception e){
            RequestResult = 'Mitigation Action Saving Failed, Please contact IT administrator.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Mitigation Action Saving Failed, Please contact IT administrator'));
            return null;
        }
    } 
    
    public PageReference saveRisk(){
        try{
            update risk;
            PageReference pageRef = new PageReference('/apex/ODP_Page_MitigationPlan?id='+risk.id);
            PageRef.setRedirect(true);
            return pageRef;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Risk Saving Failed, Please contact IT administrator'));
            return null;
        }
    }
    
    public PageReference saveRPN(){
        try{
            update risk.Business_Impact_ID__r;
            update risk.Root_Cause_ID__r;
            update risk.Process_Control_ID__r;
            PageReference pageRef = new PageReference('/apex/ODP_Page_MitigationPlan?id='+risk.id);
            PageRef.setRedirect(true);
            return pageRef;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Risk Saving Failed, Please contact IT administrator'));
            return null;
        }
    }
    
    public PageReference approvalRisk(){
        try{
             Id workItemId=getWorkItemId(risk.Id);
            
            if(workItemId == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Risk Approval Failed, this risk is not in approval process.'));
                return null;
            }
            else{                  
                 // Create an approval request for the risk
                Approval.ProcessWorkitemRequest req1 = new Approval.ProcessWorkitemRequest();
                req1.setComments(Comments);
                req1.setAction('Approve');
                
                req1.setWorkitemId(workItemId);
                
                // Submit the approval request for the risk
                Approval.ProcessResult result = Approval.process(req1);
                
                SendRiskEmail(string.valueOf(PendingRisk.CreatedById),
                          'The risk['+risk.Name__C+'] approval request has been approved.',
                          'The risk['+risk.Name__C+'] approval request has been approved by ' + UserInfo.getName() + '<br/> Comments:' + Comments,
                          '<a href="{base}/'+project.Id+'"> ' + project.Name__c + '</a>',
                          '<a href="{base}/apex/ODP_Page_MitigationPlan?id='+risk.Id+'"> ' + risk.Name__c + '</a>',
                          'Opportunity Owner : <a href="mailto:' + project.Owner.email  + '">  ' + project.Owner.Name + ' </a>'
                    );
                
                PageReference pageRef = new PageReference('/apex/ODP_Page_MitigationPlan?id='+risk.id);
                PageRef.setRedirect(true);
                return pageRef;
            }
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Risk Approval Failed, Please contact IT administrator'));
            return null;
        }
    }
    
    public PageReference rejectRisk(){
        try{
             Id workItemId=getWorkItemId(risk.Id);
            
            if(workItemId == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Risk Approval Failed, this risk is not in approval process.'));
                return null;
            }
            else{                  
                 // Create an approval request for the risk
                Approval.ProcessWorkitemRequest req1 = new Approval.ProcessWorkitemRequest();
                req1.setComments(Comments);
                req1.setAction('Reject');
                
                req1.setWorkitemId(workItemId);
                // Submit the approval request for the risk
                Approval.ProcessResult result = Approval.process(req1);
                
                SendRiskEmail(string.valueOf(PendingRisk.CreatedById),
                          'The risk['+risk.Name__C+'] approval request has been rejected.',
                          'The risk['+risk.Name__C+'] approval request has been rejected by ' + UserInfo.getName() + '<br/> Comments:' + Comments,
                          '<a href="{base}/'+project.Id+'"> ' + project.Name__c + '</a>',
                          '<a href="{base}/apex/ODP_Page_MitigationPlan?id='+risk.Id+'"> ' + risk.Name__c + '</a>',
                          'Opportunity Owner : <a href="mailto:' + project.Owner.email  + '">  ' + project.Owner.Name + ' </a>'
                    );
                
                PageReference pageRef = new PageReference('/apex/ODP_Page_MitigationPlan?id='+risk.id);
                PageRef.setRedirect(true);
                return pageRef;
            }
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Risk Approval Failed, Please contact IT administrator'));
            return null;
        }
    }
    
    public PageReference submitApprovalRisk(){
        try{
            // Create an submit approval request for the risk
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments(Comments);
            req1.setObjectId(risk.Id);

            // Submit the approval request for the risk
            Approval.ProcessResult result = Approval.process(req1);
            
            PageReference pageRef = new PageReference('/apex/ODP_Page_MitigationPlan?id='+risk.id);
            PageRef.setRedirect(true);
            return pageRef;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Submit request for Risk Approval Failed, Please contact IT administrator' + e.getMessage()));
            return null;
        }
    } 
    
    public Id getWorkItemId(Id targetObjectId){
        Id retVal = null;
        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
                                                 where p.ProcessInstance.TargetObjectId =:targetObjectId])
        {
            retVal  =  workItem.Id;
        }
        return retVal;
    }

    public void SendRiskEmail(string userId,string subject, string title,
                                                string offeringRelease,
                                    string risk, 
                                    string contactor)
    {
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        User tempUser = [select email, Name from User where id =:userId];            
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {tempUser.email }; 
            mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Athena ODP'); 
        mail.setSubject('Notification - '+ subject); 
        mail.setUseSignature(false);
        
        string bodyString = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><title></title></head>  <style>a:link {color:white;}a:visited {color:#D7410B;}a:hover {color:#D7410B;}a:active {color:#D7410B;}font-family: "HP Simplified","Arial","sans-serif" !important;</style><body><p>&nbsp;</p>';
        bodyString = bodyString + '<table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px;">';
        bodyString = bodyString + '<tbody><tr><td><h3><span><span style="font-family:HP Simplified,Arial,sans-serif;font-size:24px;"><b style="font-family:HP Simplified,Arial,sans-serif;font-size:24px;">Opportunity Development</b><br>';
        bodyString = bodyString + '<small><b style="font-family:HP Simplified,Arial,sans-serif;">HP Enterprise Services IT</b></small></span></span></h3></td><td>';
        bodyString = bodyString + '<img alt="" src="https://hp--plmesit--c.cs10.content.force.com/servlet/servlet.ImageServer?id=015J0000000HBJY&oid=00DJ00000036uji" style="width: 100px; height: 100px; border-width: 0px; border-style: solid; margin: 0px; float: right;"></td></tr></tbody></table>';
        bodyString = bodyString + '<table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px;">';
        bodyString = bodyString + '<tbody><tr><td><h1><b style="font-family:HP Simplified,Arial,sans-serif;">For Your Information</b>&nbsp;</h1><p>';
        bodyString = bodyString + '<span style="font-size:16px;"><span style="font-family:HP Simplified,Arial,sans-serif;">';
        bodyString = bodyString + 'To  '+ tempUser.Name +' ,&nbsp;</span></span></p>';
        bodyString = bodyString + '<p><span style="font-size:16px;"><span style="font-family:HP Simplified,Arial,sans-serif;">'+title+'</span></span></p><p>';
        bodyString = bodyString + '<table style="border:1px solid black;width:100%;">';
        if(!String.isEmpty(offeringRelease))
        {
            bodyString = bodyString + '<tr><td style="background-color:#D7410B; padding-left:10px;color:white; white-space:nowrap;"><b style="font-family:HP Simplified,Arial,sans-serif;">Opportunity</b></td>';
            bodyString = bodyString + '<td style="background-color:#0096D6;color:white;"><b style="font-family:HP Simplified,Arial,sans-serif;">';
            bodyString = bodyString + offeringRelease.replace('{base}', baseUrl) + '</b></td></tr>';
        }
        if(!String.isEmpty(risk))
        {
            bodyString = bodyString + '<tr><td style="background-color:#D7410B; padding-left:10px;color:white; white-space:nowrap;"><b style="font-family:HP Simplified,Arial,sans-serif;">Risk</b></td>';
            bodyString = bodyString + '<td style="background-color:#0096D6;color:white;"><b style="font-family:HP Simplified,Arial,sans-serif;">';
            bodyString = bodyString + risk.replace('{base}', baseUrl) + '</b></td></tr>';
        }
        if(!String.isEmpty(contactor))
        {
            bodyString = bodyString + '<tr><td style="background-color:#a9a9a9; padding-left:10px;padding-right:30px;padding-top:15px;padding-bottom:15px;color:white; white-space:nowrap;width:25%;"><b style="font-family:HP Simplified,Arial,sans-serif;">Contacts for questions</b></td>';
            bodyString = bodyString + '<td style="background-color:#0096D6;color:white;"><b style="font-family:HP Simplified,Arial,sans-serif;">';
            bodyString = bodyString + contactor + '</b></td></tr>';
        }
        bodyString = bodyString + '</table></p>';
        bodyString = bodyString + '<p><span style="font-size:16px;"><span style="font-family:HP Simplified,Arial,sans-serif;"><br <br="">Regards,&nbsp;</span></span></p>';
        bodyString = bodyString + '<p><span style="font-size:16px;"><span style="font-family:HP Simplified,Arial,sans-serif;">HP ESIT Engagement Team</span></p>';
        bodyString = bodyString + '</td></tr></tbody></table>';
        bodyString = bodyString + '<h3 style="color:#0096D6;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
        bodyString = bodyString + '<hr><p style="text-align: center;">';
        bodyString = bodyString + '<span style="font-size:10px;"><span style="font-family:HP Simplified,Arial,sans-serif;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;HP Confidential and Internal use only</span></span></p>';
        bodyString = bodyString + '</body></html>';
        mail.setHtmlBody(bodyString);
        
        // Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });          
    }
    
    public PageReference delMA(){
        try{
            Mitigation_Action__c delMac = [select Id
                   from Mitigation_Action__c where Id=:linkMAId];
            delete delMac;
            
            PageReference pageRef = new PageReference('/apex/ODP_Page_MitigationPlan?id='+risk.id);
            PageRef.setRedirect(true);
            return pageRef;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Mitigation Action Deletion Failed, Please contact IT administrator if needed.'));
            return null;
        }
    }
    
    public PageReference loadMA(){
        try{
            mac = [select Id,Name__c,Note__c,Status__c,Due_Date__c,Mitigation_Action_Owner__c
                   from Mitigation_Action__c where Id=:linkMAId];
            return null;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Mitigation Action Loading Failed, Please contact IT administrator if needed.'));
            return null;
        }
    }
    
    public PageReference reloadMitigationPlan(){
        try{
            macList = [select Id,Name__c,Note__c,Status__c,Due_Date__c,
                   Mitigation_Action_Owner__c
                   from Mitigation_Action__c where Risk_ID__c=:risk.Id];
            mac = new Mitigation_Action__c(
                Risk_ID__c = risk.Id,
                Mitigation_Action_Owner__c = risk.Risk_Owner__c
            );
            return null;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Mitigation Action Loading Failed, Please contact IT administrator if needed.'));
            return null;
        }
    }
    
    public List<SelectOption> TeamMemberList{
        get{
            List<SelectOption> options = new List<SelectOption>();
            Set<Id> teamUserId = new Set<Id>();
            for(Core_Team_Member__c ctm : CTMList){
                if(!teamUserId.contains(ctm.User__c)){
                    teamUserId.add(ctm.User__c);
                    options.add(new SelectOption(ctm.User__c,ctm.User__r.Name));  // + ' - '+ ctm.Role_Name__c                          
                }
            }
            return options;
        }
    }
}