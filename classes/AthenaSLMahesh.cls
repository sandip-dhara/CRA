public class AthenaSLMahesh {
    
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
    Public static ApexPages.standardSetController FeaturedConn{    
        get{
            if(FeaturedConn == null){
                FeaturedConn = new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,description__c,  Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and Featured__c = True]));                      
                //FeaturedConn.setPageSize(NoOfTile);
            }        
            return FeaturedConn;   
        }    
        set;
    }
    
    
      public static String GetResourceURL(String resourceName)  
    {  
        //Fetching the resource 
        List<StaticResource> resourceList=       new List<StaticResource>();
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
    public static List<LearningBoardCustomClass> FeaturedL(Integer Text,Integer Next,Integer Prev)
    {

         NoOfTile=Text;
         list<LearningBoardCustomClass> fut = new List<LearningBoardCustomClass>();
        list<LearningBoardCustomClass> futCust = new List<LearningBoardCustomClass>();
        
        list<Attachment> attachmentList = new List<Attachment>(); 
        list<id> learningBoardIds= new list<id>();
        List<Learning_Board__c> Learning_Board = new List<Learning_Board__c>();
      

         Learning_Board = (List<Learning_Board__c>)FeaturedConn.getRecords();

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
            //Datetime myDate = datetime.valueOf(lb.CreatedDate); 
            lbCustom.LBCreateDate=(lb.CreatedDate).format('dd MMM yy');
           
           system.debug('lbCustom.LBCrtDate'+lbCustom.LBCrtDate);
           
            
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

            if(lbCustom.StaticImage == true){
            //LBImgURL

                
            lbCustom.LBImgURL=lbCustom.ServerPath+strStaticImg+'/images/antena_defaultImgLearning.png';
            }
            else{
            lbCustom.LBImgURL=lbCustom.ServerPath+'/servlet/servlet.FileDownload?file='+lbCustom.AttachmentId;
            }
            lbCustom.FeaIndex =inx;
            
           if(Prev==-1){
            if(inx>next ){
            
             fut.add(lbCustom);
             if(fut.size()==NoOfTile){
             break;
             }
           
            }
            }
            if(next==-1 ){
            if(inx>=(prev-NoOfTile) ){
            
             fut.add(lbCustom);
             if(fut.size()==NoOfTile){
             break;
             }
           
            }
            
            }
            inx++;
            
               
        }        




        return fut;
        
    }
    
    Public List<LearningBoardCustomClass> FeaturedLBList {
    get
        {
            if(featuredIndex == 0){
                featuredIndex=1;
                FeaturedLBList.clear();
                getLearningBoards('Featured');
                }               
            return FeaturedLBList;
            }                 
        set;
    }
    //Featured End
       
    //Personalized Start
    Public ApexPages.standardSetController PersonalizedCon{    
    get{
        if(PersonalizedCon== null){        
            //List<EntitySubscription> entitySub=new List<EntitySubscription>();
            List<Learning_Board__c>  perlist= new List<Learning_Board__c>();    
            List<Learning_Board__c>  lblist= [select id,Name__c,description__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True];                           
            
            /*start added by Murali R2*/
            // Get all LearningBoard Ids
            Set<Id> LBIds = new Set<Id>();
            for (Learning_Board__c lb :lblist) {
                LBIds.add(lb.Id);
            }
            
            // Get all EntitySubscription records
            List<EntitySubscription> entitySub = new List<EntitySubscription>([SELECT Id, Subscriber.name,ParentId FROM EntitySubscription WHERE ParentId IN :LBIds AND SubscriberID = :UserInfo.getUserId()]);
            
            // Get Map to relate which EntitySubscription records are retrieved for each LearningBoard (using LearningBoard Id)
            Map<Id,boolean> LbEsMap = new Map<Id,boolean>();
            
            for (Id LBId :LBIds) {
                //List <EntitySubscription> esList = new List<EntitySubscription>();
                for (EntitySubscription es :entitySub) {
                    if (es.ParentId == LBId) {
                        //esList.add(es);
                        LbEsMap.put(LBId,true);
                    }
                }                
            }            
            
            for(Learning_Board__c lb: lblist)
            {
                //entitySub = [select id,Subscriber.name from EntitySubscription where ParentId = :lb.id and SubscriberID =:UserInfo.getUserId()];
                if (LbEsMap.containsKey(lb.id) || lb.owner.Id == UserInfo.getUserId())
                {
                    perlist.add(lb);
                }
            }
            
            /*end added by Murali R2*/
            
            PersonalizedCon= new ApexPages.StandardSetController(perlist);
            PersonalizedCon.setPageSize(TileCount);
            
            }
            return PersonalizedCon;   
    }    
    set;}
    
    Public List<LearningBoardCustomClass> PersonalizedLBList {
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
        
        //Mahesh
        Public void saveList(){
        
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
         
         FeaturedLBList = new List<LearningBoardCustomClass>();            
         PersonalizedLBList = new List<LearningBoardCustomClass>(); 
         SearchResultLBList = new List<LearningBoardCustomClass>();      
    }
        //Mahesh
    //Personalized End
    
    Public AthenaSLMahesh(){
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
         
         FeaturedLBList = new List<LearningBoardCustomClass>();            
         PersonalizedLBList = new List<LearningBoardCustomClass>(); 
         SearchResultLBList = new List<LearningBoardCustomClass>();      
    }
    
    Public void perNext(){
        PersonalizedCon.next(); 
        PersonalizedIndex=0;
    }
    
    Public void perPrevious(){
        PersonalizedCon.previous();
        PersonalizedIndex=0;       
    }
    
    Public void featuredNext(){
        FeaturedCon.next();
        featuredIndex=0;
    }       
    
   
    
    Public void featuredPrevious(){
        FeaturedCon.previous();
        featuredIndex=0;       
    }
    
    // Search -- Start        
    Public void dosearch(){
        ShowSearch=true;
        searchCon=null;
        searchIndex=0;                            
    }            

    Public ApexPages.standardSetController searchCon{    
    get{
        if(searchCon== null){      
            String newSearchText= '%'+ strSearchValue + '%';               
    
            List<Learning_Board__c> searchResult;
            searchResult= [select id,Name__c,description__c,  Featured__c,Owner.name,Owner.Id,CreatedDate from Learning_Board__c where Name__c like:newSearchText];            
            searchCon= new ApexPages.StandardSetController(searchResult); 
            searchCon.setPageSize(TileCount);
        }        
        return searchCon;    
    }    
    set;}
    
    Public List<LearningBoardCustomClass> SearchResultLBList{
    get
    {
        if(searchIndex== 0){
            searchIndex=1;                
            SearchResultLBList.clear();  
            getLearningBoards('Search'); 
        }                      
        return SearchResultLBList;        
    }                 
    set;
    }  
    
    Public void searchNext(){
        searchCon.next();        
        searchIndex=0;
    }
        
    Public void searchPrevious(){
        searchCon.previous();    
        searchIndex=0;
    }
    //Search -- End     
    
    //Common Method -- Start   
    Private void getLearningBoards(String Section) {    
        list<Attachment> attachmentList = new List<Attachment>(); 
        list<id> learningBoardIds= new list<id>();
        //List<id> UserIds = new List<id>();
        
        List<Learning_Board__c> Learning_Board = new List<Learning_Board__c>();
        
        if(Section == 'Featured'){
            Learning_Board = (List<Learning_Board__c>)FeaturedCon.getRecords();
        }
        else if(Section == 'Personalized'){
            Learning_Board = (List<Learning_Board__c>)PersonalizedCon.getRecords();
        }
        else if(Section == 'Search'){
            Learning_Board = (List<Learning_Board__c>)searchCon.getRecords();
        }
        
        for (Learning_Board__c lb: Learning_Board )
        {
            learningBoardIds.add(lb.id);
        }
        
        /*start added by Murali R2*/
        List<Learning_Board__c> LBOwnerIds = new List<Learning_Board__c>();
        LBOwnerIds = [Select id,OwnerID  from Learning_Board__c where ID IN :learningBoardIds];  
        set<id> lbowid = new set<id>();
        for(Learning_Board__c lboid :LBOwnerIds ){
            lbowid.add(lboid.OwnerID);
        }
        List<User> ImageUrl = new List<User>();
        ImageUrl =[Select id,SmallPhotoUrl,FullPhotoUrl From User where id in : lbowid];
        Map<id,String> UserImageMap  = new Map<id,String>();
        
        for(id UId : lbowid){
            for(User S : ImageUrl){
                if(S.id == UId ){
                    UserImageMap.put(UId,string.valueof(S.SmallPhotoUrl));
                }
            }
        }      
      
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
        List<liked_item__C> LBLikeCountList = [select like_count__c,Item_identifier__C from liked_item__C where Item_identifier__C in :learningBoardIds];
        map<id,decimal> LBLikeCountMap = new map<id,decimal>();        
        
        map<id,Integer> LBCommentCountmap = new map<id,Integer>();
        List<FeedItem> commCount = [Select id,parentID,commentCount from FeedItem where parentID=:learningBoardIds];
        
        for (Id LBId :learningBoardIds) {
            for (Liked_Item__c FI :LBLikeCountList) {
                if(FI.Item_identifier__C== LBId) {
                    LBLikeCountMap.put(LBId,FI.like_count__c);
                }
            }                            
        }   

        for(id LBId : LearningBoardIds){
            for (FeedItem FI : commCount){
                if(FI.ParentID == LBId){
                    system.debug('@#%');
                    LBCommentCountmap.put(FI.ParentId,FI.CommentCount);                       
                }
            }
        }
        /*end added by Murali R2*/    
        
        //commCount.size();            
        
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
            lbCustom.LBOwnerID=lb.Owner.Id;
            lbCustom.LBOwnerName = lb.Owner.Name;  
            lbCustom.LBOwnerURL = UserImageMap.get(lb.Owner.Id);    //Added by murali R2
            lbCustom.LBCrtDate = lb.CreatedDate; 
             
            lbCustom.LBNoOfComments =   CommentCount(lb.id);  
            system.debug('@#!'+integer.valueof( LBCommentCountMap.get(lb.id)));   //Added by murali R2  
            system.debug('@#$'+LBCommentCountMap);
            
            //lbCustom.LBNoOfComments= integer.valueof( LBCommentCountMap.get(lb.id));//Added by murali R2
            
            lbCustom.LBNoOfLikes =integer.valueof( LBLikeCountMap.get(lb.id));    //Added by murali R2
            //lbCustom.LBNoOfLikes =   LikedItemCount(lb.id); 
            
            lbCustom.LbId = lb.id;
            lbCustom.StaticImage = true;
            
            for(Attachment att: attachmentList){
                if(lb.id == att.ParentId  && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png')){
                    lbCustom.AttachmentId = att.Id;
                    lbCustom.StaticImage=false;
                }  
            }
            
            if(Section == 'Featured')
            {
                FeaturedLBList.add(lbCustom);
            }
            else if(Section == 'Personalized')
            {
                PersonalizedLBList.add(lbCustom);
            }
            else if(Section == 'Search')
            {
                SearchResultLBList.add(lbCustom);
            }
        }        
    }
    
    Private integer LikedItemCount(string itemIdentifier){
        List<Liked_Item__C> li = [select like_count__C from liked_item__C where Item_identifier__C = : itemIdentifier];
        if(li.size()!=0)
        {
            return Integer.ValueOf(li[0].like_count__c);
        }
        return 0;
    } 
    
    
     public static integer LikedItemCounts(string itemIdentifier){
        List<Liked_Item__C> li = [select like_count__C from liked_item__C where Item_identifier__C = : itemIdentifier];
        if(li.size()!=0)
        {
            return Integer.ValueOf(li[0].like_count__c);
        }
        return 0;
    }   
        
    Private Integer CommentCount(string id){    
        List<FeedItem> commCount = [Select id from FeedItem where parentID=:id];
        return commCount.size();    
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