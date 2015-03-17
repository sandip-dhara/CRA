/****
1. Class Name : OrgFileSpaceLimit

2. Version : 

3. Created Date : 12/05/2014

4. Description : This class is used to find out org file and data storage , send an email to selected user's
 
*****/

public class OrgFileSpaceLimit{

    public static void fileParseMethod(){
        
        Datetime TDate = datetime.now();
       
        Map<String,String> newMap = new Map<String,String>();
        for(Application_Setting__c app : [SELECT Id, Name__c, Value__c FROM Application_Setting__c]){
            newMap.put(app.Name__c,app.Value__c );
        }
        system.debug('newMap ---------'+newMap);
        String [] ema = newMap.get('DataUsageMonitoringMails').split(',');
        
        //------------Http call to fetch the data from org page-----It return html body-----//
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(newMap.get('EndPointUrl')); 
        req.setMethod('GET');
        req.setHeader('Cookie','sid='+UserInfo.getSessionId());   
        HTTPResponse res = http.send(req);     
        String pageData = res.getBody();
        
        //------Parsing the html body to fetch file and data usage and storing in a string-------------//  
        String fileSize = pageData.substringAfter(newMap.get('FileStorage')).left(5).remove('&n')+' MB ' + ' and percent used ' + pageData.substringAfter(newMap.get('FileStorage')).substringBetween('(',')');
        String DataSize = pageData.substringAfter(newMap.get('DataStorage')).left(5).remove('&n')+ ' MB ' + ' and percent used ' + pageData.substringAfter(newMap.get('DataStorage')).substringBetween('(',')');
        
        //-----Daily To send email with out any condition-------------//
        if(newMap.get('DataUsageMonitoring') == 'Daily'){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();            
                mail.setToAddresses(ema);
                //mail.setCcAddresses(new string[] {Label.athena_KomalaEmail,Label.athena_veersh});              
                mail.setSubject('Organization File and Data Storage Usage Space');
                mail.setPlainTextBody('Total Used File Space by  '+ TDate +' is  '+ fileSize + '\n \n' + 'Total Used Data Space by ' + TDate + ' is  ' + DataSize);
                mail.setReplyTo(Label.athena_imranEmail);
                mail.setSenderDisplayName(UserInfo.getUserEmail());
                Messaging.SendEmailResult[] resp = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        else if(newMap.get('DataUsageMonitoring') == 'Threshold'){   
            //-----IF org File size is going to exceed based on condition it will send an email------//
            if(pageData.substringAfter(newMap.get('FileStorage')).left(5) > newMap.get('FileStorageSize')){
                Messaging.SingleEmailMessage fileMail = new Messaging.SingleEmailMessage();
                fileMail.setToAddresses(ema);
                //fileMail.setCcAddresses(new string[] {Label.athena_KomalaEmail,Label.athena_veersh});
                fileMail.setSubject('Organization File Storage Usage Space is Exceding');
                fileMail.setPlainTextBody('Total Used File Space by  '+ TDate +' is  '+ fileSize);
                fileMail.setReplyTo(Label.athena_imranEmail);
                fileMail.setSenderDisplayName(UserInfo.getUserEmail());
                Messaging.SendEmailResult[] fileResp = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { fileMail });
            }
            //-----IF org Data size is going to exceed based on condition it will send an email------//
            if(pageData.substringAfter(newMap.get('DataStorage')).left(5) > newMap.get('DataStorageSize')){
                Messaging.SingleEmailMessage dataMail = new Messaging.SingleEmailMessage();
                dataMail.setToAddresses(ema);
                //dataMail.setCcAddresses(new string[] {Label.athena_KomalaEmail,Label.athena_veersh});
                dataMail.setSubject('Organization Data Storage Usage Space is Exceding');
                dataMail.setPlainTextBody('Total Used Data Space by ' + TDate + ' is  ' + DataSize);
                dataMail.setReplyTo(Label.athena_imranEmail);
                dataMail.setSenderDisplayName(UserInfo.getUserEmail());
                Messaging.SendEmailResult[] dataResp = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { dataMail });
            }
        }
    }
}