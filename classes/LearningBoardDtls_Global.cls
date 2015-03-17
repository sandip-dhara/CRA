public class LearningBoardDtls_Global extends RestWSResult{

    Public String LearningBoardid {get;set;}
    //Public string Learningid{get;set;}
     
    public LearningBoardDtls_Global(String lbid){
            LearningBoardid = lbid;
            LearningDtls = new list<AthenaSocialLearning_mobile.LearningDtlsCustomClass>();
      }
    Public List<Learning_Board__c> PersonalizedCon{    
    get{
        if(PersonalizedCon== null){        
            List<EntitySubscription> entitySub=new List<EntitySubscription>();
            List<Learning_Board__c>  perlist= new List<Learning_Board__c>();    
            List<Learning_Board__c>  lblist= [select id,Name__c,description__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and id=:LearningBoardid];                           
            
            
            for(Learning_Board__c lb: lblist)
            {                
               entitySub = [select id,Subscriber.name from EntitySubscription where ParentId = :lb.id and SubscriberID =:UserInfo.getUserId()];
               if (entitySub.size()==1 || lb.owner.Id == UserInfo.getUserId())
               {
                   perlist.add(lb);
               }               
            }
            if(perlist.size() < 1)
            {PersonalizedCon = lblist;}
            else
            {PersonalizedCon = perlist;}
            
            return PersonalizedCon;   
            }
        return PersonalizedCon;   
    }    
    set;}
    
        Public User getLearningBoardOwnerDtls()
    {
        User u = [Select u.id, u.SmallPhotoUrl, u.FullPhotoUrl, u.CompanyName,u.AboutMe, u.Division, u.Department, 
        u.Email, u.Phone, u.MobilePhone, u.Employee_Country__c, u.Manager.Name  From User u where u.id in 
        (select ownerid from learning_board__c where id = :this.LearningBoardid)];
        return U;
    }
    
    Public List <AthenaSocialLearning_mobile.LearningDtlsCustomClass> LearningDtls {
        get {
            LearningDtls.clear();            
            list<id> lstLearningIds= new list<id>();
            
            List<Learning_Board_Learning__c> learnings=[select Learning_ID__c,Learning_ID__r.Name__c,
            Learning_ID__r.Description__c,Learning_ID__r.type__c,Learning_ID__r.URL__C,Learning_ID__r.Owner.name 
            from Learning_Board_Learning__c where Learning_ID__r.Is_Active__c = True and 
            Learning_Board_ID__c= : this.LearningBoardid order by Display_Sequence_Nbr__c asc];
            
            for (Learning_Board_Learning__c l:learnings ) {
                lstLearningIds.add(l.Learning_ID__c);
            }
            
            list<Attachment> Att = new List<Attachment>();             
            Att = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :lstLearningIds]; 
                                           
            for (Learning_Board_Learning__c l:learnings ) {
                    AthenaSocialLearning_mobile.LearningDtlsCustomClass lrng = new AthenaSocialLearning_mobile.LearningDtlsCustomClass();
                    
                    lrng.LName=l.Learning_ID__r.Name__c;
                    lrng.LDescription = l.Learning_ID__r.Description__c;
                    lrng.LOwnerName = l.Learning_ID__r.Owner.name; 
                    lrng.LType= l.Learning_ID__r.type__c;   
                    lrng.LURL= l.Learning_ID__r.URL__C; 
                    lrng.LId = l.Learning_ID__c;
                    //lrng.LikedOrNot=LikedOrNotLearn(l.Learning_ID__r.id);
                    lrng.LikeCount=LikedItemCount(l.Learning_ID__r.id);
                        
                    if(lrng.LType=='Video' && lrng.LURL.contains('youtube.com') && lrng.LURL.contains('watch?v=')){
                          lrng.LURL=lrng.LURL.replace('watch?v=', 'embed/');
                    }
                    
                    if(lrng.LType=='Other' && lrng.LURL!=null)
                    {   
                        if(lrng.LURL.contains('.pdf'))
                        {
                          lrng.DocType='PDF';
                        }
                        else if(lrng.LURL.contains('.ppt'))
                        {
                          lrng.DocType='PPT';
                        }                    
                        else if(lrng.LURL.contains('.doc'))
                        {
                          lrng.DocType='DOC';
                        }
                        else
                        {
                          lrng.DocType='OTHER';
                          lrng.DocAttachmentURL= lrng.LURL;
                        }
                    }
                    lrng.StaticImage=true;
                    lrng.ImageAttachmentURL= 'https://hp--esit.cs11.my.salesforce.com/resource/1389777783000/AthenaStaticLearningImage';
                    if(l.Learning_ID__r.type__c=='Other')
                    {    
                        //if(Att.size()<1){//temporarily hardcoding
                         //   lrng.AttachmentURL = 'https://hp--esit--c.cs11.content.force.com/servlet/servlet.FileDownload?file=00PZ00000014m3LMAQ';
                        //}
                        for(Attachment a: Att)
                        { 
                            if(lrng.LId == a.ParentId && (a.ContentType == 'image/jpeg' || a.ContentType == 'image/png'  || a.ContentType == 'image/jpg') )
                            {
                                lrng.AttachmentId = a.Id;
                                lrng.ImageAttachmentId = a.Id;
                                lrng.StaticImage=false;
                                if(a.Id != null){
                                    lrng.AttachmentURL = 'https://hp--esit--c.cs11.content.force.com/servlet/servlet.FileDownload?file='+a.id;
                                    lrng.ImageAttachmentURL = 'https://hp--esit--c.cs11.content.force.com/servlet/servlet.FileDownload?file='+a.id;
                                }
                                //else{//Temporarily hardcoding. Will need to change.
                                 //   lrng.AttachmentURL = 'https://hp--esit--c.cs11.content.force.com/servlet/servlet.FileDownload?file=00PZ00000014m3LMAQ';
                                //}
                                    
                            }                 
                            else if(lrng.LId == a.ParentId)
                            {
                                lrng.DocAttachmentId = a.Id;
                                lrng.DocAttachmentURL= 'https://hp--esit--c.cs11.content.force.com/servlet/servlet.FileDownload?file='+a.id;
                            }
                        }
                    } 
                    else
                    {
                        lrng.StaticImage=false;
                    }
                    
                LearningDtls.add(lrng);
                }        
                return LearningDtls;                
            }   
    set;    
    }
    Public integer LikedItemCount(string itemIdentifier)
    {
        List<Liked_Item__C> li = [select like_count__C from liked_item__C where Item_identifier__C = : itemIdentifier];
        if(li.size()!=0)
        {
            return Integer.ValueOf(li[0].like_count__c);
        }
        else
        {
            return 0;
        }
    }         
       Public String getUserImage(Id uid){
            User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id=:uid];
            return u.smallPhotoUrl;
            }
        public Integer CommentCount(string id){    
        List<FeedItem> commCount = [Select id from FeedItem where parentID=:id];
        return commCount.size();    
    }
}