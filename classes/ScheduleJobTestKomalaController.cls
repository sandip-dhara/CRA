global class ScheduleJobTestKomalaController implements Schedulable{

public ScheduleJobTestKomalaController  ()
{
SendMail();
}

global void execute(SchedulableContext SC) {
ScheduleJobTestKomalaController  m=new ScheduleJobTestKomalaController ();
String sch = '0 * * * * ?'; // 
String jobID = system.schedule('Mail Job', sch, m);
}

global void SendMail()
{
//Send Mail to Owner and CC requestor
                    Messaging.SingleEmailMessage mail;  
                    string bodyString = '';
                    string[] toAddresses;
                    mail = new Messaging.SingleEmailMessage();  
                    //mail.setSaveAsActivity(false);
                    
                    //mail.setTargetObjectId('005Z00000025ZU5'); 
                   
                    toAddresses = new String[] { 'komala.g@hp.com' };
                    mail.setToAddresses(toAddresses); 
                    //mail.setCCAddresses( new String[]{ 'jinumoni.dihingia@hp.com' });    
                   // mail.setUseSignature(false);      
                  
                    mail.setSubject('Test Mail By Komala' );                                                                                                                                                                                                                                                                                                 
                                                                                               
                    bodyString += '<html><head><title></title></head><body style="font-family: HP Simplified !important;"><p>&nbsp;</p><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; ">';
                    bodyString +='Mail to test Scheduler';
                    bodyString += '</body></html>';

                    mail.setHtmlBody(bodyString);
                    //return mail;
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
}
}