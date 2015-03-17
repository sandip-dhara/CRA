/**********************************************************************************
Name:  GripExtractadapter
Copyright © 2012  HP
===================================================================================
===================================================================================
Purpose:
-------
Class to Extract Opportunity Activites and send mail as an Attacahment
===================================================================================
===================================================================================
History
-------
VERSION      AUTHOR                DATE             DETAIL              
1.0 -       Pradeep Kumar L.G          23/10/2012      INITIAL DEVELOPMENT
**********************************************************************************/

public class GripExtractadapterController{

    public Map<Id,User> usermap;
    public Map<id,Opportunity> optyids;

    public void Extractopptyacivities(List<Task> tasklistvar,String region){
        try{                                          
           List<Task> optact=new List<Task>();
           system.debug('%%'+tasklistvar);
           if(tasklistvar==null){
               optact= [SELECT What.Name,What.id,CreatedBy.Legacy_Employee_Ref__c,CreatedBy.Last_First_name__c,CreatedBy.Email,LastModifiedBy.Legacy_Employee_Ref__c,LastModifiedBy.Last_First_name__c,LastModifiedBy.Email,Who.Name,Subject,Type,ActivityDate,Status,Priority,Owner.name,Rating__c,Sales_Stage__c,Description,LastModifiedDate,Completion_Date__c,Createddate,Owner.Id FROM Task where WhatId in (select id from Opportunity Where Business_Group2__c ='ES' AND Account.WorldRegion_Region__c=:region) AND (LastModifiedDate >=:System.Today() OR LastModifiedDate >=:System.Today()-1 OR Createddate >=:System.Today() OR Createddate >=:System.Today()-1)];
             }else{
                 optact=tasklistvar;
             }
           if(!optact.isEmpty()&&optact.Size()>0){   
           
            Set<Id> ownerids=new Set<Id>();
            Set<Id> opptyids=new Set<Id>();
            
            for(Task  tasklist: optact){
                ownerids.add(tasklist.ownerid);
                opptyids.add(tasklist.what.id);
            }           
               usermap=new Map<Id,User>([Select id,Legacy_Employee_Ref__c from User where Legacy_Employee_Ref__c!=null AND Id in:ownerids]);
               optyids=new Map<Id,Opportunity>([select id,Opportunity_ID__c from Opportunity where id in :opptyids]);
               
               string header = 'Opportunity ID,Name,Subject,Type,Due Date,Status,Priority,Assigned To,Assigned To Workforce Id,Rating,Sales Stage,Comments,Created Date,Created By Workforce Identifier,Created By Full Name,Last Updated Timestamp,Last Updated By Workforce Identifier,Last Updated By Full Name,Completion Date \n';
                                                   
               string finalstr = header ;
                                                   
               for(Task T: optact)
                    {
                        String oppid;
                        String userlegacyno;
                        if(tasklistvar==null){
                            oppid=optyids.get(t.What.id).Opportunity_ID__c;
                            userlegacyno=usermap.get(t.Owner.Id).Legacy_Employee_Ref__c;
                        }
                        string recordString = '"'+oppid+'","'+T.Who.Name+'","'+T.Subject+'","'+T.Type+'","'+T.ActivityDate+'","'+T.Status+'","'+T.Priority+'","'+T.Owner.Name+'","'+userlegacyno+'","'+T.Rating__c+'","'+T.Sales_Stage__c+'","'+T.Description+'","'+T.CreatedDate+'","'+T.CreatedBy.Legacy_Employee_Ref__c+'","'+T.CreatedBy.Last_First_name__c+'","'+T.LastModifiedDate+'","'+T.LastModifiedBy.Legacy_Employee_Ref__c+'","'+T.LastModifiedBy.Last_First_name__c+'","'+T.Completion_Date__c+'" \n';
                        finalstr = finalstr +recordString;                                                                                                                                                                                                                                                                                           
                    }
                    
            String tocustumlabel=Label.GRIP_Extract_To_Mail_Id;
            String ccCustomlabel=Label.GRIP_Extract_CC_Mail_Id;
            List<String> toEmailaddress=new List<String>();
            List<String> ccEmailaddress=new List<String>(); 
               
           if(tocustumlabel!=null&&tocustumlabel!=' '){       
                for(String tomailid: tocustumlabel.split(';')){            
                    toEmailaddress.add(tomailid);
                } 
            }   
           if(ccCustomlabel!=null&&ccCustomlabel!=' '){                                                          
                for(String ccmailid: ccCustomlabel.split(';')){            
                    ccEmailaddress.add(ccmailid);
                }
            }
                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                
                Blob csvBlob = Blob.valueOf(finalstr);
                string csvname= 'OpptyActivities_'+region+'_Region.csv';
                csvAttc.setFileName(csvname);
                csvAttc.setBody(csvBlob);  
              
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                String subject ='Opportunity Activities List For '+region+' Region CSV';
                email.setSubject(subject);
                email.setToAddresses (toEmailaddress);
                email.setCcAddresses (ccEmailaddress);                
                email.setPlainTextBody('Please Find Attached All Opportunities Activities Report as a CSV File');
                email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
            }
               }catch(Exception e){
                            
            }
        
        
    
    } 

}