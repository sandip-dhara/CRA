/*
* NAME : ApttusAgmtSignatureController
* NOTE : Class will used when user clicks on "eSignature" Button,
* Author : Apttus
*/
public with sharing class ApttusAgmtSignatureController {  
   public Apttus__APTS_Agreement__c agreement {get; set;}
    // list of attachments
    public List<AttachmentInfo> attColl {get;	set;}
    // attachment ids selected
    private Set<ID> selectedAttachmentIds = null;   
    // error indicator
    private Boolean hasErrors = false;
    // action
    private String action = null;
    
    public String apiSessionId {get;set;} 
    public String apiServerURL {get;set;}   
   
     public ApttusAgmtSignatureController(ApexPages.StandardController stdController) {
        System.debug('api Session Id' +apiSessionId);
        System.debug('api server url' +apiServerURL);
        Map<String, String> params = ApexPages.currentPage().getParameters();   
        agreement = (Apttus__APTS_Agreement__c) stdController.getRecord();          
        agreement = [select Id,Name,ownerId,Apttus__Status__c,Sent_for_eSignature_Date__c,Apttus__Status_Category__c from Apttus__APTS_Agreement__c where id=:agreement.Id];
        this.selectedAttachmentIds = new Set<ID>();
        
        //goDocuSign(); 
     }
 
 	public PageReference goDocuSignold()
 	{
 		agreement.Sent_for_eSignature_Date__c = System.now();
        update agreement;
 		return new PageReference('/apex/dsfs__DocuSign_CreateEnvelope?DSEID=0&SourceID='+agreement.ID+'&DSEDMAX=3&OCO=Tag');
 	}
 	
 	public PageReference goDocuSign()
 	{
 		agreement.Sent_for_eSignature_Date__c = System.now();
        update agreement;
        
        dsfs.DSECreateandSend createAndSend = new dsfs.DSECreateandSend();
        dsfs__DocuSign_Envelope__c  envelope = createAndSend.CreateEnvelopeObject(agreement.ID);
        System.debug('*****envelop:'+envelope);
 		//return new PageReference('/apex/dsfs__DocuSign_CreateEnvelope?DSEID=0&SourceID='+agreement.ID+'&DSEDMAX=3&OCO=Tag');
 		return new PageReference('/apex/dsfs__DocuSign_OneClickSendPage?DSEID='+envelope.Id+'&SourceID='+agreement.ID+'&DSEDMAX=3&OCO=Tag');
 	}
 	
     public PageReference sendForEsginatureold() {
        //String csvIds  = getSelectedAttachmentIdsCsv();
        String docIds = convertSelectedDocs();
        System.debug('docIds '+docIds);
        //OLD : /apex/dsfs__DocuSign_EditEnvelope?SourceID='+agreement.ID+'&STB=0&OCO=Tag
        ///apex/DocuSign_CreateEnvelope?DSEID=0&SourceID={!Lead.Id}&DSEDMAX=3
        
        agreement.Sent_for_eSignature_Date__c = System.now();
        update agreement;
        return new PageReference('/apex/dsfs__DocuSign_CreateEnvelope?DSEID=0&SourceID='+agreement.ID+'&DSEDMAX=3&OCO=Tag');
        
     }
     
     public PageReference sendForEsginature() {
        //String csvIds  = getSelectedAttachmentIdsCsv();
        agreement.Apttus__Status__c = 'Internal Signatures';
        agreement.Apttus__Status_Category__c = 'In Signatures';
        agreement.Sent_for_eSignature_Date__c = System.now();
        update agreement;
        
        dsfs.DSECreateandSend createAndSend = new dsfs.DSECreateandSend();
        dsfs__DocuSign_Envelope__c  envelope = createAndSend.CreateEnvelopeObject(agreement.ID);
        envelope.dsfs__Custom_Field_1_Name__c = 'ApttusAgreementID';
        envelope.dsfs__Custom_Field_1_Value__c = agreement.ID;
        update envelope;
        System.debug('*****envelop:'+envelope);
 		AddDocumentsToEnvelope(createAndSend);
        
        
        return new PageReference('/apex/dsfs__DocuSign_OneClickSendPage?DSEID='+envelope.Id+'&SourceID='+agreement.ID+'&DSEDMAX=3&OCO=Tag');
        
     }
      
     private void AddDocumentsToEnvelope(dsfs.DSECreateandSend createAndSend) {
     	
        String docIds=null;
        integer i = 0;
        for (AttachmentInfo attInfo : getAttachments()) { 
            String fileName = attInfo.attSO.Name;
            fileName = fileName.toLowerCase(fileName);
            System.debug('*****attInfo.selected:'+attInfo.selected+'  fileName:'+fileName);
            if(attInfo.selected ) {
            	if (fileName.contains('.doc')) {
	                Id docId = attInfo.attSO.Id;
	                if(docId == null) {
	                    System.debug('ERROR: Failed to locate the attachment');
	                    return ;
	                }
	                fileName = attInfo.attSo.Name;
	                
					createAndSend.AddDocument(docId, 'Attachment', fileName, i++);
					System.debug('***** Added:'+fileName);
	            }else if (attInfo.selected && attInfo.attSO.Name.contains('.pdf')){
	                
	                createAndSend.AddDocument(attInfo.attSO.Id, 'Attachment', attInfo.attSo.Name, i++);
	            	System.debug('***** Added:'+attInfo.attSo.Name);
	            }
	            else {
	            	createAndSend.AddDocument(attInfo.attSO.Id, 'Attachment', attInfo.attSo.Name, i++);
	            	System.debug('***** Added:'+attInfo.attSo.Name);
	            }
            }
        }
     }
     public PageReference sendForWetSignature() {
        System.debug('api Session Id' +apiSessionId);
        System.debug('api server url' +apiServerURL);
        String docIds = convertSelectedDocs();
        return new PageReference('/apex/Apttus__SendEmail?id='+agreement.Id+ '&action=Send_To_Other_Party_For_Signatures&documentIdsCsv='+docIds);
        
     }  

    private String convertSelectedDocs() {
        String docIds=null;
        for (AttachmentInfo attInfo : getAttachments()) { 
            String fileName = attInfo.attSO.Name;
            fileName = fileName.toLowerCase(fileName);
            if (attInfo.selected && fileName.contains('.doc')) {
                try {
                  
                    Id docId = attInfo.attSO.Id;
                    if(docId == null) {
                        System.debug('ERROR: Failed to locate the attachment');
                        return null;
                    }
                    fileName = attInfo.attSo.Name;
                    //String conveDocId = Apttus.MergeWebService.convertWordDocToPDF(docId,fileName.substring(0,fileName.indexOf('.')) +'-'+String.valueOf(System.today())+'.pdf',false, true, null,null , apiSessionId, apiServerURL);
                    String conveDocId = null;
                    if (conveDocId != null) {
                        if (docIds == null)                 
                            docIds = conveDocId;
                        else 
                           docIds +=','+conveDocId; 
                    }
                } catch (Exception ex) {
                    System.debug('Failed to Convert the document to pdf: ' + ex);                      
                }
            }else if (attInfo.selected && attInfo.attSO.Name.contains('.pdf')){
                        if (docIds == null)                 
                            docIds =  attInfo.attSO.Id;
                        else 
                           docIds +=','+ attInfo.attSO.Id;  
                
            }
                
            
        }

        return docIds;      
    } 

    /**
     * Gets the Agreement Name
     * @return the Agreemnt Name
     */
    public String getName() {
        return agreement.Name; 
        
    }

   public PageReference onLoad() {
        System.debug('On load');
        List<AttachmentInfo> attachments  = getAttachments();
        System.debug('Attachments Size '+attachments.size());
        if (attachments.size() == 1) {
            AttachmentInfo attInfo = attachments[0];
            return new PageReference('/apex/Apttus_Echosign__SelectAttachment?targetPageURL=/apex/Apttus_Echosign__EchoSignInfoEdit&id='+agreement.Id+'&documentIdsCsv='+attInfo.attSO.Id);
            
        }
        return null;    
   }
	/* Method is not used anywhere
    public static void createActivityLogEntry(Id agreementId, String subject) {
        Task task = new Task();
        task.ActivityDate = Date.today();
        task.Description = subject;
        task.OwnerId = UserInfo.getUserId();
        task.Priority = 'Normal';
        task.Status = 'Completed';
        task.Subject = subject; 
        task.WhatId = agreementId;

        insert task; 
    } */
    /**
     * Gets the list of attachment info objects associated with the Agreement
     * @return the list of attachment info objects
     */
    public List<AttachmentInfo> getAttachments() {
    
        // read records from the current page in the recordset
        if (attColl == null) {
            attColl = new List<AttachmentInfo>();
            List<Attachment> attachmentList =  [Select Id, a.Name,a.ContentType,a.BodyLength,LastModifiedDate,CreatedDate  From Attachment a where a.parentId=:agreement.Id order by LastModifiedDate  desc];
            
            List<Id> attachmentIds = new List<Id> ();
            for (Attachment attSO : attachmentList) {
                attachmentIds.add(attSO.Id);
            }
            
            for (Attachment attSO : attachmentList) {
                String aName = attSO.Name;          
                AttachmentInfo attInfo = new AttachmentInfo(attSO);
                // add to the collection
                attColl.add(attInfo);
            }
            
        }
        
        return attColl;
        
    }
        
    /**
     * Checks if the agreements has attachments
     * @return <code>true</code> if there are attachments, <code<false</code> otherwise
     */
    public Boolean getHasAttachments() {
        return !getAttachments().isEmpty(); 
        
    }
    
    /**
     * Gets the selected attachment ids as a comma separated list
     * @return the comma separated list of attachment ids
     */
    public String getSelectedAttachmentIdsCsv() {
        
        // build the comma separated list of attachment ids
        String attIdStr = '';   
        for (ID attId : selectedAttachmentIds) {
            if (attIdStr.length() > 0) {
                attIdStr += ',';
                
            }
            
            attIdStr += attId;
            
        }
                
        return attIdStr;
        
    } 
    
    public ID getSelectedAttachmentId() {
        for (ID attId : selectedAttachmentIds) {
                return attId;
            
        }
        return null;        
    }
    
    /**
     * Checks if there are selecetd attachments
     * @return <code>true</code> if there are selected attachments, <code<false</code> otherwise
     */
    public Boolean getHasSelectedAttachmentIds() {
        return !selectedAttachmentIds.isEmpty()  ;
                
    } 
    

    
    /**
     * Checks if there were errors in loading the page
     * @return <code>true</code> if there were errors, <code>false</code> otherwise
     */
    public Boolean getHasErrors() {
        return hasErrors;
        
    }
    
    /**
     * Performs the select action
     */
    public void doSelect() {
        
        try {
        System.debug('api Session Id' +apiSessionId);
        System.debug('api server url' +apiServerURL);
            
            // STEP I - iterate through list page and select/deselect attachments       
            for (AttachmentInfo attInfo : getAttachments()) {
                // get the sobject id
                Id attId = attInfo.attSO.Id;
                if (attInfo.selected) {
                    // selected
                    selectedAttachmentIds.add(attId);
                    
                } else {
                    // deselected
                    selectedAttachmentIds.remove(attId);
                    
                }
                
            }
            
        } catch (Exception ex) {
            // add error messages
            ApexPages.addMessages(ex);
            // set the error indicator
            this.hasErrors = true;
            
            System.Debug(LoggingLevel.ERROR, ex.getMessage());
            
        } 
        
    }
    

    
    /**
     * Performs the cancel action
     * @return the next page reference 
     */
    public PageReference doCancel() {
        // navigate back to the detail page
        return new PageReference('/' + agreement.Id);
        
    }
    
            
    /**
     * Wrapper class for holding attachments
     */
    public class AttachmentInfo {
        
        // state
        
        // attachment sobject
        public Attachment attSO {get; private set;}
        // selected indicator
        public Boolean selected {get; set;}
        
        /**
         * Class Constructor specifying initial values
         * @param attSO the attachment sobject
         */
        public AttachmentInfo(Attachment attSO) {
            this.attSO = attSO;
            this.selected = false;
            
        }
        
    }
}