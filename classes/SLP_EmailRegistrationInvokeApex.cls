global class SLP_EmailRegistrationInvokeApex implements Messaging.InboundEmailHandler {
  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope) {
     
     Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
     try{
            String Environment = AthenaUtility.ApplicationSettingValue(AthenaUtility.Environment);
            Profile profileObject = new Profile ();
            Profile profileObjectAdmin = new Profile ();
            List<User> ExistingUser = new List<User>();
            List<User> isSLPUser = new List <User>();
            
      //Commented welcome message.      
  /*          String emailbody1 = 'Hi User, <br>We have received your request to access HP Insight and are currently processing your registration. You will receive a confirmation email granting you access shortly. If you do not receive an email within 24 hours, please contact XXXYYY@hp.com for support.<br><br> Thank You,<br>The HP Insight team';
            Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
            List<Messaging.SingleEmailMessage> mails1 = new List<Messaging.SingleEmailMessage>();
            mail1.setToAddresses(new String[] {'sreelakshmi.annasamudram@hp.com','veeresh.alur@hp.com'});
            mail1.setSubject('HP Insight – Your request for access has been submitted');
            mail1.sethtmlBody(emailbody1);
            mails1.add(mail1);
            Messaging.sendEmail(mails1);
    */                 
//Check SLP User.                
            profileObject = [SELECT Id, Name FROM Profile where name='ES Base Profile' Limit 1];
            profileObjectAdmin = [SELECT Id, Name FROM Profile where name='IT Administrator' Limit 1];
            ExistingUser = [Select id, Name, Profileid , email From User where email = :email.subject and IsActive=true and (Profileid = :profileObject.id or Profileid = :profileObjectAdmin.id)];
            System.debug('Existing user :'+ExistingUser );            
            if(ExistingUser.size() > 0)
                {
                 for(User userObj : ExistingUser)
                   {
                     String emailbody = 'Hello '+userObj.Name+',<br><br>Thank you for submitting a request to access HP Insight. Our records show that you have previously registered and currently have access. Please visit http://eskm.hp.com and click “HP Employee Login” to sign in.  You can use a Digital Badge, or your HP email address and NT password, as you would with other HP sites.  If you are unable to login, please email esinsight@hp.com for support.<br><br>Thank You,<br>The HP Insight team';
                     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                     List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                     mail.setToAddresses(new String[] {'komala.g@hp.com','veeresh.alur@hp.com'});
                     mail.setSubject('HP Insight – Your request for access has been processed.');
                     mail.sethtmlBody(emailbody);
                     mail.setTargetObjectId(userObj.id); 
                     mail.setSaveAsActivity(false);
                     mails.add(mail);
                     Messaging.sendEmail(mails);
                     SetUserPermission(userObj);
                   //  updateSelfRegistrationLog(email.subject,'Success','Already existing SLP User');
                   } 
                }
              
//Check if the user is inactive, and make active and give permission.               
              else
                  {
                      String envEmailId = email.subject + Environment;
                      isSLPUser = [Select id, Name, email, FirstName, LastName, Alias, Legacy_Employee_Ref__c, profileid From User where email = :email.subject or email = :envEmailId    or 
                                     email_address__c = :email.subject or email_address__c = :envEmailId limit 1 ];
                                    
                      if(isSLPUser.size() > 0)
                        {
                        User userObject = new User();
                        for(User userDetail : isSLPUser )
                            {
                            
            
                            userObject.Id = userDetail.Id;
                            userObject.email = email.subject;
                            userObject.Isactive = true;
                            userObject.email_address__c = email.subject ;
                            userObject.username = email.subject  + Environment;
                            userObject.federationidentifier = email.subject ;
                            userObject.digestfrequency = 'N';
                            userObject.userpreferencesdisableallfeedsemail = true;
                            userObject.UserPermissionsMarketingUser=false;  
                            userObject.FirstName = userDetail.FirstName;
                            userObject.LastName = userDetail.LastName;
                           // userObject.Alias = userDetail.FirstName.Substring(0, 1) +' '+ userDetail.LastName.Substring(1, 4); 
                            userObject.legacy_employee_ref__c = userDetail.Legacy_Employee_Ref__c;
                            userObject.ProfileId = profileObject.id; //userDetail.ProfileId; 
                            userObject.UserPreferencesDisableAllFeedsEmail  = true;
                            userObject.Adoption_Role_Type__c = 'IT';
                            userObject.TimeZoneSidKey =  'America/Los_Angeles';
                            userObject.LocaleSidKey = 'en_US';
                            userObject.EmailEncodingKey = 'UTF-8';
                            userObject.LanguageLocaleKey = 'en_US';
                            
                            update userObject;
                            
                            String emailbody = 'Hello '+userObject.FirstName+' '+userObject.LastName+',<br><br>Welcome to HP Insight! Your registration was successful, and you are now ready to sign in. To start using HP Insight, visit http://eskm.hp.com from your computer or mobile device, and click “HP Employee Login.” You can sign in using a Digital Badge or your HP email address and NT password. <br>Once you have signed in, we’ll help you get set up. If you run into any issues, please email esinsight@hp.com for support.<br><br> Thank You,<br>The HP Insight team.';
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                            mail.setToAddresses(new String[] {'komala.g@hp.com','veeresh.alur@hp.com'});
                            mail.setSubject('HP Insight – Your registration confirmation');
                            mail.sethtmlBody(emailbody);
                            mail.setTargetObjectId(userObject.id);
                            mail.setSaveAsActivity(false);
                            mails.add(mail);
                          Messaging.sendEmail(mails);
                            SetUserPermission(userObject);
                           // updateSelfRegistrationLog(email.subject,'Success','Existing SLP User. Made active.');
                          }
                            
                         }
 //Check if the user is existing in HrDD
                         else
                          {
                              List<SLP_ES_Emp_HRDD_Feed__c> lstEmpHrddFeedObject = [SELECT Id, First_Name__c, Last_Name__c, Emp_Name__c, Email__c, Emp_Number__c, Region__c, Business_Group__c,
                                                  Region_ID__c, Business_Group_Id__c, User_Id__c FROM SLP_ES_Emp_HRDD_Feed__c where Email__C = :email.subject];
                              System.debug('asdfsdf'+lstEmpHrddFeedObject.size() );                    
                              if(lstEmpHrddFeedObject.size() > 0)
                              {
                                    SLP_ES_Emp_HRDD_Feed__c    hrddfeedobj=lstEmpHrddFeedObject[0];
                                    
                                        
                                        User userObject = new User();
                                        
                                        userObject.email = email.subject;
                                        userObject.Isactive = true;
                                        userObject.email_address__c = email.subject;
                                        userObject.username = email.subject + Environment;
                                        userObject.federationidentifier = email.subject;
                                        
                                        userObject.digestfrequency = 'N';
                                        userObject.userpreferencesdisableallfeedsemail = true;
                                        userObject.FirstName = hrddfeedobj.First_Name__c;
                                        userObject.LastName = hrddfeedobj.Last_Name__c;
                                        string lastName4Alias='';
                                        if(hrddfeedobj.Last_Name__c.length()>=4)
                                        {
                                            lastName4Alias=hrddfeedobj.Last_Name__c.Substring(1, 4);
                                        }
                                        else
                                        {
                                            lastName4Alias=hrddfeedobj.Last_Name__c;
                                        }
                                        userObject.Alias = hrddfeedobj.First_Name__c.Substring(0, 1) +''+lastName4Alias ;                
                                        userObject.legacy_employee_ref__c = String.ValueOf(hrddfeedobj.Emp_Number__c);
                                        
                                        userObject.ProfileId = profileObject.Id;
                                        userObject.Adoption_Role_Type__c = 'IT';
                                        userObject.TimeZoneSidKey =  'America/Los_Angeles';
                                        userObject.LocaleSidKey = 'en_US';
                                        userObject.EmailEncodingKey = 'UTF-8';
                                        userObject.LanguageLocaleKey = 'en_US';

//                                        insert userObject;
                                        Database.SaveResult lstUpdateList = Database.insert(UserObject, false);
                                        if (lstUpdateList.isSuccess()) 
                                            {
                                                SetUserPermission(userObject);
                                                String emailbody = 'Hello '+userObject.FirstName+' '+userObject.LastName+',<br><br>Welcome to HP Insight! Your registration was successful, and you are now ready to sign in. To start using HP Insight, visit http://eskm.hp.com from your computer or mobile device, and click “HP Employee Login.” You can sign in using a Digital Badge or your HP email address and NT password. <br>Once you have signed in, we’ll help you get set up. If you run into any issues, please email esinsight@hp.com for support.<br><br> Thank You,<br>The HP Insight team.';
                                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                                                mail.setToAddresses(new String[] {'komala.g@hp.com','veeresh.alur@hp.com'});
                                                mail.setSubject('HP Insight – Your registration confirmation');
                                                mail.sethtmlBody(emailbody);
                                                mail.setTargetObjectId(userObject.id);
                                                mail.setSaveAsActivity(false);
                                                mails.add(mail);
                                               Messaging.sendEmail(mails);
                                                
                                                //updateSelfRegistrationLog(email.subject,'Success','Found in HRDD. Created account successfully.');
                                            }
                                        else 
                                            {
                                                lstUpdateList.getErrors()[0].getMessage();  
                                                String emailbody = 'Hello '+userObject.FirstName+' '+userObject.LastName+',<br><br> We have received your request to access HP Insight and are currently processing your registration. You will receive a confirmation email granting you access shortly. If you do not receive an email within 24 hours, please contact esinsight@hp.com for support. <br><br> Thank You,<br>The HP Insight team.';
                                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                                                mail.setToAddresses(new String[] {'komala.g@hp.com','veeresh.alur@hp.com',email.subject});
                                                mail.setCcAddresses(new String[] {'esinsight@hp.com'});
                                                mail.setSubject('HP Insight – Your request for access has been submitted');
                                                mail.sethtmlBody(emailbody);
                                                mail.setTargetObjectId(userObject.id);
                                                mail.setSaveAsActivity(false);
                                                mails.add(mail);
                                              Messaging.sendEmail(mails);
                                              //  SetUserPermission(userObject);
                                                updateSelfRegistrationLog(email.subject,'Failure','Found in HRDD. Issues during user creation. Sent email to Admin .'+lstUpdateList.getErrors()[0].getMessage());                                  
                                            }
                                 }       
                              
//As record not found in HrDD, not eligible.                              
                              else
                              {
                                    String emailbody = 'Hello,<br><br> Thank you for submitting a request to access HP Insight. We have opened our platform to a limited number of organizations, and currently cannot confirm your registration. If you are interested in bringing HP Insight to your team, please email esinsight@hp.com, and we will contact you for further information.<br><br> Thank You,<br>The HP Insight team.';
                                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                                    //mail.setToAddresses(new String[] {email.subject});
                                    mail.setToAddresses(new String[] {'komala.g@hp.com','veeresh.alur@hp.com',email.subject});
                                    mail.setSubject('HP Insight – Your request for access has been processed');
                                    mail.sethtmlBody(emailbody);
                                    mails.add(mail);
                                    Messaging.sendEmail(mails);
                                    
                                    updateSelfRegistrationLog(email.subject,'Failure','Not Found in HRDD. Hence not eligible.');
                              }
                          }
                  }
                  
            //Code added to update the user object.
  /*          User userObject = new User ();
            String fname;
            String lname;    
                    userObject.email = email.subject;
                    userObject.Isactive = true;
                    userObject.email_address__c = email.subject;
                    userObject.username = email.subject + '.esit';
                    userObject.federationidentifier = email.subject;
                    userObject.digestfrequency = 'N';
                    userObject.userpreferencesdisableallfeedsemail = true;
                    userObject.Adoption_Role_Type__c = 'IT';
                    userObject.TimeZoneSidKey =  'America/Los_Angeles';
                    userObject.LocaleSidKey = 'en_US';
                    userObject.EmailEncodingKey = 'UTF-8';
                    userObject.LanguageLocaleKey = 'en_US';

//                    userObject.FirstName = empFeedItemObject.First_Name__c;
//                    userObject.LastName = empFeedItemObject.Last_Name__c;
                    
                    userObject.FirstName = 'test_Email';
                    userObject.LastName = 'Test_Email';
                    
                    string strf='';
                    string strl='';
                    String empno='20389681';
                    if(userObject.LastName.length()>4)
                    {
                        strl=userObject.LastName.Substring(1, 4);
                    }
                    else
                    {
                        strl=userObject.LastName;
                    }
                    
                    userObject.Alias = userObject.FirstName.Substring(0, 1) +' '+ strl;                  
                    userObject.legacy_employee_ref__c = String.ValueOf(empno);
                    userObject.ProfileId = '00eZ0000000HssD';//ES Base profile
                    userObject.UserPreferencesDisableAllFeedsEmail  = true;
                    insert userObject;
    */
/*         To send email to the registered user

           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
           mail.setToAddresses(new String[] {email.subject});
           mail.setSubject('Test from Apex');
           mail.setHtmlBody('This email is sent from Apex code');

           mails.add(mail);
           Messaging.sendEmail(mails); */
                      
           result.success = true;
     } catch (Exception e) {
           result.success = false;
           result.message = 'Oops .... In Exception'+e;
           System.debug('Sree---Fail------------ in handleInboundEmail'+e);
    }

    return result;
     }
     
     public void updateSelfRegistrationLog(String emailid,String status, String comment)
    {
        SLP_SelfRegistrationLog__c selfRegistrationLog = new SLP_SelfRegistrationLog__c();
        selfRegistrationLog.EmailId__c = emailid;
        selfRegistrationLog.Status__c = status;
        selfRegistrationLog.Comment__c = comment;
        insert selfRegistrationLog;
    }
     public void SetUserPermission(User user)
    {
        PermissionSet producerSetID = [SELECT Id, Name FROM PermissionSet where name='ES_Social_Learning_Producer'];
        PermissionSet moderatorSetID = [SELECT Id, Name FROM PermissionSet where name='ES_Social_Learning_Moderator'];
        integer flag = 0;
        
        List<string> lstPermIds=new List<string>();
        lstPermIds.add(producerSetID.id);
        lstPermIds.add(moderatorSetID.id);

        List<PermissionSetAssignment> lstPermissionSet = [SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment where AssigneeId = :user.Id and PermissionSetId in :lstPermIds]; 
        System.debug('Number of permissions'+lstPermissionSet.size() );
        if(lstPermissionSet.size()==0)
        {
                    PermissionSetAssignment permissionAssignment = new PermissionSetAssignment ();
                    permissionAssignment.AssigneeId = user.Id;
                    permissionAssignment.PermissionSetId = producerSetID.Id;
                    Database.SaveResult lstEsBaseUser = Database.insert(permissionAssignment, false);
        }       
        User userObj = [select id, email,name,title,aboutme,Department,SmallPhotoUrl,fullphotourl,city,state,country from user where email=:user.email Limit 1];
        if(userObj.fullphotourl == 'https://hp--ESIT--c.cs11.content.force.com/profilephoto/005/F'){
            UpadteLdapImage(userObj.email,userObj.id);
        }
    }
    @Future(callout=true)
    public static void UpadteLdapImage(String emailId,String userId){
        System.debug('emailId----------'+emailId);
        CertificateLdapApex.LdapSoap ldap = new CertificateLdapApex.LdapSoap();
        ldap.clientCertName_x = 'SFDC_Certificate';
        ldap.timeout_x = 120000;
        String before = ldap.GetLDAPPtofilePictureUrl(emailId);
        system.debug('before--------'+before);
        if(before !=null){
            Blob beforeblob = EncodingUtil.base64Decode(before);
            system.debug('beforeblob-----------'+beforeblob);
            Boolean isPublicalyVisible = true;
            String communityId = null;  
            //String userId= UserInfo.getUserId();   
            ConnectApi.Photo photo = ConnectApi.ChatterUsers.setPhoto(communityId, userId,  new ConnectApi.BinaryInput(beforeblob,'image/jpg','userImage.jpg'));
            User currentUser = [SELECT Id, UserPreferencesShowProfilePicToGuestUsers FROM User WHERE Id =:userId];
            currentUser.UserPreferencesShowProfilePicToGuestUsers = isPublicalyVisible;
            system.debug('currentUser-----------'+currentUser);
            update currentUser;
        }
    }
}