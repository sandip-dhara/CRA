/**********************************************************
* Class Name: Apttus_AgreementRequestCreation 
* Author: HP
* Date: 20-April-2013.
* Requirement # Request Id :5801
* Description: Agreement creation when Request submitted on SR.
***********************************************************/
public class Apttus_AgreementRequestCreation {
 /**
    * @description: Update the SR once the agreement is created with agreement Row Id.
    * @param: list of SObject - agreement
  **/ 
  public static void updateSR(List<Apttus__APTS_Agreement__c > AgreementList){
    List<Id> agreementIdList =new List<Id>();
    List<Id> agreementSRIdList=new List<Id>();
    List<Id> supportIds=new List<Id>();
    List<Support_Request__c > supportupdate=new List<Support_Request__c >();
// Generating the list of agreement ids and support request ids from agreement 
    for(Apttus__APTS_Agreement__c agreement: AgreementList){
        agreementIdList.add(agreement.id);
        agreementSRIdList.add(agreement.SR_Id__c);
    }
    List<Apttus__APTS_Agreement__c>  apttusagreementIdList= [select id,SR_Id__c,Legal_Owner__c,Apttus__Status__c ,Apttus__FF_Agreement_Number__c 
                                                                      from Apttus__APTS_Agreement__c where id IN: agreementIdList ];
    List<Support_Request__c> supportList=[select id from Support_Request__c where id IN: agreementSRIdList];
// Updating the support request with agrement row ID.  
    for(Support_Request__c support :supportList){
      for(Apttus__APTS_Agreement__c agrmt: apttusagreementIdList){
         if(support.id==agrmt.SR_Id__c){
             support.Agreement_Number__c=agrmt.Apttus__FF_Agreement_Number__c;
             support.System_Support_Request_Long_Nr__c=agrmt.id;
             supportupdate.add(support);
             supportIds.add(support.id);
             }
         }
    }
// Updating the Support Request object
     update supportupdate;
// Associating the attachemnts to the Agreement from SR object   
     createAllAttachmentForARObj(supportIds);
// Associating the NOTES to the Agreement from SR object         
     createAllNoteForARObj(supportIds);
// Sending a notification to the Submitor whenever the agreement was created.
     sendEmailToAllSubmitor(supportupdate);
 }
    /**
    * @description: Method to insert attachment in agreement when ever submitting the Request.
    * @param: list of SObject - attachment
    **/
     public static void createAllAttachmentForARObj(List<id> supportIds){
        Map<id,List<Attachment>> attachementSRMap =new Map<id,List<Attachment>>();
        List<Attachment> attachmentListAll=new List<Attachment>();
        if(HPUtils.AgreementInsertForAtta == False){
           List<Attachment> attachmentList=[select id,name,body,contentType,parentid from Attachment where parentid IN:supportIds];
           HPUtils.AgreementInsertForAtta =True;
            for(Attachment attachment: attachmentList){
                if(attachementSRMap.containsKey(attachment.parentid)){
                   attachementSRMap.get(attachment.parentid).add(attachment);
                }
                else{
                   attachementSRMap.put(attachment.parentid,new List<attachment>());
                   attachementSRMap.get(attachment.parentid).add(attachment);
                }
            }
            List<Support_Request__c> supportRequestList=[select id,System_Support_Request_Long_Nr__c from Support_Request__c where id IN:supportIds];
            for(id supp: attachementSRMap.keySet()){
                 for(Support_Request__c support :supportRequestList){
                     if(supp==support.id){
                        for(attachment attcah: attachementSRMap.get(supp)){
                            if(support.System_Support_Request_Long_Nr__c!=null){
                              Attachment attachment =new Attachment();
                              attachment.name=attcah.name;
                              attachment.body=attcah.body;
                              attachment.contentType=attcah.contentType;
                              attachment.parentId=support.System_Support_Request_Long_Nr__c;
                              attachmentListAll.add(attachment);
                           }
                        }               
                     }
                 }
              }
             insert attachmentListAll;
           }
        }
    /**
    * @description: Method to insert note in agreement after insert attahment on SR
    * @param: list of SObject - note
    **/
 public static void createAllNoteForARObj(List<id> supportIds){
        Map<id,List<Note>> NoteSRMap =new Map<id,List<Note>>();
        List<Note> NoteListAll=new List<Note>();
        if(HPUtils.AgreementInsertForNote == False){
          List<Note> NoteList=[select id,body,title,parentid,isPrivate from Note where parentid IN:supportIds];
          HPUtils.AgreementInsertForNote =True;
            for(Note Note: NoteList){
                if(NoteSRMap.containsKey(Note.parentid)){
                   NoteSRMap.get(Note.parentid).add(Note);
                }
                else{
                   NoteSRMap.put(Note.parentid,new List<Note>());
                   NoteSRMap.get(Note.parentid).add(Note);
                }
            }
            List<Support_Request__c> supportRequestList=[select id,System_Support_Request_Long_Nr__c from Support_Request__c where id IN:supportIds];
            for(id supp: NoteSRMap.keySet()){
                 for(Support_Request__c support :supportRequestList){
                     if(supp==support.id){
                        for(Note nt:NoteSRMap.get(supp)){
                            if(support.System_Support_Request_Long_Nr__c!=null){
                              Note note =new Note();
                              note.body=nt.body;
                              note.title=nt.title;
                              note.isPrivate=nt.isPrivate;
                              note.parentId=support.System_Support_Request_Long_Nr__c;
                              noteListAll.add(Note);
                           }
                        }               
                     }
                 }
              }
             insert noteListAll;
           }
         }
   /**
    * @description: Trigger the notification to submitter when agreement inserted.
    * @param: list of SObject - Support Request.
    **/
       public static void sendEmailToAllSubmitor(List<Support_Request__c> supportList){
       List<Messaging.SingleEmailMessage> mailList=new List<Messaging.SingleEmailMessage>();
       if(HPUtils.AgreementInsertForMail == False){
         HPUtils.AgreementInsertForMail = True;
         EmailTemplate SRTemplate= [SELECT id FROM EmailTemplate WHERE developerName = 'Support_Request_Email_notification']; 
           for(Support_Request__c support : supportList){
              id pareentID=support.id;
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ; 
              mail.setTargetObjectId(userInfo.getUserId());
              mail.saveAsActivity = false;
              mail.setTemplateId(SRTemplate.id);
              mail.whatId=pareentID;
              mailList.add(mail);
           }
         }
        if(mailList.size()>0){
           Messaging.sendEmail( mailList );       
        }
     }
      /**
    * @description: Method to Adding the products from Oppty to the agreement when submitting the Request.
    * @param: list of SObject - Agreement
    **/
    public static void addAllProductsToAgreementLineItem(List<Apttus__APTS_Agreement__c> agreementList){
       if(HPUtils.insertProductsToAgreementFlag == False){
         if(test.isRunningTest()== true){
            HPUtils.insertProductsToAgreementFlag = True;
        }
        List<Apttus__AgreementLineItem__c> agreementLineItemList=new List<Apttus__AgreementLineItem__c>();
        Map<Apttus__APTS_Agreement__c,id> agreementOpportunityMap=new Map<Apttus__APTS_Agreement__c,id>();
        Map<Apttus__APTS_Agreement__c,List<OpportunityLineItem>> agreementOpportunityLineItemMap=new Map<Apttus__APTS_Agreement__c,List<OpportunityLineItem>>();
        List<Id> agreementOpptyIdsList=new List<Id>();
// Generating the Map of agreement with opportuntiy.    
        for(Apttus__APTS_Agreement__c aptts :agreementList){
            agreementOpptyIdsList.add(aptts.Apttus__Related_Opportunity__c);
            agreementOpportunityMap.put(aptts,aptts.Apttus__Related_Opportunity__c);
            }
// Retreving the OpportuntiyLineItem from opportuntiy.          
        List<OpportunityLineItem> OpportunityProductsList =[Select Id,opportunityid,Business_Group__c,Quantity,UnitPrice,Product__c,Subtotal,ServiceDate,PricebookEntry.Product2.Name,GBU__c,HasSchedule
                                              from OpportunityLineItem where OpportunityId IN:agreementOpptyIdsList];
// Genrating the Map of agreement with opptyLineItem.                                     
        for(Apttus__APTS_Agreement__c agrmt :agreementOpportunityMap.keySet()){
            agreementOpportunityLineItemMap.put(agrmt,new List<OpportunityLineItem>());
        }       
        for(Apttus__APTS_Agreement__c agrmt :agreementOpportunityLineItemMap.keySet()){
            for(OpportunityLineItem opptyLine :OpportunityProductsList){
                if(agreementOpportunityMap.get(agrmt)==opptyLine.opportunityid){
                   agreementOpportunityLineItemMap.get(agrmt).add(opptyLine);
                }
            }
        }                     
// Adding the products to the agreementLineItem.        
        for(Apttus__APTS_Agreement__c agreement :agreementOpportunityLineItemMap.keySet()){
            for(OpportunityLineItem olitem : agreementOpportunityLineItemMap.get(agreement)){
                Apttus__AgreementLineItem__c agreementLineItem=new Apttus__AgreementLineItem__c();
                agreementLineItem.Apttus__AgreementId__c=agreement.Id;
                agreementLineItem.Apttus__ProductId__c=olitem.Product__c;
                agreementLineItem.Apttus__Quantity__c=olitem.Quantity;
                agreementLineItem.Apttus__NetPrice__c=olitem.UnitPrice;
                agreementLineItemList.add(agreementLineItem);
                }
        }
         insert agreementLineItemList;                        
     }
   }
 }