public class ODP_Class_BatchMail{
    public List<Messaging.SingleEmailMessage> LstMail{get;set;}
    String baseUrl;
    public ODP_Class_BatchMail(){
        LstMail = new List<Messaging.SingleEmailMessage>();
        baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
    }
    
    public void AddMail(User tempUser,string subject, string title,
                                    string offeringRelease, string releaseStage, string releaseDeliverable, string stageWorkElement, 
                        string contactor){
        //User tempUser = [select email, Name from User where id =:userId ];
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
        if(!String.isEmpty(releaseStage))
        {
            bodyString = bodyString + '<tr><td style="background-color:#D7410B; padding-left:10px;color:white; white-space:nowrap;"><b style="font-family:HP Simplified,Arial,sans-serif;">Stage</b></td>';
            bodyString = bodyString + '<td style="background-color:#0096D6;color:white;"><b style="font-family:HP Simplified,Arial,sans-serif;">';
            bodyString = bodyString + releaseStage.replace('{base}', baseUrl) + '</b></td></tr>';
        }
        if(!String.isEmpty(releaseDeliverable))
        {
            bodyString = bodyString + '<tr><td style="background-color:#D7410B; padding-left:10px;color:white; white-space:nowrap;">Release Deliverable</td>';
            bodyString = bodyString + '<td style="background-color:#0096D6;color:black;">';
            bodyString = bodyString + releaseDeliverable.replace('{base}', baseUrl) + '</td></tr>';
        }
        if(!String.isEmpty(stageWorkElement))
        {
            bodyString = bodyString + '<tr><td style="background-color:#D7410B; padding-left:10px;color:white; white-space:nowrap;"><b style="font-family:HP Simplified,Arial,sans-serif;">Work Element</b></td>';
            bodyString = bodyString + '<td style="background-color:#0096D6;color:white;"><b style="font-family:HP Simplified,Arial,sans-serif;">';
            bodyString = bodyString + stageWorkElement.replace('{base}', baseUrl) + '</b></td></tr>';
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
        LstMail.Add(mail);
    }
    public void AddMailForRisk(User tempUser,string subject, string title,
                                    string offeringRelease,string releaseStage, string risk,string contactor){
        //User tempUser = [select email, Name from User where id =:userId ];
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
        if(!String.isEmpty(releaseStage))
        {
            bodyString = bodyString + '<tr><td style="background-color:#D7410B; padding-left:10px;color:white; white-space:nowrap;"><b style="font-family:HP Simplified,Arial,sans-serif;">Stage</b></td>';
            bodyString = bodyString + '<td style="background-color:#0096D6;color:white;"><b style="font-family:HP Simplified,Arial,sans-serif;">';
            bodyString = bodyString + releaseStage.replace('{base}', baseUrl) + '</b></td></tr>';
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
        LstMail.Add(mail);
    }
}