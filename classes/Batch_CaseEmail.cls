global class Batch_CaseEmail implements Database.Batchable<sObject>,Database.Stateful  
{   
   Set<Id> teammemberId{get;set;} 
     
   global Batch_CaseEmail(Set<Id> userid)  
   {  
       teammemberId = userid;
   }
   string emailType{get;set;}
   string ctmId{get;set;}
   global Batch_CaseEmail(Set<Id> userid ,string memberId,string type)  
   {  
       teammemberId = userid;
       emailType = type;
       ctmId = memberId;
   }  
  
   global Database.QueryLocator start(Database.BatchableContext BC)  
   {          
      //Batch on all system admins (sales rep)
      string idListString = '(' ;
      for(string idtemp : teammemberId ) {       
          idListString = idListString + '\'' + String.valueOf(idtemp) + '\',';
      }
      idListString = idListString.substring(0,idListString.length()-1);
      idListString = idListString  + ')';
      String query = 'select id , name , Email from User where id in ' + idListString ; 
      
      system.debug('//////////////////////////////////////' + query );  
      //String query = 'select id , name , Email from User where Name like \'%Kang%\''; 
      return Database.getQueryLocator(query);  
   }  
   String host = URL.getSalesforceBaseUrl().toExternalForm();
   global void execute(Database.BatchableContext BC, List<sObject> scope)  
   {   
       if(emailType.equals('NewTeammember')){
           Core_Team_Member__c ctmc = [select Release_Role__r.Offering_Release__r.id,Role_Name__c,Release_Name__c,User__r.email, User__c, User__r.Name  from Core_Team_Member__c where id =: ctmId];       
           Offering_Release__c orc = [select OwnerId from Offering_Release__c where id =: ctmc.Release_Role__r.Offering_Release__r.id];
           User tempUser = [select email, Name from User where id =: orc.OwnerId ];   
           for(Sobject s : scope)      
           {    
                User urObj = (User)s; 
              
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {urObj.email }; 
                mail.setToAddresses(toAddresses);
                mail.setSenderDisplayName('Athena ODP'); 
                mail.setSubject('Notification - You are invited as the team member of  '+ ctmc.Role_Name__c +'-' + ctmc.Release_Name__c); 
                mail.setUseSignature(false);
                
                
                string bodyString = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><title></title></head>';
                bodyString = bodyString + '<style>a:link {color:white;}a:visited {color:#D7410B;}a:hover {color:#D7410B;}a:active {color:#D7410B;}.fontclass{font-family: \'HP Simplified\',\'Arial\',\'sans-serif\' !important;}</style><body style="font-family: \'HP Simplified\',\'Arial\',\'sans-serif\' !important;"><p>&nbsp;</p>';
                bodyString = bodyString + '<table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px;">';
                bodyString = bodyString + '<tbody><tr><td><h3><span style="font-size:24px;"><strong><b class="fontclass">Offering Life Cycle Platform<br></b>';
                bodyString = bodyString + '<small>HP Enterprise Services</small></strong></span></h3></td><td>';
                bodyString = bodyString + '<img alt="" src="https://hp--plmesit--c.cs10.content.force.com/servlet/servlet.ImageServer?id=015J0000000HBJY&oid=00DJ00000036uji" style="width: 100px; height: 100px; border-width: 0px; border-style: solid; margin: 0px; float: right;"></td></tr></tbody></table>';
                bodyString = bodyString + '<table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px;">';
                bodyString = bodyString + '<tbody><tr><td><h1><b class="fontclass">For Your Information</b>&nbsp;</h1><p>';
                bodyString = bodyString + '<span style="font-size:16px;"><span class="fontclass">';
                bodyString = bodyString + 'To  '+ urObj.Name +' ,&nbsp;</span></span></p>';
                bodyString = bodyString + '<p><span style="font-size:16px;"><span class="fontclass">You are invited as the team member of '+ ctmc.Role_Name__c + '. Please check the details as below</span></span></p><p>';
                bodyString = bodyString + '<table style="border:1px solid black;width:100%;"><tr>';
                bodyString = bodyString + '<td style="background-color:#D7410B; padding-left:10px;color:white; white-space:nowrap;"><b class="fontclass">Offering Release</b></td>';
                bodyString = bodyString + '<td style="background-color:#0096D6;color:white;">';
                bodyString = bodyString + '<b class="fontclass"><a href="'+host + '/' + ctmc.Release_Role__r.Offering_Release__r.id+'">' + ctmc.Release_Name__c +' </a>' + '</b></td></tr>';
                bodyString = bodyString + '<tr><td style="background-color:#a9a9a9; padding-left:10px;padding-right:30px;color:white; white-space:nowrap;width:230px;"><b class="fontclass">Contacts for questions</b></td>';
                bodyString = bodyString + '<td style="background-color:#0096D6;color:white;">';
                bodyString = bodyString + '<b class="fontclass">Offering Manager : <a href="mailto:' + tempUser.email  + '">  ' + tempUser.Name + ' </a></b></td></tr></table></p>';
                bodyString = bodyString + '<p><span style="font-size:16px;"><span class="fontclass"><br <br="">Regards,&nbsp;</span></span></p>';
                bodyString = bodyString + '<p><span style="font-size:16px;"><span class="fontclass">HP ES Offering Management Lifeycle Team</span></p>';
                bodyString = bodyString + '</td></tr></tbody></table>';
                bodyString = bodyString + '<h3 style="color:blue;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
                bodyString = bodyString + '<hr><p style="text-align: center;">';
                bodyString = bodyString + '<span style="font-size:10px;"><span class="fontclass">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;HP Confidential and Internal use only</span></span></p>';
                bodyString = bodyString + '</body></html>';
                mail.setHtmlBody(bodyString);
    
                // Send the email you have created.
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
            
              /*
              User ur = (User)s ;                        
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[]{ur.Email}; 
                mail.setToAddresses(toAddresses);
                mail.setSenderDisplayName('Athena ODP'); 
                mail.setSubject('Notification for the 10 emails :'+ ur.Name ); 
                mail.setUseSignature(false);
    
                string bodyString = 'test for 10 emails';
                mail.setHtmlBody(bodyString);
    
                // Send the email you have created.
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
               */ 
           }
        }      
   }    
  
   global void finish(Database.BatchableContext BC)  
   {  
   }  
  
}