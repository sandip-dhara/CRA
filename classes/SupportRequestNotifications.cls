/**********************************************************
* Class Name: SupportRequestNotifications
* Author: Accenture
* Date: 12-June-2012 
* Requirement # Request Id:
* Description: Apex Class used by Assignment Engine to send Email Notification to Support Team
***********************************************************/
public class SupportRequestNotifications{
	
	/**
    * @description: Send Email & attach Request Attachment as an email attachment
    *               
    * @return: return void  
    */
    public static void sendNotification(String sRequestID, List<String> paramEmails,String templateId){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Messaging.EmailFileAttachment> allAttachments = new List<Messaging.EmailFileAttachment>();
        List<Attachment> attachmentList = [Select body, name from Attachment where ParentId= :sRequestID];
        for(Attachment file: attachmentList){
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(file.Name);
            efa.setBody(file.body);
            allAttachments.add(efa); 
        }
        mail.setFileAttachments(allAttachments);
        //String[] toAddresses = new String[] {paramEmail};
        String[] toAddresses = paramEmails;
        mail.setToAddresses(toAddresses);
        mail.setTargetObjectId(UserInfo.getUserId());
        mail.setTemplateId(templateId);
        mail.setSaveAsActivity(false);
        mail.setwhatId(sRequestID);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}