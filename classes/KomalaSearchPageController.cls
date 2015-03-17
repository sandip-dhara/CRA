public class KomalaSearchPageController{

    public KomalaSearchPageController(AthenaSocialLearning controller) {

    }

// Added By Komala
Public string strSearchValue{get;set;}
 Public String SearchOptions{get;set;}
 public string searchText{get;set;}
 Public Boolean ShowBoards{get;set;}
 Public Boolean ShowTopics{get;set;}
 Public Boolean ShowCommunity{get;set;}
 Public Boolean ShowCollateral{get;set;}
 Public Boolean ShowPeople{get;set;}
 
    Public boolean ShowSearch{get;set;}
      public string AvailTags{get;set;}
      public Integer TopicResultCount{get;set;}
      public Integer LBResultCount{get;set;}
      public Integer PeopleResultCount{get;set;}
      public Integer CommunityResultCount{get;set;}
      public Integer CollResultCount{get;set;}     
      
      public class LearningBoardCustomClass{
        Public id AttachmentId{get;set;}
        Public String LBName{get;set;}
        Public String LBDescription{get;set;}  
        Public id TopicId{get;set;}
        Public string TopicName{get;set;} 
        Public String LBid{get;set;}
        Public String id{get;set;}        
        Public DateTime LBCrtDate{get;set;}
    Public DateTime LBLastUpdateDate{get;set;}
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
         
    Public KomalaSearchPageController(){
        //strSearchValue = ApexPages.currentPage().getParameters().get('SearchVal'); 
        searchText= ApexPages.currentPage().getParameters().get('SearchVal'); 
        SearchOptions=ApexPages.currentPage().getParameters().get('SearchOptions');

        //strSearchValue =searchInput;
         system.debug('Search Text: '+searchText);
         system.debug('Search Options: '+SearchOptions);
         BoardResult =new List<LearningBoardCustomClass>(); 
         TopicsResult=new List<LearningBoardCustomClass>();    
         PeopleResult=new List<PeopleCustomClass>(); 
         CommunityResult=new List<LearningBoardCustomClass>();
         CollResult=new List<LearningBoardCustomClass>();       
         

        if(searchText == null) 
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
    public List<LearningBoardCustomClass> CommunityResult{get;set;}
    public List<LearningBoardCustomClass> CollResult{get;set;}

    public List<PeopleCustomClass> PeopleResult{get;set;}

     public void doSearch(){
      GetSearchBoards();
     }
    
    Public void GetSearchBoards()
    {
    ShowCommunity=false;
    ShowCollateral=false;
    ShowBoards=false;
    ShowTopics=false;
    ShowPeople=false;
    List<string> lstSelectedOptions=new List<string>();
    if(SearchOptions.contains(','))
    lstSelectedOptions=SearchOptions.split(',');
    else
    lstSelectedOptions.add(SearchOptions);
    
    if(SearchOptions.contains('Select all'))
    {
    GetCommunities();
    ShowCommunity=true;
    GetColls(); 
    ShowCollateral=true;
    GetLearningBoard();  
    ShowBoards=true;
    GetTopics();
    ShowTopics=true;
    GetPeople();
    ShowPeople=true; 
    }
    else
    {
    for(string data:lstSelectedOptions)
    {    
    if(data=='Community')
    {
        GetCommunities(); 
        ShowCommunity=true;
    }
    else if(data=='Collateral')
    {
        GetColls(); 
        ShowCollateral=true;
    }
    else if(data=='Boards')
    {
            GetLearningBoard();  
            ShowBoards=true;            
    }
    else if(data=='Topics')
    {
            GetTopics();
            ShowTopics=true;
    }
    else if(data=='People')
    {
            GetPeople();
            ShowPeople=true;
    }
    }
    }
    } 
    
      public void GetColls()
    {
    CollResultCount = 0;
     list<LearningBoardCustomClass> ListFeaturedColl = new List<LearningBoardCustomClass>();
     list<Attachment> attachmentList = new List<Attachment>(); 
     Map<Id, Attachment> attachmentIdMap ; 
     list<id> CollIds= new list<id>();
     string resourceURL= GetResourceURL('img_athena');
     List<User> userImagesLst=getCollUserImagesLst();
     string userImageUrl='';
     String  GString= '%'+ searchText.trim() + '%';
     string CommunityName = '';
     string CommunityId = '';

     SET<ID> finalCollData=new SET<ID>();

     
       LIST<Collateral__c> collSrchRslt=new LIST<Collateral__c>([ select   Community_Category_ID__r.Community_Id__r.name__c,  Community_Category_ID__r.Community_ID__r.id,   Community_Category_ID__r.name__c,  Community_Category_ID__r.id,  Name__c, Name,  Id, Description__c from Collateral__c where  Community_Category_ID__r.Community_ID__r.IsActive__c=:True      and Community_Category_ID__r.IsActive__c=:True     and IsActive__c=:True     and (Name__c like:gstring OR short_description__c like:gstring )]);
          
       // for(Community_Category__c ccatData: ccatSrchRslt)
           // {

    //  if (ccatData.Collaterals__r.size() > 0)
    //  {
 
    //      LIST<Collateral__c> collSrchRslt = new LIST<Collateral__c>();
    //      integer isize = 0;
    //      for (isize = 0; isize < ccatData.Collaterals__r.size() ; isize ++){
    //          collSrchRslt.Add(ccatData.Collaterals__r[isize]);
    //      }

            for (Collateral__c collData: collSrchRslt)
            {
                    finalCollData.add(collData.id); 
            }   
    //  }
        //    }    
                
         
    LIST<Collateral__c> collSearchResult= [ select   Community_Category_ID__r.Community_Id__r.name__c,   Community_Category_ID__r.Community_ID__r.id,    Community_Category_ID__r.name__c,   Community_Category_ID__r.id,   Name__c,  Name,   Id,  Description__c, Type__c, IsActive__c, Owner.Name, Owner.Id, Owner.Title, CreatedDate,LastModifiedDate,url__c from Collateral__c where  IsActive__c=:True   and (Collateral__c.id in:finalCollData) order by LastModifiedDate desc ];
    
            for (Collateral__c coll: collSearchResult)
            {
                
                      LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();
                        lbCustom.TopicType=coll.Type__C;
                        lbCustom.TopicURL=coll.URL__C; 

                        if( coll.Community_Category_ID__r.Community_Id__r.name__c != null)
                        {
                            if( coll.Community_Category_ID__r.Community_Id__r.name__c.length() > 130)
                            {                    
                            lbCustom.LBName =  coll.Community_Category_ID__r.Community_Id__r.name__c.substring(0,130) + '...';
                            }
                            else
                            {
                            lbCustom.LBName =  coll.Community_Category_ID__r.Community_Id__r.name__c;
                            }
                        }

                        lbCustom.LBid = coll.Community_Category_ID__r.Community_ID__r.id;
                        lbCustom.TopicId=coll.id;
                        lbCustom.TopicName=coll.Name__c;
                        if(coll.description__c!=null){
                            if(coll.description__c.length()>130){                    
                            lbCustom.LBDescription = coll.Description__c.substring(0,130) + '...';
                            }
                            else{
                            lbCustom.LBDescription=coll.description__c;
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
                            
                        lbCustom.id=coll.id;
                        lbCustom.LBOwnerID=coll.Owner.Id;

                        if(coll.Owner.Name != null)
                        {
                            if(coll.Owner.Name.length() > 16)
                            lbCustom.LBOwnerName = coll.Owner.Name.substring(0, 16) + '...';
                            else
                            lbCustom.LBOwnerName = coll.Owner.Name;
                        }
                        
                        for(User userData:userImagesLst)
                        {
                            if(userData.Id==coll.Owner.Id)
                                userImageUrl=userData.SmallPhotoUrl;
                        }
                        
                        lbCustom.LBOwnerURL =  userImageUrl;
                        if(coll.Owner.title!= null)
                        {
                            lbCustom.LBOwnerTitle = coll.Owner.title;
                             if(coll.Owner.title.length() > 25)
                             {                            
                            lbCustom.LBOwnerTitle = coll.Owner.title.substring(0, 25) + '...';
                             }
                             else
                             {
                            lbCustom.LBOwnerTitle = coll.Owner.title;
                             }
                        }
                        lbCustom.LBCrtDate = coll.CreatedDate;
                        lbCustom.LBLastUpdateDate= coll.LastModifiedDate;

                        
                        CollResult.add(lbCustom);                

                }

        
        if (CollResult != null && CollResult.size() > 0)
        {
            CollResultCount=CollResult.size();
        }
        else
        {
            CollResultCount = 0;
        }

                             
    }
    
    
    public void GetTopics()
    {
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
           String  GString= '%'+ searchText.trim() + '%';
//String  GString= '%'+ 'test' + '%';
     SET<ID> finalLrngData=new SET<ID>();
       //List<Learning__c> lrngSrchRslt=new List<Learning__c>([SELECT Id,Name__c,Name FROM Learning__c WHERE (Name__c like: GString OR Short_description__c like:GString) AND Id IN (SELECT Learning_ID__c FROM Learning_Board_Learning__c)]);
       LIST<Learning_board_learning__c> lrngSrchRslt=new LIST<Learning_board_learning__c>([select  learning_ID__r.id ,learning_ID__r.Name__c,learning_ID__r.description__c,Learning_Board_ID__r.name__c,Learning_Board_ID__r.id from Learning_board_learning__c where (learning_ID__r.Name__c like:GString OR learning_ID__r.short_description__c like: GString) and learning_ID__r.Is_Active__c=:True and learning_board_ID__r.Is_Active__c=:True]);
            
            for(Learning_board_learning__c lrngData: lrngSrchRslt)
            {
                finalLrngData.add(lrngData.learning_ID__r.id);            
            }    
                
            List<Tag_Item__c> learningTagItmLst=[
            SELECT Item_Identifier__c FROM Tag_Item__c where Tag_ID__c IN (SELECT ID FROM Tag__c WHERE Value__c =: searchText) and Item_Name__c=:AthenaUtility.Learning];
             
            for(Tag_Item__c lrngTagItm: learningTagItmLst){
                finalLrngData.add(lrngTagItm.Item_Identifier__c);
            }
            LIST<Learning_Board_learning__c> lrngSearchResult= [select learning_ID__r.id ,Learning_ID__r.Type__c,Learning_ID__r.Default_Image_Name__c,learning_ID__r.Is_Active__c,learning_ID__r.Owner.name,learning_ID__r.Owner.Id,learning_ID__r.Owner.title,learning_ID__r.CreatedDate,learning_ID__r.Name__c,learning_ID__r.description__c,learning_ID__r.url__c,Learning_Board_ID__r.name__c,Learning_Board_ID__r.id from Learning_board_learning__c where learning_ID__r.Is_Active__c  = true and learning_ID__r.id IN:finalLrngData Order by learning_ID__r.LastModifiedDate desc];
                                                                                                                                            
        for (Learning_Board_learning__c lrng: lrngSearchResult)
        {
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
                if(lrng.Learning_ID__r.Owner.title!= null)
                {
                    lbCustom.LBOwnerTitle = lrng.Learning_ID__r.Owner.title;
                     if(lrng.Learning_ID__r.Owner.title.length() > 25)
                     {                            
                        lbCustom.LBOwnerTitle = lrng.Learning_ID__r.Owner.title.substring(0, 25) + '...';
                     }
                     else
                     {
                        lbCustom.LBOwnerTitle = lrng.Learning_ID__r.Owner.title;
                     }
                }
                //lbCustom.LBCrtDate = (lrng.Learning_ID__r.CreatedDate).format('MMM dd');
                lbCustom.LBCrtDate = lrng.Learning_ID__r.CreatedDate;
 
                lbCustom.LBNoOfComments =   commentCount;  
//                lbCustom.LBNoOfLikes =   integer.valueof( LBLikeCountMap.get(lb.id));
                //lbCustom.LBNoOfLikes = getLBLikeCount(lb.id); 
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
           String  GString= '%'+ searchText.trim() + '%';
                 SET<ID> finalLrngBrdIdSet = new SET<ID>();
            SET<ID> LrngIdSet = new SET<ID>(); 
             
        List<Learning_Board__c> lrngBrdSrchRslt= new List<Learning_Board__c>([SELECT Id,Name__c,Name FROM Learning_Board__c WHERE (Name__c like : GString OR Short_description__c Like : GString Or Sub_Title__c Like:GString)and is_Active__c=true]);
        
        
            for(Learning_Board__c Lrng : lrngBrdSrchRslt){
                finalLrngBrdIdSet.add(Lrng.id);
            }
         List<Tag_Item__c> tagItmLst=[
            SELECT Item_Identifier__c FROM Tag_Item__c where Tag_ID__c IN (SELECT ID FROM Tag__c WHERE Value__c =:searchText) and Item_Name__c=:AthenaUtility.LearningBoard];
             for(Tag_Item__c TagItm : tagItmLst){
                finalLrngBrdIdSet.add(TagItm.Item_Identifier__c);
             }
                        List<Learning_Board__c> searchResult = [select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,  Featured__c,Owner.name,Owner.Id,Owner.title,CreatedDate from Learning_Board__c where Is_Active__c = True and id IN:finalLrngBrdIdSet Order by LastModifiedDate Desc];
                         
        
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
                    if(lb.description__c.length()>75){                    
                        lbCustom.LBDescription = lb.Description__c.substring(0,75) + '...';
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
                if(lb.Owner.title!= null)
                {
                    lbCustom.LBOwnerTitle = lb.Owner.title;
                     if(lb.Owner.title.length() > 25)
                     {                            
                        lbCustom.LBOwnerTitle = lb.Owner.title.substring(0, 25) + '...';
                     }
                     else
                     {
                        lbCustom.LBOwnerTitle = lb.Owner.title;
                     }
                }
                //lbCustom.LBCrtDate = (lb.CreatedDate).format('MMM dd');
                lbCustom.LBCrtDate = lb.CreatedDate;
                lbCustom.LBNoOfComments =   commentCount;  
//                lbCustom.LBNoOfLikes =   integer.valueof( LBLikeCountMap.get(lb.id));
                //lbCustom.LBNoOfLikes = getLBLikeCount(lb.id); 
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
    String  GString= '%'+ searchText.trim() + '%';
    SET<ID> finalCommunityIdSet = new SET<ID>();
         
    List<Community__c> communitySrchRslt= new List<Community__c>([SELECT Id,Name__c,Name FROM Community__c WHERE (Name__c like : GString OR Short_description__c Like : GString)and isActive__c=true]);
        
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
    
      private List<User> getCollUserImagesLst(){
        List<User> userImgLst = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id IN (select ownerId from Collateral__c)];
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
        List<Community__Share> commShare = new List<Community__Share>();
    List<Collateral__Share> collShare = new List<Collateral__Share>();
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
        
        for (LearningBoardCustomClass b : CommunityResult) {
            if (!boardIds.contains(b.LBid)) {
                boardIds.add(b.LBid);
            }                
        }

    for (LearningBoardCustomClass b : CollResult) {
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
        // get the owners ('All' access) and contributors ('Edit' access) of the Communities returned from the search
        // 
        commShare = [select UserOrGroupId from Community__Share where AccessLevel in ('Edit', 'All') and ParentId in : boardIds];
        for (Community__Share b : commShare) {
            if (!boardUids.contains(b.UserOrGroupId)) {
                boardUids.add(b.UserOrGroupId);
            }                
        }
      //
        // get the owners ('All' access) and contributors ('Edit' access) of the Collateral returned from the search
        // 
        collShare = [select UserOrGroupId from Collateral__Share where AccessLevel in ('Edit', 'All') and ParentId in : boardIds];
        for (Collateral__Share b : collShare) {
            if (!boardUids.contains(b.UserOrGroupId)) {
                boardUids.add(b.UserOrGroupId);
            }                
        }
        //
        //  get the users with matches on their names for the search filter value
        // 
        String  SearchStrWithLike= '%'+ searchText+ '%';
         List<sObject> usersMatch = [SELECT AssigneeId
                FROM PermissionSetAssignment 
                where PermissionSet.Name in ('ES_Social_Learning_Consumer', 'ES_Social_Learning_Producer', 'ES_Social_Learning_Moderator') 
                and Assignee.Name like : SearchStrWithLike ];
        
         for (sObject b : usersMatch) { 
            if (!boardUids.contains(String.valueOf(b.get('AssigneeId')))) {
                boardUids.add(String.valueOf(b.get('AssigneeId')));
            }
         }
        
        List<User> usersMatch2 = [select u.id from User u where u.Profile.Name = 'ES IT Administrator' and  u.name like : SearchStrWithLike];
        
         for (User b : usersMatch2) {
            if (!boardUids.contains(b.id)) {
                boardUids.add(b.id);
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
//            pCustom.Title = b.title;
                if(b.title!= null && b.title!= 'null')
                {
                   // pCustom.Title = b.title;
                     if(b.title.length() > 25)
                     {                            
                        pCustom.Title = b.title.substring(0, 25) + '...';
                     }
                     else
                     {
                        pCustom.Title = b.title;
                     }

                }
            pCustom.Department = b.department;
            pCustom.SmallImageName = b.SmallPhotoUrl;
            pCustom.FullImageName = b.FullPhotoUrl;
            if(b.department!=null && b.title!=null && b.department!='null' && b.title!='null')
            {
                pCustom.TitleDepartment= b.title + ', ' + b.department;  
            }
            else if((b.department!=null && b.department!='null') && (b.title==null || b.title=='null'))
            {
                pCustom.TitleDepartment=  b.department;  
            }
            
            else if((b.department==null || b.department=='null')  && (b.title!=null && b.title!='null'))
            {
                pCustom.TitleDepartment=  b.title;  
            }
            else {
                pCustom.TitleDepartment= '';
            }
            
            
            
            
            PeopleResult.add(pCustom);                            
        }
        
        PeopleResultCount = PeopleResult.size();
    }
        
}