/**********************************************************
* Class Name: LeadManualAssignmentController
* Author: Accenture
* Date: 19-JUL-2012 
* Requirement # Request Id: 1184
* Description: Controller to assign the lead manually
***********************************************************/

public class LeadManualAssignmentController {

    public String leadId, qualifiedRT;
    public Lead lead {get; set;}
    public Set<ID> prdSet;
    private boolean errorFlag; 
    public String errorMessage {get;set;} 
    public String getURL1{get; set;}
    public String errorMessage1 {get;set;}
    public String errorMessage2 {get;set;}
    public Boolean isOwnerChanged{get;set;}
    public Boolean isSave{get;set;}
    public GroupMember GroupMember1 {get; set;}
    Public integer grpcount;
    public Boolean sendEmailNotificationFlag{set;get;}
    List<Product_Interest__c> productInterests = new List<Product_Interest__c>(); 
        public List<Id> QueueOwnId= new List<Id>();     
    public LeadManualAssignmentController(ApexPages.StandardController controller) {
    
    getURL1 = URL.getSalesforceBaseUrl().toExternalForm(); 
        /* Initializing properties*/
        errorMessage  = '';
        errorFlag = false;
        prdSet = new Set<Id>();
        lead = new Lead();
        isOwnerChanged = False;
        isSave = True;
        sendEmailNotificationFlag=false;
        GroupMember1 = new GroupMember();
        
        grpcount=0;
        leadId = ApexPages.currentPage().getParameters().get('leadId');
        
        lead = [SELECT Id, Name, FirstName, OwnerId, Salutation, Company, Lead_State__c, First_Assignment_Date__c FROM Lead WHERE Id =: leadId limit 1];
        /* Author: HP
        * Date:6-AUG-2012  
        * Requirement # Defect Id-1454(R2.0)
        * @description -  It checks Lead State and Product Interest Validation. 
        */                   
        productInterests = [Select Id, Lead__c From Product_Interest__c Where Lead__c =: leadId ];
        if (productInterests.size()== 0 || productInterests == null) {
            errorMessage  = Label.No_Product_Interest;                                                                
            errorFlag = true;
        }  
        if (errorFlag) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage));                                                                   
        }
        
        Schema.DescribeSObjectResult describeResult = Schema.SObjectType.Lead; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = describeResult.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Qualified Lead');
        
        /* Storing record type id in class property */
        if (rtByName != null) 
        {
            qualifiedRT = rtByName.getRecordTypeId();
        }
        lead.RecordTypeId = qualifiedRT; 
        lead.Lead_State__c= 'New';      
        
    }
       
    /**
    * @description: Save menthod to change the owner of the lead
    * @return: Redirects to Lead Page after save
    */
    public PageReference save() {
   // if(sendEmailNotificationFlag && (errorFlag==false)){
   
       if (errorFlag) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
            return null;
        } else {
            try {
                    // R6
                   System.debug('************First_Assignment_Date__c: '+lead.First_Assignment_Date__c);
                   
                   if(lead.First_Assignment_Date__c == null  )
                       lead.First_Assignment_Date__c=DateTime.now();
                    // R6 
            
                   
                    update lead;
                    system.debug('*****LeadId'+lead.id);
                    isSave = False;
                    if(UserInfo.getUserId()!=lead.OwnerId){    
                        isOwnerChanged=True;
                    }
                                           
            }
            catch (DMLException dmlEx) {
                CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Lead', 'LeadManualAssignmentController', '');
                for (Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                     Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
                }
                return null;
            }
           /* if (Lead.Company == null)
            {
                Lead.Company = ' ';
            }*/
            if (Lead.Salutation == null)
            {
                Lead.Salutation = ' ';
            }
            
            if(sendEmailNotificationFlag){
                    List<Messaging.SingleEmailMessage> mailList =new List<Messaging.SingleEmailMessage>();
                    for(GroupMember GroupMem : [Select UserOrGroupId From GroupMember where GroupId =:lead.OwnerId]){
                        QueueOwnId.add(GroupMem.UserOrGroupId);
                        Messaging.singleEmailMessage mail = new Messaging.singleEmailMessage();
                        mail.setSenderDisplayName('Salesforce Support');
                        mail.setSubject('New Lead Assigned to You : ' + Lead.id);
                        mail.setBccSender(false); 
                        mail.setPlainTextBody('*** NEW LEAD ASSIGNMENT NOTIFICATION ***');
                        mail.setHtmlBody('*** NEW LEAD ASSIGNMENT NOTIFICATION ***<p>The following lead has been assigned to you. <p>Company :  ' + Lead.Company +' <p>'+'Lead Name : '+ Lead.Salutation +'  '+ Lead.Name + '<p>Click on the link to access the lead directly : '+ '<a href="'+getURL1+'/'+Lead.Id +'">'+getURL1 +'/'+Lead.Id+'</a>');                       
                        mail.setTargetObjectId(GroupMem.UserOrGroupId);
                        mail.setSaveAsActivity(false);
                        mail.setUseSignature(false);
                        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        maillist.add(mail);
                        grpcount = 1;
                    }
                    if(mailList.size()>0)
                        Messaging.sendEmail( mailList ); 
                    if (grpcount==0){
                        if (grpcount==0){
                           Messaging.singleEmailMessage mail = new Messaging.singleEmailMessage();
                            mail.setSenderDisplayName('Salesforce Support');
                            mail.setSubject('New Lead Assigned to You : ' + Lead.id);
                            mail.setBccSender(false); 
                            mail.setPlainTextBody('*** NEW LEAD ASSIGNMENT NOTIFICATION ***');
                            mail.setHtmlBody('*** NEW LEAD ASSIGNMENT NOTIFICATION ***<p>The following lead has been assigned to you. <p>Company :  ' + Lead.Company +' <p>'+'Lead Name : '+ Lead.Salutation +'  '+ Lead.Name + '<p>Click on the link to access the lead directly : '+ '<a href="'+getURL1+'/'+Lead.Id +'">'+getURL1 +'/'+Lead.Id+'</a>');                       
                            mail.setTargetObjectId(lead.OwnerId);
                            mail.setSaveAsActivity(false);
                            mail.setUseSignature(false);
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        }
                    }  
             }  
            PageReference retPage;
            if(isOwnerChanged){
                retPage = null;
            }
            else{
                retPage = new PageReference('/'+lead.Id);
            }
            return retPage;  
        }
    }  
    
    /**
    * @description: Cancel menthod 
    * @return: Redirects to Lead Page 
    */
    public PageReference cancel() { 
        PageReference retPage = new PageReference('/'+leadId);
        retPage.setRedirect(true);
        return retPage;              
    }
}