global class AthenaSocialLearning_mobile extends RestWSResult{
    
    
    public User GetLoggedinUserDtls{
    get{
        User u = [Select Name From User where User.id= :UserInfo.getUserId()];
        return U;
    }    
    set;}
    
    public class LearningBoardCustomClass{ 
            public id AttachmentId{get;set;}
            public String AttBody{get;set;}
            public String AttContentType{get;set;}
            public String LBName{get;set;}
            public String LBDescription{get;set;}   
            public String LBid{get;set;}
            public String LBOwnerName{get;set;} 
            public String LBOwnerURL{get;set;}
            public datetime LBCrtDate{get;set;}
            public integer LBNoOfLikes{get;set;}
            public integer LBNoOfComments{get;set;} 
            public boolean StaticImage{get;set;}  
            public string LBLDescription{get;set;}
            public string LBOwnerID{get;set;}           
    }   
       Public class LearningDtlsCustomClass{
        public id AttachmentId{get;set;}
        public String LName{get;set;}
        public String LDescription{get;set;}
        public string LType{get;set;}   
        public String Lid{get;set;}
        public String LOwnerName{get;set;}
        public String LURL{get;set;}
        public string DocType{get;set;}  
        public boolean StaticImage{get;set;}   
        public integer LikeCount{get;set;}   
        public boolean LikedOrNot{get;set;}    
        public string AttachmentURL{get;set;}
        //Added below properties        
        public id ImageAttachmentId{get;set;}
        public string ImageAttachmentURL{get;set;}        
        public id DocAttachmentId{get;set;}
        public string DocAttachmentURL{get;set;}        
        
    }
    
    public AthenaSocialLearning_mobile(){}
              
           Public String getUserImage(Id uid){
            User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id=:uid];
            return u.smallPhotoUrl;
            }
        
         
    
        public Integer CommentCount(string id){

             system.debug('## In CommentCount Method' + id);
            List<FeedItem> commCount = [Select id from FeedItem where parentID=:id];
            return commCount.size();
        }
    
    
}