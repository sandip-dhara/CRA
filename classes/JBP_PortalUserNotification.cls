/*************************************************************************************
 * Class Name: JBP_PortalUserNotification
 * Author: HP PRM Team
 * Date: 23-07-2013 
 * R6 : Requirement #: 5386
 * Description: To Send email to Partner Approvers when a JBP is Submitted for Approval
 **************************************************************************************/
global class JBP_PortalUserNotification
{
    webService static void SendEmail(JBP__c JBP, String emailtempId)
    {
        List<Messaging.SingleEmailMessage> emailList= new List<Messaging.SingleEmailMessage>();
        Set<id> userIdSet = new Set<id>();
        userIdSet.add(JBP.Partner_ApproverUser_Account_Manager__c);
        userIdSet.add(JBP.Partner_ApproverUser_Principal_Sponsor__c);
        List<JBP__Share> shareToCreateList = new List<JBP__Share>();
        
        List<JBP__Share> jbpShareList = [select id,UserOrGroupId from JBP__Share where UserOrGroupId IN:userIdSet and ParentId=:JBP.id];
        if(jbpShareList.size()>0){
            for(JBP__Share shareRec : jbpShareList){
                userIdSet.remove(shareRec.UserOrGroupId);
            }
        }
        if(userIdSet.size()>0){
            for(id usrId : userIdSet){
                JBP__Share shareRec = new JBP__Share();
                shareRec.UserOrGroupId = usrId;
                shareRec.ParentId = JBP.id;
                shareRec.RowCause = 'Approval_Sharing__c';
                shareRec.AccessLevel = 'Read';
                shareToCreateList.add(shareRec);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
                mail.saveAsActivity = false;
                mail.setTargetObjectId(usrId );
                mail.setTemplateId(emailtempid);
                mail.setWhatId(JBP.Id);
                emailList.add(mail);
            }
            if(!Test.isRunningTest()){
                insert shareToCreateList;
                Messaging.sendEmail(emailList);
            }
        }
    }               
}