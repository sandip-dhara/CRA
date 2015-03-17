Public class AthenaUserProfileOld {

    Private Integer userOwnedIndex;
    Public String AthenaUserId{get;set;}
    Public String strSearchValue{get;set;}
    public string AvailTags{get;set;}
    
    Public String getSfInstance{
        get{
            return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
    
    Public User getUserDtls(){
        User u = [Select u.name,u.title,  u.SmallPhotoUrl, u.FullPhotoUrl,u.AboutMe, u.Email, u.Phone, u.MobilePhone  From User u where u.id =:this.AthenaUserId];
        return U;
    }
        
    Public User GetLoggedinUserDtls(){
        User u = [Select Name From User where User.id= :UserInfo.getUserId()];
        return U;         
    }
    
    //Like count for the user
   /*Public integer UserLikeCount{
        get{     
            UserLikeCount = 0;
            List<Liked_Item__C> LikdItms= [select like_count__C from liked_item__C where Item_identifier__C = :this.AthenaUserId];
            if(LikdItms.size()!=0)
            {
                UserLikeCount = Integer.ValueOf(LikdItms[0].like_count__c);
            }
            return UserLikeCount;            
        }
        set;
    }*/
    
    //Comment count for the user
    /* Public integer UserCommentCount{
    get{
    //UserCommentCount = 0;
    List<FeedItem> commCount = [Select id from FeedItem where parentID=:AthenaUserId];
    UserCommentCount = commCount.size();
    return UserCommentCount;

    }
    set;
    }*/
    
    Public List<skill__C> getExpertise(){
        List<skill__c> Lskill=[select Name__C from Skill__C where id In (select skill_id__C from user_skill__c where user_id__c=:AthenaUserId) and Is_Active__c=True];
        return Lskill;
    }
    
    /*This method is used get the user like status.
    1 - If the logged in user and the user profile displayed are same, the the like button is not displayed.
    2 - If the user has already liked, then the like button is toggled to unlike button
    3 - If the user has not liked, then the Like button is displayed.*/ 
   /*Public integer getUserLikeStatus{
        get{
            //0- Logged in user and user is same
            //1- Not liked
            //2 - liked
            integer isLiked=1;
            string LgdInUser=UserInfo.getUserId();                         
            if(!LgdInUser.contains(this.AthenaUserId))
            {
                List<Liked_Item__c> LLikedItem = [select Id,Name from Liked_Item__c where Item_Identifier__c = :this.AthenaUserId];
                // Get all Liked_Item__c IDs
                Set<Id> LLikedItemIds = new Set<Id>();
                for (Liked_Item__c lli :LLikedItem) {
                    LLikedItemIds.add(lli.Id);
                }

                // Get all User_Liked_Item__c for all Liked_Item__c
                List<User_Liked_Item__c> lgdUserLiked = new List<User_Liked_Item__c>(
                        [SELECT Id,Liked_Item_ID__c FROM User_Liked_Item__c WHERE
                        User_ID__c = :UserInfo.getUserId() AND Liked_Item_ID__c IN :LLikedItemIds]);

                // Map to hold List of User_Liked_Item__c for each Liked_Item__c IDs
                Map<Id, List<User_Liked_Item__c>> lgdUserLikedMap = new Map<Id, List<User_Liked_Item__c>>();

                for (Id i :LLikedItemIds) {
                    List<User_Liked_Item__c> uliList = lgdUserLikedMap.get(i);
                    if (uliList == NULL) {
                        uliList = new List<User_Liked_Item__c>();
                    }
                    for (User_Liked_Item__c uli :lgdUserLiked ) {
                        if (uli.Liked_Item_ID__c == i) {
                            uliList.add(uli);
                        }
                    }
                    lgdUserLikedMap.put(i, uliList);
                }
                System.Debug('lgdUserLikedMap = ' + lgdUserLikedMap);

                for(Liked_Item__c litem:LLikedItem)
                {                         
                    //list<User_Liked_Item__c> lgdUserLiked =[SELECT Id,Liked_Item_ID__c FROM User_Liked_Item__c WHERE User_ID__c = :UserInfo.getUserId() AND Liked_Item_ID__c = :litem.Id];
                    //if(lgdUserLiked.size() != 0)
                    if (lgdUserLikedMap.get(litem.Id).size() != 0)
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
    }*/
    
    //Learning Board Like Count
    Private integer getLBLikeCount(string itemIdentifier){
        List<Liked_Item__C> li = [select like_count__C from liked_item__C where Item_identifier__C = : itemIdentifier];
        if(li.size()!=0)
        {
        return Integer.ValueOf(li[0].like_count__c);
        }
        return 0;
    }
    
    //Learning Board Comment Count
    Private integer getLBCommentCount(string lbID){
        List<FeedItem> commCount = [Select id from FeedItem where parentID=:lbID];
        return commCount.size();
    }
    
    Public ApexPages.standardSetController UserOwnedCon{    
        get{
            if(UserOwnedCon == null){  
                UserOwnedCon= new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,Default_Image_Name__c,description__c, Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and owner.id=:AthenaUserId]));                           
                UserOwnedCon.setPageSize(4);
            }        
            return UserOwnedCon;   
        }    
        set;
    }    

    Public List<LearningBoardCustomClass> UserOwnedLBList {
        get
        {
            UserOwnedLBList.clear();
            list<Attachment> attachmentList = new List<Attachment>(); 
            list<id> learningBoardIds= new list<id>();
            List<Learning_Board__c> LearningBoards=(List<Learning_Board__c>)UserOwnedCon.getRecords();            

            for (Learning_Board__c lb: LearningBoards)
            {
                learningBoardIds.add(lb.id);
            }
            attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
            List<liked_item__C> LBLikeCountList = [select like_count__c,Item_identifier__C from liked_item__C where Item_identifier__C in :learningBoardIds];
            map<id,decimal> LBLikeCountMap = new map<id,decimal>();        

            for (Id LBId :learningBoardIds) {
                for (Liked_Item__c FI :LBLikeCountList) {
                    if(FI.Item_identifier__C== LBId) {
                        LBLikeCountMap.put(LBId,FI.like_count__c);
                    }
                }                            
            } 

            for(Learning_Board__c lb: LearningBoards){
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
                lbCustom.LBNoOfLikes =   integer.valueof( LBLikeCountMap.get(lb.id));
                lbCustom.LBNoOfLikes = getLBLikeCount(lb.id); 
                system.debug('lb.Default_Image_Name__c'+lb.Default_Image_Name__c);
                //lbCustom.DefaultImageName = get
                  if(lb.Default_Image_Name__c!=''){                        
                        lbCustom.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/' + lb.Default_Image_Name__c;          
                   }
                
                lbCustom.StaticImage = true;
                for(Attachment att: attachmentList){
                    if(lb.id == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
                        lbCustom.AttachmentId = att.Id;
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
    
    Public AthenaUserProfileOld() {
          AvailTags=AthenaUtility.getAvailableTags(); 
        this.AthenaUserId= ApexPages.currentPage().getParameters().get('id');
        UserOwnedLBList=new List<LearningBoardCustomClass>();
        userOwnedIndex=0;
    }
    
    Public void UserOwnedNext(){
        UserOwnedCon.next();
        UserOwnedIndex=0;
    }       

    Public void UserOwnedPrevious(){
        UserOwnedCon.previous();
        UserOwnedIndex=0;       
    }

    //User likes
   /* Public void UserLike(){        
        boolean isLikedItem=false;
        Liked_Item__c litm=new Liked_Item__c();           
        List<Liked_Item__c> lLikedItem = [select Id,Name from Liked_Item__c where Item_Identifier__c=:this.AthenaUserId];

        for(Liked_Item__c litem:lLikedItem)
        {
            isLikedItem=true;  
            litm.id=litem.id;  
        }

        if(!isLikedItem)
        {
            litm.Item_Identifier__c=this.AthenaUserId;
            litm.Item_Name__c='User';
            insert litm;                        
        }


        List<User_Liked_Item__C> UsrlikdItms=[Select id from User_Liked_Item__C where Liked_Item_ID__C=:litm.Id and User_ID__C=:UserInfo.getUserId()];
        if(UsrlikdItms.size()==0)
        {
            User_Liked_Item__C UsrlikdItm=new User_Liked_Item__C();
            UsrlikdItm.Liked_Item_ID__C=litm.ID;
            UsrlikdItm.User_ID__C=UserInfo.getUserId();                
            insert UsrlikdItm;            
        }
    }  */

    //User unlikes 
   /* public void UserUnLike(){        
        List<Liked_Item__c> LikdItms= [select Id,Name from Liked_Item__c where Item_Identifier__c=:this.AthenaUserId];
        if(LikdItms.size()>0)
        {
            List<User_Liked_Item__C> UsrlikdItms= [SELECT Id, User_ID__c, Liked_Item_ID__c FROM User_Liked_Item__c where Liked_Item_ID__c=:LikdItms[0].Id and User_ID__c=:UserInfo.getUserId()];
            if(UsrlikdItms.size()>0)
            {
                for(User_Liked_Item__C usrlikdItm:UsrlikdItms)
                {
                    delete usrlikdItm;            
                }
            }
        }
    } */

    //Search the Learning board: redirects to social learning page to display the search results
    public PageReference dosearch(){
        PageReference pRef = new PageReference('/apex/athenaSocialLearningOld');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.setRedirect(true);
        return pRef;
    }    
    
     private String GetResourceURL(String resourceName)  
      {  
        //Fetching the resource 
        List<StaticResource> resourceList= new List<StaticResource>();
        resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];  
        //Checking if the result is returned or not  
        if(resourceList.size() == 1)  
        {  
           //Getting namespace  
           String namespace = resourceList[0].NamespacePrefix;  
           //Resource URL  
           return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName;   
        }  
        else return '';  
       } 
    
    public class LearningBoardCustomClass{
        Public id AttachmentId{get;set;}
        Public String LBName{get;set;}
        Public String LBDescription{get;set;}   
        Public String LBid{get;set;}
        Public String id{get;set;}
        Public String LBOwnerName{get;set;} 
        Public datetime LBCrtDate{get;set;}
        Public Integer LBNoOfLikes{get;set;}
        Public Integer LBNoOfComments{get;set;}  
        Public boolean StaticImage{get;set;}
        Public String DefaultImageName{get;set;}    
    }
    
}