public with sharing class AthenaUserProfileSmita {

      public Integer userOwnedIndex;
      public String AthenaUserId{get;set;}
      public String strSearchValue{get;set;}
       public String getSfInstance{
        get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }

      public class LearningBoardCustomClass{
            public id AttachmentId{get;set;}
            public String AttBody{get;set;}
            public String AttContentType{get;set;}
            public String LBName{get;set;}
            public String LBDescription{get;set;}   
            public String LBid{get;set;}
            public String id{get;set;}
            public String LBOwnerName{get;set;} 
            public datetime LBCrtDate{get;set;}
            public Object LBNoOfLikes{get;set;}
            public Object LBNoOfComments{get;set;}  
            public boolean StaticImage{get;set;}   
    }   

public User GetLoggedinUserDtls{
    get{
        User u = [Select Name From User where User.id= :UserInfo.getUserId()];
        return U;
    }    
    set;}

   public AthenaUserProfileSmita() {
        this.AthenaUserId= ApexPages.currentPage().getParameters().get('id');
        UserOwnedLBList=new List<LearningBoardCustomClass>();
        userOwnedIndex=0;
    }

    Public User getUserDtls()
    {
        User u = [Select u.name,u.title,  u.SmallPhotoUrl, u.FullPhotoUrl, u.CompanyName,u.AboutMe, u.Division, u.Department, u.Email, u.Phone, u.MobilePhone, u.Employee_Country__c, u.Manager.Name  From User u where u.id =:AthenaUserId];
        return U;
    }
    
    public List<skill__C> getExpertise()
    {
        List<skill__c> Lskill=[select Name__C from Skill__C where id In (select skill_id__C from user_skill__c where user_id__c=:AthenaUserId)];
        return Lskill;
    }
    
    
    
    public ApexPages.standardSetController UserOwnedCon{    
    get{
        if(UserOwnedCon == null){          
            UserOwnedCon= new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,description__c, Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and owner.id=:AthenaUserId]));            
//
            UserOwnedCon.setPageSize(3);
        }        
        return UserOwnedCon;   
    }    
    set;}
     public void UserOwnedNext(){
        UserOwnedCon.next();
        UserOwnedIndex=0;
     }       
       
       public void UserOwnedPrevious(){
        UserOwnedCon.previous();
        UserOwnedIndex=0;       
       }
    
     public List<LearningBoardCustomClass> UserOwnedLBList {
        get
            {               
                list<Attachment> attachmentList = new List<Attachment>(); 
                list<id> learningBoardIds= new list<id>();
                List<Learning_Board__c> Learning_Board=(List<Learning_Board__c>)UserOwnedCon.getRecords();
                UserOwnedLBList.clear();
                for (Learning_Board__c lb: Learning_Board )
                {
                    learningBoardIds.add(lb.id);
                }
                attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
                for(Learning_Board__c lb: Learning_Board){
                    LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();
                    
                    lbCustom.LBName = lb.Name__c; 
                     if(lb.description__c!=null){
                        if(lb.description__c.length()>53){
                            
                            lbCustom.LBDescription = lb.Description__c.substring(0,53) + '...';
                        }
                        else{
                            lbCustom.LBDescription=lb.description__c;
                        }
                      }
                      lbCustom.id=lb.id;
                    lbCustom.LBOwnerName = lb.Owner.Name;  
                    lbCustom.LBCrtDate = lb.CreatedDate;  
                    lbCustom.LBNoOfComments =   getLBCommentCount(lb.id);  
                    lbCustom.LBNoOfLikes =   getLBLikeCount(lb.id); 
                    lbCustom.StaticImage = true;
                    for(Attachment att: attachmentList){
                        if(lb.id == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png')){
                            lbCustom.AttachmentId = att.Id;
                            lbCustom.AttBody = EncodingUtil.Base64Encode(att.body);
                            lbCustom.AttContentType = att.ContentType;
                            lbCustom.LbId = att.ParentId;
                            lbCustom.StaticImage=false;
                        }  
                    }
                    UserOwnedLBList.add(lbCustom);
                }
                                
                return UserOwnedLBList;
            }                 
            set;
            }
    
        //Learning Board Like Count
        Public integer getLBLikeCount(string itemIdentifier)
        {
            List<Liked_Item__C> li = [select like_count__C from liked_item__C where Item_identifier__C = : itemIdentifier];
            if(li.size()!=0)
            {
                return Integer.ValueOf(li[0].like_count__c);
            }
            return 0;
        }       
        
        //Learning Board Comment Count
        Public integer getLBCommentCount(Id lbID){
             List<FeedItem> commCount = [Select id from FeedItem where parentID=:lbID];
            return commCount.size();
        }
        
    /*
    This method is used get the user like status.
    1 - If the logged in user and the user profile displayed are same, the the like button is not displayed.
    2 - If the user has already liked, then the like button is toggled to unlike button
    3 - If the user has not liked, then the Like button is displayed.
    */
    public integer getUserLikeStatus{
     get{
              //0- Logged in user and user is same
              //1- Not liked
              //2 - liked
              integer isLiked=1;
              string LgdInUser=UserInfo.getUserId();                         
              if(!LgdInUser.contains(this.AthenaUserId))
              { 
                List<Liked_Item__c> LLikedItem= [select Id,Name from Liked_Item__c where Item_Identifier__c=:this.AthenaUserId];
                for(Liked_Item__c litem:LLikedItem)
                {                         
                    list<User_Liked_Item__c> lgdUserLiked =[SELECT Id,Liked_Item_ID__c from User_Liked_Item__c where User_ID__c=:UserInfo.getUserId()and Liked_Item_ID__c=:litem.Id];
                    if(lgdUserLiked.size() != 0)
                    {
                        isliked=2; 
                    }
                    return isLiked;                
                }  
              }
              else
              {
                isLiked=0;                                                   
              }
            return isLiked;    
    }    
    set;
    }
    
    //User likes
     public static void UserLike()
     {
            string UserID= ApexPages.currentPage().getParameters().get('id');
            List<Liked_Item__c> lLikedItem = [select Id,Name from Liked_Item__c where Item_Identifier__c=:UserID];
            boolean isLikedItem=false;
            Liked_Item__c litm=new Liked_Item__c();           
            for(Liked_Item__c litem:lLikedItem)
            {
                isLikedItem=true;  
                litm.id=litem.id;  
            }
            if(!isLikedItem)
            {
                litm.Item_Identifier__c=UserID;
                litm.Item_Name__c='User';
                insert litm;                        
            }
            
            User_Liked_Item__C ULikdItm=new User_Liked_Item__C();
            ULikdItm.Liked_Item_ID__C=litm.ID;
            ULikdItm.User_ID__C=UserInfo.getUserId();                
            insert ULikdItm;            
     }  
 
 //Like count for the user
      public integer UserLikeCount{
        get{     
            UserLikeCount = 0;
            List<Liked_Item__C> li = [select like_count__C from liked_item__C where Item_identifier__C = :this.AthenaUserId];
            if(li.size()!=0)
            {
                UserLikeCount = Integer.ValueOf(li[0].like_count__c);
            }
            return UserLikeCount;
            
        }
        set;}
        
   //Comment count for the user
   public integer UserCommentCount{
   get{
       //UserCommentCount = 0;
       List<FeedItem> commCount = [Select id from FeedItem where parentID=:AthenaUserId];
       UserCommentCount = commCount.size();
       return UserCommentCount;
       
   }
   set;
   }
     //User unlikes 
     public  void UserUnLike()
     {        
            List<Liked_Item__c> LLikedItem= [select Id,Name from Liked_Item__c where Item_Identifier__c=:this.AthenaUserId];
            User_Liked_Item__C UserLikdItm= [SELECT Id, User_ID__c, Liked_Item_ID__c FROM User_Liked_Item__c where Liked_Item_ID__c=:LLikedItem[0].Id and User_ID__c=:UserInfo.getUserId()];
            delete UserLikdItm;            
     } 
     
    public PageReference dosearch()
    {
        PageReference pRef = new PageReference('/apex/athenaSocialLearningSmita');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.setRedirect(true);
        return pRef;
    }
 
}