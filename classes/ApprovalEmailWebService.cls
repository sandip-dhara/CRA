/**********************************************************
 * Class Name: ApprovalEmailWebService
 * Author: HP
 * Date: 26-SEP-2012 
 * Requirement # 
 * Description: A global Email Service Class to process the mails and update the records of Support Request in SFDC.
 ***********************************************************/

global class ApprovalEmailWebService implements Messaging.InboundEmailHandler {

    /**
     * @description: Method to process InbountEmail
     * @parameter: Inbound Email and Inbound Envelope
     */
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
            Messaging.InboundEnvelope env){

        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

        String myPlainText= '';

        myPlainText = email.plainTextBody;

        Integer Index1= myPlainText.indexOf('Approval Id:');
        Integer Index2= myPlainText.indexOf('Status:');
        Integer Index3= myPlainText.indexOf('Approver\'s Comments:');

        Id ApprovalId= myPlainText.subString(Index1+13, Index1+13+15);
        String status= myPlainText.subString(Index2+8, Index3-1);
        String comment= myPlainText.subString(Index3+21);

        String Sub= email.Subject;
        String emailid= email.fromAddress;

        List<Approval__c> approvalList=[Select id,Approver_Email_A__c From Approval__c Where id=:ApprovalId];  

        try {
            if(approvalList.size()>0){

                approvalList[0].Comments__c=comment;
                approvalList[0].Status__c=status;
                approvalList[0].Approver_s_Email_Address__c=emailid;
                approvalList[0].Date_of_Response__c= DateTime.now();
                
                String[] emailArray;
                
                if(approvalList[0].Approver_Email_A__c != null)
                    emailArray=(approvalList[0].Approver_Email_A__c).split(',');
                    
                Boolean valid=false;

                for(String s:emailArray){
                    if(s==emailId)
                        valid=true;
                }
                if(valid)
                    update approvalList;    

                if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
                    List<Attachment> attachList= new List<Attachment>();
                    for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
                        Attachment attachment = new Attachment();
                        // attach to the opportunity record
                        attachment.ParentId = approvalList[0].Id;
                        attachment.Name = email.binaryAttachments[i].filename;
                        attachment.Body = email.binaryAttachments[i].body;
                        attachList.add(attachment);
                    }
                    insert attachList;
                }

            }
        }

        catch (QueryException e) {
            System.debug('Query Issue: ' + e);
        }

        result.success = true;

        return result;
    }
}