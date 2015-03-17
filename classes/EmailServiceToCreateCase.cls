global class EmailServiceToCreateCase implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
        Messaging.InboundEnvelope envelope){
            Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
            
            // mapping case fields with incoming email 
            Case cocase = new Case();
            cocase.subject = email.subject;
            cocase.description = email.plainTextBody;
            cocase.Status  = 'New';
            //cocase.Submitter__c = email.fromname.substring(0,email.fromname.indexOf(' ')) + email.fromname.substring(email.fromname.indexOf(' ')) ;
            cocase.Case_Requestor__c = email.fromname.substring(0,email.fromname.indexOf(' ')) + email.fromname.substring(email.fromname.indexOf(' ')) ;
            cocase.Case_Requestor_Email__c = envelope.fromAddress;
            CaseExternalSystemMapper__c cm = [Select Id,Assign_to_Team__c, Classification__c, ExternalValue__c, Origin__c, Request_Type__c, SystemValue__c, BG__c, Country__c, Program_Type__c, Route_to_Market__c, Region__c, Time_zone__c, Work_Location__c FROM CaseExternalSystemMapper__c where ExternalValue__c = :envelope.toAddress]; 
            
            Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
            Schema.SObjectType s = m.get('Case') ;
            Schema.DescribeSObjectResult cfrSchema = s.getDescribe() ;
            Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
            id rcdType= RecordTypeInfo.get(cm.SystemValue__c).getRecordTypeId();
            if(cm != Null){
                //setting case fields with case external system mapper field values 
                cocase.Origin = cm.Origin__c;
                cocase.Assign_to_Team__c = cm.Assign_To_Team__c;
                cocase.bg__c = cm.bg__c;
                cocase.Work_Location__c = cm.Work_Location__c;
                cocase.Route_to_Market__c = 'Direct';
                cocase.Requestor_s_TimeZone__c = cm.Time_zone__c;
                cocase.Country__c = cm.Country__c;
                cocase.Region__c = cm.Region__c;
                cocase.Work_Location__c = cm.Work_Location__c;
                cocase.RecordTypeId = rcdType;
                cocase.Request_Type__c = cm.Request_Type__c; 
                cocase.Business_Type__c = 'Standard';
                insert cocase;
            }
            
            //Attaching email to email related list on case object
            EmailMessage msg = new EmailMessage();
            msg.incoming = True;    
            msg.ParentId = cocase.Id;
            msg.Subject = email.subject;
            msg.TextBody = email.plainTextBody;
            msg.HtmlBody = email.htmlBody;
            msg.MessageDate = System.now();
            msg.FromAddress = email.fromAddress;
            msg.FromName = email.fromName;
        //if there are multiple To email address then separate by ;
            String str = '';
            if (email.toAddresses != null && email.toAddresses.size() > 0){
                for (integer i = 0 ; i < email.toAddresses.size() ; i++) {
                    if (i != 0) str = str + ';';  
                    str = str + email.toAddresses[i];
                }
                msg.ToAddress = str;
            }
        if (email.ccAddresses != null && email.ccAddresses.size() > 0){
            str = '';
            for (integer i = 0 ; i < email.ccAddresses.size() ; i++) {
                if (i != 0) str = str + ';';  
                str = str + email.ccAddresses[i];
            }
            msg.CcAddress = str;
        }
        insert msg;
        
        // Attaching email attachments to case object      
        if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
            for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
                Attachment attachment = new Attachment();
        //      attach to the newly created case record
                attachment.ParentId = cocase.Id;
                    if(email.binaryAttachments[i].mimeTypeSubType == 'message/rfc822'){
                    //if(email.binaryAttachments[i].filename.endsWith('.msg'))
                        String newfilename = 'OUTLOOK MESSAGE FILE :' + email.binaryAttachments[i].filename + '.eml';
                        attachment.Name = newfilename;
                    }
                    else
                        attachment.Name = email.binaryAttachments[i].filename;
                        attachment.Body = email.binaryAttachments[i].body;
               insert attachment;
            }
        }
        if (email.textAttachments != null && email.textAttachments.size() > 0) {
            for (integer i = 0 ; i < email.textAttachments.size() ; i++) {  
            Attachment attachment1 = new Attachment();
        //  attach to the newly created contact record
            attachment1.ParentId = cocase.Id;
            attachment1.Name = email.textAttachments[i].filename;      
            attachment1.Body = blob.valueOf(email.textAttachments[i].body);
       //   attachment1.mimeTypeSubType = 'application/vnd.ms-outlook';
            insert attachment1;
            }
        }
        return result;
    }
}