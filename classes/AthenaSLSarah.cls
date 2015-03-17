public class AthenaSLSarah {
    
    Private Integer featuredIndex;
    Private Integer PersonalizedIndex;    
    Private Integer searchIndex;
    
    Public Integer TileCount {get;set;}
    public String testStrValue { get; set; }
    Public String strSearchValue{get;set;}
    Public boolean ShowSearch{get;set;}
    public static Integer NoOfTile {get;set;} 
    
    Public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
    
    
    Public static String getStaticSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
    
       
    public String getTileCount() {
        return null;
    }
        
    Public User GetLoggedinUserDtls(){    
        User u = [Select Name From User where User.id= :UserInfo.getUserId()];
        return U;
    }    
    
    Private String getUserImage(Id uid){
        User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id=:uid];
        return u.smallPhotoUrl;
    }
    
    public static String getUserImages(Id uid){
        User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id=:uid];
        return u.smallPhotoUrl;
    }
    
    //Featured Start    
    Public ApexPages.standardSetController FeaturedCon{    
        get{
            if(FeaturedCon == null){
                FeaturedCon = new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,description__c,  Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and Featured__c = True]));                      
                FeaturedCon.setPageSize(TileCount);
            }        
            return FeaturedCon;   
        }    
        set;
    }      
   
   
    //Featured Start    
    Public static ApexPages.standardSetController FeaturedLBQuery{    
        get{
            if(FeaturedLBQuery == null){
                FeaturedLBQuery = new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,description__c,  Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and Featured__c = True]));                      
           }        
            return FeaturedLBQuery;   
        }    
        set;
    }
    
    
      public static String GetResourceURL(String resourceName)  
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
    
    @RemoteAction
    public static List<LearningBoardCustomClass> GetFeaturedLB(Integer Text,Integer Next,Integer Prev)
    {
        NoOfTile=Text;
        list<LearningBoardCustomClass> ListFeaturedLB = new List<LearningBoardCustomClass>();
        list<Attachment> attachmentList = new List<Attachment>(); 
        list<id> learningBoardIds= new list<id>();
        List<Learning_Board__c> Learning_Board = new List<Learning_Board__c>();
        Learning_Board = (List<Learning_Board__c>)FeaturedLBQuery.getRecords();
        for (Learning_Board__c lb: Learning_Board )
        {
                   learningBoardIds.add(lb.id);
        }
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
        integer inx=1;
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
   
       
    //Personalized End
    
    Public AthenaSLSarah(){
        TileCount =6;
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
         featuredIndex=0;
         searchIndex=0;
         PersonalizedIndex=0;
         
             
    }
    
    // Search -- Start        
    Public void dosearch(){
        ShowSearch=true;
        searchIndex=0;                            
    }            

   
        
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
    //Common Method -- End
    
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
    }
}