// TEST Comment!
public class pshort_AthenaSocialLearning {
    Public String strSearchValue{get;set;}
    Public boolean ShowSearch{get;set;}
    
     Public class LearningBoardCustomClass{
        public id AttachmentId{get;set;}        
        public String LBName{get;set;}
        public String LBDescription{get;set;}   
        public String LBid{get;set;}
        public String LBOwnerName{get;set;} 
        public String LBOwnerURL{get;set;}
        public Datetime LBCrtDate{get;set;}
        public integer LBNoOfLikes{get;set;}
        public integer LBNoOfComments{get;set;} 
        public boolean StaticImage{get;set;} 
        public string LBOwnerID{get;set;}  
        public String LBImgURL{get;set;}
        public String ServerPath  {get;set;}
        public integer FeaIndex {get;set;}
        public string LikeIcon {get;set;}
        public string CommentIcon {get;set;}
        public String LBCreateDate{get;set;}
        public Integer TotalCount {get;set;}
        public boolean Active{get;set;}
        public boolean existing{get;set;}
    }
      
    public static Integer NoOfTile {get;set;} 
    
        public static integer LikedItemCounts(string itemIdentifier){
        List<Liked_Item__C> li = [select like_count__C from liked_item__C where Item_identifier__C = : itemIdentifier];
        if(li.size()!=0)
        {
            return Integer.ValueOf(li[0].like_count__c);
        }
        return 0;
    }   
        
    Public static Integer CommentCounts(string id){    
        List<FeedItem> commCount = [Select id from FeedItem where parentID=:id];
        return commCount.size();    
    }
    
    Public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }      
        
    Public User GetLoggedinUserDtls(){    
        User u = [Select Name From User where User.id= :UserInfo.getUserId()];
        return U;
    }    
    
        
    private static String getUserImages(Id uid){
        User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id=:uid];
        return u.smallPhotoUrl;
    }
    
      private static String GetResourceURL(String resourceName)  
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
        
        
        private static List<LearningBoardCustomClass> GetLearningBoard(Integer Text,Integer Next,Integer Prev,List<Learning_Board__c> Learning_Board,string Section)
        {
        NoOfTile=Text;
        list<LearningBoardCustomClass> ListFeaturedLB = new List<LearningBoardCustomClass>();
        list<Attachment> attachmentList = new List<Attachment>(); 
        list<id> learningBoardIds= new list<id>();
        
        for (Learning_Board__c lb: Learning_Board )
        {
                   learningBoardIds.add(lb.id);
        }
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
        integer inx=1;
        
        if((Section=='Personalized') && (IsProducer(UserInfo.getUserId()) ||(IsModerator(UserInfo.getUserId()))))
        {
                LearningBoardCustomClass lbproducer= new LearningBoardCustomClass();
                lbproducer.StaticImage = True;
                            lbproducer.FeaIndex =inx;
                            inx++;
                lbproducer.LBName='Create New Board';
                lbproducer.LBDescription ='';
                lbproducer.Active=False;
                lbproducer.existing=False;
                lbproducer.LBOwnerName='';
                ListFeaturedLB.add(lbproducer);
                LearningBoardCustomClass lbLearning= new LearningBoardCustomClass();
                lbLearning.StaticImage = True;
                lbLearning.FeaIndex =inx;
                  inx++;
                lbLearning.LBDescription ='';
                lbLearning.LBOwnerName='';
                lbLearning.LBName='My Learnings';
                lbLearning.Active=False;
                lbLearning.existing=False;
                ListFeaturedLB.add(lbLearning);
                        
        }
        for(Learning_Board__c lb: Learning_Board){
         LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();            
         lbCustom.TotalCount =Learning_Board.size();
            lbCustom.LBName = lb.Name__c; 

            if(lb.description__c!=null){
                if(lb.description__c.length()>53){
                    
                    lbCustom.LBDescription = lb.Description__c.substring(0,53) + '...';
                }
                else{
                    lbCustom.LBDescription=lb.description__c;
                }
            }
            lbCustom.LBOwnerID=lb.Owner.Id;
            lbCustom.LBOwnerName = lb.Owner.Name;  
            lbCustom.LBOwnerURL = getUserImages(lb.Owner.Id);   
            lbCustom.LBCreateDate=(lb.CreatedDate).format('dd MMM yy');
            lbCustom.LBNoOfComments =   CommentCounts(lb.id);  
            lbCustom.LBNoOfLikes =   LikedItemCounts(lb.id); 
            lbCustom.LbId = lb.id;
            lbCustom.StaticImage = true;
            lbCustom.ServerPath ='https://'+URL.getSalesforceBaseUrl().getHost();
            string strStaticImg=    GetResourceURL('athena_images');
            lbCustom.LikeIcon=lbCustom.ServerPath+strStaticImg+'/images/hpit_athena_likeIcon.png';
            lbCustom.CommentIcon =lbCustom.ServerPath+strStaticImg+'/images/hpit_athena_chatIcon.png';
            for(Attachment att: attachmentList){
                if(lb.id == att.ParentId  && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png')){
                    lbCustom.AttachmentId = att.Id;
                    lbCustom.StaticImage=false;
                }  
            }

            if(lbCustom.StaticImage == true)
            {
            lbCustom.LBImgURL=lbCustom.ServerPath+strStaticImg+'/images/antena_defaultImgLearning.png';
            }
            else
            {
            lbCustom.LBImgURL=lbCustom.ServerPath+'/servlet/servlet.FileDownload?file='+lbCustom.AttachmentId;
            }
            lbCustom.FeaIndex =inx;
            
           if(Prev==-1)
            {
                if(inx>next )
                    {
                        ListFeaturedLB.add(lbCustom);
                        if(ListFeaturedLB.size()==NoOfTile)
                            {
                                break;
                            }
                    }
            }
            if(next==-1 )
              {
            if(inx>=(prev-NoOfTile) )
                {
                   ListFeaturedLB.add(lbCustom);
                   if(ListFeaturedLB.size()==NoOfTile)
                    {
                    break;
                    }
                }
            }
            inx++;  
        }        
        return ListFeaturedLB;
        }
    
    Public static Boolean IsModerator(string userID){
    
        String usrProfileName = [select u.Profile.Name from User u where u.id = :userID].Profile.Name;
    
        if(usrProfileName=='ES IT Administrator' || usrProfileName=='IT Administrator')
            Return True;
        else If(usrProfileName=='ES Base Profile'){
            List<PermissionSet> usrAsgndPermSet=[SELECT Id, Name, Label, UserLicenseId FROM PermissionSet where  IsOwnedbyprofile=FALSE and id in (SELECT  PermissionSetId FROM PermissionSetAssignment where AssigneeId=:userID)];
            for(PermissionSet permSet: usrAsgndPermSet){
                If(permSet.Name=='ES_Social_Learning_Moderator')
                    return true;             
            }
            return false;            
        }
        else  
            return false;
    }
        
    Public static Boolean IsProducer(string userID){
         String usrProfileName = [select u.Profile.Name from User u where u.id = :userID].Profile.Name;
         List<PermissionSet> usrAsgndPermSet=[SELECT Id, Name, Label, UserLicenseId FROM PermissionSet where  IsOwnedbyprofile=FALSE and id in (SELECT  PermissionSetId FROM PermissionSetAssignment where AssigneeId=:userID)];
         If(usrProfileName=='ES Base Profile'){
            for(PermissionSet permSet: usrAsgndPermSet){
                If(permSet.Name=='ES_Social_Learning_Producer')
                    return true;                
            }
            return false;        
         }
         else
            return False;
        
    }          

    
    @RemoteAction
    public static List<LearningBoardCustomClass> GetFeaturedLB(Integer Text,Integer Next,Integer Prev)
    {
        List<Learning_Board__c> Learning_Board = new List<Learning_Board__c>();
        Learning_Board=[select id,Name__c,description__c,  Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and Featured__c = True];
        string strSection='';
        return  GetLearningBoard( Text, Next,Prev,Learning_Board,strSection);
    }
  
    @RemoteAction
    public static List<LearningBoardCustomClass> GetPersonalizedLB(Integer Text,Integer Next,Integer Prev)
    {
            List<EntitySubscription> entitySub=new List<EntitySubscription>();
            List<Learning_Board__c>  perlist= new List<Learning_Board__c>(); 
                        List<Learning_Board__c>  lblist;   
             
             
             if((IsModerator(UserInfo.getUserId())) || (IsProducer(UserInfo.getUserId())) )
             {
                 lblist=[select id,Name__c,description__c,Is_Active__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c]; 
             }
             else
             {
                 lblist= [select id,Name__c,description__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True];                           
             }
            for(Learning_Board__c lb: lblist)
            {                
               entitySub = [select id,Subscriber.name from EntitySubscription where ParentId = :lb.id and SubscriberID =:UserInfo.getUserId()];
               if (( entitySub.size()==1 && lb.Is_Active__c == true ) || (lb.owner.Id == UserInfo.getUserId()))
               {
                   perlist.add(lb);
               }               
            }
        string strSection='Personalized';
        return  GetLearningBoard( Text, Next,Prev,perlist,strSection);
    }
       
    //Personalized End
 
    @RemoteAction
    public static List<LearningBoardCustomClass> GetSearchLB(Integer Text,Integer Next,Integer Prev,string newSearchText)
    {
            List<Learning_Board__c> searchResult;
             searchResult= [select id,Name__c,description__c,  Featured__c,Owner.name,Owner.Id,CreatedDate from Learning_Board__c where Name__c like:newSearchText];   
             string strSection='';         
             return  GetLearningBoard( Text, Next,Prev,searchResult,strSection);
    }
 
    
    Public pshort_AthenaSocialLearning(){
        strSearchValue = ApexPages.currentPage().getParameters().get('SearchVal');        
        if(strSearchValue == null) 
        {
             ShowSearch=false;
        }
        else
        {
              ShowSearch=true;
              dosearch();
         }         
    }
    
    // Search -- Start        
    Public void dosearch(){
        ShowSearch=true;
        //searchIndex=0;                            
    }            

}