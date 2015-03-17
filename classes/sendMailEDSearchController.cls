/*
* NAME : sendMailEDSearchController
* This controller class is used to
* 	- select the email ids from ED 
*	- select the attachments 
*	- select the email temlate
* 	- forwards all the above information to Send Email page
* when user clicks on Send to Other Party Review and Send for Review HP button
*
* Author : Apttus (last modified by : Axay Varu)
*/
public class sendMailEDSearchController {
    
    public List<EmailTemplate> dispEmailTemplates{get;set;}
    private List<Folder> allEmailTemplateFolders;
    public String selectedEmailTemplateFolder {get;set;}
    public String selectedEmailTemplate {get;set;}
    public EmailTemplate chosenEmailTemplate {get;set;}
    public String documentId{get;set;}
    public Static String agreementID {get; private set;}
    public Static String actionDetect;
    public List<ID> attachedIds {get;set;}
    public List<String> atName{get;set;}
    public static final String EMAIL_DEFAULT_TEMPLATE = 'Apttus Email Template For Review Signature';
    public String urlToEmail {get;  set;}
    public String additionToUrl {get;   set;}
    public String bccUrl {get;  set;}
    public String ccUrl {get;   set;}
       
    // params for invoking SFDC's SendEmail action
    public static final String EMAIL_AUTHOR_URL = '/_ui/core/email/author/EmailAuthor';
    public static final String PARAM_ID = 'id';
    public static final String PARAM_P3_LKID = 'p3_lkid';
    public static final String PARAM_P24 = 'p24';
    public static final String PARAM_P4 = 'p4';
    public static final String PARAM_P5 = 'p5';
    public static final String PARAM_ACTION = 'action';
    public static final String PARAM_NEW_UNDERSCORE_TEMPLATE = 'new_template';
    public static final String PARAM_TEMPLATE_UNDERSCORE_ID = 'template_id';
    public static final String PARAM_NEW_TEMPLATE_ID = 'newTemplateId'; 
    public static final String PARAM_RETURN_URL = 'retURL';
    public static final String PARAM_CANCEL_URL = 'cancelURL';
    
    public String emailAuthorURL {get; private set;}    
    // selected emailTemplateId
    public String emailTemplateId {get; set;}
    
     // indicator to apply protection
    public Boolean protect {get; private set;}
    // protection leve to apply     
    public String protectionLevel {get; set;}
    
   
    public sendMailEDSearchController(ApexPages.StandardController controller) { 

        agreementID = ApexPages.currentPage().getParameters().get('id');
        actionDetect = ApexPages.currentPage().getParameters().get('action');
        additionToUrl = ApexPages.currentPage().getParameters().get('p24');
        ccUrl = ApexPages.currentPage().getParameters().get('p4');
        bccUrl = ApexPages.currentPage().getParameters().get('p5');
        setEmailAuthorURL();
        
        attachedIds = new List<ID>();
        emailTemplateId = '';
        
        dispEmailTemplates=new List<EmailTemplate>();
        
        protect = true;
        protectionLevel = 'Default';
        urlToEmail = '/_ui/core/email/author/EmailAuthor?p3_lkid='+agreementID;
        
        if(additionToUrl != null && additionToUrl != ''){
            urlToEmail = urlToEmail + '&p24='+additionToUrl;
        }
        if(ccUrl != null && ccUrl != ''){
            urlToEmail = urlToEmail + '&p4='+ccUrl;
        }
        if(bccUrl != null && bccUrl != ''){
            urlToEmail = urlToEmail + '&p5='+bccUrl;
        }
        
        urlToEmail = urlToEmail + '&retURL=/'+agreementID;
    }

    
    public PageReference doCancel(){
        agreementID = ApexPages.currentPage().getParameters().get('id');
        return new PageReference('/'+AgreementID);
    }    
    public PageReference doSearchED(){
        actionDetect = ApexPages.currentPage().getParameters().get('action');
        String reqURL = URL.getCurrentRequestUrl().toExternalForm();
        return new PageReference('/apex/addeMailsIds?reqURL='+reqURL+'&action='+actionDetect);
    }
    // get the selected additional to email ids 
    public String getAdditionalTO(){
        return ApexPages.currentPage().getParameters().get('p24');
    }
    // get the selected cc email ids
    public String getCC(){
        return ApexPages.currentPage().getParameters().get('p4');
    }
    // get the selected bcc email ids
    public String getBCC(){
        return ApexPages.currentPage().getParameters().get('p5');
    }
    // get the selected attachment email ids
    public String getAttachment(){
        return ApexPages.currentPage().getParameters().get('doc_id');
    }
    
    public String getattachIds(){
        //System.debug('Comma Seperated Attachment IDs are ' + toCommaSepString(attachedIds));
        return toCommaSepString(attachedIds);       
    }
    
    private String toCommaSepString(List<ID> attachedIds) {
        String commaSepString = '';
        for(Id attId : attachedIds) {
            if(commaSepString!='') {
            commaSepString += ','+attId;
            } else {
                commaSepString += attId;
            }
        }
        return commaSepString;
    }
    //all the required details are attached to the URL n sent to the called page
    public void doNext(){        
        if ((emailTemplateId == '') && (emailTemplateId.length() == 0)) {
            
            // If Selected Email Template is null,get default email template
            EmailTemplate ApttusEmailTemplate = [Select Id, Name from EmailTemplate where Name = :EMAIL_DEFAULT_TEMPLATE];
            emailTemplateId = ApttusEmailTemplate.Id;
           }
        updateAgreement();
      }
    // Adds the attachments    
    public class AttachmentWrapper{
        public Apttus__APTS_Agreement__c agrmt{get;set;}
        public Attachment attach{get;set;}
        public boolean selected{get;set;}
        public AttachmentWrapper(Attachment at, Apttus__APTS_Agreement__c agt){
            attach = at;
            agrmt = agt;
            selected = false;
        }
    }
    //Lists all the attachments and templates
    public List<AttachmentWrapper> dispAttachment{get;set;}
    public Pagereference getAllAttachments(){   
        List<AttachmentWrapper> attachmentList = new List<AttachmentWrapper>();
        
        for(Apttus__APTS_Agreement__c agt : [Select ID, Name, Apttus__Status_Category__c, Apttus__Status__c,Apttus__FF_Agreement_Number__c  from Apttus__APTS_Agreement__c where ID =:AgreementID]){
            for(Attachment at : [Select Id,Name,BodyLength,LastModifiedDate from Attachment where ParentId=:AgreementID]){
                attachmentList.add(new AttachmentWrapper(at,agt));
            } 
        }
        dispAttachment = attachmentList;
        getEmailTemplateOpts();
        
        return null;
    }
    public Pagereference addAttachments(){
        atName= new List<String>();
        attachedIds.clear();
        for(AttachmentWrapper aw :dispAttachment){
            if(aw.selected == true){
               attachedIds.add(aw.attach.id);
               documentId = aw.attach.id;
               atName.add(aw.attach.name);
            }
        }
       
        return null;
        
    } 
    //list all the email folders    
    public List<SelectOption> getEmailTemplateFolderOpts() {
        allEmailTemplateFolders = [select Id, Name from Folder where Type = 'Email' order by Name asc];
        List<SelectOption> opts = new List<SelectOption>();
        opts.add(new SelectOption('null', ' - Select - '));
        for ( Folder f : allEmailTemplateFolders )
            opts.add(new SelectOption(f.Id, f.Name));
        // add an option for templates in the Unfiled Public folder
        opts.add(new SelectOption(UserInfo.getOrganizationId(), 'Unfiled Public'));
        return opts;
    }
    //list allt he templates 
    public Pagereference getEmailTemplateOpts() {
        
        dispEmailTemplates=new List<EmailTemplate>();        
        List<EmailTemplate> allEmailTemplates = [select Id, Name,FolderId,TemplateType,Description from EmailTemplate order by Name asc];
        if ( selectedEmailTemplateFolder != null ) {
            Id selectedId = (Id) selectedEmailTemplateFolder;
            
            for ( EmailTemplate et : allEmailTemplates ) {
                if ( et.FolderId == selectedId )
                    dispEmailTemplates.add(et);
            }
        }
        return null;
    }
    //get the selected template id
    public PageReference refreshEmailTemplateSection() {        
        Id selectedId = ApexPages.currentPage().getParameters().get('selET');
        for ( EmailTemplate et : dispEmailTemplates) {
            if ( et.Id == selectedId ) {
                chosenEmailTemplate = et;
                emailTemplateId = et.Id;
                break;
             }
        }           
        return null;
    }
    
    public void doValidateEmailTemplateSelection() {
        
    }
    /**
     * Sets the url to the email author page
     */
    private void setEmailAuthorURL() {
        
        
        String agmtIdStr = agreementID;
        PageReference emailAuthorPageRef = new PageReference(EMAIL_AUTHOR_URL);
        Map<String, String> emailAuthorPageParams = emailAuthorPageRef.getParameters();
        emailAuthorPageParams.put(PARAM_P3_LKID, agmtIdStr.substring(0, 15));
        emailAuthorPageParams.put(PARAM_TEMPLATE_UNDERSCORE_ID, '__NEW_TEMPLATE_ID_16CHARS__');
        emailAuthorPageParams.put(PARAM_NEW_UNDERSCORE_TEMPLATE, '1');
        
        if (getAdditionalTO() != null) {
            emailAuthorPageParams.put(PARAM_P24, getAdditionalTO());
        }
        if (getCC() != null) {
            emailAuthorPageParams.put(PARAM_P4, getCC());
        }
        if (getBCC() != null) {
            emailAuthorPageParams.put(PARAM_P5, getBCC());
        }       
             
        // construct retURL for post processing 
        PageReference postProcessPageRef = Page.Apttus__SendToOtherPartyPostProcess;
        postProcessPageRef.getParameters().put(PARAM_ID, agreementID);
        postProcessPageRef.getParameters().put(PARAM_NEW_TEMPLATE_ID, '__NEW_TEMPLATE_ID_16CHARS__');
        postProcessPageRef.getParameters().put(PARAM_ACTION, 'Send_To_Other_Party_For_Review'); // Removed Variable - actionDetect
        String returl = postProcessPageRef.getUrl();
        
        emailAuthorPageParams.put(PARAM_RETURN_URL, returl);    

        emailAuthorURL = emailAuthorPageRef.getUrl();
        
    }
    
    
    private void updateAgreement()
    {
        agreementID = ApexPages.currentPage().getParameters().get('id');
        actionDetect = ApexPages.currentPage().getParameters().get('action');
        
    if(actionDetect != null && actionDetect != ''){
             Apttus__APTS_Agreement__c  agrmnt = [SELECT Apttus__Status__c,Apttus__Status_Category__c,HP_Review_Status__c,Other_Party_Review_Status__c,First_send_for_Other_Party_review__c,HP_Send_for_Internal_Review_Date__c FROM Apttus__APTS_Agreement__c WHERE ID = :AgreementID];         
             if(agrmnt != null){
                 if(actionDetect == 'Submit_For_Review_HP'){
                    
                     agrmnt.Apttus__Workflow_Trigger_Viewed_Final__c = FALSE;
                     //agrmnt.Apttus__Status_Category__c = 'In Authoring';//status
                     agrmnt.HP_Review_Status__c = 'In HP Review';
                     agrmnt.HP_Send_for_Internal_Review_Date__c = System.now();
                     //agrmnt.Apttus__Status__c = 'Internal Review';//status Progress    
                     }                     
                 else if(actionDetect == 'Send_To_Other_Party_For_Review'){
                     //agrmnt.Apttus__Status_Category__c = 'In Authoring';//status
                     agrmnt.Other_Party_Review_Status__c = 'In Other Party Review';
                     agrmnt.Apttus__Workflow_Trigger_Viewed_Final__c = FALSE;
                     agrmnt.Last_Send_for_Other_Party_Review__c = System.now();
                     if(agrmnt.First_send_for_Other_Party_review__c == null)
                     {  agrmnt.First_send_for_Other_Party_review__c = System.now(); }
                     //agrmnt.Apttus__Status__c = 'Other Party Review';//status Progress                     
                 }                 
                 update agrmnt;
                            
             }                         
         }  
    }
    
}