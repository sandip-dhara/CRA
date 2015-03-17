/**********************************************************************************
Name:  OpportunityActivitiesScheduled
Copyright © 2012  HP
===================================================================================
===================================================================================
Purpose:
-------
Batch Class to Extract Opportunity Activites and send mail as an Attacahment
===================================================================================
===================================================================================
History
-------
VERSION      AUTHOR                DATE             DETAIL              
1.0 -       Pradeep Kumar L.G          23/10/2012      INITIAL DEVELOPMENT
**********************************************************************************/


global class OpportunityActivitiesScheduled implements Schedulable { 
    public  String subject { get; set; }
    
    
 global void execute(SchedulableContext sc) {
 /*
                public String body { get; set; }
                public Map<id,Opportunity> optyids;
                public Map<Id,User> usermap;
               optyids =new Map<id,Opportunity>([SELECT id,Opportunity_ID__c from Opportunity where Business_Group2__c ='ES']);            
               usermap=new Map<Id,User>([Select id,Legacy_Employee_Ref__c from User limit 1000]);
               IsFirstGripExtract__c isfirstextract=[select name from IsFirstGripExtract__c LIMIT 1];
              List<Task> optact;
               
              if(isfirstextract.Name=='True'){
                   optact= [SELECT What.Name,What.id,CreatedBy.Legacy_Employee_Ref__c,CreatedBy.Last_First_name__c,CreatedBy.Email,LastModifiedBy.Legacy_Employee_Ref__c,LastModifiedBy.Last_First_name__c,LastModifiedBy.Email,Who.Name,Subject,Type,ActivityDate,Status,Priority,Owner.name,Rating__c,Sales_Stage__c,Description,LastModifiedDate,Completion_Date__c,Createddate,Owner.Id FROM Task where WhatId =:Optyids.values()];
              }else{
                   //optact= [SELECT What.Name,What.id,CreatedBy.Legacy_Employee_Ref__c,CreatedBy.Last_First_name__c,CreatedBy.Email,LastModifiedBy.Legacy_Employee_Ref__c,LastModifiedBy.Last_First_name__c,LastModifiedBy.Email,Who.Name,Subject,Type,ActivityDate,Status,Priority,Owner.name,Rating__c,Sales_Stage__c,Description,LastModifiedDate,Completion_Date__c,Createddate,Owner.Id FROM Task where WhatId =:Optyids.values() AND (LastModifiedDate=:System.Today() OR LastModifiedDate=:System.Today()-1 OR Createddate=:System.Today() OR Createddate=:System.Today()-1)];
                   
                optact= [SELECT What.Name,What.id,CreatedBy.Legacy_Employee_Ref__c,CreatedBy.Last_First_name__c,CreatedBy.Email,LastModifiedBy.Legacy_Employee_Ref__c,LastModifiedBy.Last_First_name__c,LastModifiedBy.Email,Who.Name,Subject,Type,ActivityDate,Status,Priority,Owner.name,Rating__c,Sales_Stage__c,Description,LastModifiedDate,Completion_Date__c,Createddate,Owner.Id FROM Task where WhatId =:Optyids.values() AND (LastModifiedDate >=:System.Today() OR LastModifiedDate >=:System.Today()-1 OR Createddate >=:System.Today() OR Createddate >=:System.Today()-1)];

              } 
               
                
               
               string header = 'Opportunity ID,Name,Subject,Type,Due Date,Status,Priority,Assigned To,Assigned To Workforce Id,Rating,Sales Stage,Comments,Created Date,Created By Workforce Identifier,Created By Full Name,Last Updated Timestamp,Last Updated By Workforce Identifier,Last Updated By Full Name,Completion Date \n';

               string finalstr = header ;
               for(Task T: optact)
                    {
                        String oppid=optyids.get(t.What.id).Opportunity_ID__c;
                        String userlegacyno=usermap.get(t.Owner.Id).Legacy_Employee_Ref__c;
                        string recordString = '"'+oppid+'","'+T.Who.Name+'","'+T.Subject+'","'+T.Type+'","'+T.ActivityDate+'","'+T.Status+'","'+T.Priority+'","'+T.Owner.Name+'","'+userlegacyno+'","'+T.Rating__c+'","'+T.Sales_Stage__c+'","'+T.Description+'","'+T.CreatedDate+'","'+T.CreatedBy.Legacy_Employee_Ref__c+'","'+T.CreatedBy.Last_First_name__c+'","'+T.LastModifiedDate+'","'+T.LastModifiedBy.Legacy_Employee_Ref__c+'","'+T.LastModifiedBy.Last_First_name__c+'","'+T.Completion_Date__c+'" \n';
                        finalstr = finalstr +recordString;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                    }
                    
            String tocustumlabel=Label.GRIP_Extract_To_Mail_Id;
            List<String> toEmailaddress=new List<String>();           
            for(String tomailid: tocustumlabel.split(';')){
            
                toEmailaddress.add(tomailid);
            }
            
            String ccCustomlabel=Label.GRIP_Extract_CC_Mail_Id;
            List<String> ccEmailaddress=new List<String>();
            for(String ccmailid: ccCustomlabel.split(';')){
            
                ccEmailaddress.add(ccmailid);
            }
                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                
                Blob csvBlob = Blob.valueOf(finalstr);
                string csvname= 'OpptyActivities.csv';
                csvAttc.setFileName(csvname);
                csvAttc.setBody(csvBlob);  
              
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                subject ='Opportunity Activities List CSV';
                email.setSubject(subject);
                email.setToAddresses (toEmailaddress);
                email.setCcAddresses (ccEmailaddress);                
                email.setPlainTextBody('Please Find Attached All Opportunities Activities Report as a CSV File');
                email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
                
                */
 }

}