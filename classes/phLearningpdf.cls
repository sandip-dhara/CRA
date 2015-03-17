public with sharing class phLearningpdf {
 public String LearningBoardsid {get;set;}
    public list < Attachment > listAttVideo {get;set;}
    public list < Attachment > listAttPDF {get;set;}        
    public list < Attachment > listAttWord {get;set;}
    Public List < Attachment > Att;
    public Integer i {get;set;}
    
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
    public phLearningpdf(ApexPages.StandardController controller) {
        this.LearningBoardsid = ApexPages.currentPage().getParameters().get('id');
        i = 0;
        AttachmentFilesPDF = new list<LearningAttachmentClass>();       
    }        
    public List < LearningAttachmentClass > AttachmentFilesPDF {
    get 
        {
            AttachmentFilesPDF.clear();
            list<id> listLearningId= new list<id>();
            for (Learning__C l: [select Name__c, type__c, Owner.Name from Learning__c where id in (select Learning_ID__c from Learning_Board_Learning__c where Learning_Board_ID__c = : this.LearningBoardsid)]) {
// Description__c,
                listLearningId.add(l.id);
                //system.debug('$$'+listLearningId);
            }
            system.debug('$$'+listLearningId);  
            //0Att = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :listLearningId]; 
            for(Learning__c l1: [select Name__c, type__c, Owner.Name from Learning__c where id in (select Learning_ID__c from Learning_Board_Learning__c where Learning_Board_ID__c = : this.LearningBoardsid) AND Type__c = 'MS PPT'])
            {
            //, Description__c
                LearningAttachmentClass AttFile = new LearningAttachmentClass();
                AttFile.LName = l1.Name__c; 
                //AttFile.LDescription = l1.Description__c;
                AttFile.LOwnerName = l1.Owner.Name;    
                system.debug('#@'+l1);
                system.debug('%%'+l1.Id);
                List<Attachment> c1 = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid = :l1.Id];
                List<ContentDocumentLink> c =[SELECT Id, ContentDocument.LastReferencedDate, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedById, ContentDocument.LastModifiedDate FROM ContentDocumentLink WHERE LinkedEntityId = :l1.Id];
                system.debug('&&'+c.size());
                if(c.size() >0 ){
                    AttFile.AttachmentId = c[0].Id;
                    AttFile.LId = ID.Valueof(c[0].ContentDocument.LatestPublishedVersionId);
                    AttachmentFilesPDF.add(AttFile);
                }
                else if(c1.size() >0){
                    AttFile.AttachmentID =  c[0].Id;
                    AttFile.LId = l1.Id;
                    AttachmentFilesPDF.add(AttFile);
                }
                system.debug('&&'+c1.size()+'$$'+c1);
                System.debug('??????3');                
            }
            system.debug('!!!'+AttachmentFilesPDF);    
            return AttachmentFilesPDF;                   
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