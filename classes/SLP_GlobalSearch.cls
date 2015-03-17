public class SLP_GlobalSearch{
  
// Added By Komala
public string RedirectUrl{get;set;}
public integer TopicCnt {get;set;}
Public string strSearchValue{get;set;}
 Public String SearchOptions{get;set;}
 public string searchText{get;set;}
 Public Boolean ShowBoards{get;set;}
 Public Boolean ShowTopics{get;set;}
 Public Boolean ShowCommunity{get;set;}
 Public Boolean ShowCollateral{get;set;}
 Public Boolean ShowPeople{get;set;}
 Public Boolean ShowPeopleExpert {get;set;}
 public boolean PreviewRequired { get; set; } 
 public boolean IsUserRoleMappingVisible
    {
    get
    {
    
    string userId=UserInfo.getUserId();
    
    AthenaUserAccess UsrAcc=new AthenaUserAccess();
       
                   if (UsrAcc.IsModerator(userId))
                return true;
            else
                return false;        
    }
    }
 Public String ResourceURL{get;set;}
 
        private string DATABASE;
        private string SERVER;
        private integer PAGE_SIZE;
        private integer MAX_HITS;
 
 
        public  integer MaxItem {get; private set;}
      
        public  List<SLP_IdolQueryResponse> SearchResults {get; private set;}
 
 
    Public boolean ShowSearch{get;set;}
      public string AvailTags{get;set;}
      public Integer TopicResultCount{get;set;}
      public Integer LBResultCount{get;set;}
      public Integer PeopleResultCount{get;set;}
      public Integer CommunityResultCount{get;set;}
      public Integer CollResultCount{get;set;} 
      public Integer ExpertResultCount{get;set;} 
      
      public class LearningBoardCustomClass{
       public boolean IsContentAttchment {get;set;}
        public boolean IsIdolSearch {get;set;}
        Public id AttachmentId{get;set;}
        Public String LBName{get;set;}
        Public String LBDescription{get;set;}  
        Public id TopicId{get;set;}
        Public string TopicName{get;set;}
        public string TopicImageUrl{get;set;} // Added By Komala 
        Public String LBid{get;set;}
        Public String id{get;set;}        
        Public string LBCrtDate{get;set;}
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
        public string BoardCommunityIdolTopicstype {get;set;}
        public string BoardCommunityNm {get;set;}
        public string BoardOrCommunityVideo {get;set;}
        Public boolean IsVideo{get;set;}
        public integer TopicCount {get;set;}
        public string IsPreviewRequired { get; set; }
    } 
    public class PeopleCustomClass {
        Public id Id{get;set;}
        public boolean IsBrdCommOwner {get;set;}
        Public String Name{get;set;}
        Public String Title{get;set;} 
        public boolean IsCommunityContributor {get;set;}
        public boolean IsCommunityOwner {get;set;}
        Public String Department{get;set;} 
        Public String SmallImageName{get;set;} 
        Public String FullImageName{get;set;} 
        Public String TitleDepartment{get;set;} 
        public string ExpertUserRole {get;set;}
        public string ShortExpertUserRole { get; set; }
        public string SecondaryIndImage {get;set;}
        public boolean IsSecondaryIndImg {get;set;}
        public string lstExperts {get;set;}
        public string Region {get;set;}
        public string BusinessGroup {get;set;}
        public boolean IsExperts {get;set;}
        public string RoleName { get; set;}
    }
    private List<FeedItem> getLBCommentCountLst(){
        List<FeedItem> commCount = [Select id from FeedItem];
        return commCount;
    }
    Public List<feeditem> commCount;
    Public SLP_GlobalSearch(){
    commCount = [Select id from FeedItem];
    SLP_IDOL_Settings__c s = SLP_IDOL_Settings__c.getOrgDefaults();      
        this.PAGE_SIZE = s.Page_Size__c.intValue();
        this.MAX_HITS = s.Maximum_Hits__c.intValue();
        this.DATABASE = s.Database__c;
        this.SERVER = s.Server_URL__c;
//        this.Hits = -1; // -1 sentinel value meaning 'not searched'
    
        //strSearchValue = ApexPages.currentPage().getParameters().get('SearchVal'); 
        searchText= ApexPages.currentPage().getParameters().get('SearchVal'); 
        SearchOptions=ApexPages.currentPage().getParameters().get('SearchOptions');
        ResourceURL=GetResourceURL('img_athena');
    
        //strSearchValue =searchInput;
         system.debug('Search Text: '+searchText);
         system.debug('Search Options: '+SearchOptions);
         BoardResult =new List<LearningBoardCustomClass>(); 
         TopicsResult=new List<LearningBoardCustomClass>();    
         PeopleResult=new List<PeopleCustomClass>();
         ExpertResult=new List<PeopleCustomClass>();
         CommunityResult=new List<LearningBoardCustomClass>();
         CollResult=new List<LearningBoardCustomClass>();       
         
        if(searchText == null) 
        {
             ShowSearch=false;
        }
        else
        {
              ShowSearch=true;
              dosearch();
             
         }                
        //string previewRequiredVal = AthenaUtility.ApplicationSettingValue(AthenaUtility.PreviewRequired);

        //if(previewRequiredVal == 'YES')
          //  PreviewRequired = true;
        //else
          //  PreviewRequired = false;

           PreviewRequired = false;
           
        system.debug('PreviewRequired:'+ PreviewRequired);
    }
    
        
    public void SaveRecentSearch()
    {
      system.debug('TopicResultCount:'+TopicResultCount);
      system.debug('LBResultCount:'+LBResultCount);
      system.debug('PeopleResultCount:'+PeopleResultCount);
      system.debug('CommunityResultCount:'+CommunityResultCount);
      system.debug('CollResultCount:'+CollResultCount);
            if(TopicResultCount>0 || LBResultCount>0 ||  PeopleResultCount>0 ||  CommunityResultCount>0 || CollResultCount>0)
             {
               List<SLP_RecentSearch__c> slpRSeExist=[select Id,Search_Text__c From SLP_RecentSearch__c where Search_Text__c =:searchText.trim() limit 1];
               if(slpRSeExist!=null && slpRSeExist.size()>0)
               {
                 update slpRSeExist;
               }
               else
               {
                   SLP_RecentSearch__c slpRS=new SLP_RecentSearch__c();
                   slpRS.Search_Text__c =searchText.trim();
                   insert slpRS;
               }
               
             }
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
    public List<PeopleCustomClass> ExpertResult{get;set;}

     public void doSearch(){
     system.debug('dosearch:');
      GetSearchResults();
     }
    
    public void GetSearchResults()
    {
      ShowCommunity=false;
    ShowCollateral=false;
    ShowBoards=false;
    ShowTopics=false;
    ShowPeople=false;
    ShowPeopleExpert=false;
    List<string> lstSelectedOptions=new List<string>();
    system.debug('SearchOptions:'+SearchOptions);
    if(SearchOptions.contains(','))
    {
    lstSelectedOptions=SearchOptions.split(',');
    }
    else
    {
    lstSelectedOptions.add(SearchOptions);
    }
    if(SearchOptions.contains('multiselect-all'))
    {
     GetCommunities();
    ShowCommunity=true;
    
    
    ShowCollateral=true;
    GetLearningBoard();  
    ShowBoards=true;
    
    GetCollTopicsIdolResults();
   
    ShowTopics=true;
    GetPeople();
    ShowPeople=true;
    GetExperts();
    ShowPeopleExpert=true;
    
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
    
    else if(data=='Boards')
    {
            GetLearningBoard();  
            ShowBoards=true;            
    }
    else if(data=='Topics')
    {
    GetCollTopicsIdolResults();
            ShowTopics=true;
    }
    else if(data=='People')
    {
            GetPeople();
            GetExperts(); // added by Komala
            ShowPeople=true;
            ShowPeopleExpert=true; // added by Komala
    }
    else if(data=='Expert')
    {
      GetExperts();
      ShowPeopleExpert=true;
      
    }
    }
    }
    
    }
    
    
     public void GetCollTopicsIdolResults()
     {
     CollResultCount = 0;
      TopicsResult=new list<LearningBoardCustomClass>();
      String  GString= '%'+ searchText.trim() + '%';
     string CommunityName = '';
     string CommunityId = '';
     system.debug('GString:'+GString);

     SET<ID> finalCollData=new SET<ID>();
     LIST<Collateral__c> collSrchRslt=new LIST<Collateral__c>([ select   Community_Category_ID__r.Community_Id__r.name__c,  Community_Category_ID__r.Community_ID__r.id,   Community_Category_ID__r.name__c,  Community_Category_ID__r.id,  Name__c, Name,  Id, Description__c from Collateral__c where  Community_Category_ID__r.Community_ID__r.IsActive__c=:True      and Community_Category_ID__r.IsActive__c=:True     and IsActive__c=:True     and (Name__c like:gstring OR short_description__c like:gstring )]);
     system.debug('collSrchRslt:'+collSrchRslt.size());
     for (Collateral__c collData: collSrchRslt)
            {
                    finalCollData.add(collData.Id); 
            }
            system.debug('finalCollData:'+finalCollData);
     LIST<Collateral__c> collSearchResult= [ select   Community_Category_ID__r.Community_Id__r.name__c,   Community_Category_ID__r.Community_ID__r.id,    Community_Category_ID__r.name__c,   Community_Category_ID__r.id,   Name__c,  Name,   Id,  Description__c, Type__c, IsActive__c, Owner.Name, Owner.Id, Owner.Title, CreatedDate,LastModifiedDate,url__c from Collateral__c where  IsActive__c=:True   and (Collateral__c.id in:finalCollData) order by LastModifiedDate desc ];     
     
     system.debug('collSearchResult:'+collSearchResult);
     
     TopicsResult=GetCollaterals(collSearchResult);
     TopicCnt=TopicsResult.size();
     TopicsResult.addAll(GetTopics());
     
     TopicsResult.addAll(search(searchText.trim(), 1, -1, this.PAGE_SIZE));
     
     
        if (TopicsResult != null && TopicsResult.size() > 0)
        {
            TopicResultCount=TopicsResult.size();
        }
        else
        {
            TopicResultCount = 0;
        }

        system.debug('TopicResultCount:'+TopicResultCount);
        system.debug('TopicsResult.size():'+TopicsResult.size());
     }
     
     public list<LearningBoardCustomClass> GetCollaterals(LIST<Collateral__c> collSearchResult)
     {
     system.debug('collSearchResult:'+collSearchResult.size());
     list<LearningBoardCustomClass> CollateralResult = new List<LearningBoardCustomClass>();
     list<Attachment> attachmentList = new List<Attachment>(); 
     Map<Id, Attachment> attachmentIdMap ; 
     list<id> CollIds= new list<id>();
     List<User> userImagesLst=getCollUserImagesLst();
     string userImageUrl='';
     string fileVideoUpload = 'https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileVideo.png';
     
     set<ID> CommunityIds=new set<ID>();
     set<ID> PrivateCommunityIds=new set<ID>();
     
     list<Community__c> lstCommunity=  [SELECT Id FROM Community__c where IsActive__c =:true and Public__c=:true];
     for(Community__c community: lstCommunity){
     CommunityIds.add(community.Id);
     }
     list<Community__c> lstPrivateCommunity=  [SELECT Id FROM Community__c where IsActive__c =:true and Public__c=:false];
     for(Community__c Pcommunity: lstPrivateCommunity){
     PrivateCommunityIds.add(Pcommunity.Id);
     }
     
     List<Community_Member__c> lstCommunityMem= [SELECT Id, Community_Id__c, User_Id__c, Status__c FROM Community_Member__c where User_Id__c =:UserInfo.getUserId() and Status__c=:'Approved' and Community_Id__c in :PrivateCommunityIds ];
     for(Community_Member__c commMem:lstCommunityMem){
     CommunityIds.add(commMem.Community_Id__c);
     }
     
    list<Community__Share> lstCommunityShare= [SELECT Id, ParentId, UserOrGroupId FROM Community__Share where ParentId in :PrivateCommunityIds  and UserOrGroupId=:UserInfo.getUserId()];
     for(Community__Share commShare:lstCommunityShare){
     CommunityIds.add(commShare.ParentId);
     }
     
     list<id> topicIds= new list<id>();
     
     for(Collateral__c cll:collSearchResult)
     {
       topicIds.add(cll.id);
     }
     
     
     List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c in :topicIds];
        map<id,decimal> RatedItemMap = new map<id,decimal>();        
                   
        
        for (Rated_Item__c rtdItm :RatedItemLst) {
                    RatedItemMap.put(rtdItm.Item_identifier__C,rtdItm.Rating_Average__c);  
        }  

     
     integer iCount=0;
      for (Collateral__c coll: collSearchResult)
            {
            if(CommunityIds.contains(coll.Community_Category_ID__r.Community_ID__r.id)){
            
                LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();
                        lbCustom.TopicType=coll.Type__C;

                    if(coll.URL__C != null)
                    {
                        //if(coll.URL__C.contains('sharepoint'))
                        if(coll.URL__C.contains('prime31.sharepoint.hp.com/teams/social%20learning/FileRepoWS/Uploads') || coll.URL__C.contains('intranet.hp.com/enterpriseservices/ww/site/'))
                        {
                            lbCustom.TopicURL = 'https://it-services-gw-itg.external.hp.com/gw/esit/sfdc/idol.dev/action=View&NoACI=true&OutputType=RAW&IgnoreCache=true&reference=' + coll.URL__C;
                        }
                        else
                        {
                            lbCustom.TopicURL = coll.URL__C;
                        }
                    }
                    else
                    {
                        lbCustom.TopicURL = coll.URL__C;
                    }
                    

                        //lbCustom.TopicURL=coll.URL__C; 
                        
                         If(RatedItemMap.containskey(coll.id))
                        {
                            lbCustom.AvgRating=RatedItemMap.get(coll.id);
                        }
                        else
                        {
                            lbCustom.AvgRating=0;
                        }
                        
                        
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
                    
                        if(lbCustom.TopicType=='Video')
                        {
                        lbCustom.BoardOrCommunityVideo=fileVideoUpload;
                        lbCustom.IsVideo=true;
                        if(lbCustom.TopicURL!=null)
                            {
                             if( lbCustom.TopicURL.contains('youtube.com') && lbCustom.TopicURL.contains('watch?v=')){
                                  lbCustom.TopicURL=lbCustom.TopicURL.replace('watch?v=', 'embed/');
                                  lbCustom.TopicURL=lbCustom.TopicURL.replace('http:', 'https:');
                                }
                            else if(lbCustom.TopicURL.contains('www.brainshark.com')){
                              lbCustom.TopicURL=lbCustom.TopicURL+'&dm=5&pause=1&nrs=1';
                                  
                            }
                            }
                        }
                        
                        
                        lbCustom.LBid = coll.Community_Category_ID__r.Community_ID__r.id;
                        lbCustom.TopicId=coll.id;
                        lbCustom.TopicName=coll.Name__c;
                        if(coll.description__c!=null){
                            if(coll.description__c.length()>1000){                    
                            lbCustom.LBDescription = coll.Description__c.substring(0,1000) + '...';
                            }
                            else{
                            lbCustom.LBDescription=coll.description__c;
                            }
                        }
                        
                        
                         if( lbCustom.TopicURL!=null)
                            {                           
                            if(lbCustom.TopicURL.toLowerCase().contains('.pdf'))
                            {
                              lbCustom.TopicDocType='PDF';
                            }
                            else if(lbCustom.TopicURL.toLowerCase().contains('.ppt'))
                            {
                              lbCustom.TopicDocType='PPT';
                            }               
                            else if(lbCustom.TopicURL.toLowerCase().contains('.xls'))
                            {
                              lbCustom.TopicDocType='XLS';
                            }                    
                            else if(lbCustom.TopicURL.toLowerCase().contains('.txt'))
                            {
                              lbCustom.TopicDocType='TXT';
                            } 
                            else if(lbCustom.TopicURL.toLowerCase().contains('.doc') ||  lbCustom.TopicURL.toLowerCase().contains('.docx'))
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
                        lbCustom.LBCrtDate = coll.CreatedDate.format('MMM dd ');
                        lbCustom.LBLastUpdateDate= coll.LastModifiedDate;    
                        lbCustom.BoardCommunityNm='/apex/SLP_ViewCommunity?id='+lbCustom.LBid+'&topicid='+lbCustom.TopicId+'';   
                        lbCustom.BoardCommunityIdolTopicstype='/apex/SLP_ViewCommunity?id='+lbCustom.LBid+'';   
                        lbCustom.TopicCount=iCount;
                        iCount++;                       
                        CollateralResult.add(lbCustom);    
    
                }
                }
                system.debug('CollateralResult:'+CollateralResult.size());
                return CollateralResult;
     }
     
    public List<LearningBoardCustomClass> GetTopics()
    {
    list<LearningBoardCustomClass> SearchListOfTopics = new List<LearningBoardCustomClass>();
     list<LearningBoardCustomClass> ListFeaturedLB = new List<LearningBoardCustomClass>();
     list<Attachment> attachmentList = new List<Attachment>(); 
     Map<Id, Attachment> attachmentIdMap ; 
     list<id> topicIds= new list<id>();
     string resourceURL= GetResourceURL('img_athena');
     //List<FeedItem> feedItemsLst=getLBCommentCountLst();
     List<User> userImagesLst=getTopicsUserImagesLst();
     List<FeedItem> finalFeedsLst=new List<FeedItem>();
     string userImageUrl='';
     integer commentCount=0;
     string fileVideoUpload = 'https://' + URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena')+ '/img_athena/fileVideo.png';
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
                        
           Map<String,string> AttMap = new Map<String,string>();   
           list<Attachment> Att = [SELECT Id,ParentId FROM Attachment WHERE Parentid in :topicIds and ContentType in:AthenaUtility.ContentType()];
           for (Attachment at : Att)
           {                        
              AttMap.put(at.ParentId,at.Id);            
           }      
        
        List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c in :topicIds];
        map<id,decimal> RatedItemMap = new map<id,decimal>();        
                   
        
        for (Rated_Item__c rtdItm :RatedItemLst) {
                    RatedItemMap.put(rtdItm.Item_identifier__C,rtdItm.Rating_Average__c);  
        }  

             set<ID> BoardIds=new set<ID>();
         set<ID> PrivateBoardIds=new set<ID>();
         
        
       list<Learning_Board__c> lstPublicBoardIds =[SELECT  Id FROM Learning_Board__c where Is_Active__c=:true and Public__c=:true];
       for(Learning_Board__c lb: lstPublicBoardIds){
        BoardIds.add(lb.Id);
       }
       
       list<Learning_Board__c> lstPrivateBoardIds =[SELECT  Id FROM Learning_Board__c where Is_Active__c=:true and Public__c=:false];
       for(Learning_Board__c lbPrviate: lstPrivateBoardIds){
        PrivateBoardIds.add(lbPrviate.Id);
       }
       
       
     List<Learning_Board_Member__c> lstBoardMember =[SELECT Learning_Board_ID__c, Id, User_Id__c, Status__c FROM Learning_Board_Member__c where User_Id__c =:UserInfo.getUserId()  and Status__c=:'Approved' and  Learning_Board_ID__c in:PrivateBoardIds];
     
     for(Learning_Board_Member__c lbmc:lstBoardMember){
    
     BoardIds.add(lbmc.Learning_Board_ID__c);

     }
     List<Learning_Board__Share> lstBoardShare= [SELECT Id, ParentId, UserOrGroupId FROM Learning_Board__Share where ParentId in:PrivateBoardIds and UserOrGroupId =:UserInfo.getUserId()];
     
     for(Learning_Board__Share lbs:lstBoardShare ){
           BoardIds.add(lbs.ParentId);
     }
     
     integer iCount=TopicCnt;
       for(Learning_Board_learning__c lrng: lrngSearchResult){
       
       if(BoardIds.contains(lrng.Learning_Board_ID__r.id)){
                LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();
                lbCustom.TopicType=lrng.Learning_ID__r.Type__C;
                if(lrng.Learning_ID__r.Type__C !=null)
                {
                    if(lbCustom.TopicType.contains('Link or Document'))
                    {
                        lbCustom.TopicType='Upload Document';
                    }
                }
                
                if(lrng.Learning_ID__r.URL__C != null)
                {
                    //if(lrng.Learning_ID__r.URL__C.contains('sharepoint'))
                    if(lrng.Learning_ID__r.URL__C.contains('prime31.sharepoint.hp.com/teams/social%20learning/FileRepoWS/Uploads') || lrng.Learning_ID__r.URL__C.contains('intranet.hp.com/enterpriseservices/ww/site/'))
                    {
                        lbCustom.TopicURL = 'https://it-services-gw-itg.external.hp.com/gw/esit/sfdc/idol.dev/action=View&NoACI=true&OutputType=RAW&IgnoreCache=true&reference=' + lrng.Learning_ID__r.URL__C;
                    }
                    else
                    {
                    lbCustom.TopicURL=lrng.Learning_ID__r.URL__C;
                    }
                }
                else
                {
                    lbCustom.TopicURL=lrng.Learning_ID__r.URL__C;
                }
                
                lbCustom.LBName = lrng.Learning_Board_ID__r.Name__c; 

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
                    lbCustom.TopicCount=iCount;
                        iCount++;
                lbCustom.LBid = lrng.Learning_Board_ID__r.id;
                lbCustom.TopicId=lrng.Learning_ID__r.id;
                lbCustom.TopicName=lrng.Learning_ID__r.Name__c;
                lbCustom.TopicImageUrl=lrng.Learning_ID__r.Default_Image_Name__c;
                if(lrng.Learning_ID__r.description__c!=null){
                    if(lrng.Learning_ID__r.description__c.length()>1000){                    
                        lbCustom.LBDescription = lrng.Learning_ID__r.Description__c.substring(0,1000) + '...';
                    }
                    else{
                        lbCustom.LBDescription=lrng.Learning_ID__r.description__c;
                    }
                }
                
                if(lbCustom.TopicType=='Video')
                        {
                        lbCustom.BoardOrCommunityVideo=fileVideoUpload;
                        lbCustom.IsVideo=true;
                        if(lbCustom.TopicURL!=null)
                            {
                             if( lbCustom.TopicURL.contains('youtube.com') && lbCustom.TopicURL.contains('watch?v=')){
                                  lbCustom.TopicURL=lbCustom.TopicURL.replace('watch?v=', 'embed/');
                                  lbCustom.TopicURL=lbCustom.TopicURL.replace('http:', 'https:');
                                }
                            else if(lbCustom.TopicURL.contains('www.brainshark.com')){
                              lbCustom.TopicURL=lbCustom.TopicURL+'&dm=5&pause=1&nrs=1';
                                  
                            }
                            }
                        }
                
                 else if( lbCustom.TopicURL!=null)
                    {            
                        system.debug('lbCustom.TopicURL:' + lbCustom.TopicURL);               
                        if(lbCustom.TopicURL.toLowerCase().contains('.pdf'))
                        {
                          lbCustom.TopicDocType='PDF';
                        }
                        else if(lbCustom.TopicURL.toLowerCase().contains('.ppt'))
                        {
                          lbCustom.TopicDocType='PPT';
                        }  
                        else if(lbCustom.TopicURL.toLowerCase().contains('.xls'))
                        {
                          lbCustom.TopicDocType='XLS';
                        }                    
                        
                        else if(lbCustom.TopicURL.toLowerCase().contains('.txt'))
                        {
                          lbCustom.TopicDocType='TXT';
                        }                    
                        else if(lbCustom.TopicURL.toLowerCase().contains('.doc') || lbCustom.TopicURL.toLowerCase().contains('.docx'))
                        {
                          lbCustom.TopicDocType='DOC';
                        }
                        else
                        {
                          lbCustom.TopicType='Link or Document';
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
                
                for(User userData:userImagesLst)
                {
                if(userData.Id==lrng.Learning_ID__r.Owner.Id)
                {
                userImageUrl=userData.SmallPhotoUrl;
                if(userData.Name != null)
                {
                    if(userData.Name.length() > 16)
                    lbCustom.LBOwnerName = userData.Name.substring(0, 16) + '...';
                    else
                        lbCustom.LBOwnerName = userData.Name;
                }
                }
                }
                
                //for(FeedItem commentData:feedItemsLst)
                //{
                //if(commentData.Id==lrng.Learning_ID__r.Id)
                //{
                //finalFeedsLst.add(commentData);                
                //}
                //commentCount=finalFeedsLst.size();
                //}
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
                lbCustom.LBCrtDate = lrng.Learning_ID__r.CreatedDate.format('MMM dd ');
 
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
                lbCustom.IsContentAttchment=true;
                lbCustom.StaticImage=false;
                }
                lbCustom.BoardCommunityNm='/apex/AthenaLearningBoardDtls?id='+lbCustom.LBid+'&topicid='+lbCustom.TopicId+'';        
                 lbCustom.BoardCommunityIdolTopicstype='/apex/AthenaLearningBoardDtls?id='+lbCustom.LBid+'';        
                //lbCustom.IsPreviewRequired = AthenaUtility.ApplicationSettingValue(AthenaUtility.PreviewRequired);
                SearchListOfTopics.add(lbCustom);                
            }
            }
            TopicResultCount=SearchListOfTopics.size();                 
            //feedItemsLst=null;
            userImagesLst=null;
            return SearchListOfTopics;
    }
    
    
    
    Private void GetLearningBoard()
    {
       list<LearningBoardCustomClass> ListFeaturedLB = new List<LearningBoardCustomClass>();
        list<Attachment> attachmentList = new List<Attachment>(); 
        list<id> learningBoardIds= new list<id>();
        string resourceURL= GetResourceURL('img_athena');
        //List<FeedItem> feedItemsLst=getLBCommentCountLst();
        List<User> userImagesLst=getLearningBoardUserImagesLst();
     List<FeedItem> finalFeedsLst=new List<FeedItem>();
     string userImageUrl='';

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
        
           Map<String,string> AttMap = new Map<String,string>();   
           list<Attachment> Att = [SELECT Id,ParentId FROM Attachment WHERE Parentid in :learningBoardIds and ContentType in:AthenaUtility.ContentType()];
           for (Attachment at : Att)
           {                        
              AttMap.put(at.ParentId,at.Id);            
           }      
        //attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
               
        
        List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c in :learningBoardIds];
        Map<String,Integer> CmntCntMap = new Map<String,Integer>();
        List<FeedItem> feeddItmlst = [SELECT ParentId FROM FeedItem where Type='TextPost' and ParentId IN :learningBoardIds];

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
                //for(FeedItem commentData:feedItemsLst)
                //{
                //if(commentData.Id==lb.Id)
                //{
                //finalFeedsLst.add(commentData);                
                //}
                //commentCount=finalFeedsLst.size();
                //}
                
                // START By Komala
                
                for (FeedItem feedItm : feeddItmlst){            
              if(!CmntCntMap.containskey(feedItm.ParentId)){
                  CmntCntMap.put(feedItm.ParentId,1);
              }
              else{
                  integer i = CmntCntMap.get(feedItm.parentId);
                  CmntCntMap.put(feedItm.parentId,i+1);            
              }
        }  
                
                // END By Komala
                        
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
                lbCustom.LBCrtDate = lb.CreatedDate.format('MMM dd ');
                lbCustom.LBNoOfComments =   CmntCntMap.get(lb.id);  
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
            //feedItemsLst=null;
            userImagesLst=null;               
    }

     Private void GetCommunities()
    {
    list<LearningBoardCustomClass> ListFeaturedLB = new List<LearningBoardCustomClass>();
    list<Attachment> attachmentList = new List<Attachment>(); 
    list<id> communityIds= new list<id>();
    string resourceURL= GetResourceURL('img_athena');
    //List<FeedItem> feedItemsLst=getLBCommentCountLst();
    List<User> userImagesLst=getCommunityUserImagesLst();
    List<FeedItem> finalFeedsLst=new List<FeedItem>();
    string userImageUrl='';
//    integer commentCount=0;
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

           Map<String,string> AttMap = new Map<String,string>();   
           list<Attachment> Att = [SELECT Id,ParentId FROM Attachment WHERE Parentid in :communityIds and ContentType in:AthenaUtility.ContentType()];
           for (Attachment at : Att)
           {                        
              AttMap.put(at.ParentId,at.Id);            
           }                      
           
                   List<FeedItem> feeddItmlst = [SELECT ParentId FROM FeedItem where Type='TextPost' and ParentId IN :communityIds];
 
 
        Map<String,Integer> CmntCntMap = new Map<String,Integer>();
        system.debug('FI##'+feeddItmlst);
        for (FeedItem feedItm : feeddItmlst){            
              if(!CmntCntMap.containskey(feedItm.ParentId)){
                  CmntCntMap.put(feedItm.ParentId,1);
              }
              else{
                  integer i = CmntCntMap.get(feedItm.parentId);
                  CmntCntMap.put(feedItm.parentId,i+1);            
              }
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
                //for(FeedItem commentData:commcount)
                //{
            //if(commentData.Id==comm.Id)
            //{
             //   finalFeedsLst.add(commentData);                
            //}
            //commentCount=finalFeedsLst.size();
              //  }
                        
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
                commCustom.LBCrtDate = comm.CreatedDate.format('MMM dd ');
                commCustom.LBNoOfComments = CmntCntMap.get(comm.id);  
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
            //feedItemsLst=null;
            userImagesLst=null;               
    }
    
    
    
    
        private List<User> getLearningBoardUserImagesLst(){
        List<User> userImgLst = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id IN (select ownerId from learning_board__c)];
        return userImgLst;
    }
    
    private List<User> getTopicsUserImagesLst(){
        List<User> userImgLst = [Select u.SmallPhotoUrl,u.Name, u.FullPhotoUrl From User u where u.id IN (select createdbyid from learning__c)];
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
    
    
    
    //Learning Board Comment Count
    Private integer getLBCommentCount(string lbID){
        List<FeedItem> commCount = [Select id from FeedItem where parentID=:lbID];
        return commCount.size();
    }
    
    
    Private String getUserImage(Id uid){
        User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id=:uid];
        return u.smallPhotoUrl;
    }
    
    Public static User GetLoggedinUserDtls(){
        User u = [Select Name,Email,SmallPhotoUrl From User where User.id= :UserInfo.getUserId()];
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
    
//    public void GetPeople()
//    {
//        Set<String> boardUids = new Set<String>();
//        Set<String> boardIds = new Set<String>();
//        List<Learning_Board__Share> lbShare = new List<Learning_Board__Share>();
//        List<Community__Share> commShare = new List<Community__Share>();
//        List<Collateral__Share> collShare = new List<Collateral__Share>();
//        //
//        // get learning board ids that were returned from the search
//        // 
//        for (LearningBoardCustomClass b : BoardResult) {
//            if (!boardIds.contains(b.id)) {
//                boardIds.add(b.id);
//            }                
//        }
        
//        for (LearningBoardCustomClass b : TopicsResult) {
//            if (!boardIds.contains(b.LBid)) {
//                boardIds.add(b.LBid);
//            }                
//        }
        
//        for (LearningBoardCustomClass b : CommunityResult) {
//            if (!boardIds.contains(b.LBid)) {
//                boardIds.add(b.LBid);
//            }                
//        }

//        for (LearningBoardCustomClass b : CollResult) {
//            if (!boardIds.contains(b.LBid)) {
//                boardIds.add(b.LBid);
//            }                
//        }

//        //
//        // get the owners ('All' access) and contributors ('Edit' access) of the Learning Boards returned from the search
//        // 
//        lbShare = [select UserOrGroupId from Learning_Board__Share where AccessLevel in ('Edit', 'All') and ParentId in : boardIds];
//        for (Learning_Board__Share b : lbShare) {
//            if (!boardUids.contains(b.UserOrGroupId)) {
//                boardUids.add(b.UserOrGroupId);
//            }                
//        }
//        //
//        // get the owners ('All' access) and contributors ('Edit' access) of the Communities returned from the search
//        // 
//        commShare = [select UserOrGroupId from Community__Share where AccessLevel in ('Edit', 'All') and ParentId in : boardIds];
//        for (Community__Share b : commShare) {
//            if (!boardUids.contains(b.UserOrGroupId)) {
//                boardUids.add(b.UserOrGroupId);
//            }                
//        }
//      //
//        // get the owners ('All' access) and contributors ('Edit' access) of the Collateral returned from the search
//        // 
//        collShare = [select UserOrGroupId from Collateral__Share where AccessLevel in ('Edit', 'All') and ParentId in : boardIds];
//        for (Collateral__Share b : collShare) {
//            if (!boardUids.contains(b.UserOrGroupId)) {
//                boardUids.add(b.UserOrGroupId);
//            }                
//        }
//        //
//        //  get the users with matches on their names for the search filter value
//        // 
//        String  SearchStrWithLike= '%'+ searchText+ '%';

//        List<sObject> usersMatch = [SELECT AssigneeId
//                FROM PermissionSetAssignment 
//                where PermissionSet.Name in ('ES_Social_Learning_Consumer', 'ES_Social_Learning_Producer', 'ES_Social_Learning_Moderator') 
//                and Assignee.Name like : SearchStrWithLike ];
        
//         for (sObject b : usersMatch) { 
//            if (!boardUids.contains(String.valueOf(b.get('AssigneeId')))) {
//                boardUids.add(String.valueOf(b.get('AssigneeId')));
//            }
//         }
        
//        List<User> usersMatch2 = [select u.id from User u where u.Profile.Name = 'ES IT Administrator' and  u.name like : SearchStrWithLike];
        
//        system.debug('SearchStrWithLike:' + SearchStrWithLike);

//         for (User b : usersMatch2) {
//            if (!boardUids.contains(b.id)) {
//                boardUids.add(b.id);
//            }
//         }

//         //Mahesh
//         set<ID> RoleIds=new set<ID>();
//         set<ID> ExpertIds=new set<ID>();
//         set<ID> SetEsExpertsUserIds=new set<ID>();
         
//         list<SLP_Role__c> lstSLPRoles=[SELECT Id FROM SLP_Role__c  where Is_Active__c=:True and Role_Name__c like: SearchStrWithLike];
         
//         for(SLP_Role__c slpRole: lstSLPRoles)
//         {
//          RoleIds.add(slpRole.Id);
//         }       
//         system.debug('RoleIds:'+RoleIds.size());
//         list<SLP_Secondary_Industry__c> lstSLPSecondaryIdus=[SELECT Id  FROM SLP_Secondary_Industry__c where Is_Active__c=:True and Secondary_Industry_Name__c like: SearchStrWithLike];
//         for(SLP_Secondary_Industry__c SecInd:lstSLPSecondaryIdus)
//         {
//           ExpertIds.add(SecInd.Id);
//         }
//         system.debug('ExpertIds:'+ExpertIds.size());
//         list<ES_User__c> lstEsUser = [SELECT  User_Id__c, Role_ID__c,Role_ID__r.Role_Name__c FROM ES_User__c where Role_ID__c in : RoleIds];
//         for(ES_User__c ESUser:lstEsUser){
//            SetEsExpertsUserIds.add(ESUser.User_Id__c);     
//         }
//         system.debug('SetEsExpertsUserIds1:'+SetEsExpertsUserIds.size());
         
//         list<SLP_Expert__c> lstSLPExperts= [SELECT Id, ES_User_ID__r.User_ID__c, SLP_Secondary_Industry_ID__c FROM SLP_Expert__c where SLP_Secondary_Industry_ID__c in :ExpertIds];
//         system.debug('lstSLPExperts:'+lstSLPExperts.size());
         
//         for(SLP_Expert__c SLPExpert:lstSLPExperts){
//         if(!SetEsExpertsUserIds.contains(SLPExpert.ES_User_ID__r.User_ID__c)){
//         SetEsExpertsUserIds.add(SLPExpert.ES_User_ID__r.User_ID__c);
//         //MapExperts.put(SLPExpert.ES_User_ID__c);
//         }
//         }
         
          
         
//         system.debug('SetEsExpertsUserIds2:'+SetEsExpertsUserIds.size());
//         Map<Id,string> MapExpertUserRole=new Map<Id,string>();
         
//         list<ES_User__c> lstEsUsers = [SELECT  User_Id__c, Role_ID__c,Role_ID__r.Role_Name__c FROM ES_User__c where User_Id__c in : SetEsExpertsUserIds];
//                 system.debug('lstEsUsers:'+lstEsUsers.size());
//                 for(ES_User__c esUser:lstEsUsers ){
//                 string RoleName=esUser.Role_ID__r.Role_Name__c;
//                 MapExpertUserRole.put(esUser.User_Id__c,RoleName);
//                 }
//            for(ES_User__c esUser:lstEsUsers ){
//              if (!boardUids.contains(esUser.User_Id__c)) {
//                boardUids.add(esUser.User_Id__c);
//                }
//            }
            
//             Map<string,string> MapExperts=new Map<string,string>();
             
//         list<SLP_Expert__c> lstSecondaryInd=  [SELECT Id, ES_User_ID__r.User_ID__c, SLP_Secondary_Industry_ID__r.Industry_name__c,SLP_Secondary_Industry_ID__r.secondary_Industry_name__c  FROM SLP_Expert__c where ES_User_ID__r.User_ID__c in: SetEsExpertsUserIds];
        
//        for( SLP_Expert__c splEx: lstSecondaryInd){
//        if(MapExperts.containskey(splEx.ES_User_ID__r.User_ID__c)){
//        string StrList=MapExperts.get(splEx.ES_User_ID__r.User_ID__c)+', '+ splEx.SLP_Secondary_Industry_ID__r.secondary_Industry_name__c + '('+splEx.SLP_Secondary_Industry_ID__r.Industry_name__c+')';
        
//        MapExperts.put(splEx.ES_User_ID__r.User_ID__c,StrList);
//        }
//        else{
//        string StrLists=splEx.SLP_Secondary_Industry_ID__r.secondary_Industry_name__c +'(' + splEx.SLP_Secondary_Industry_ID__r.Industry_name__c +')';
//        MapExperts.put(splEx.ES_User_ID__r.User_ID__c,StrLists);
//        }
        
//        }
         
         
//         system.debug('MapExpertUserRole:'+MapExpertUserRole);
         
//         //

         
//        // 
//        // get the user details
//        // 
//        string resourceURL= GetResourceURL('img_athena');
//        string  ServerPath ='https://'+URL.getSalesforceBaseUrl().getHost();
//        string SecondaryIndImg=ServerPath+resourceURL+'/img_athena/bulbIcon.png';
//        List<User> users = [select u.id, u.name, u.title, u.department, u.SmallPhotoUrl, u.FullPhotoUrl from User u where u.id in : boardUids order by u.name];

//        list<ES_User__c> listEsuser = [SELECT  User_Id__c, Role_ID__c, Role_ID__r.Role_Name__c, Region_Id__r.Region_Name__c, Business_Group_Id__r.Business_Group_Name__c FROM ES_User__c where User_Id__c in :boardUids ];
//        Map<Id,string> MapUserRole = new Map<Id,string>();
//        Map<Id,string> MapBusinessGrp=new Map<Id,string>();
//        Map<Id,string> MapRegion=new Map<Id,string>();

//        for(ES_User__c esUser:listEsuser )
//        {
//             string RoleName = esUser.Role_ID__r.Role_Name__c;
//             string RegionName = esUser.Region_Id__r.Region_Name__c;
//             string BsnGrp = esUser.Business_Group_Id__r.Business_Group_Name__c;

//             MapUserRole.put(esUser.User_Id__c,RoleName);
//             MapBusinessGrp.put(esUser.User_Id__c,BsnGrp);
//             MapRegion.put(esUser.User_Id__c,RegionName);
//        }

//        for (User b : users) {
//            PeopleCustomClass pCustom = new PeopleCustomClass();
//            pCustom.Id = b.id;
//            pCustom.Name = b.name;
            
//            if(MapExpertUserRole.containskey(b.id)){
//            system.debug('ExpertUserRole:'+pCustom.ExpertUserRole);
//                pCustom.ExpertUserRole=MapExpertUserRole.get(b.id);
//                pCustom.SecondaryIndImage=SecondaryIndImg;
//                pCustom.IsSecondaryIndImg=true;
//            }
            

//            if(MapExperts.containskey(b.id))
//            {
//                pCustom.lstExperts=MapExperts.get(b.id);
//                pCustom.IsExperts = true;
//                system.debug('IsExperts:' + pCustom.IsExperts);
//            }
//            else
//            {
//                pCustom.IsExperts = false;
//                system.debug('IsExperts:' + pCustom.IsExperts);
//            }

//            if(MapUserRole.containsKey(b.id))
//            {
//                pCustom.RoleName = MapUserRole.get(b.id);
//            }

//            if(MapRegion.containsKey(b.id))
//            {
//                pCustom.Region = MapRegion.get(b.id);
//            }
            
//            if(MapBusinessGrp.containsKey(b.id))
//            {
//                pCustom.BusinessGroup = MapBusinessGrp.get(b.id);
//            }
            
////            pCustom.Title = b.title;
//                if(b.title!= null && b.title!= 'null')
//                {
//                   // pCustom.Title = b.title;
//                     if(b.title.length() > 25)
//                     {                            
//                        pCustom.Title = b.title.substring(0, 25) + '...';
//                     }
//                     else
//                     {
//                        pCustom.Title = b.title;
//                     }

//                }

//            if(pCustom.ExpertUserRole != null && pCustom.ExpertUserRole != 'null')
//            {
//                if(pCustom.ExpertUserRole.length() > 17)
//                {                            
//                    pCustom.ShortExpertUserRole = pCustom.ExpertUserRole.substring(0, 17) + '...';
//                }
//                else
//                {
//                    pCustom.ShortExpertUserRole = pCustom.ExpertUserRole;
//                }
//            }

//            pCustom.Department = b.department;
//            pCustom.SmallImageName = b.SmallPhotoUrl;
//            pCustom.FullImageName = b.FullPhotoUrl;
//            if(b.department!=null && b.title!=null && b.department!='null' && b.title!='null')
//            {
//                pCustom.TitleDepartment= b.title + ', ' + b.department;  
//            }
//            else if((b.department!=null && b.department!='null') && (b.title==null || b.title=='null'))
//            {
//                pCustom.TitleDepartment=  b.department;  
//            }
            
//            else if((b.department==null || b.department=='null')  && (b.title!=null && b.title!='null'))
//            {
//                pCustom.TitleDepartment=  b.title;  
//            }
//            else {
//                pCustom.TitleDepartment= '';
//            }
            
            
            
            
//            PeopleResult.add(pCustom);                            
//        }
        
//        PeopleResultCount = PeopleResult.size();
//    }
    
    
    private list<LearningBoardCustomClass> search(string searchText, integer startItem, integer endItem, integer pageSize)
    {
        boolean endIsUnknown = (endItem == -1);
        Integer count=0;
        list<LearningBoardCustomClass> lstIdolSearchResult=new list<LearningBoardCustomClass>();
        System.debug('test...'+searchText);
        try
        {
       /*  SLP_IdolQuery idol = new SLP_IdolQuery(
            this.SERVER, 
            this.DATABASE, 
            searchText, 
            pageSize, 
            this.MAX_HITS, 
            endItem);
            system.debug('idol123:'+idol);
                system.debug('idol:'+idol.Hits);
        if(endIsUnknown)
        {
            endItem = idol.Hits;
            this.MaxItem = endItem; // now the end is known
        }

        
        List<SLP_IdolQueryResponse> results = idol.Fetch(startItem);
        
        endItem = ((startItem + pageSize) > endItem) ? endItem : startItem + pageSize;
        System.debug('Search: items ' + startItem + ' to ' + endItem + ' (of ' + endItem + '.)');*/
         integer pageNo=1;
         SLP_IdolQuery idol = new SLP_IdolQuery();
         List<SLP_IdolQueryResponse> results = idol.FetchAll(searchText,pageNo,endItem);

        
        for(SLP_IdolQueryResponse r: results)
        {
        count++;
        if(r.Title!='' && r.Url!='')
        {
        LearningBoardCustomClass idolSearch=new LearningBoardCustomClass();
        idolSearch.IsIdolSearch=true;
        idolSearch.TopicURL=r.Url;
        idolSearch.LBName=r.Title;
        idolSearch.LBid=string.valueof(count);
        //idolSearch.LBDescription=r.Summary;
        system.debug('Veeresh IDOL URL ' + r.Url);
        
                    if(r.Summary!=null){
                string strRemoveHtml=r.Summary.replaceAll('(</{0,1}[^>]+>)',' ');
                
                //strRemoveHtml=strRemoveHtml.replaceAll('</font>',' ');
                    
                            if(strRemoveHtml.length()>1000){                    
                            idolSearch.LBDescription = strRemoveHtml.substring(0,1000) + '...';
                            }
                            else{
                            idolSearch.LBDescription=strRemoveHtml;
                            }
                        }
        
        idolSearch.TopicType='Link or Document';
        //idolSearch.BoardCommunityIdolTopicstype='/apex/SLP_EditCommunity?id=LBid';
        if( idolSearch.TopicURL!=null)
                    {  
                        system.debug('Other Server Topic url:'+ idolSearch.TopicURL);               
                        
                        if(idolSearch.TopicURL.contains('.pdf'))
                        {
                          idolSearch.TopicDocType='PDF';
                        }
                        else if(idolSearch.TopicURL.contains('.ppt'))
                        {
                          idolSearch.TopicDocType='PPT';
                        }                    
                        else if(idolSearch.TopicURL.contains('.txt'))
                        {
                          idolSearch.TopicDocType='TXT';
                        }  
                        else if(idolSearch.TopicURL.contains('.doc'))
                        {
                        if(idolSearch.TopicURL.contains('.docx'))
                        {
                        string[] strTopicUrl=idolSearch.TopicURL.split('.docx');
                          idolSearch.TopicURL=strTopicUrl[0]+'.docx';
                        }
                        else if(idolSearch.TopicURL.contains('.doc'))
                        {
                            string[] strTopicUrl=idolSearch.TopicURL.split('.doc');
                          idolSearch.TopicURL=strTopicUrl[0]+'.doc';
                        }
                          
                        
                          idolSearch.TopicDocType='DOC';
                        }
                        else
                        {
                          idolSearch.TopicDocType='OTHER';
                        }
                        //by Indra                      
                        
                        if(idolSearch.TopicURL.contains('intranet.hp.com/enterpriseservices/ww/site/'))
                        {
                            system.debug('Other Server Topic url:'+ idolSearch.TopicURL);
                            idolSearch.TopicURL = 'https://it-services-gw-itg.external.hp.com/gw/esit/sfdc/idol.dev/action=View&NoACI=true&OutputType=RAW&IgnoreCache=true&reference=' + idolSearch.TopicURL;
                        }
                    }
                    
        
        lstIdolSearchResult.add(idolSearch);
        }
        }
        }
        catch(Exception ex)
        {
           
        }
        system.debug('lstIdolSearchResult:'+lstIdolSearchResult.size());
        return lstIdolSearchResult;
        
            }
            
@RemoteAction
public static void MetricCommunity(string CommunityId,string QueryString)
{
    /*User userDtls= GetLoggedinUserDtls();
    string strPagePath='/apex/SLP_ViewCommunity?id='+CommunityId;
    
 AthenaUtility.InsertMetricAction(userDtls.Email,strPagePath,'Link','','','','','','',QueryString,'');
 
   PageReference pRef = new PageReference('/apex/SLP_ViewCommunity');
        pRef.getParameters().put('id', CommunityId);
        pRef.setRedirect(true);
        return pRef;
        */
 //return pref;
 //return CommunityId;
}


@RemoteAction
public static void MetricBoard(string BoardId,string QueryString)
{
    /*User userDtls= GetLoggedinUserDtls();
    string strPagePath='/apex/AthenaLearningBoardDtls?id='+BoardId;
    
 AthenaUtility.InsertMetricAction(userDtls.Email,strPagePath,'Link','','','','','','',QueryString,'');
 
   PageReference pRef = new PageReference('/apex/AthenaLearningBoardDtls');
        pRef.getParameters().put('id', BoardId);
        pRef.setRedirect(true);
        return pRef;
         */
 //return pref;
 //return CommunityId;
}

public  List<String> GetRecentSearchResult
{
 get
 {
  //List<SLP_RecentSearch__c> lstSlpRcnt=new List<SLP_RecentSearch__c>();
  //lstSlpRcnt=[SELECT Search_Text__c FROM SLP_RecentSearch__c   order by LastModifiedDate desc limit 10];
 // List<MetricsAction__c> lstSlpRcnt=new List<MetricsAction__c>();
 
 
  List<string> lstSlpRcnt=new List<string>(); 
 AggregateResult[] results =[SELECT Search_Text__c FROM MetricsAction__c group by ActionType__c,Search_Text__c having ActionType__c='Global Search Button Click' order by count(id) desc limit 10];
  for(AggregateResult ar : results)
  {
   lstSlpRcnt.add((string)ar.get('Search_Text__c'));
  }
  
  return lstSlpRcnt;
  }
  set;
}


    public void GetExperts()
    {
     string  SearchStrWithLike = '%'+ searchText+ '%';
     
     List<string> boardUids=new List<string>();
         Map<Id,string> MapUserRole = new Map<Id,string>();
        Map<Id,string> MapBusinessGrp=new Map<Id,string>();
        Map<Id,string> MapRegion=new Map<Id,string>();
        Map<Id,string> MapExpertUserRole = new Map<Id,string>();
        Map<string,string> MapExperts=new Map<string,string>();
     
     List<SLP_Expert__c> lstSlpExpers= [SELECT Id, ES_User_ID__r.User_ID__c,ES_User_ID__r.User_ID__r.name, SLP_Secondary_Industry_ID__r.Industry_name__c,SLP_Secondary_Industry_ID__r.secondary_Industry_name__c  FROM SLP_Expert__c where SLP_Secondary_Industry_ID__r.secondary_Industry_name__c like : SearchStrWithLike and Is_Expert__c = True];
    // List<SLP_Expert__c> lstSlpExperNms= [SELECT Id, ES_User_ID__r.User_ID__c,ES_User_ID__r.User_ID__r.name, SLP_Secondary_Industry_ID__r.Industry_name__c,SLP_Secondary_Industry_ID__r.secondary_Industry_name__c  FROM SLP_Expert__c where ES_User_ID__r.User_ID__r.name Like : SearchStrWithLike and Is_Expert__c = True];
     system.debug('lstSlpExpers:'+lstSlpExpers.size());
     
     for(SLP_Expert__c SLPE:lstSlpExpers)
     {
       boardUids.add(SLPE.ES_User_ID__r.User_ID__c);
     }
     /*
         for(SLP_Expert__c SLPNm:lstSlpExperNms)
         {
           boardUids.add(SLPNm.ES_User_ID__r.User_ID__c);
         }
     */
     string resourceURL= GetResourceURL('img_athena');
        string  ServerPath ='https://'+URL.getSalesforceBaseUrl().getHost();
        string SecondaryIndImg=ServerPath+resourceURL+'/img_athena/bulbIcon.png';

        list<ES_User__c> lstEsUsers = [SELECT  User_Id__c, Role_ID__c,Role_ID__r.Role_Name__c FROM ES_User__c where User_Id__c in : boardUids];
         
         system.debug('lstEsUsers:'+lstEsUsers.size());
         
         for(ES_User__c esUser:lstEsUsers )
         {
            string RoleName = esUser.Role_ID__r.Role_Name__c;
            MapExpertUserRole.put(esUser.User_Id__c,RoleName);
         }
        

        List<User> users = [select u.id, u.name, u.title, u.department, u.SmallPhotoUrl, u.FullPhotoUrl from User u where u.id in : boardUids order by u.name];

        list<ES_User__c> listEsuser = [SELECT  User_Id__c, Role_ID__c, Role_ID__r.Role_Name__c, Region_Id__r.Region_Name__c, Business_Group_Id__r.Business_Group_Name__c FROM ES_User__c where User_Id__c in :boardUids ];

        for(ES_User__c esUser:listEsuser )
        {
             string RoleName = esUser.Role_ID__r.Role_Name__c;
             string RegionName = esUser.Region_Id__r.Region_Name__c;
             string BsnGrp = esUser.Business_Group_Id__r.Business_Group_Name__c;

             MapUserRole.put(esUser.User_Id__c,RoleName);
             MapBusinessGrp.put(esUser.User_Id__c,BsnGrp);
             MapRegion.put(esUser.User_Id__c,RegionName);
        }

        for (User b : users)
        {
            PeopleCustomClass pCustom = new PeopleCustomClass();
            pCustom.Id = b.id;
            pCustom.Name = b.name;
            
            if(MapExpertUserRole.containskey(b.id))
            {
                system.debug('ExpertUserRole:'+pCustom.ExpertUserRole);
                pCustom.ExpertUserRole=MapExpertUserRole.get(b.id);
                pCustom.SecondaryIndImage=SecondaryIndImg;
                pCustom.IsSecondaryIndImg=true;
            }
            
                pCustom.IsExperts = true;
               

            if(MapUserRole.containsKey(b.id))
            {
                pCustom.RoleName = MapUserRole.get(b.id);
            }

            if(MapRegion.containsKey(b.id))
            {
                pCustom.Region = MapRegion.get(b.id);
            }
            
            if(MapBusinessGrp.containsKey(b.id))
            {
                pCustom.BusinessGroup = MapBusinessGrp.get(b.id);
            }
            
            if(pCustom.ExpertUserRole != null && pCustom.ExpertUserRole != 'null')
            {
                if(pCustom.ExpertUserRole.length() > 17)
                {                            
                    pCustom.ShortExpertUserRole = pCustom.ExpertUserRole.substring(0, 17) + '...';
                }
                else
                {
                    pCustom.ShortExpertUserRole = pCustom.ExpertUserRole;
                }
            }

            pCustom.Department = b.department;
            pCustom.SmallImageName = b.SmallPhotoUrl;
            pCustom.FullImageName = b.FullPhotoUrl;
            
            ExpertResult.add(pCustom);                            
        }
        ExpertResultCount = ExpertResult.size();
     
    }

    public void GetPeople()
    {
        string  SearchStrWithLike = '%'+ searchText+ '%';
        
        Set<String> boardUids = new Set<String>();
        set<ID> RoleIds = new set<ID>();
        set<ID> ExpertIds = new set<ID>();
        set<ID> SetEsExpertsUserIds = new set<ID>();
        Map<Id,string> MapUserRole = new Map<Id,string>();
        Map<Id,string> MapBusinessGrp=new Map<Id,string>();
        Map<Id,string> MapRegion=new Map<Id,string>();
        Map<Id,string> MapExpertUserRole = new Map<Id,string>();
        Map<string,string> MapExperts=new Map<string,string>();

        list<SLP_Role__c> lstSLPRoles = [SELECT Id FROM SLP_Role__c  where Is_Active__c =: True and Role_Name__c like : SearchStrWithLike];
         
        for(SLP_Role__c slpRole: lstSLPRoles)
        {
            RoleIds.add(slpRole.Id);
        }       
        
        system.debug('RoleIds:'+RoleIds.size());

       // list<SLP_Secondary_Industry__c> lstSLPSecondaryIdus = [SELECT Id  FROM SLP_Secondary_Industry__c where Secondary_Industry_Name__c like : SearchStrWithLike];
        
       // for(SLP_Secondary_Industry__c SecInd : lstSLPSecondaryIdus)
        //{
            //ExpertIds.add(SecInd.Id);
        //}

        //system.debug('ExpertIds:'+ExpertIds.size());

        list<ES_User__c> lstEsUser = [SELECT  User_Id__c, Role_ID__c,Role_ID__r.Role_Name__c FROM ES_User__c where Role_ID__c in : RoleIds];

        for(ES_User__c ESUser:lstEsUser)
        {
            SetEsExpertsUserIds.add(ESUser.User_Id__c);     
        }

        system.debug('SetEsExpertsUserIds1:'+SetEsExpertsUserIds.size());
         
        //list<SLP_Expert__c> lstSLPExperts = [SELECT Id, ES_User_ID__r.User_ID__c, SLP_Secondary_Industry_ID__c FROM SLP_Expert__c where SLP_Secondary_Industry_ID__r.secondary_Industry_name__c Like :SearchStrWithLike and Is_Expert__c =: true];
        list<SLP_Expert__c> lstSLPExperts = [SELECT Id, ES_User_ID__r.User_ID__c, SLP_Secondary_Industry_ID__c FROM SLP_Expert__c where SLP_Secondary_Industry_ID__r.secondary_Industry_name__c Like :SearchStrWithLike];

        system.debug('lstSLPExperts:----------------'+lstSLPExperts.size());
         
         for(SLP_Expert__c SLPExpert:lstSLPExperts)
         {
            if(!SetEsExpertsUserIds.contains(SLPExpert.ES_User_ID__r.User_ID__c))
            {
                SetEsExpertsUserIds.add(SLPExpert.ES_User_ID__r.User_ID__c);
            }
         }
         
         system.debug('SetEsExpertsUserIds2:-------------'+SetEsExpertsUserIds.size());
         
         list<ES_User__c> lstEsUsers = [SELECT  User_Id__c,User_Id__r.name, Role_ID__c,Role_ID__r.Role_Name__c FROM ES_User__c where User_Id__c in : SetEsExpertsUserIds];
         
         system.debug('lstEsUsers:-----------'+lstEsUsers.size());
         for(ES_User__c esUser:lstEsUsers )
         {
            system.debug('esUser--------'+esUser.User_Id__r.name);
            string RoleName = esUser.Role_ID__r.Role_Name__c;
            MapExpertUserRole.put(esUser.User_Id__c,RoleName);
         }

         for(ES_User__c esUser:lstEsUsers )
         {
            if (!boardUids.contains(esUser.User_Id__c))
            {
                boardUids.add(esUser.User_Id__c);
            }
         }

        List<User> listUsers = [SELECT Id, Username, LastName, FirstName, Name FROM User where Name like : SearchStrWithLike and IsActive=true and email like '%@hp.com'];

        for(User esUser: listUsers)
        {
            if (!boardUids.contains(esUser.Id))
            {
                boardUids.add(esUser.Id);
            }
        }
        
        /////Mahesh Added 9th oct
        
        SET<ID> finalCommunityIdSet = new SET<ID>();
        SET<ID> finalBrdIdSet = new SET<ID>();
         set<Id> CoummUserId=new Set<Id>();
         set<Id> BrdCommOwners=new Set<Id>();
         set<Id> BrdCommContributors=new Set<Id>();
         Map<string,string> mapBrdCommOwners=new Map<string,string>();
         
    List<Community__c> communitySrchRslt= new List<Community__c>([SELECT Id,Name__c,Name,Owner.Id FROM Community__c WHERE (Name__c like : SearchStrWithLike OR Short_description__c Like : SearchStrWithLike)and isActive__c=true]);
        
    for(Community__c comm : communitySrchRslt){
        finalCommunityIdSet.add(comm.id);
        mapBrdCommOwners.put(comm.Owner.Id,comm.Owner.Id);
          if (!boardUids.contains(comm.Owner.Id))
            {
                boardUids.add(comm.Owner.Id);
            }
    }       
    List<Learning_Board__c> lrngBrdSrchRslt= new List<Learning_Board__c>([SELECT Id,Name__c,Name,Owner.Id FROM Learning_Board__c WHERE (Name__c like : SearchStrWithLike OR Short_description__c Like : SearchStrWithLike Or Sub_Title__c Like:SearchStrWithLike)and is_Active__c=true]);
    for(Learning_Board__c Lrng : lrngBrdSrchRslt){
        finalBrdIdSet.add(Lrng.id);
        mapBrdCommOwners.put(Lrng.Owner.Id,Lrng.Owner.Id);
        if (!boardUids.contains(Lrng.Owner.Id))
        {
            boardUids.add(Lrng.Owner.Id);
        }
    }
    
     set<Id> CommuCat=new Set<Id>();
     
     
    List<Community_Category__c> lstCommCategory= [SELECT Id, Community_ID__c, Name__c, Description__c, IsActive__c FROM Community_Category__c where IsActive__c =true and Community_ID__c in: finalCommunityIdSet];
    
    for(Community_Category__c CCC: lstCommCategory)
    {
      CommuCat.add(CCC.Id);
    }
    
    Map<string,boolean> mapCommContributor=new Map<string,boolean>();
    List<Collateral__c> lstColl= [SELECT  Id, CreatedById, OwnerId FROM Collateral__c where IsActive__c =true and  Community_Category_ID__c in:CommuCat];
     
     for(Collateral__c Coll:lstColl)
     {
        if (!boardUids.contains(Coll.CreatedById))
            {
                boardUids.add(Coll.CreatedById);
            }
            mapCommContributor.put(Coll.CreatedById,true);
        }
        
        
        LIST<Learning_Board_learning__c> lrngSearchResult= [select learning_ID__r.id ,Learning_ID__r.CreatedById from Learning_board_learning__c where learning_ID__r.Is_Active__c  = true and Learning_Board_ID__c IN:finalBrdIdSet ];
                                                                                                                                            
        for (Learning_Board_learning__c lrng: lrngSearchResult)
        {
           if (!boardUids.contains(lrng.Learning_ID__r.CreatedById))
            {
                boardUids.add(lrng.Learning_ID__r.CreatedById);
            }
            mapCommContributor.put(lrng.Learning_ID__r.CreatedById,true);
        }       
        
        
        /// End 9 oct
        
        
        
            list<SLP_Expert__c> lstSecondaryInd = [SELECT Id, ES_User_ID__r.User_ID__c, SLP_Secondary_Industry_ID__r.Industry_name__c,SLP_Secondary_Industry_ID__r.secondary_Industry_name__c  FROM SLP_Expert__c where SLP_Secondary_Industry_ID__r.secondary_Industry_name__c Like :SearchStrWithLike and Is_Expert__c =: true];
           system.debug('lstSecondaryInd------------'+lstSecondaryInd.size());
           //list<SLP_Expert__c> lstSecondaryInd = [SELECT Id, ES_User_ID__r.User_ID__c, SLP_Secondary_Industry_ID__c,SLP_Secondary_Industry_ID__r.secondary_Industry_name__c FROM SLP_Expert__c where SLP_Secondary_Industry_ID__r.secondary_Industry_name__c Like :SearchStrWithLike and Is_Expert__c =: true];
        for( SLP_Expert__c splEx: lstSecondaryInd)
        {
            
            if(MapExperts.containskey(splEx.ES_User_ID__r.User_ID__c))
            {
                string StrList = MapExperts.get(splEx.ES_User_ID__r.User_ID__c)+', '+ splEx.SLP_Secondary_Industry_ID__r.secondary_Industry_name__c + '('+splEx.SLP_Secondary_Industry_ID__r.Industry_name__c+')';
                MapExperts.put(splEx.ES_User_ID__r.User_ID__c,StrList);
                
            }
            else
            {
                string StrLists=splEx.SLP_Secondary_Industry_ID__r.secondary_Industry_name__c +'(' + splEx.SLP_Secondary_Industry_ID__r.Industry_name__c +')';
                MapExperts.put(splEx.ES_User_ID__r.User_ID__c,StrLists);
            }
        }
         system.debug('MapExpertUserRole:'+MapExpertUserRole);

        string resourceURL= GetResourceURL('img_athena');
        string  ServerPath ='https://'+URL.getSalesforceBaseUrl().getHost();
        string SecondaryIndImg=ServerPath+resourceURL+'/img_athena/bulbIcon.png';


        List<User> users = [select u.id, u.name, u.title, u.department, u.SmallPhotoUrl, u.FullPhotoUrl from User u where u.id in : boardUids order by u.name];

        list<ES_User__c> listEsuser = [SELECT  User_Id__c, Role_ID__c, Role_ID__r.Role_Name__c, Region_Id__r.Region_Name__c, Business_Group_Id__r.Business_Group_Name__c FROM ES_User__c where User_Id__c in :boardUids ];

        for(ES_User__c esUser:listEsuser )
        {
             string RoleName = esUser.Role_ID__r.Role_Name__c;
             string RegionName = esUser.Region_Id__r.Region_Name__c;
             string BsnGrp = esUser.Business_Group_Id__r.Business_Group_Name__c;

             MapUserRole.put(esUser.User_Id__c,RoleName);
             MapBusinessGrp.put(esUser.User_Id__c,BsnGrp);
             MapRegion.put(esUser.User_Id__c,RegionName);
        }
        
        
        

        for (User b : users)
        {
            PeopleCustomClass pCustom = new PeopleCustomClass();
            pCustom.Id = b.id;
            pCustom.Name = b.name;
            
            if(MapExpertUserRole.containskey(b.id))
            {
                system.debug('ExpertUserRole:'+pCustom.ExpertUserRole);
                pCustom.ExpertUserRole=MapExpertUserRole.get(b.id);
                pCustom.SecondaryIndImage=SecondaryIndImg;
                pCustom.IsSecondaryIndImg=true;
            }
            if(mapBrdCommOwners.containsKey(b.id))
            {
              pCustom.IsBrdCommOwner=true;
            }
            if(mapCommContributor.containsKey(b.id))
            {
             pCustom.IsCommunityContributor=true;
            }
            
            if(MapExperts.containskey(b.id))
            {
                pCustom.lstExperts=MapExperts.get(b.id);
                pCustom.IsExperts = true;
                system.debug('IsExperts:---------true---' + pCustom.IsExperts);
            }
            else
            {
                pCustom.IsExperts = false;
                system.debug('IsExperts:-------false---------' + pCustom.IsExperts);
            }

            if(MapUserRole.containsKey(b.id))
            {
                pCustom.RoleName = MapUserRole.get(b.id);
            }

            if(MapRegion.containsKey(b.id))
            {
                pCustom.Region = MapRegion.get(b.id);
            }
            
            if(MapBusinessGrp.containsKey(b.id))
            {
                pCustom.BusinessGroup = MapBusinessGrp.get(b.id);
            }
            
            if(pCustom.ExpertUserRole != null && pCustom.ExpertUserRole != 'null')
            {
                if(pCustom.ExpertUserRole.length() > 17)
                {                            
                    pCustom.ShortExpertUserRole = pCustom.ExpertUserRole.substring(0, 17) + '...';
                }
                else
                {
                    pCustom.ShortExpertUserRole = pCustom.ExpertUserRole;
                }
            }

            pCustom.Department = b.department;
            pCustom.SmallImageName = b.SmallPhotoUrl;
            pCustom.FullImageName = b.FullPhotoUrl;
            
            PeopleResult.add(pCustom);                            
        }
        PeopleResultCount = PeopleResult.size();
    }
    
    // START By Komala
    
    @RemoteAction
    public static String LogMetrics(string boardId,string boardName,string link,string tabSection,string operatingSystem,string browserVersion,string DeviceType)
    {  
        
        string userId=UserInfo.getUserId();            
        MetricsAction__c metricsObj=new MetricsAction__c();
        metricsObj.UserId__c=userId;
        metricsObj.OperatingSystem__c=operatingSystem;
        metricsObj.Browser__c=browserVersion;
        //metricsObj.Text__c=strSearchValue;
        if(link.contains('AthenaUserProfile'))
        {
         metricsObj.ActionType__c='People Hyperlink Click';
        }
        else
        {
        metricsObj.ActionType__c='Hyperlink Click';
        }
        metricsObj.ObjectId__c=boardId;
        //metricsObj.ObjectName__c=boardName;
               
        metricsObj.Text__c=boardName;
        metricsObj.ActionPath__c=link;
        metricsObj.PageName__c='Search Page';
        metricsObj.SessionId__c=UserInfo.getSessionId();
        if(link.contains('SLP_ViewCommunity') && link.contains('topicid'))
        {
        metricsObj.ObjectName__c='Community Topic';
        }
        else if(link.contains('SLP_ViewCommunity'))
        {
        metricsObj.ObjectName__c='Community';
        }
        else if(link.contains('AthenaLearningBoardDtls') && link.contains('topicid'))
        {
        metricsObj.ObjectName__c='Learning Board Topic';
        }  
        else if(link.contains('AthenaLearningBoardDtls'))
        {
        metricsObj.ObjectName__c='Learning Board';
        }        
        else if(link.contains('AthenaUserProfile'))
        {
        metricsObj.ObjectName__c='User Profile';
        }
        
        if(tabSection=='Communities Image Click')
        {
        tabSection='Communities Tab';
        metricsObj.ActionType__c='Communities Image Click';
        }
        
        if(tabSection=='Learning Board Image Click')
        {
        tabSection='Learning Board Tab';
        metricsObj.ActionType__c='Learning Board Image Click';
        }
        
        metricsObj.DeviceType__c=DeviceType;
        metricsObj.TabSection__c=tabSection;
        Insert(metricsObj);
        //PageReference pRef = new PageReference('/apex/AthenaLearningBoardDtls');
        //pRef.getParameters().put('id',boardId);
        //pRef.setRedirect(true);
        //return pRef;        
        return link;
    }
    
    @RemoteAction
    public static void LogTabMetrics(string tabName,string operatingSystem,string browserVersion)
    {
        string userId=UserInfo.getUserId();            
        MetricsAction__c metricsObj=new MetricsAction__c();
        metricsObj.UserId__c=userId;
        //metricsObj.Text__c=strSearchValue;
        metricsObj.ActionType__c='Tab Click';
        //metricsObj.ObjectId__c=boardId;
        metricsObj.TabSection__c=tabName+' '+'Tab';
        //metricsObj.ActionPath__c=tabName+' '+'Tab';
        metricsObj.PageName__c='Search Page';
        metricsObj.DeviceType__c='Desktop';
        metricsObj.SessionId__c=UserInfo.getSessionId();
        metricsObj.OperatingSystem__c=operatingSystem;
        metricsObj.Browser__c=browserVersion;
        Insert(metricsObj);
    }
    
    @RemoteAction
    public static void LogIdolSearchMetrics(string link,string operatingSystem,string browserVersion)
    {
        string userId=UserInfo.getUserId();            
        MetricsAction__c metricsObj=new MetricsAction__c();
        metricsObj.UserId__c=userId;
        //metricsObj.Text__c=strSearchValue;
        metricsObj.ActionType__c='Hyperlink Click';
        //metricsObj.ObjectId__c=boardId;
        metricsObj.ObjectName__c='Idol Result';
        metricsObj.TabSection__c='Content Tab';
        metricsObj.ActionPath__c=link;
        metricsObj.PageName__c='Search Page';
        metricsObj.DeviceType__c='Desktop';
        metricsObj.SessionId__c=UserInfo.getSessionId();
        metricsObj.OperatingSystem__c=operatingSystem;
        metricsObj.Browser__c=browserVersion;
        Insert(metricsObj);
        //return link;
    }
    
    @RemoteAction
    public static void LogDownloadMetrics(string link,string fileType,string operatingSystem,string browserVersion)
    {
        string userId=UserInfo.getUserId();            
        MetricsAction__c metricsObj=new MetricsAction__c();
        metricsObj.UserId__c=userId;
        //metricsObj.Text__c=strSearchValue;
        metricsObj.ActionType__c=fileType+' Document Click';
        //metricsObj.ObjectId__c=boardId;
        metricsObj.ObjectName__c='Document';
        metricsObj.TabSection__c='Content Tab';
        metricsObj.ActionPath__c=link;
        metricsObj.PageName__c='Search Page';
        metricsObj.DeviceType__c='Desktop';
        metricsObj.SessionId__c=UserInfo.getSessionId();
        metricsObj.OperatingSystem__c=operatingSystem;
        metricsObj.Browser__c=browserVersion;
        Insert(metricsObj);
    }
    
    public PageReference RedirectToPage()
    {
    string url='';  
    string boardid='';    
     
    if(RedirectUrl.contains('id='))
    {
    url=RedirectUrl.substring(RedirectUrl.lastIndexOf('/')+1,RedirectUrl.indexOf('?'));
    boardid=RedirectUrl.substring(RedirectUrl.indexOf('=')+1,RedirectUrl.length());    
    } 

    if(RedirectUrl.contains('SLP_GlobalSearch'))
    {
     PageReference pRef = new PageReference('/apex/SLP_GlobalSearch');
     pRef.getParameters().put('SearchOptions','multiselect-all,Boards,Topics,Community,People');
     pRef.getParameters().put('SearchVal',RedirectUrl.substring(RedirectUrl.lastIndexOf('=')+1,RedirectUrl.length()));
     pRef.setRedirect(true);
     return pRef;
    }
    else if (RedirectUrl.contains('topicid'))
    {
     PageReference pRef = new PageReference('/apex/'+url);
     pRef.getParameters().put('id',RedirectUrl.substring(RedirectUrl.indexOf('=')+1,RedirectUrl.indexOf('&')));
     pRef.getParameters().put('topicid',RedirectUrl.substring(RedirectUrl.lastIndexOf('=')+1,RedirectUrl.length()));
     pRef.setRedirect(true);
     return pRef;
    }    
    else
    {
        PageReference pRef = new PageReference('/apex/'+url);
        pRef.getParameters().put('id',boardId);
        pRef.setRedirect(true);
        return pRef;
        }

    }
    
    // END By Komala
}