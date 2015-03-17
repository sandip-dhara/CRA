public with sharing class phLearningpdfppt {

 public String LearningBoardsid {
        get;
        set;
    }
    public list < Attachment > listAttVideo {
        get;
        set;
    }
    public list < Attachment > listAttPDF {
        get;
        set;
    }
    public list < Attachment > listAttWord {
        get;
        set;
    }
    Public List < Attachment > Att;
    public Integer i {
        get;
        set;
    }
    
    public class LearningAttachmentClass{
            public id AttachmentId{get;set;}
            public Blob AttBody{get;set;}
            public String AttContentType{get;set;}
            public String LName{get;set;}
            public String LDescription{get;set;}   
            public String Lid{get;set;}
            public String LOwnerName{get;set;}
            public date AttDate{get;set;}       
    }   
    
    public class LBAttachmentClass{
            public id AttachmentId{get;set;}
            public String AttBody{get;set;}
            public String AttContentType{get;set;}
            
    }    


    public phLearningpdfppt(ApexPages.StandardController controller) {
        this.LearningBoardsid = ApexPages.currentPage().getParameters().get('id');
        i = 0;
       // AttachmentFilesVideo = new list<LearningAttachmentClass>();
        AttachmentFilesPDF = new list<LearningAttachmentClass>(); 
        AttachmentFilesPPT = new list<LearningAttachmentClass>(); 
        //AttachmentFilesWord = new list<LearningAttachmentClass>();
        
    }
       public List < LearningAttachmentClass > AttachmentFilesPPT {
        get {
                AttachmentFilesPPT.clear();
                
                list<id> listLearningId= new list<id>();
                for (Learning__C l: [select Name__c,  type__c, Owner.Name from Learning__c where id in (select Learning_ID__c from Learning_Board_Learning__c where Learning_Board_ID__c = : this.LearningBoardsid)]) {
//Description__c,
                listLearningId.add(l.id);
                }
                
                for(Learning__c l1: [select Name__c,  type__c, Owner.Name from Learning__c where id in (select Learning_ID__c from Learning_Board_Learning__c where Learning_Board_ID__c = : this.LearningBoardsid) AND Type__c = 'MS PPT' Limit 3])
                {
                //Description__c,
                    LearningAttachmentClass AttFile = new LearningAttachmentClass();
                    AttFile.LName = l1.Name__c; 
                   // AttFile.LDescription = l1.Description__c;
                    AttFile.LOwnerName = l1.Owner.Name; 
                    List<ContentDocumentLink> c =[SELECT Id, ContentDocument.LastReferencedDate,ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedById, ContentDocument.LastModifiedDate FROM ContentDocumentLink WHERE LinkedEntityId = :l1.Id Limit 1];
                    
                        if(c.size() >0 )
                        {
                            AttFile.AttachmentId = c[0].ContentDocumentId;
                            //AttFile.AttBody = a.body;
                            //AttFile.AttContentType = a.ContentType;
                            AttFile.LId = l1.Id;
                            AttFile.AttDate = date.valueof(c[0].ContentDocument.LastReferencedDate);                            
                            AttachmentFilesPPT.add(AttFile);
                        }                 
                    
                    System.debug('??????3');                       
                }
                return AttachmentFilesPPT;                
            }   
    set;    
    }    
        
    public List < LearningAttachmentClass > AttachmentFilesPDF {
        get {
        AttachmentFilesPDF.clear();
                
                list<id> listLearningId= new list<id>();
                for (Learning__C l: [select Name__c,  type__c, Owner.Name from Learning__c where id in (select Learning_ID__c from Learning_Board_Learning__c where Learning_Board_ID__c = : this.LearningBoardsid)]) {
//Description__c,
                listLearningId.add(l.id);
                }
            
                //0Att = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :listLearningId]; 
                
                for(Learning__c l1: [select Name__c,  type__c, Owner.Name from Learning__c where id in (select Learning_ID__c from Learning_Board_Learning__c where Learning_Board_ID__c = : this.LearningBoardsid) AND Type__c = 'PDF' Limit 3])
                {
                //Description__c,
                    LearningAttachmentClass AttFile = new LearningAttachmentClass();
                    AttFile.LName = l1.Name__c; 
                   // AttFile.LDescription = l1.Description__c;
                    AttFile.LOwnerName = l1.Owner.Name;    
                    
                    List<ContentDocumentLink> c =[SELECT Id, ContentDocument.LastReferencedDate,ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedById, ContentDocument.LastModifiedDate FROM ContentDocumentLink WHERE LinkedEntityId = :l1.Id Limit 1];
                    
                        if(c.size() >0 )
                        {
                            AttFile.AttachmentId = c[0].Id;
                            //AttFile.AttBody = a.body;
                            //AttFile.AttContentType = a.ContentType;
                            AttFile.LId = l1.Id;
                            AttFile.AttDate = date.valueof(c[0].ContentDocument.LastReferencedDate);                            
                            AttachmentFilesPDF.add(AttFile);
                        }                 
                    
                    System.debug('??????3');                       
                }
    return  AttachmentFilesPDF;
    }
    set;    
    }
     public LBAttachmentClass LearningBoardAtt {
        get
            {             
                    attachment att = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid = :this.LearningBoardsid]; 
                    LBAttachmentClass LBAttachment = new LBAttachmentClass();        
                    LBAttachment.AttBody = EncodingUtil.Base64Encode(att.body);   
                    LBAttachment.AttContentType = att.ContentType;                
                return LBAttachment;
            }                 
            set;
            }
   


}