public class SLP_ViewAllCommunities {

    /*public SLP_ViewAllCommunities(SLP_ViewAllCommunities controller) {
     CommunityResult=new List<LearningBoardCustomClass>();
GetCommunities();
    }*/
    public SLP_ViewAllCommunities() {
     CommunityResult=new List<LearningBoardCustomClass>();
GetCommunities();
    }

 Public String strSearchValue{get;set;}
    Public boolean ShowSearch{get;set;}
      public string AvailTags{get;set;}
      public Integer TopicResultCount{get;set;}
      public Integer LBResultCount{get;set;}
      public Integer PeopleResultCount{get;set;}
      public Integer CommunityResultCount{get;set;}
      public class LearningBoardCustomClass{
        Public id AttachmentId{get;set;}
        Public String LBName{get;set;}
        Public String LBDescription{get;set;}  
        Public id TopicId{get;set;}
        Public string TopicName{get;set;} 
        Public String LBid{get;set;}
        Public String id{get;set;}        
        Public DateTime LBCrtDate{get;set;}
        Public Integer LBNoOfLikes{get;set;}
        Public Integer LBNoOfComments{get;set;}  
        Public boolean StaticImage{get;set;}
        Public String DefaultImageName{get;set;} 
         public String LBOwnerName{get;set;} 
        public String LBOwnerURL{get;set;}
        public string LBOwnerID{get;set;}  
        public String LBOwnerTitle{get;set;} 
        public Decimal AvgRating{get;set;} 
        public String TopicURL{get;set;}
        public String TopicType{get;set;}
        public String TopicDocType{get;set;}
    } 
    public class PeopleCustomClass {
        Public id Id{get;set;}
        Public String Name{get;set;}
        Public String Title{get;set;} 
        Public String Department{get;set;} 
        Public String SmallImageName{get;set;} 
        Public String FullImageName{get;set;} 
        Public String TitleDepartment{get;set;} 
        
    }
         

    
    Public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }

    public List<LearningBoardCustomClass> CommunityResult{get;set;}



     Private void GetCommunities()
    {
    list<LearningBoardCustomClass> ListFeaturedLB = new List<LearningBoardCustomClass>();
    list<Attachment> attachmentList = new List<Attachment>(); 
    list<id> communityIds= new list<id>();
    string resourceURL= GetResourceURL('img_athena');
    List<FeedItem> feedItemsLst=getLBCommentCountLst();
    List<User> userImagesLst=getCommunityUserImagesLst();
    List<FeedItem> finalFeedsLst=new List<FeedItem>();
    string userImageUrl='';
    integer commentCount=0;
   // String  GString= '%'+ strSearchValue.trim() + '%';
    SET<ID> finalCommunityIdSet = new SET<ID>();
         
    List<Community__c> communitySrchRslt= new List<Community__c>([SELECT Id,Name__c,Name FROM Community__c WHERE isActive__c=true]);
        
    for(Community__c comm : communitySrchRslt){
        finalCommunityIdSet.add(comm.id);
    }       

    List<Community__c> searchResult = [select id,Name__c,description__c,Default_Image_Name__c,IsActive__c, Owner.name,Owner.Id,Owner.title,CreatedDate from Community__c where IsActive__c = True and id IN:finalCommunityIdSet Order by LastModifiedDate Desc];
        
        for (Community__c comm: searchResult)
        {
           communityIds.add(comm.id);
        }

        List<string> contype=new List<string>();
           contype.add('image/jpeg');
           contype.add('image/png');
           contype.add('image/jpg');
           contype.add('image/gif');

           Map<String,string> AttMap = new Map<String,string>();   
           list<Attachment> Att = [SELECT Id,ParentId FROM Attachment WHERE Parentid in :communityIds and ContentType in:contype];
           for (Attachment at : Att)
           {                        
              AttMap.put(at.ParentId,at.Id);            
           }                      

       for(Community__c comm: searchResult){
                LearningBoardCustomClass commCustom= new LearningBoardCustomClass();

                if(comm.Name__c != null)
                {
                    if(comm.Name__c.length() > 38)
                    {                    
                        commCustom.LBName = comm.Name__c.substring(0,38) + '...';
                    }
                    else
                    {
                        commCustom.LBName = comm.Name__c;
                    }
                }


                if(comm.description__c!=null){
                    if(comm.description__c.length()>75){                    
                        commCustom.LBDescription = comm.Description__c.substring(0,75) + '...';
                    }
                    else{
                        commCustom.LBDescription=comm.description__c;
                    }
                }                  
                        
                for(User userData:userImagesLst)
                {
            if(userData.Id==comm.Owner.Id)
                userImageUrl=userData.SmallPhotoUrl;
                }
                for(FeedItem commentData:feedItemsLst)
                {
            if(commentData.Id==comm.Id)
            {
                finalFeedsLst.add(commentData);                
            }
            commentCount=finalFeedsLst.size();
                }
                        
                commCustom.id=comm.id;
                commCustom.LBid = comm.id;
                commCustom.LBOwnerID=comm.Owner.Id;
                commCustom.LBOwnerName = comm.Owner.Name;  

                if(comm.Owner.Name != null)
                {
                    if(comm.Owner.Name.length() > 16)
                        commCustom.LBOwnerName = comm.Owner.Name.substring(0, 16) + '...';
                    else
                        commCustom.LBOwnerName = comm.Owner.Name;
                }
                

                commCustom.LBOwnerURL = userImageUrl;    
                if(comm.Owner.title!= null)
                {
                    commCustom.LBOwnerTitle = comm.Owner.title;
                     if(comm.Owner.title.length() > 25)
                     {                            
                        commCustom.LBOwnerTitle = comm.Owner.title.substring(0, 25) + '...';
                     }
                     else
                     {
                        commCustom.LBOwnerTitle = comm.Owner.title;
                     }
                }
                commCustom.LBCrtDate = comm.CreatedDate;
                commCustom.LBNoOfComments = commentCount;  
                if(comm.Default_Image_Name__c!=''){                        
                        commCustom.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() +resourceURL+ '/img_athena/' + comm.Default_Image_Name__c;         
                }
                
                commCustom.StaticImage = true;

                if(AttMap.containskey(comm.id))
                {
                    commCustom.AttachmentId = AttMap.get(comm.id);
                    commCustom.StaticImage=false;
                }
                CommunityResult.add(commCustom);
            }  
            CommunityResultCount=CommunityResult.size();
            feedItemsLst=null;
            userImagesLst=null;               
    }
    
    
    
    
        private List<User> getLearningBoardUserImagesLst(){
        List<User> userImgLst = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id IN (select ownerId from learning_board__c)];
        return userImgLst;
    }
    
    private List<User> getTopicsUserImagesLst(){
        List<User> userImgLst = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id IN (select ownerId from learning__c)];
        return userImgLst;
    }

    private List<User> getCommunityUserImagesLst(){
        List<User> userImgLst = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id IN (select ownerId from community__c)];
        return userImgLst;
    }
    
    private List<FeedItem> getLBCommentCountLst(){
        List<FeedItem> commCount = [Select id from FeedItem];
        return commCount;
    }
    
    //Learning Board Comment Count
    Private integer getLBCommentCount(string lbID){
        List<FeedItem> commCount = [Select id from FeedItem where parentID=:lbID];
        return commCount.size();
    }
    
    
    Private String getUserImage(Id uid){
        User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id=:uid];
        return u.smallPhotoUrl;
    }
    
    Public User GetLoggedinUserDtls(){
        User u = [Select Name,SmallPhotoUrl From User where User.id= :UserInfo.getUserId()];
        return U;
    }
  public PageReference dosearch()
    {
            PageReference pRef = ApexPages.currentPage();
            pRef = new PageReference('/apex/AthenaCreateLearningBoard');
            pRef.setRedirect(true);
           return pRef;
    }  
    Public boolean IsLearningBoardCreator
    { 
       get
          { 
            AthenaUserAccess usrAccs=new AthenaUserAccess(); 
            if(usrAccs.IsModerator(UserInfo.getUserId()) || usrAccs.IsProducer(UserInfo.getUserId()) )
                return true; 
            else
                return false;
           } 
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
    
        
}