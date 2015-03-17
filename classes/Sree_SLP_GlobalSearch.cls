public class Sree_SLP_GlobalSearch {

    public Sree_SLP_GlobalSearch(AthenaSocialLearning controller) {

    }


 Public String strSearchValue{get;set;}
    Public boolean ShowSearch{get;set;}
      public string AvailTags{get;set;}
      public Integer TopicResultCount{get;set;}
      public Integer LBResultCount{get;set;}
      public Integer PeopleResultCount{get;set;}
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
         
    Public Sree_SLP_GlobalSearch(){
        strSearchValue = ApexPages.currentPage().getParameters().get('SearchVal'); 
        system.debug('@@@@@@@@@SearchVal'+ ApexPages.currentPage().getParameters().get('SearchVal'));
        system.debug('@@@@@@@@@strSearchValue '+strSearchValue );
        system.debug('Line 37 constructor');
         BoardResult =new List<LearningBoardCustomClass>(); 
         TopicsResult=new List<LearningBoardCustomClass>();    
         PeopleResult=new List<PeopleCustomClass>(); 
        if(strSearchValue == null) 
        {
             ShowSearch=false;
        }
        else
        {
              ShowSearch=true;
              //strSearchValue = strSearchValue.trim();
              dosearch();
         }         
//         strSearchValue='Cloud';
  //             GetSearchBoards();
    }
    
    Public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
    public List<LearningBoardCustomClass> BoardResult{get;set;}
    public List<LearningBoardCustomClass> TopicsResult{get;set;}
    public List<PeopleCustomClass> PeopleResult{get;set;}

     public void doSearch(){
     System.debug('Started doSearch');
     BoardResult =new List<LearningBoardCustomClass>();   
     TopicsResult=new List<LearningBoardCustomClass>();  
     PeopleResult=new List<PeopleCustomClass>(); 
      GetSearchBoards();
      System.debug('Completed doSearch');
    }
    
    Public void GetSearchBoards()
    {
            System.debug('Search board1');
            GetLearningBoard();    
            System.debug('Search board2');            
            GetTopics();
            System.debug('Search topics2');
            System.debug('Search topics3');
            GetPeople();
//            System.Debug('Learning Board Count: '+searchResult.size());
//            System.Debug('Topics: '+lrngSearchResult.size());
    } 
    
    public void GetTopics()
    {
    system.debug('In get topics 82');
     list<LearningBoardCustomClass> ListFeaturedLB = new List<LearningBoardCustomClass>();
     list<Attachment> attachmentList = new List<Attachment>(); 
     Map<Id, Attachment> attachmentIdMap ; 
     list<id> topicIds= new list<id>();
     string resourceURL= GetResourceURL('img_athena');
     List<FeedItem> feedItemsLst=getLBCommentCountLst();
     List<User> userImagesLst=getTopicsUserImagesLst();
     List<FeedItem> finalFeedsLst=new List<FeedItem>();
     string userImageUrl='';
     integer commentCount=0;
           String  GString= '%'+ strSearchValue.trim() + '%';
//String  GString= '%'+ 'test' + '%';
     SET<ID> finalLrngData=new SET<ID>();
      System.debug('Search topics');
       //List<Learning__c> lrngSrchRslt=new List<Learning__c>([SELECT Id,Name__c,Name FROM Learning__c WHERE (Name__c like: GString OR Short_description__c like:GString) AND Id IN (SELECT Learning_ID__c FROM Learning_Board_Learning__c)]);
       LIST<Learning_board_learning__c> lrngSrchRslt=new LIST<Learning_board_learning__c>([select  learning_ID__r.id ,learning_ID__r.Name__c,learning_ID__r.description__c,Learning_Board_ID__r.name__c,Learning_Board_ID__r.id from Learning_board_learning__c where (learning_ID__r.Name__c like:GString OR learning_ID__r.short_description__c like: GString) and learning_ID__r.Is_Active__c=:True and learning_board_ID__r.Is_Active__c=:True]);
            
            for(Learning_board_learning__c lrngData: lrngSrchRslt)
            {
                system.debug('LBL :'+lrngData.learning_ID__r.id);
                finalLrngData.add(lrngData.learning_ID__r.id);            
            }    
                
            List<Tag_Item__c> learningTagItmLst=[
            SELECT Item_Identifier__c FROM Tag_Item__c where Tag_ID__c IN (SELECT ID FROM Tag__c WHERE Value__c =: strSearchValue) and Item_Name__c=:AthenaUtility.Learning];
             
            for(Tag_Item__c lrngTagItm: learningTagItmLst){
                system.debug('TI :'+lrngTagItm.Item_Identifier__c);
                finalLrngData.add(lrngTagItm.Item_Identifier__c);
            }
            LIST<Learning_Board_learning__c> lrngSearchResult= [select learning_ID__r.id ,Learning_ID__r.Type__c,Learning_ID__r.Default_Image_Name__c,learning_ID__r.Is_Active__c,learning_ID__r.Owner.name,learning_ID__r.Owner.Id,learning_ID__r.CreatedDate,learning_ID__r.Name__c,learning_ID__r.description__c,learning_ID__r.url__c,Learning_Board_ID__r.name__c,Learning_Board_ID__r.id from Learning_board_learning__c where learning_ID__r.Is_Active__c  = true and learning_ID__r.id IN:finalLrngData Order by learning_ID__r.LastModifiedDate desc];
                                                                                                                                            
        for (Learning_Board_learning__c lrng: lrngSearchResult)
        {
            system.debug('/////////////////line 110 '+lrng.learning_ID__r.id);
           topicIds.add(lrng.learning_ID__r.id);
        }
                        
           List<string> contype=new List<string>();
           contype.add('image/jpeg');
           contype.add('image/png');
           contype.add('image/jpg');
           contype.add('image/gif');

           Map<String,string> AttMap = new Map<String,string>();   
           list<Attachment> Att = [SELECT Id,ParentId FROM Attachment WHERE Parentid in :topicIds and ContentType in:contype];
           for (Attachment at : Att)
           {                        
              AttMap.put(at.ParentId,at.Id);            
           }      
        
        List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c in :topicIds];
        map<id,decimal> RatedItemMap = new map<id,decimal>();        
                   
        
        for (Rated_Item__c rtdItm :RatedItemLst) {
                    RatedItemMap.put(rtdItm.Item_identifier__C,rtdItm.Rating_Average__c);  
        }  

       for(Learning_Board_learning__c lrng: lrngSearchResult){
                LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();
                lbCustom.TopicType=lrng.Learning_ID__r.Type__C;
                system.debug('LB Type'+lrng.Learning_ID__r.Type__C);
                lbCustom.TopicURL=lrng.Learning_ID__r.URL__C;
                //lbCustom.LBName = lrng.Learning_Board_ID__r.Name__c; 

                if(lrng.Learning_Board_ID__r.Name__c != null)
                {
                    if(lrng.Learning_Board_ID__r.Name__c.length() > 130)
                    {                    
                        lbCustom.LBName = lrng.Learning_Board_ID__r.Name__c.substring(0,130) + '...';
                    }
                    else
                    {
                        lbCustom.LBName = lrng.Learning_Board_ID__r.Name__c;
                    }
                }

                lbCustom.LBid = lrng.Learning_Board_ID__r.id;
                lbCustom.TopicId=lrng.Learning_ID__r.id;
                lbCustom.TopicName=lrng.Learning_ID__r.Name__c;
                if(lrng.Learning_ID__r.description__c!=null){
                    if(lrng.Learning_ID__r.description__c.length()>130){                    
                        lbCustom.LBDescription = lrng.Learning_ID__r.Description__c.substring(0,130) + '...';
                    }
                    else{
                        lbCustom.LBDescription=lrng.Learning_ID__r.description__c;
                    }
                }
                
                
                 if( lbCustom.TopicURL!=null)
                    {                           
                        if(lbCustom.TopicURL.contains('.pdf'))
                        {
                          lbCustom.TopicDocType='PDF';
                        }
                        else if(lbCustom.TopicURL.contains('.ppt'))
                        {
                          lbCustom.TopicDocType='PPT';
                        }                    
                        else if(lbCustom.TopicURL.contains('.doc'))
                        {
                          lbCustom.TopicDocType='DOC';
                        }
                        else
                        {
                          lbCustom.TopicDocType='OTHER';
                        }
                    }
                    If(RatedItemMap.containskey(lrng.Learning_ID__r.id))
                        {
                            lbCustom.AvgRating=RatedItemMap.get(lrng.Learning_ID__r.id);
                        }
                        else
                        {
                            lbCustom.AvgRating=0;
                        }
                        
                lbCustom.id=lrng.Learning_ID__r.id;
                lbCustom.LBOwnerID=lrng.Learning_ID__r.Owner.Id;
                
                //lbCustom.LBOwnerName = lrng.Learning_ID__r.Owner.Name;

                if(lrng.Learning_ID__r.Owner.Name != null)
                {
                    if(lrng.Learning_ID__r.Owner.Name.length() > 16)
                    lbCustom.LBOwnerName = lrng.Learning_ID__r.Owner.Name.substring(0, 16) + '...';
                    else
                        lbCustom.LBOwnerName = lrng.Learning_ID__r.Owner.Name;
                }
                
                for(User userData:userImagesLst)
                {
                if(userData.Id==lrng.Learning_ID__r.Owner.Id)
                userImageUrl=userData.SmallPhotoUrl;
                }
                for(FeedItem commentData:feedItemsLst)
                {
                if(commentData.Id==lrng.Learning_ID__r.Id)
                {
                finalFeedsLst.add(commentData);                
                }
                commentCount=finalFeedsLst.size();
                }
                lbCustom.LBOwnerURL =  userImageUrl;
                //lbCustom.LBCrtDate = (lrng.Learning_ID__r.CreatedDate).format('MMM dd');
                lbCustom.LBCrtDate = lrng.Learning_ID__r.CreatedDate;
 
                lbCustom.LBNoOfComments =   commentCount;  
//                lbCustom.LBNoOfLikes =   integer.valueof( LBLikeCountMap.get(lb.id));
                //lbCustom.LBNoOfLikes = getLBLikeCount(lb.id); 
                system.debug('lb.Default_Image_Name__c'+lrng.Learning_ID__r.Default_Image_Name__c);
                //lbCustom.DefaultImageName = get
                  if(lrng.Learning_ID__r.Default_Image_Name__c!=''){                        
                        lbCustom.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() + resourceURL+ '/img_athena/' + lrng.Learning_ID__r.Default_Image_Name__c;         
                   }
                
                lbCustom.StaticImage = true;

                if(AttMap.containskey(lrng.Learning_ID__r.id))
                {
                lbCustom.AttachmentId = AttMap.get(lrng.Learning_ID__r.id);
                lbCustom.StaticImage=false;
                }
                
                TopicsResult.add(lbCustom);                
            }
            TopicResultCount=TopicsResult.size();                 
            feedItemsLst=null;
            userImagesLst=null;
    }
    
    
    
    Private void GetLearningBoard()
    {
       list<LearningBoardCustomClass> ListFeaturedLB = new List<LearningBoardCustomClass>();
        list<Attachment> attachmentList = new List<Attachment>(); 
        list<id> learningBoardIds= new list<id>();
        string resourceURL= GetResourceURL('img_athena');
        List<FeedItem> feedItemsLst=getLBCommentCountLst();
        List<User> userImagesLst=getLearningBoardUserImagesLst();
     List<FeedItem> finalFeedsLst=new List<FeedItem>();
     string userImageUrl='';
     integer commentCount=0;
           String  GString= '%'+ strSearchValue.trim() + '%';
            system.debug('@@@@@@@@@strSearchValue'+strSearchValue);
            system.debug('@@@@@@@@@GString'+GString);
                 SET<ID> finalLrngBrdIdSet = new SET<ID>();
            SET<ID> LrngIdSet = new SET<ID>(); 
             
        List<Learning_Board__c> lrngBrdSrchRslt= new List<Learning_Board__c>([SELECT Id,Name__c,Name FROM Learning_Board__c WHERE (Name__c like : GString OR Short_description__c Like : GString Or Sub_Title__c Like:GString)and is_Active__c=true]);
        
        
            for(Learning_Board__c Lrng : lrngBrdSrchRslt){
            system.debug('//////////////????????');
                finalLrngBrdIdSet.add(Lrng.id);
            }
         List<Tag_Item__c> tagItmLst=[
            SELECT Item_Identifier__c FROM Tag_Item__c where Tag_ID__c IN (SELECT ID FROM Tag__c WHERE Value__c =:strSearchValue) and Item_Name__c=:AthenaUtility.LearningBoard];
            system.debug('@@@@@@@@@@@@@tagItmLst'+tagItmLst);
             for(Tag_Item__c TagItm : tagItmLst){
                finalLrngBrdIdSet.add(TagItm.Item_Identifier__c);
             }
                        List<Learning_Board__c> searchResult = [select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,  Featured__c,Owner.name,Owner.Id,CreatedDate from Learning_Board__c where Is_Active__c = True and id IN:finalLrngBrdIdSet Order by LastModifiedDate Desc];
                         
                        system.debug('@@@@@@@@@@@@@searchResult'+searchResult);
        
        for (Learning_Board__c lb: searchResult)
        {
           learningBoardIds.add(lb.id);
        }
        List<string> contype=new List<string>();
           contype.add('image/jpeg');
           contype.add('image/png');
           contype.add('image/jpg');
           contype.add('image/gif');

           Map<String,string> AttMap = new Map<String,string>();   
           list<Attachment> Att = [SELECT Id,ParentId FROM Attachment WHERE Parentid in :learningBoardIds and ContentType in:contype];
           for (Attachment at : Att)
           {                        
              AttMap.put(at.ParentId,at.Id);            
           }      
        //attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
               
        
        List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c in :learningBoardIds];
        map<id,decimal> RatedItemMap = new map<id,decimal>();        
                   
        
        for (Rated_Item__c rtdItm :RatedItemLst) {
                    RatedItemMap.put(rtdItm.Item_identifier__C,rtdItm.Rating_Average__c);  
        }  

       for(Learning_Board__c lb: searchResult){
                LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();

                //lbCustom.LBName = lb.Name__c; 

                if(lb.Name__c != null)
                {
                    if(lb.Name__c.length() > 38)
                    {                    
                        lbCustom.LBName = lb.Name__c.substring(0,38) + '...';
                    }
                    else
                    {
                        lbCustom.LBName = lb.Name__c;
                    }
                }


                if(lb.description__c!=null){
                    if(lb.description__c.length()>53){                    
                        lbCustom.LBDescription = lb.Description__c.substring(0,53) + '...';
                    }
                    else{
                        lbCustom.LBDescription=lb.description__c;
                    }
                }
                    If(RatedItemMap.containskey(lb.id))
                        {
                            lbCustom.AvgRating=RatedItemMap.get(lb.id);
                        }
                        else
                        {
                            lbCustom.AvgRating=0;
                        }
                        
                for(User userData:userImagesLst)
                {
                if(userData.Id==lb.Owner.Id)
                userImageUrl=userData.SmallPhotoUrl;
                }
                for(FeedItem commentData:feedItemsLst)
                {
                if(commentData.Id==lb.Id)
                {
                finalFeedsLst.add(commentData);                
                }
                commentCount=finalFeedsLst.size();
                }
                        
                lbCustom.id=lb.id;
                lbCustom.LBid = lb.id;
                lbCustom.LBOwnerID=lb.Owner.Id;
                lbCustom.LBOwnerName = lb.Owner.Name;  

                if(lb.Owner.Name != null)
                {
                    if(lb.Owner.Name.length() > 16)
                        lbCustom.LBOwnerName = lb.Owner.Name.substring(0, 16) + '...';
                    else
                        lbCustom.LBOwnerName = lb.Owner.Name;
                }
                

                lbCustom.LBOwnerURL = userImageUrl;    
                //lbCustom.LBCrtDate = (lb.CreatedDate).format('MMM dd');
                lbCustom.LBCrtDate = lb.CreatedDate;
                lbCustom.LBNoOfComments =   commentCount;  
//                lbCustom.LBNoOfLikes =   integer.valueof( LBLikeCountMap.get(lb.id));
                //lbCustom.LBNoOfLikes = getLBLikeCount(lb.id); 
                system.debug('lb.Default_Image_Name__c'+lb.Default_Image_Name__c);
                //lbCustom.DefaultImageName = get
                  if(lb.Default_Image_Name__c!=''){                        
                        lbCustom.DefaultImageName='https://' + URL.getSalesforceBaseUrl().getHost() +resourceURL+ '/img_athena/' + lb.Default_Image_Name__c;         
                   }
                
                lbCustom.StaticImage = true;
                /*for(Attachment att: attachmentList){
                    if(lb.id == att.ParentId && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
                        lbCustom.AttachmentId = att.Id;
                        //lbCustom.LbId = att.ParentId;
                        lbCustom.StaticImage=false;
                    }  
                }*/
                if(AttMap.containskey(lb.id))
                {
                    lbCustom.AttachmentId = AttMap.get(lb.id);
                    lbCustom.StaticImage=false;
                }
                BoardResult.add(lbCustom);
            }  
            LBResultCount=BoardResult.size();
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
    
    public void GetPeople() {
        Set<String> boardUids = new Set<String>();
        Set<String> boardIds = new Set<String>();
        List<Learning_Board__Share> lbShare = new List<Learning_Board__Share>();
        //
        // get learning board ids that were returned from the search
        // 
        for (LearningBoardCustomClass b : BoardResult) {
            if (!boardIds.contains(b.id)) {
                boardIds.add(b.id);
            }                
        }
        
        for (LearningBoardCustomClass b : TopicsResult) {
            if (!boardIds.contains(b.LBid)) {
                boardIds.add(b.LBid);
            }                
        }
        //
        // get the owners ('All' access) and contributors ('Edit' access) of the Learning Boards returned from the search
        // 
        lbShare = [select UserOrGroupId from Learning_Board__Share where AccessLevel in ('Edit', 'All') and ParentId in : boardIds];
        for (Learning_Board__Share b : lbShare) {
            if (!boardUids.contains(b.UserOrGroupId)) {
                boardUids.add(b.UserOrGroupId);
            }                
        }
        //
        //  get the users with matches on their names for the search filter value
        // 
        String  SearchStrWithLike= '%'+ strSearchValue + '%';
         List<PermissionSetAssignment> usersMatch = [SELECT AssigneeId 
            FROM PermissionSetAssignment
            where PermissionSetId in 
                (select ID
                    from Permissionset where label in ('ES Social Learning Consumer', 'ES Social Learning Producer', 'ES Social Learning Moderator'))
                  and AssigneeId in (select u.id
                    from User u
                    where u.name like : SearchStrWithLike ) ];
         for (PermissionSetAssignment b : usersMatch) {
            if (!boardUids.contains(b.AssigneeId)) {
                boardUids.add(b.AssigneeId);
            }
         }
        // 
        // get the user details
        // 
        List<User> users = [select u.id, u.name, u.title, u.department, u.SmallPhotoUrl, u.FullPhotoUrl from User u where u.id in : boardUids order by u.name];
        for (User b : users) {
            PeopleCustomClass pCustom = new PeopleCustomClass();
            pCustom.Id = b.id;
            pCustom.Name = b.name;
            pCustom.Title = b.title;
            pCustom.Department = b.department;
            pCustom.SmallImageName = b.SmallPhotoUrl;
            pCustom.FullImageName = b.FullPhotoUrl;
            if(b.department!=null && b.title!=null)
            {
                pCustom.TitleDepartment= b.title + ',' + b.department;  
            }
            if(b.department!=null && b.title==null)
            {
                pCustom.TitleDepartment=  b.department;  
            }
            
            if(b.department==null && b.title!=null)
            {
                pCustom.TitleDepartment=  b.title;  
            }
            
            
            
            
            PeopleResult.add(pCustom);                            
        }
        
        PeopleResultCount = PeopleResult.size();
    }
        
}