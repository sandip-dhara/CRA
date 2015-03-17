public with sharing class phLearningAttachment {
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

 public phLearningAttachment(ApexPages.StandardController controller) {
        this.LearningBoardsid = ApexPages.currentPage().getParameters().get('id');
        i = 0;
        AttachmentFilesVideo = new list<LearningAttachmentClass>();
       /* AttachmentFilesPDF = new list<LearningAttachmentClass>(); 
        AttachmentFilesPPT = new list<LearningAttachmentClass>(); 
        AttachmentFilesWord = new list<LearningAttachmentClass>();*/
        
    }
     public List < LearningAttachmentClass > AttachmentFilesVideo {
        get {
                AttachmentFilesVideo.clear();
                list<Attachment> Att = new List<Attachment>();             
                list<id> listLearningId= new list<id>();
                for (Learning__C l: [select Name__c,  type__c, Owner.Name from Learning__c where id in (select Learning_ID__c from Learning_Board_Learning__c where Learning_Board_ID__c = : this.LearningBoardsid)]) {
//Description__c,
                listLearningId.add(l.id);
                }
            
                Att = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :listLearningId]; 
        
                for(Learning__c l1: [select Name__c,  type__c, Owner.Name from Learning__c ])
                {
                //Description__c,
                    LearningAttachmentClass AttFile = new LearningAttachmentClass();
                    AttFile.LName = l1.Name__c; 
                   // AttFile.LDescription = l1.Description__c;
                    AttFile.LOwnerName = l1.Owner.Name;            
                    for(Attachment a: Att)
                    {                      
//                        if(l1.id == a.ParentId && a.ContentType == 'video/mp4')
                                            if(l1.id == a.ParentId && a.ContentType == 'video/avi')
                        {
                            AttFile.AttachmentId = a.Id;
                            AttFile.AttBody = a.body;
                            AttFile.AttContentType = a.ContentType;
                            AttFile.LId = a.ParentId;
                            AttachmentFilesVideo.add(AttFile);
                        }                 
                    }
                    System.debug('??????3');                       
                }
                  System.debug('mags' + AttachmentFilesVideo);             
                  return AttachmentFilesVideo;                
            }   
    set;    
    }
}