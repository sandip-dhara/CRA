/**********************************************************
* Class Name: ChangeEloquaEmailAddressCls
* Author: Accenture
* Date: 26-JULY-2012
* Requirement # Request Id:  
* Description: Eloqua
***********************************************************
* Author: HP
* Date: 22-AUG-2012
* Requirement # CR Id:2643 
* Description:This class Sends New and Old set of Email to Eloqua  and makes Eloqua Email Null.
***********************************************************/

public class ChangeEloquaEmailAddressCls {
    @future (callout=true)
    public static void ChangeEloquaEmailAddress(map<string,string> emails) {
    HttpRequest req = new HttpRequest();
    HttpResponse response = null;
    Http http = new Http();
    try
    {
        for (string key : emails.keySet() ) {
            req.setEndpoint('https://secure.eloqua.com/e/f2?elqSiteID=2129&elqFormName=SFDCEmailAddressChange&NewEmailAddress=' + emails.get(key) + '&OldEmailAddress=' + key);
            req.setMethod('GET');
            response = http.send(req);
            System.debug('***************response'+response);
        }
    } 
    catch(Exception ex)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{'eloqua.support@hp.com'};
        mail.setToAddresses( toAddresses );
        mail.setReplyTo('eloqua.support@hp.com');
        mail.setSenderDisplayName('Salesforce - ChangeEloquaEmailAddress - EXCEPTION ');
        mail.setSubject('ChangeEloquaEmailAddress sent with '+emails.size() + ' emails - EXCEPTION.' );
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody('ChangeEloquaEmailAddress sent with '+emails.size() + ' emails.' + ex );
        mail.setHtmlBody('ChangeEloquaEmailAddress sent with '+emails.size() + ' emails.' + ex );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    }
    
    public static void NullEloquaEmailAddress(Set<Id> newLead) {
        List<Lead> lupd = new List<Lead>();
        List<Lead> leadList = [Select id, email,Eloqua_Email__c from Lead where Id IN:newLead ];
        try
        {
            for(Lead led:leadList) 
            {
                if(led!=null && !led.email.contains('.elq') 
                &&led.Eloqua_Email__c !=null )
                {
                    led.Eloqua_Email__c = null;
                    lupd.add(led);
                }
            }
            update lupd;
        }
        catch(Exception e)        
        {
            e.getMessage();
        }
    }
    
    public static void NullEloquaEmailAddressContact(Set<Id> newContact) 
    {
        List<Contact> contupd = new List<Contact>();
        List<Contact> contList = [Select id, email,Eloqua_Email__c from Contact where Id IN:newContact];
        try
        {
            for(Contact con: contList ) 
            {
            if(con!=null && !con.email.contains('.elq')&& con.Eloqua_Email__c !=null )
            {
                con.Eloqua_Email__c = null;
                contupd.add(con);
            }
            }
            update contupd;
        }
        catch(Exception e)        
        {
        e.getMessage();
        }
    }
}