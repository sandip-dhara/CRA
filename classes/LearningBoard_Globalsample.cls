global class LearningBoard_Globalsample extends RestWSResult {
    public Integer PersonalizedIndex;
    public LearningBoard_Globalsample(String method){
        if(method == 'MyTopics')
        {
         PersonalizedIndex=0;
         PersonalizedLBList = new List<AthenaSocialLearning_mobilesample.LearningBoardCustomClass>(); 
        }
    }
    
    Public List<AthenaSocialLearning_mobilesample.LearningBoardCustomClass> PersonalizedLBList {
    get{
        if(PersonalizedIndex== 0){
            PersonalizedIndex=1;
            PersonalizedLBList.clear();
            getLearningBoards('Personalized');                     
        }                
        return PersonalizedLBList;
    }                 
    set;
    }
    /*Public List<Learning_Board__c> PersonalizedCon{    
    get{
        if(PersonalizedCon== null){        
            List<EntitySubscription> entitySub=new List<EntitySubscription>();
            List<Learning_Board__c>  perlist= new List<Learning_Board__c>();    
            List<Learning_Board__c>  lblist= [select id,Name__c,description__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True order by LastModifiedDate];                           
            
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
    set;}*/
    
    Private List<AthenaSocialLearning_mobilesample.LearningBoardCustomClass> getLearningBoards(String Section) {    
        list<Attachment> attachmentList = new List<Attachment>(); 
        list<id> learningBoardIds= new list<id>();
        List<Learning_Board__c> Learning_Board = new List<Learning_Board__c>();
                		
        List<EntitySubscription> entitySub=new List<EntitySubscription>();
        List<Learning_Board__c>  perlist= new List<Learning_Board__c>();    
        List<Learning_Board__c>  lblist= [select id,Name__c,description__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True order by LastModifiedDate];                           
            
        for(Learning_Board__c lb: lblist)
        {                
            entitySub = [select id,Subscriber.name from EntitySubscription where ParentId = :lb.id and SubscriberID =:UserInfo.getUserId()];
            if (entitySub.size()==1 || lb.owner.Id == UserInfo.getUserId())
            {
                perlist.add(lb);
            }               
        }
        if(perlist.size() < 1 && Section =='Personalized')
        {Learning_Board = lblist;}
        else
        {Learning_Board = perlist;}       
        
        /*if(Section == 'Personalized'){
            Learning_Board = PersonalizedCon;
        }*/
        
        
        for (Learning_Board__c lb: Learning_Board )
        {
            learningBoardIds.add(lb.id);
        }
    
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
    
        for(Learning_Board__c lb: Learning_Board){
            AthenaSocialLearning_mobilesample.LearningBoardCustomClass lbCustom= new AthenaSocialLearning_mobilesample.LearningBoardCustomClass();            
            
            lbCustom.LBName = lb.Name__c; 
            if(lb.description__c!=null){
                if(lb.description__c.length()>53){
                    
                    lbCustom.LBDescription = lb.Description__c.substring(0,53) + '...';
                }
                else{
                    lbCustom.LBDescription=lb.description__c;
                }
            }
            lbcustom.LBOwnerID = lb.OwnerId;
            lbcustom.LBLDescription = lb.Description__c;
            lbCustom.LBOwnerName = lb.Owner.Name;  
            lbCustom.LBOwnerURL = getUserImage(lb.Owner.Id);    
            lbCustom.LBCrtDate = lb.CreatedDate;  
            lbCustom.LBNoOfComments =   CommentCount(lb.id);  
            lbCustom.LBNoOfLikes =   LikedItemCount(lb.id); 
            lbCustom.LbId = lb.id;
            lbCustom.StaticImage = true;
            
            for(Attachment att: attachmentList){
                if(lb.id == att.ParentId  && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png')){
                    lbCustom.AttachmentId = att.Id;
                    lbCustom.StaticImage=false;
                    lbCustom.AttBody = EncodingUtil.Base64Encode(att.body);
                    lbCustom.AttContentType = att.ContentType;
                }  
            }
            if(Section == 'Personalized')
            {
                PersonalizedLBList.add(lbCustom);
            }            
        }
        if(Section == 'Personalized')
        {
            return PersonalizedLBList;
        }

        return null;
    }
       Public String getUserImage(Id uid){
            User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id=:uid];
            return u.smallPhotoUrl;
            }
        public integer LikedItemCount(string itemIdentifier)
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
        
    public Integer CommentCount(string id){    
        List<FeedItem> commCount = [Select id from FeedItem where parentID=:id];
        return commCount.size();    
    }
}