trigger ODP_Trigger_TeamMemberCreated on Core_Team_Member__c (after insert) {
    /*
    List <FeedItem> FIPosts = new List <FeedItem>();
    for(Core_Team_Member__c ctmc : Trigger.new){
        if(Trigger.isInsert){
            FeedItem post = new FeedItem();
            post.parentId =  ctmc.User__c;
            //post.parentId =  UserInfo.getUserId();            
            post.Body='You are invited as the Core Team Member of '+ ctmc.Release_Role__r.Role_Name__c ;               
            FIPosts.add(post);
        }    
    }
    database.insert(FIPosts);
    */
    String host = URL.getSalesforceBaseUrl().toExternalForm();
    User tempUser = new User();    
    if(Trigger.isInsert )    {
        for(Core_Team_Member__c ctmcTemp : Trigger.new){
            
            Core_Team_Member__c ctmc = [select Release_Role__r.Offering_Release__r.id,Role_Name__c,Release_Name__c,User__r.email, User__c, User__r.Name  from Core_Team_Member__c where id =: ctmcTemp.id];       
            
            Offering_Release__c orc = [select OwnerId,Facilitator__c from Offering_Release__c where id =: ctmc.Release_Role__r.Offering_Release__r.id];
            tempUser = [select email, Name from User where id =: orc.Facilitator__c ]; 
            
            /*
            Set<Id> useridSet = new Set<Id>();
            useridSet.add(ctmc.User__r.Id); 
            Batch_CaseEmail controller = new Batch_CaseEmail(useridSet,ctmcTemp.id,'NewTeammember') ;  
            Integer batchSize = 1;  
            database.executebatch(controller , batchSize); 
            */
             
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {ctmc.User__r.email }; 
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('Athena ODP'); 
            mail.setSubject('Notification - You have been selected to work on the following new ESIT opportunity as of  '+ ctmc.Role_Name__c +'-' + ctmc.Release_Name__c); 
            mail.setUseSignature(false);
            
            
            string bodyString = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><title></title></head>';
            bodyString = bodyString + '<style>a:link {color:white;}a:visited {color:#D7410B;}a:hover {color:#D7410B;}a:active {color:#D7410B;}.fontclass{font-family: \'HP Simplified\',\'Arial\',\'sans-serif\' !important;}</style><body style="font-family: \'HP Simplified\',\'Arial\',\'sans-serif\' !important;"><p>&nbsp;</p>';
            bodyString = bodyString + '<table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px;">';
            bodyString = bodyString + '<tbody><tr><td><h3><span style="font-size:24px;"><strong><b class="fontclass">Opportunity Development<br></b>';
            bodyString = bodyString + '<small>HP Enterprise Services IT</small></strong></span></h3></td><td>';
            bodyString = bodyString + '<img alt="" src="https://hp--plmesit--c.cs10.content.force.com/servlet/servlet.ImageServer?id=015J0000000HBJY&oid=00DJ00000036uji" style="width: 100px; height: 100px; border-width: 0px; border-style: solid; margin: 0px; float: right;"></td></tr></tbody></table>';
            bodyString = bodyString + '<table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px;">';
            bodyString = bodyString + '<tbody><tr><td><h1><b class="fontclass">For Your Information</b>&nbsp;</h1><p>';
            bodyString = bodyString + '<span style="font-size:16px;"><span class="fontclass">';
            bodyString = bodyString + 'To  '+ ctmc.User__r.Name +' ,&nbsp;</span></span></p>';
            bodyString = bodyString + '<p><span style="font-size:16px;"><span class="fontclass">You have been selected to work on the following new ESIT opportunity as of '+ ctmc.Role_Name__c + '. Please check the details as below</span></span></p><p>';
            bodyString = bodyString + '<table style="border:1px solid black;width:100%;"><tr>';
            bodyString = bodyString + '<td style="background-color:#D7410B; padding-left:10px;color:white; white-space:nowrap;"><b class="fontclass">Opportunity</b></td>';
            bodyString = bodyString + '<td style="background-color:#0096D6;color:white;">';
            bodyString = bodyString + '<b class="fontclass"><a href="'+host + '/' + ctmc.Release_Role__r.Offering_Release__r.id+'">' + ctmc.Release_Name__c +' </a>' + '</b></td></tr>';
            bodyString = bodyString + '<tr><td style="background-color:#a9a9a9; padding-left:10px;padding-right:30px;color:white; white-space:nowrap;width:230px;"><b class="fontclass">Contacts for questions</b></td>';
            bodyString = bodyString + '<td style="background-color:#0096D6;color:white;">';
            bodyString = bodyString + '<b class="fontclass">Business Engagement Partner : <a href="mailto:' + tempUser.email  + '">  ' + tempUser.Name + ' </a></b></td></tr></table></p>';
            bodyString = bodyString + '<p><span style="font-size:16px;"><span class="fontclass"><br <br="">Regards,&nbsp;</span></span></p>';
            bodyString = bodyString + '<p><span style="font-size:16px;"><span class="fontclass">HP ESIT Engagement Team</span></p>';
            bodyString = bodyString + '</td></tr></tbody></table>';
            bodyString = bodyString + '<h3 style="color:blue;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
            bodyString = bodyString + '<hr><p style="text-align: center;">';
            bodyString = bodyString + '<span style="font-size:10px;"><span class="fontclass">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;HP Confidential and Internal use only</span></span></p>';
            bodyString = bodyString + '</body></html>';
            mail.setHtmlBody(bodyString);

            // Send the email you have created.
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
            
                   
        }
    }   
}