public with sharing class phLearningppt 
{
     public String LearningBoardsid {get;set;}
     public list < Attachment > listAttVideo {get;set;}
     public list < Attachment > listAttPDF {get;set;}
     public list < Attachment > listAttWord {get;set;}
     Public List < Attachment > Att;
     Public List < Attachment > ppt;     
     public Integer i {get;set;}
    
     public class LearningAttachmentClass
     {
            public id AttachmentId{get;set;}
            public Blob AttBody{get;set;}
            public String AttContentType{get;set;}
            public String LName{get;set;}
            public String LDescription{get;set;}   
            public String Lid{get;set;}
            public String LOwnerName{get;set;}
            public date AttDate{get;set;}       
    }   
    
    public class LBAttachmentClass
    {
            public id AttachmentId{get;set;}
            public String AttBody{get;set;}
            public String AttContentType{get;set;}
            
    }    


    public phLearningppt(ApexPages.StandardController controller) 
    {
        this.LearningBoardsid = ApexPages.currentPage().getParameters().get('id');
        i = 0;
        AttachmentFilesPPT = new list<LearningAttachmentClass>();         
    }
    public List < LearningAttachmentClass > AttachmentFilesPPT 
    {
        get {
                AttachmentFilesPPT.clear();
                list<Attachment> ppt = new List<Attachment>();
                list<id> listLearningId= new list<id>();
                for (Learning__C l: [select Id,Name__c,  type__c, Owner.Name from Learning__c where id in (select Learning_ID__c from Learning_Board_Learning__c where Learning_Board_ID__c = :LearningBoardsid)]) {
                //Description__c,
                listLearningId.add(l.id);
                System.debug('****************************************'+listLearningId);  
            }
                ppt = [SELECT Id, Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :listLearningId];
                
                system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'+ppt);
                                
               for(Learning__c l1: [select Id,Name__c, type__c, Owner.Name from Learning__c ])
                {
                //, Description__c
                 system.debug('###############################################'+l1);
                    LearningAttachmentClass AttFile = new LearningAttachmentClass();
                    AttFile.LName = l1.Name__c; 
//                    AttFile.LDescription = l1.Description__c;
                    AttFile.LOwnerName = l1.Owner.Name; 

                    for(Attachment a: ppt)
                    {               
                        System.debug('a.ContentType ********'+a);
                       if(l1.id == a.parentid && a.ContentType == 'application/x-shockwave-flash')
                        {
                            AttFile.AttachmentId = a.Id;
                            system.debug('=================================================================='+a.Id);
                            AttFile.AttBody = a.body;
                            AttFile.AttContentType = a.ContentType;
                            AttFile.LId = a.ParentId;
                            AttachmentFilesPPT.add(AttFile);
                            System.debug('AttFile.AttachmentId=================>'+AttFile.AttachmentId); 
                            
                        }                 
                    }
                      System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+AttachmentFilesPPT);                       
                } 
                System.debug('888888888888888888888888888888888888888888888888888'+AttachmentFilesPPT);  
                return AttachmentFilesPPT;                
            }   
    set;    
    }    
}