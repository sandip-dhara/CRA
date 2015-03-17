/*
* NAME : SelectRecordType
* NOTE : This class is used when user clicks on "Begin Agreement Creation" or "Clone Opportunity data" button,
*		 class logic will clone current Agreement with Agreement & Only Metadata Statuses and with 'not yet selected' record type
*		 if user have clicked on Begin Agreement creation button this will copy all attachments also,
*		 additionally class will call web service to get protection level and enable Authoring
* Author : Apttus (Axay Varu)
*/
public with sharing class SelectRecordType{
    
    public String selectedRecordType{get;set;}
    public List<SelectOption> lstSelectRecordTypes{get;set;}
    public List<RecordType> lstRecordType{get;set;}
    public String agreementId{get;set;}
    public String action{get; set;}
    public String apiSessionId {get;set;} 
    public String apiServerURL {get;set;}
    public List<Support_Request__c> supportRequest {get;	set;}
    public List<Attachment> lstAttachment {get; set;}
    public List<Note> lstNotes {get; set;}
    public List<Attachment> lstAtchmntSR {get; set;}
    public List<Note> lstNoteSR {get;	set;}
    
    public SelectRecordType(){
        action = '';
        lstRecordType = [Select Id,Name,Description From RecordType Where SobjectType = 'Apttus__APTS_Agreement__c'];
        lstSelectRecordTypes = new List<SelectOption>();
        supportRequest = new List<Support_Request__c>();
        lstAttachment = new List<Attachment>();
        lstNotes = new List<Note>();
        lstAtchmntSR = new List<Attachment>();
        lstNoteSR = new List<Note>();
        
        for (RecordType RT : lstRecordType){ 
            if(RT.Name == 'Not yet selected'){
                selectedRecordType = RT.Id;
            }
            lstSelectRecordTypes.add(new SelectOption(RT.Id, RT.Name)); 
        }      
        agreementId = Apexpages.currentPage().getParameters().get('id');
        action = ApexPages.currentPage().getParameters().get('action');  
    }
    
    public PageReference SaveAndContinue(){
        List<Apttus__APTS_Agreement__c> lstAgreement = [Select Apttus__Account__c,Apttus__Account_Search_Field__c,
            Activated_By__c,Additional_Information__c,Apttus__Agreement_Category__c,Apttus__Contract_End_Date__c,
            Apttus__Contract_Start_Date__c,Apttus__Amendment_Effective_Date__c,Apttus__Auto_Renewal__c,
            Base_Term__c,Apttus__Business_Hours__c,Close_Date__c,Comments__c,Apttus__Company_Signed_By__c,Apttus__Company_Signed_Date__c,
            Apttus__Company_Signed_Title__c,Contract_Geographic_Scope__c,Contract_Term__c,Customer_Legal_Contact__c,Customer_Legal_Name__c,
            Customer_Location_Country__c,Customer_State_if_US__c,Customer_s_Agreement__c,Deal_Negotiation_status__c,
            Apttus__Description__c,Effective_Date__c,Apttus__Executed_Copy_Mailed_Out_Date__c,Is_Global_Account__c,External_Agreement_Id__c,
            HP_Agreement_Term__c,HP_Apttus_Agreement_Completion_Status__c,Incumbent_Competitor__c,Industry_Segment__c,Industry_Vertical__c,
            Integration_Status_with_Axiom_Apttus__c,Language_for_Agreement__c,Lead_BU__c,Legal_Issue_Content__c,Legal_Owner__c,
            Managed_By__c,Apttus__Non_Standard_Legal_Language__c,Not_Applicable__c,Opportunity_No__c,Opportunity_Owner__c,Opportunity_Type__c,
            Apttus__Other_Party_Returned_Date__c,Apttus__Other_Party_Sent_Date__c,Apttus__Other_Party_Signed_By__c,Apttus__Other_Party_Signed_By_Unlisted__c,
            Apttus__Other_Party_Signed_Date__c,Apttus__Other_Party_Signed_Title__c,Apttus__Owner_Expiration_Notice__c,Paragraph__c,
            Apttus__Parent_Agreement__c,Governing_Master_Agreement__c,Apttus__Perpetual__c,Primary_Account__c,Primary_Competitor_Acct__c,
            Apttus__Primary_Contact__c,Primary_Partner__c,Primary_Partner_Acct__c,Public_Sector__c,Related_Agreement__c,Related_Agreement_1__c,
            Related_Agreement_2__c,Related_Agreement_3__c,Apttus__Auto_Renew_Consent__c,Apttus__Renewal_Notice_Days__c,
            Apttus__Auto_Renew_Term_Months__c,Apttus__Auto_Renewal_Terms__c,Request__c,Request_Date__c,Apttus__Requestor__c,
            Apttus__RetentionDate__c,Apttus__RetentionPolicyId__c,Apttus__Risk_Rating__c,Route__c,Sales_Coverage_Segment__c,
            Sales_Request_Type__c,Sales_Stage__c,Secondary_BU__c,Apttus__Source__c,Apttus__Special_Terms__c,Specify_if_others__c,
            Apttus__Status__c,Apttus__Status_Category__c,Apttus__Submit_Request_Mode__c,Apttus__Subtype__c,Support_Number__c,
            SR_Id__c,Apttus__Term_Months__c,Apttus__TerminationComments__c,Apttus__Termination_Date__c,Apttus__Termination_Notice_Days__c,
            Apttus__Termination_Notice_Issue_Date__c,Third_Party_Consultant_ProviderUser__c,Legal_First_Assigned_Date__c,
            Apttus__Total_Contract_Value__c,Apttus__Version__c,Will_this_customer_use_standard_HP_terms__c,
            Apttus__Workflow_Trigger_Viewed_Final__c,Apttus__Account__r.Name,Contract_Type_Abbreviation__c 
            From Apttus__APTS_Agreement__c
            Where Id =: agreementId];
        
        Apttus__APTS_Agreement__c newAgmt = new Apttus__APTS_Agreement__c();
        
        if(lstAgreement.size() > 0){
            Apttus__APTS_Agreement__c agmt = lstAgreement[0];
            newAgmt = agmt.clone(false,true,false,false);
            newAgmt.RecordTypeId = selectedRecordType;
            newAgmt.Apttus__Status__c = 'Only Metadata';
            newAgmt.Apttus__Status_Category__c = 'Agreement';
            newAgmt.Apttus__Parent_Agreement__c = agreementId;
            newAgmt.Apttus__Workflow_Trigger_Viewed_Final__c = FALSE;
            String AccountName = agmt.Apttus__Account__r.Name;
            System.debug('***Ac Nam: '+AccountName);
            if(AccountName != null && AccountName.length() > 60){
            	AccountName = AccountName.subString(0,60);
            }
            newAgmt.Name = AccountName + ' - ' + agmt.Contract_Type_Abbreviation__c;            
            insert newAgmt; // clone existing Agreement
            System.debug('*****Request Date: '+newAgmt.Request_Date__c);	
            if(newAgmt.SR_Id__c != null && newAgmt.SR_Id__c != ''){
            	supportRequest = [SELECT ID FROM Support_Request__c WHERE ID = :newAgmt.SR_Id__c LIMIT 1];
            	
            	//lstAtchmntSR = [SELECT ID,BodyLength,Name,ParentID,BODY FROM Attachment WHERE ParentID = :newAgmt.SR_Id__c];
            	//lstNoteSR = [SELECT ID,Body,Title,ParentID FROM Note WHERE ParentID = :newAgmt.SR_Id__c];
            }
            
            System.debug('*****Support Requ. Found: '+supportRequest.size());
            if(supportRequest.size() > 0 && action != '' && action == 'CloneOpp'){
            	
            	lstAttachment = [SELECT ID,NAME,BODY,BodyLength,ParentID FROM Attachment WHERE ParentID = :newAgmt.ID];
            	lstNotes = [SELECT ID,Title,Body,ParentID FROM Note WHERE ParentID = :newAgmt.ID];
            	if(lstAttachment.size() > 0){
            		delete lstAttachment;
            		System.debug('***Deleted attachments::');
            	}
            	if(lstNotes.size() > 0){
            		delete lstNotes;
            	}
            }
            
            if(action != '' && action == 'ConvertDoc')
            {
            	//List<Attachment> lstAttachments = [SELECT ID,NAME,BODY,ParentID FROM Attachment WHERE ParentID = :newAgmt.ID];
                //List<Note> lstNote = [SELECT ID,Title,Body,ParentID FROM Note WHERE ParentID = :newAgmt.ID];                                    
            	List<Id> lstAttachmentIds = new List<Id>();
            	if(supportRequest.size() > 0){
            		/*
            		System.debug('****need to delete those in support request:');
            		lstAtchmntSR = [SELECT ID,BodyLength,Name,ParentID,BODY FROM Attachment WHERE ParentID = :newAgmt.SR_Id__c];
            		lstNoteSR = [SELECT ID,Body,Title,ParentID FROM Note WHERE ParentID = :newAgmt.SR_Id__c];
            		for(Attachment atment :  lstAtchmntSR){
            			for(Attachment atmen : lstAttachments){
            				if()
            			}
            		}*/
            	}
            	else{
            		System.debug('****Inside Incorrect-Logic:');
                	List<Attachment> lstAttachments = [SELECT ID,NAME,BODY,ParentID FROM Attachment 
                                                    WHERE ParentID = :agreementId];
                	List<Attachment> lstAtchInsert = new List<Attachment>();
                	for(Attachment attach : lstAttachments){
	                    Attachment atchmnt = new Attachment();
	                    atchmnt.NAME = attach.NAME;
	                    atchmnt.BODY = attach.BODY;
	                    atchmnt.ParentID = newAgmt.ID;
	                    lstAtchInsert.add(atchmnt);
                	}
                if(lstAtchInsert.size() > 0){
                    insert lstAtchInsert;
                }
                
                
                for(Attachment att : lstAtchInsert){
                    lstAttachmentIds.add(att.Id);
                }
            }
            	
                
                EnableMergeService(lstAttachmentIds,newAgmt.Id,apiSessionId,apiServerURL);
            }
            /*
            if(action != '' && action == 'ConvertDoc') //cpoy all attachment as well if press on Begin Agreement Creation Button
            {
            	
            	lstAttachment = [SELECT ID,NAME,BODY,BodyLength,ParentID FROM Attachment WHERE ParentID = :agreementId];
            	lstNotes = [SELECT ID,Title,Body,ParentID FROM Note WHERE ParentID = :agreementId];
                List<Attachment> lstAtchInsert = new List<Attachment>();
                List<Note> lstNoteInsert = new List<Note>();
                
                for(Note notes : lstNotes){
                	Note myNote = new Note();
                	myNote.Body = notes.Body;
                	myNote.ParentId = newAgmt.ID;
                	myNote.Title = notes.Title;
                	lstNoteInsert.add(myNote);
                }
                
                for(Attachment attach : lstAttachment){
                    Attachment atchmnt = new Attachment();
                    atchmnt.NAME = attach.NAME;
                    atchmnt.BODY = attach.BODY;
                    atchmnt.ParentID = newAgmt.ID;
                    lstAtchInsert.add(atchmnt);
                }
                
                if(lstAtchInsert.size() > 0){
                    insert lstAtchInsert;
                }
                
                if(lstNoteInsert.size() > 0){
                	insert lstNoteInsert;
                }
                
                List<Attachment> lstCompareAtmnt = [SELECT ID,BodyLength,ParentID,NAME FROM Attachment WHERE ParentID = :newAgmt.ID]; 
                List<Attachment> deleteThisAtmt = new List<Attachment>();
                Set<Attachment> setAttmnt = new Set<Attachment>();
                setAttmnt.addAll(lstCompareAtmnt);
                Set<ID> ids = new Set<ID>();
                for(Attachment atment1 : lstCompareAtmnt){
                	setAttmnt.remove(atment1);
                	for(Attachment atment2 : setAttmnt){
                		if(atment1.BodyLength == atment2.BodyLength && atment1.NAME == atment2.NAME){
                				ids.add(atment1.ID);
                				if(!ids.contains(atment1.ID)){
                					deleteThisAtmt.add(atment1);
                				}
                			}
                	}
                	setAttmnt.add(atment1);
                }
                if(deleteThisAtmt.size() > 0){
                	delete deleteThisAtmt;
                }
                
                
                List<Note> lstCompareNote = [SELECT ID,BODY,Title,ParentID FROM Note WHERE ParentID = :newAgmt.ID];
                List<Note> deleteThisNote = new List<Note>();
                Set<Note> setNote = new Set<Note>();
                Set<ID> idset = new Set<ID>();
                setNote.addAll(lstCompareNote);
                for(Note note1 : lstCompareNote){
                		setNote.remove(note1);
                		for(Note note2 : setNote){
                			if(note1.Body.equals(note2.Body) && note1.Title == note2.Title){
                				idset.add(note1.ID);
                				if(!idset.contains(note1.ID)){
                					deleteThisNote.add(note1);
                				}
                			}
                			setNote.add(note1);
                		}
                	}
                	if(deleteThisNote.size() > 0){
                		delete deleteThisNote;
                	}
                
                List<Id> lstAttachmentIds = new List<Id>();
                for(Attachment att : [SELECT ID,NAME,ParentID FROM Attachment WHERE ParentID = :newAgmt.ID]){
                    lstAttachmentIds.add(att.Id);
                }
                
                EnableMergeService(lstAttachmentIds,newAgmt.Id,apiSessionId,apiServerURL);
            }*/
        }
        return new PageReference('/'+newAgmt.Id);
    }
    
    public PageReference doLogin(){ 
      System.debug('apiSessionId: ' + apiSessionId); 
      System.debug('apiServerURL: ' + apiServerURL); 
      return null; 
     }
    
    @future(Callout = true)
    public static void EnableMergeService(List<Id> lstDocIds,Id agreementId,String sessinId,String serverUrl){
        //String sessionId = apiSessionId;
        //String serverURL = System.Url.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/26.0/' + UserInfo.getOrganizationId();
        String protectionLevel = Apttus.AgreementWebService.getProtectionLevel(UserInfo.getProfileId(),'Convert To Document');
        if(!Test.isRunningTest()){
        	Boolean isMerged = Apttus.MergeWebService.enableAuthoring(agreementId, protectionLevel, lstDocIds,sessinId,serverUrl);
        }
        
        
    }
    
    public PageReference Cancel(){
        return new PageReference('/'+agreementId);
    }
    
}