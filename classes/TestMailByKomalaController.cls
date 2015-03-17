public class TestMailByKomalaController {

Public String getSfInstance
       {
            get
            {
                return ApexPages.currentPage().getHeaders().get('Host');
            }
       }
       
public void TestSendMail()
{
integer i=5;
Messaging.SingleEmailMessage[] mails=new Messaging.SingleEmailMessage[i];
for(integer index=0;index<i;index++)
{

mails[index]=SendMail();

}
Messaging.sendEmail(mails); 
}       

public Messaging.SingleEmailMessage SendMail()
{
//Send Mail to Owner and CC requestor
                    string instance = 'https://hp--esit--c.cs11.visual.force.com';
                    Messaging.SingleEmailMessage mail;  
                    string bodyString = '';
                    string[] toAddresses;
                    mail = new Messaging.SingleEmailMessage();
                    mail.setSaveAsActivity(false);
                    
                    mail.setTargetObjectId('005Z00000025ZU5'); 
                   
                    //toAddresses = new String[] { 'jinumoni.dihingia@hp.com' };
                    //mail.setToAddresses(toAddresses); 
                    //mail.setCCAddresses( new String[]{ 'jinumoni.dihingia@hp.com' });    
                   // mail.setUseSignature(false);      
                  
                    mail.setSubject('G Komala' + ' requesting to add as member to the board '+ 'HP Quality Center (SALENA)' ); 
                                                                                                                                                                                                                                                                                                
                                                                                                
                    string stringURL1 = 'https://{0}/apex/AthenaLearningBoardDtls?id={1}';
                    string[] subjectArguments1 = new String[] {instance, 'a6tZ00000008TJUIA2'};
                    string formatURL1 = String.format(stringURL1, subjectArguments1);
                                                                                                
                    bodyString += '<html><head><title></title></head><body style="font-family: HP Simplified !important;"><p>&nbsp;</p><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; ">';
                    bodyString += '<tbody><tr><td><h3><span style="font-size:24px;"><span style="font-family:Trebuchet MS; font-weight:normal;"><strong>Social Learning Platform<br /><small>HP Enterprise Services</small></strong></span></span></h3>';
                    bodyString += '</td></tr></tbody></table><table align="center" border="0" cellpadding="1" cellspacing="1" style="width: 800px; height: 300px; font-family:Trebuchet MS; font-weight:normal;"><tbody style= "border:1px solid black;><tr><td><p><span style="font-size:16px;"><span>Hi '+'G Komala'+',&nbsp;</span></span></p>';
                    bodyString += '<p> <p><span style="font-size:16px;">Please add me as a member to the below Board.</span></p><table style="border:1px solid black;"><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;';
                    bodyString += 'color:white; white-space:nowrap; font-family:Trebuchet MS; font-weight:normal;">Board Name</td><td style="border:1px solid black;color:black; font-family:Trebuchet MS; font-weight:normal;">'+ 'HP Quality Center (SALENA)' +' </td></tr><tr><td style=" border:1px solid black; background-color:#a9a9a9; padding-left:10px;color:white; white-space:nowrap;">Board Description</td><td style="';
                    bodyString += 'color:black; border:1px solid black; font-family:Trebuchet MS; font-weight:normal;">'+ 'HP Quality Center is quality management software offered from the HP Software Division of Hewlett-Packard with many capabilities acquired from Mercury Interactive Corporation.[1] HP Quality Center offers software quality assurance, including requirements management, test management and business process testing for IT and application environments.[2] HP Quality Center is a component of the HP Application Lifecycle Management software solution set.[3]' +'</td>';
                    bodyString +=  '</tr><tr><td style="border:1px solid black; background-color:#a9a9a9; padding-left:10px;padding-right:30px;padding-top:15px;padding-bottom:15px;color:white; white-space:nowrap;">Requestor</td><td style="border:1px solid black; padding-top:15px;padding-bottom:15px;';
                    bodyString += 'color:black; font-family:Trebuchet MS; font-weight:normal;">'+ 'komala.g@hp.com' +'</td></tr></table></p><p><span>If you are new to the Social Learning Platform, please click <a href="http://15.185.165.210:8080/SLPApp/">here</a> to Register.<br />If you are already a registered user click <a href='+ formatURL1 +'>here</a> to view the Board. </span></p>';
                    bodyString += '<p><span style="font-size:16px;"><span><br /<br />Regards,<br/>'+'Komala'+'</span></span></p><p><span style="font-size:16px;"><span></span></p></td></tr></tbody>';
                    bodyString += '</table><h3 style="color:#0096D6;">&nbsp;</h3><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>';
                    bodyString += '</body></html>';

                    mail.setHtmlBody(bodyString);
                    return mail;
                    //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
}
}