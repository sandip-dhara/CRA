public without sharing class newAthenaSocialLearning {
  
    Public String strSearchValue{get;set;}
    Public boolean ShowSearch{get;set;}
    Public static integer MostLikedNoOfDays{get;set;}
    Public static integer MostCommentedNoOfDays{get;set;}
    public string AvailTags{get;set;}
    public boolean IsLearningBoardCreator{get;set;}   
    Public static Integer TotalNumberOfLB{get;set;}     
    Public static Integer TotalNumberOfCommunities{get;set;} 
    Public List<Community__c> NoOfComm{get;set;}
    Public Boolean showcomm{get;set;}
    Public static string staticpath{get;set;}   

     Public class LearningBoardCustomClass{
        public id AttachmentId{get;set;}        
        public String LBName{get;set;}
        public String LBDescription{get;set;}   
        public String LBid{get;set;}
        public String LBOwnerName{get;set;}
        public String LBOwnerTitle{get;set;} 
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
        public string NavigationLink{get;set;}
        public Decimal AvgRating{get;set;}
        public boolean IsCommunity{get;set;}
        public Datetime LastModifiedDate{get;set;}
    }
      
      public PageReference  RedirectToSLP_GlobalSearch()
      {            
        PageReference pRef = new PageReference('/apex/SLP_GlobalSearch');
        pRef.getParameters().put('SearchVal',strSearchValue);
        pRef.setRedirect(true);
        return pRef;
      }
      
  public PageReference dosearch()
    {
            PageReference pRef = ApexPages.currentPage();
            pRef = new PageReference('/apex/AthenaCreateLearningBoard');
            pRef.setRedirect(true);
           return pRef;
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
        system.debug('####'+id);    
        List<FeedItem> commCount = [Select id from FeedItem where parentID=:id];
        return commCount.size();    
    }
    
    Public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }      
        
    Public User GetLoggedinUserDtls(){    
        User u = [Select Name,FullPhotoUrl,id From User where User.id= :UserInfo.getUserId()];
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
        List<Learning_Board__c> NewLearning_Board =new List<Learning_Board__c>();        
        
        integer icnt=1;

        for (Learning_Board__c lb: Learning_Board )
        {
            //if(icnt > Next) commented by Komala
            //{ commented by Komala
                learningBoardIds.add(lb.id);
                NewLearning_Board.add(lb);
            //} commented by Komala     
         //icnt++; commented by Komala
        }
       
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
        integer inx=1;
        
        //---------------
        
        string typeComm = '\'' + 'TextPost' + '\'';

        List<FeedItem> feeddItmlst = [SELECT ParentId FROM FeedItem where Type='TextPost' and ParentId IN :learningBoardIds];


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
        system.debug('CmntCntMap'+CmntCntMap.size());
        system.debug('CmntCntMap'+CmntCntMap);

        //---------------
       List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c in :learningBoardIds];
        map<id,decimal> RatedItemMap = new map<id,decimal>();        
                   
        
        for (Rated_Item__c rtdItm :RatedItemLst) {
                    RatedItemMap.put(rtdItm.Item_identifier__C,rtdItm.Rating_Average__c);  
        }
        
        string strStaticImage = GetResourceURL('img_athena');
        
        
        Map<string,string> usrimgmap = new Map<string,string>();
        List<string> LBOwnerList = new List<string>();
        for(Learning_Board__c lb: NewLearning_Board){
            LBOwnerList.add(lb.Owner.Id);
        }
        List<user> usrlist = [Select id,SmallPhotoUrl, FullPhotoUrl From User u where u.id=:LBOwnerList];
        for(string lbowner :LBOwnerList){
            for(user usr : usrlist){
                if(lbowner==usr.id){
                    usrimgmap.put(usr.id,usr.smallphotoUrl);
                }
            }
        }
        
        
        for(Learning_Board__c lb: NewLearning_Board){
         LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();            
         lbCustom.TotalCount =NewLearning_Board.size();
            lbCustom.LBName = lb.Name__c; 
            
            if(lb.Name__c != null)
            {
               if(lb.Name__c.length() > 35)
                 {                            
                    lbCustom.LBName = lb.Name__c.substring(0, 35) + '...';
                 }
                 else
                 {
                    lbCustom.LBName = lb.Name__c;
                 }
            }
            

            if(lb.description__c != null){
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
            
            lbCustom.existing=true;
            lbCustom.LBOwnerID=lb.Owner.Id;
            
            //lbCustom.LBOwnerName = lb.Owner.Name;  
            //Restricting Owner Name for specific characters
            
            if(lb.Owner.Name != null)
            {
            lbCustom.LBOwnerName = lb.Owner.Name;
                 if(lb.Owner.Name.length() > 15)
                 {                            
                    lbCustom.LBOwnerName = lb.Owner.Name.substring(0, 16) + '...';
                 }
                 else
                 {
                    lbCustom.LBOwnerName = lb.Owner.Name;
                 }
            }
                                        
            //lbCustom.LBOwnerTitle = lb.Owner.title;
            if(lb.Owner.title!= null){
                 lbCustom.LBOwnerTitle = lb.Owner.title;
                 if(lb.Owner.title.length() > 25){                            
                    lbCustom.LBOwnerTitle = lb.Owner.title.substring(0, 25) + '...';
                 }
                 else
                 {
                    lbCustom.LBOwnerTitle = lb.Owner.title;
                 }
            }
            
            
            lbCustom.LBOwnerURL = usrimgmap.get(lb.Owner.Id);   
            lbCustom.LBCreateDate=(lb.CreatedDate).format('MMM dd ');
            lbCustom.NavigationLink='/apex/AthenaLearningBoardDtls?id=' + lb.id;
            //lbCustom.LBNoOfComments =   CommentCounts(lb.id);  
            if(CmntCntMap.containskey(lb.id))
            {
                lbCustom.LBNoOfComments =   CmntCntMap.get(lb.id);
            }
            else
            {
            lbCustom.LBNoOfComments=0;
            }
            
            //lbCustom.LBNoOfLikes =   LikedItemCounts(lb.id); 
            lbCustom.LbId = lb.id;
            lbCustom.Active=lb.Is_Active__c;
            lbCustom.StaticImage = true;
            lbCustom.ServerPath ='https://'+URL.getSalesforceBaseUrl().getHost();
            string strStaticImg = strStaticImage;   
            lbCustom.LikeIcon=lbCustom.ServerPath+strStaticImg+'/img_athena/hpit_athena_likeIcon.png';
            lbCustom.CommentIcon =lbCustom.ServerPath+strStaticImg+'/img_athena/hpit_athena_chatIcon.png';
            for(Attachment att: attachmentList){
                if(lb.id == att.ParentId  && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
                    lbCustom.AttachmentId = att.Id;
                    lbCustom.StaticImage=false;
                }  
            }

            if(lbCustom.StaticImage == true)
            {
            lbCustom.LBImgURL=lbCustom.ServerPath+strStaticImg+'/img_athena/' + lb.Default_Image_Name__c;
            }
            else
            {
            lbCustom.LBImgURL=lbCustom.ServerPath+'/servlet/servlet.FileDownload?file='+lbCustom.AttachmentId;
            }
            lbCustom.FeaIndex =inx;
            
           if(Prev==-1)
            {
                if(inx>next)
                    {
                        ListFeaturedLB.add(lbCustom);
                        system.debug('No Of Tile'+NoOfTile);
                        system.debug('ListFeaturedLB size'+ListFeaturedLB.size());
                        if(ListFeaturedLB.size()==NoOfTile)
                            {
                                break;
                            }
                    }
            }
            if(next==-1 )
              {
            if(inx>=(prev-NoOfTile))
                {
                   ListFeaturedLB.add(lbCustom);
                   system.debug('No Of Tile'+NoOfTile);
                   system.debug('ListFeaturedLB size'+ListFeaturedLB.size());
                   if(ListFeaturedLB.size()==NoOfTile)
                    {
                        break;
                    }
                }
            }
            inx++;  
        }  
        TotalNumberOfLB=ListFeaturedLB.size();  
        system.debug('@@@@@@@@@@@@ListFeaturedLB'+ListFeaturedLB);    
        return ListFeaturedLB;
        
        }

    private static List<LearningBoardCustomClass> GetLearningBoard_Community(Integer Text,Integer Next,Integer Prev,List<LearningBoardCustomClass> Learning_Board,string Section)
    {
        NoOfTile=Text;
        list<LearningBoardCustomClass> ListFeaturedLB = new List<LearningBoardCustomClass>();
        list<Attachment> attachmentList = new List<Attachment>(); 
        list<id> learningBoardIds= new list<id>();
        List<LearningBoardCustomClass> NewLBCClist =new List<LearningBoardCustomClass>();                
        
        integer icnt=1;       


        for (LearningBoardCustomClass lb: Learning_Board){
                learningBoardIds.add(lb.LBid);
                NewLBCClist.add(lb);
        }       
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
        integer inx=1;
        
        //---------------
        
        string typeComm = '\'' + 'TextPost' + '\'';

        List<FeedItem> feeddItmlst = [SELECT ParentId FROM FeedItem where Type='TextPost' and ParentId IN :learningBoardIds];


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
        system.debug('CmntCntMap'+CmntCntMap.size());
        system.debug('CmntCntMap'+CmntCntMap);

        //---------------
       List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c in :learningBoardIds];
        map<id,decimal> RatedItemMap = new map<id,decimal>();        
                   
        
        for (Rated_Item__c rtdItm :RatedItemLst) {
                    RatedItemMap.put(rtdItm.Item_identifier__C,rtdItm.Rating_Average__c);  
        }
        
        string strStaticImage = StaticPath;
        system.debug('***'+staticPath);
        
        for(LearningBoardCustomClass lb: Learning_Board){
         LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();            
         lbCustom.TotalCount =NewLBCClist.size();
         lbCustom.LBName = lb.LBName ;  
         lbCustom.LBOwnerURL = lb.LBOwnerURL;          
            if(lb.LBName != null)
            {
               if(lb.LBName.length() > 35)
                 {                            
                    lbCustom.LBName = lb.LBName.substring(0, 35) + '...';
                 }
                 else
                 {
                    lbCustom.LBName = lb.LBName;
                 }
            }
            if(lb.LBDescription!= null){
                if(lb.LBDescription.length()>75){                    
                    lbCustom.LBDescription = lb.LBDescription.substring(0,75) + '...';
                }
                else{
                    lbCustom.LBDescription=lb.LBDescription;
                }
            }

            If(RatedItemMap.containskey(lb.LBid))
            {
                lbCustom.AvgRating=RatedItemMap.get(lb.LBid);
            }
            else
            {
                lbCustom.AvgRating=0;
            }
            
            lbCustom.existing=true;
            lbCustom.LBOwnerID=lb.LBOwnerID;
            
            //Restricting Owner Name for specific characters
            
            if(lb.LBOwnerName != null)
            {
            lbCustom.LBOwnerName = lb.LBOwnerName;
                 if(lb.LBOwnerName.length() > 15)
                 {                            
                    lbCustom.LBOwnerName = lb.LBOwnerName.substring(0, 16) + '...';
                 }
                 else
                 {
                    lbCustom.LBOwnerName = lb.LBOwnerName;
                 }
            }
                                        
            lbCustom.LBOwnerTitle = lb.LBOwnerTitle;
            if(lb.LBOwnerTitle!= null)
            {
            lbCustom.LBOwnerTitle = lb.LBOwnerTitle;
                 if(lb.LBOwnerTitle.length() > 25)
                 {                            
                    lbCustom.LBOwnerTitle = lb.LBOwnerTitle.substring(0, 25) + '...';
                 }
                 else
                 {
                    lbCustom.LBOwnerTitle = lb.LBOwnerTitle;
                 }
            }
            
            
            //lbCustom.LBOwnerURL = getUserImages(lb.LBOwnerURL);   
            //lbCustom.LBCreateDate=(lb.LBCreateDate).format('MMM dd ');
            lbCustom.LBCreateDate=(lb.LBCreateDate);
            lbCustom.IsCommunity = lb.IsCommunity;
            lbCustom.NavigationLink='/apex/AthenaLearningBoardDtls?id=' + lb.LBid;
            lbCustom.LBNoOfComments =   CommentCounts(lb.LBid);  
            if(CmntCntMap.containskey(lb.LBid))
            {
                lbCustom.LBNoOfComments =   CmntCntMap.get(lb.LBid);
            }
            else
            {
            lbCustom.LBNoOfComments=0;
            }
            
            //lbCustom.LBNoOfLikes =   LikedItemCounts(lb.id); 
            lbCustom.LbId = lb.Lbid;
            lbCustom.Active=lb.Active;
            lbCustom.StaticImage = true;
            lbCustom.ServerPath ='https://'+URL.getSalesforceBaseUrl().getHost();
            //string strStaticImg = StaticPath;   
            lbCustom.LikeIcon=lbCustom.ServerPath+StaticPath+'/img_athena/hpit_athena_likeIcon.png';
            lbCustom.CommentIcon =lbCustom.ServerPath+StaticPath+'/img_athena/hpit_athena_chatIcon.png';
            for(Attachment att: attachmentList){
                if(lb.LBid == att.ParentId  && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
                    lbCustom.AttachmentId = att.Id;
                    lbCustom.StaticImage=false;
                }  
            }

            if(lbCustom.StaticImage == true)
            {
            lbCustom.LBImgURL=lbCustom.ServerPath+StaticPath+'/img_athena/' + lb.LBImgURL;
            }
            else
            {
            lbCustom.LBImgURL=lbCustom.ServerPath+'/servlet/servlet.FileDownload?file='+lbCustom.AttachmentId;
            }
            lbCustom.FeaIndex =inx;
            lbCustom.LastModifiedDate=lb.LastModifiedDate;
            
           if(Prev==-1)
            {
                if(inx>next)
                    {
                        ListFeaturedLB.add(lbCustom);
                        system.debug('No Of Tile'+NoOfTile);
                        system.debug('ListFeaturedLB size'+ListFeaturedLB.size());
                        if(ListFeaturedLB.size()==NoOfTile)
                            {
                                break;
                            }
                    }
            }
            if(next==-1 )
              {
            if(inx>=(prev-NoOfTile))
                {
                   ListFeaturedLB.add(lbCustom);
                   system.debug('No Of Tile'+NoOfTile);
                   system.debug('ListFeaturedLB size'+ListFeaturedLB.size());
                   if(ListFeaturedLB.size()==NoOfTile)
                    {
                        break;
                    }
                }
            }
            inx++;  
            }  
        TotalNumberOfLB=ListFeaturedLB.size();  
    //    system.debug('@@@@@@@@@@@@ListFeaturedLB'+ListFeaturedLB);   
    
        
    
        return ListFeaturedLB;

     //       return Learning_Board;
        }
        
        
    public static boolean IsLearningBoardCreator
    {
        get
        {
           if (IsModerator(UserInfo.getUserId()) || IsProducer(UserInfo.getUserId()))
                return true;
            else
                return false;
        }
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

//    Commented by sree.... for the community merging in featured boards
/*        @RemoteAction
        public static List<LearningBoardCustomClass> GetFeaturedLB(Integer Text,Integer Next,Integer Prev)
    {
        List<Learning_Board__c> Learning_Board = new List<Learning_Board__c>();
        Learning_Board=[select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,  Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and Featured__c = True Order by LastModifiedDate Desc ];
        string strSection='';
        TotalNumberOfLB=Learning_Board.size();
        System.debug('Learning_Board: '+TotalNumberOfLB);
        return  GetLearningBoard( Text, Next,Prev,Learning_Board,strSection);
    }*/
    
    //Changes made for adding community to Featured Boards
    @RemoteAction
    public static List<LearningBoardCustomClass> GetFeaturedLB(Integer Text,Integer Next,Integer Prev)
    {
        List<Learning_Board__c> Learning_Board = new List<Learning_Board__c>();
        Learning_Board=[select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,  Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate,LastModifiedDate from Learning_Board__c where Is_Active__c = True and Featured__c = True Order by LastModifiedDate Desc];
        string strSection='';
        List<Community__c> comm = new List<Community__c>();
        comm =[select id,Name__c,description__c,Default_Image_Name__c,IsActive__c,  Owner.name,Owner.Id,Owner.title,CreatedDate,LastModifiedDate from Community__c where IsActive__c = True Order by LastModifiedDate Desc];
        List<LearningBoardCustomClass> lbcustomlist = new List<LearningBoardCustomClass>();
        string strStaticImg1=    GetResourceURL('img_athena');
        staticpath = strStaticImg1;

        Map<string,string> usrimgmap1 = new Map<string,string>();
        List<string> CommOwnerList = new List<string>();
        for(Community__c lb:comm){
            CommOwnerList.add(lb.Owner.Id);
        }
        List<user> usrlist1 = [Select id,SmallPhotoUrl, FullPhotoUrl From User u where u.id =:CommOwnerList];
        for(user usr : usrlist1){
            usrimgmap1.put(usr.id,usr.smallphotoUrl);
        }        
          
        for(Community__c lb: comm){
            LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();            
            lbCustom.TotalCount = comm.size();
            lbCustom.IsCommunity = true;
            lbCustom.LBName = lb.Name__c; 
            lbCustom.LBDescription=lb.description__c;
            lbCustom.LBOwnerID=lb.Owner.Id;
            lbCustom.LBOwnerName = lb.Owner.Name;
            lbCustom.LBOwnerTitle= lb.Owner.title;
            lbCustom.LBOwnerURL = usrimgmap1.get(lb.Owner.Id);   
            lbCustom.LBCreateDate=(lb.CreatedDate).format('MMM dd');
            lbCustom.LBImgURL=lb.Default_Image_Name__c;
            lbCustom.NavigationLink='/apex/AthenaLearningBoardDtls?id=' + lb.id;
            lbCustom.LbId = lb.id;
            lbCustom.StaticImage = true;
            //lbCustom.AvgRating=RatedItemMap.get(lb.id);
            lbCustom.ServerPath ='https://'+URL.getSalesforceBaseUrl().getHost();
            string strStaticImg = staticpath;
            lbCustom.LikeIcon=lbCustom.ServerPath+strStaticImg+'/img_athena/hpit_athena_likeIcon.png';
            lbCustom.CommentIcon =lbCustom.ServerPath+strStaticImg+'/img_athena/hpit_athena_chatIcon.png';
            lbCustom.LastModifiedDate = lb.LastModifiedDate;
            lbcustomlist.add(lbCustom);
        }
        
        Map<string,string> usrimgmap = new Map<string,string>();
        List<string> LBOwnerList = new List<string>();
        for(Learning_Board__c lb:Learning_Board){
            LBOwnerList.add(lb.Owner.Id);
        }
        List<user> usrlist = [Select id,SmallPhotoUrl, FullPhotoUrl From User u where u.id=:LBOwnerList];
        for(user usr : usrlist){                
                usrimgmap.put(usr.id,usr.smallphotoUrl);                
        }        
        for(Learning_Board__c lb: Learning_Board){
            LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();            
            lbCustom.TotalCount =Learning_Board.size();
            lbCustom.IsCommunity = false;
            lbCustom.LBName = lb.Name__c; 
            lbCustom.LBDescription=lb.description__c;
            lbCustom.LBOwnerID=lb.Owner.Id;
            lbCustom.LBOwnerName = lb.Owner.Name;
            lbCustom.LBOwnerTitle= lb.Owner.title;
            lbCustom.LBOwnerURL = usrimgmap.get(lb.Owner.Id);
            lbCustom.LBCreateDate=(lb.CreatedDate).format('MMM dd');
            lbCustom.NavigationLink='/apex/AthenaLearningBoardDtls?id=' + lb.id;
            lbCustom.LbId = lb.id;
            lbcustom.LBImgURL=lb.Default_Image_Name__c;
            lbCustom.StaticImage = true;
//            lbCustom.AvgRating=RatedItemMap.get(lb.id);
            lbCustom.ServerPath ='https://'+URL.getSalesforceBaseUrl().getHost();
            string strStaticImg= staticpath;
            lbCustom.LikeIcon=lbCustom.ServerPath+strStaticImg+'/img_athena/hpit_athena_likeIcon.png';
            lbCustom.CommentIcon =lbCustom.ServerPath+strStaticImg+'/img_athena/hpit_athena_chatIcon.png';
            lbCustom.LastModifiedDate = lb.LastModifiedDate;
            lbcustomlist.add(lbCustom);
        }
        
        system.debug('$$'+lbcustomlist);
        for(LearningBoardCustomclass LBCC : lbcustomlist){
            System.debug('%%'+LBCC.LBOwnerURL);
            system.debug('$$'+LBCC.LikeIcon);        
        }
        TotalNumberOfLB=Learning_Board.size();
        TotalNumberOfCommunities=comm.size();        
        //lbcustomlist=SortData(lbcustomlist,'Desc');
        List<LearningBoardCustomclass> result=SortData(lbcustomlist,'DESC');
        system.debug('result@@: '+result);
        //return GetLearningBoard_Community( Text, Next,Prev,lbcustomlist,strSection);        
        return GetLearningBoard_Community( Text, Next,Prev,result,strSection);        
    }
    
   //End of featured
   
public static List<LearningBoardCustomclass> SortData(List<LearningBoardCustomclass> CustomerCollection, String sortingOrder){
List<LearningBoardCustomclass> resultList = new List<LearningBoardCustomclass>();
Map<integer,Map<Datetime,LearningBoardCustomclass>> objectMap = new Map<integer,Map<Datetime,LearningBoardCustomclass>>();
Map<datetime,LearningBoardCustomclass> resultData=new Map<datetime,LearningBoardCustomclass>();
Map<datetime,LearningBoardCustomclass> resultMapData=new Map<datetime,LearningBoardCustomclass>();
integer index=0;
List<datetime> datetimeresult=new List<datetime>();
for(LearningBoardCustomclass ob : CustomerCollection){
index=index+1;
//ob.Name is the property name of customer object
if(objectMap.get(index) == null){ 
map<datetime,LearningBoardCustomclass> mapdata=new map<datetime,LearningBoardCustomclass>();
mapdata.put(ob.LastModifiedDate, ob);
objectMap.put(index,mapdata);
}
//objectMap.get(ob.LastModifiedDate).add(ob);

//objectMap.put(ob.LastModifiedDate, ob);
}
List<integer> keys = new List<integer>(objectMap.keySet());
keys.sort();
system.debug('Keys :'+keys);
system.debug('sortingorder: '+sortingorder);
for(integer key : keys){
resultData=objectMap.get(key);
for(datetime datekey:resultData.keySet())
resultMapData.put(datekey,resultData.get(datekey));
}
datetimeresult=new List<datetime>(resultMapData.keySet());
datetimeresult.sort();

system.debug('Datetime Keys@@: '+datetimeresult);

for(datetime datetimedata: datetimeresult){
resultList.add(resultMapData.get(datetimedata));
}
CustomerCollection.clear();

if(sortingOrder.toUpperCase()=='ASC'){
for(LearningBoardCustomclass ob : resultList){
CustomerCollection.add(ob);
}
}
Else if(sortingOrder.toUpperCase()=='DESC'){

for(integer i = resultList.size()-1; i >= 0; i--){
CustomerCollection.add(resultList[i]); 
}
}
return CustomerCollection;
}
    
    Public newAthenaSocialLearning(){
    system.debug('SreeAthenaSocialLearning Suman');
        strSearchValue = ApexPages.currentPage().getParameters().get('SearchVal');  
        AvailTags=AthenaUtility.getAvailableTags();          
        MostCommentedNoOfDays=0;
        staticpath = getResourceURL('Img_Athena');   
        system.debug('!!!'+staticpath);     
        if (AthenaUtility.ApplicationSettingValue(AthenaUtility.MostCommentedTrendDays)!= ''){
            MostCommentedNoOfDays=Integer.valueOf(AthenaUtility.ApplicationSettingValue(AthenaUtility.MostCommentedTrendDays));     
        }
            
        if(strSearchValue == null) 
        {
             ShowSearch=false;
        }
        else
        {
              ShowSearch=true;
            //  dosearch();
         }         
        NoOfComm = [select id from community__c where ownerid =:UserInfo.getUserId() And IsActive__c=true];
        if(NoOfComm.size()!=0){
            showComm=true;
        }
        else{
            showComm=false;
        }

    }
        
             
    @RemoteAction
    public static List<LearningBoardCustomClass> GetMostCommentedTrends(Integer Text,Integer Next,Integer Prev)
    {
    //----Start
     Integer TrendDays=Integer.valueOf(AthenaUtility.ApplicationSettingValue(AthenaUtility.MostCommentedTrendDays));
     //        MostCommentedNoOfDays=TrendDays;
        string typeComm='\'' + 'TextPost' + '\'';
        //Fetch all the Comments for all learning boards in N number days
        //List<FeedItem> feeddItmlst = [SELECT ParentId FROM FeedItem where Type='TextPost' and CreatedDate>= N_DAYS_AGO:30 and ParentId IN (Select id from learning_board__c)];    
         List<FeedItem> feeddItmlst = Database.query('SELECT ParentId FROM FeedItem where Type=' + typeComm + ' and CreatedDate>= N_DAYS_AGO:' + TrendDays + ' and ParentId IN (Select id from learning_board__c)');    
        //Making the map of Learning Board Id anf Comment Count        
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
        system.debug('CmntCntMap'+CmntCntMap);          
        
        //Making Comment counts in Ascending order in  a list        
        List<integer> CmtCntLst = new List<integer>();
        CmtCntLst.addAll(CmntCntMap.Values());
        CmtCntLst.sort();
        System.debug(' Comment Count Lst' + CmtCntLst);
        
        //Making Comment counts in Descending order in  a list     
        List<integer> CmtCntDscLst = new List<integer>();
        for(Integer i = CmtCntLst.size()-1; i>=0;i--)
        {   
            CmtCntDscLst.add(CmtCntLst.get(i));
        }
        system.debug('CmtCntDscLst' + CmtCntDscLst);       
        
        //Getting Learning Board Ids in to a list 
        List<String> lrngBrdIdLstTmp = new List<string>();
        for(integer i : CmtCntDscLst){
            for(String s : CmntCntMap.keyset()){
                if(i==CmntCntMap.get(s)){
                    lrngBrdIdLstTmp.add(s);                    
                }
            }
        }
        
        Set<String> myset = new Set<String>();
        List<String> finallrngBrdIdLst = new List<String>();
        List<Learning_Board__c> lrngBrdLst=[SELECT id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,Owner.name,Owner.Id, Owner.title, Featured__c,CreatedDate FROM Learning_Board__c where id in:lrngBrdIdLstTmp and Is_Active__c=true];
        List<Learning_Board__c> lstLearningBoard=new List<Learning_Board__c>();
        system.debug(' lrngBrdLst ' + lrngBrdLst);
        
       List<string> learningBoardIds= new List<String>();
        for (String s : lrngBrdIdLstTmp) {
          if (myset.add(s)) {
              finallrngBrdIdLst.add(s); 
              for(Learning_Board__c lb:lrngBrdLst)
              {
                  if(lb.id==s)
                  {
                      lstLearningBoard.add(lb);
                      learningBoardIds.add(lb.id);
                  }
              }
          }            
        }
 
    //--End
    
        list<Attachment> attachmentList = new List<Attachment>(); 
        integer inx=1;
        NoOfTile=Text;
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];

        List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c in :learningBoardIds];
        map<id,decimal> RatedItemMap = new map<id,decimal>();        
                   
        
        for (Rated_Item__c rtdItm :RatedItemLst) {
                    RatedItemMap.put(rtdItm.Item_identifier__C,rtdItm.Rating_Average__c);  
        }

        
        
            list<LearningBoardCustomClass> lstMostCommentedTrends = new List<LearningBoardCustomClass>();
            for (Learning_Board__c lb : lstLearningBoard){

                    LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();            
                    lbCustom.TotalCount =lstLearningBoard.size();
                   // lbCustom.LBName = lb.Name__c; 
                    
                   if(lb.Name__c != null)
                    {
                       if(lb.Name__c.length() > 30)
                         {                            
                            lbCustom.LBName = lb.Name__c.substring(0, 30) + '...';
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
                    lbCustom.LBOwnerID=lb.Owner.Id;
                        
                        //lbCustom.LBOwnerName = lb.Owner.Name;
                        //Restricting Owner Name for specific characters
                        
                        if(lb.Owner.Name != null)
                        {
                            if(lb.Owner.Name.length() > 18)
                            {                            
                                lbCustom.LBOwnerName = lb.Owner.Name.substring(0, 18) + '...';
                            }
                            else
                            {
                                lbCustom.LBOwnerName = lb.Owner.Name;
                            }
                        }

                        if(lb.Owner.title != null)
                        {
                            if(lb.Owner.title.length() > 25)
                            {                            
                                lbCustom.LBOwnerTitle= lb.Owner.title.substring(0, 25) + '...';
                            }
                            else
                            {
                                lbCustom.LBOwnerTitle= lb.Owner.title;
                            }
                        }
                    
                    lbCustom.LBOwnerURL = getUserImages(lb.Owner.Id);   
                    lbCustom.LBCreateDate=(lb.CreatedDate).format('MMM dd');
                    lbCustom.NavigationLink='/apex/AthenaLearningBoardDtls?id=' + lb.id;
                    lbCustom.LBNoOfComments =  CmntCntMap.get(lb.id); //CommentCounts(lb.id);  
                    lbCustom.LBNoOfLikes =   LikedItemCounts(lb.id); 
                    lbCustom.LbId = lb.id;
                    lbCustom.StaticImage = true;
                    
                    If(RatedItemMap.containskey(lb.id))
                    {
                        lbCustom.AvgRating=RatedItemMap.get(lb.id);
                    }
                    else
                    {
                        lbCustom.AvgRating=0;
                    }
                    lbCustom.ServerPath ='https://'+URL.getSalesforceBaseUrl().getHost();
                    string strStaticImg=    GetResourceURL('img_athena');
                    lbCustom.LikeIcon=lbCustom.ServerPath+strStaticImg+'/img_athena/hpit_athena_likeIcon.png';
                    lbCustom.CommentIcon =lbCustom.ServerPath+strStaticImg+'/img_athena/hpit_athena_chatIcon.png';
                    for(Attachment att: attachmentList){
                        if(lb.id == att.ParentId  && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg'  || att.ContentType == 'image/gif' )){
                            lbCustom.AttachmentId = att.Id;
                            lbCustom.StaticImage=false;
                        }  
                    }
                    if(lbCustom.StaticImage == true){
                        system.debug('&&&'+lb.Default_Image_Name__c);
                        lbCustom.LBImgURL=lbCustom.ServerPath+strStaticImg+'/img_athena/' + lb.Default_Image_Name__c;
                    }
                    else{
                        lbCustom.LBImgURL=lbCustom.ServerPath+'/servlet/servlet.FileDownload?file='+lbCustom.AttachmentId;
                    }
                    lbCustom.FeaIndex =inx;
                    inx++; 
                   if(Prev==-1){
                        if(inx>next ){
                            lstMostCommentedTrends.add(lbCustom);
                            if(lstMostCommentedTrends.size()==NoOfTile){
                                system.debug('next value'+next);
                                break;
                            }
                        }
                    }
                
                    if(next==-1 ){
                        if(inx>=(prev-NoOfTile)){
                           lstMostCommentedTrends.add(lbCustom);
                           if(lstMostCommentedTrends.size()==NoOfTile){
                                break;
                           }
                        }
                    }
                
            }
        
        return  lstMostCommentedTrends;
    }
    
      @RemoteAction
    public static List<LearningBoardCustomClass> GetMyBoards(Integer Text,Integer Next,Integer Prev)
    {
    
            List<EntitySubscription> entitySub=new List<EntitySubscription>();
            List<Learning_Board__c>  perlist= new List<Learning_Board__c>(); 
            List<Learning_Board__c>  lblist;   
             
             lblist= [select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True Order by LastModifiedDate Desc ];                           
            //Active Following  
            Set<string> lbidsEnt=new Set<string>();
            for(learning_Board__c ids:lblist){
                lbidsEnt.add(ids.id);
            }   
            
            entitySub = [select ParentId,id,Subscriber.name from EntitySubscription where ParentId = :lbidsEnt and SubscriberID =:UserInfo.getUserId() Limit 900];//added by murali
            lbidsEnt=new Set<string>();
            for(EntitySubscription ent:entitySub)
            {
                lbidsEnt.add(ent.ParentId);
            }
            perlist=[select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate from Learning_Board__c where Id IN:lbidsEnt and Is_Active__c = True Order by LastModifiedDate Desc ];                           
            
            //Active Owner 
            lblist=new List<Learning_Board__c>();
            lblist= [select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and owner.Id=:UserInfo.getUserId() Order by LastModifiedDate Desc ];                            
            for(Learning_Board__c lb: lblist)
            {
                   perlist.add(lb);             
            }

             //Active and Contributor
            lblist=new List<Learning_Board__c>();
            lblist= [select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and owner.Id!=:UserInfo.getUserId() Order by LastModifiedDate Desc ];                            
            List<string> lbIds=new List<string>();
            for(Learning_Board__c lb: lblist)
            {
                   lbIds.add(lb.Id);             
            }   
             List<Learning_Board__Share>  lstContr = [SELECT ParentId FROM Learning_Board__Share where parentId=:lbIds and AccessLevel='Edit' and UserOrGroupId=:UserInfo.getUserId()];
            for(Learning_Board__c lb: lblist)
            {
                for(Learning_Board__Share lbs:lstContr)
                {
                    If(lb.Id==lbs.ParentId)
                    {
                       perlist.add(lb);             
                   }
                }   
            }
            
            //InActive Owner 
            lblist=new List<Learning_Board__c>();
            lblist= [select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,Owner.name,Owner.Id,Owner.title, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = False and owner.Id=:UserInfo.getUserId() Order by LastModifiedDate Desc ];                            
            for(Learning_Board__c lb: lblist)
            {
                   perlist.add(lb);             
            }
            
            //InActive and Contributor
            lblist=new List<Learning_Board__c>();
            lblist= [select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,Owner.name,Owner.Id,Owner.title,  Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = False and owner.Id!=:UserInfo.getUserId() Order by LastModifiedDate Desc ];                            
            lbIds=new List<string>();
            for(Learning_Board__c lb: lblist)
            {
                   lbIds.add(lb.Id);             
            }   
           lstContr = [SELECT ParentId FROM Learning_Board__Share where parentId=:lbIds and AccessLevel='Edit' and UserOrGroupId=:UserInfo.getUserId()];
            for(Learning_Board__c lb: lblist)
            {
                for(Learning_Board__Share lbs:lstContr)
                {
                    If(lb.Id==lbs.ParentId)
                    {
                       perlist.add(lb);             
                   }
                }   
            }
   
        return  GetLearningBoard( Text, Next,Prev,perlist,'');
    }
//Started by Sree   
    @RemoteAction
    public static List<LearningBoardCustomClass> GetMyCommunities(Integer Text,Integer Next,Integer Prev)
    {
        //List<EntitySubscription> entitySub=new List<EntitySubscription>();
        List<Community_Member__c> communityfollow=new List<Community_Member__c>();
        List<Community__c>  perlist= new List<Community__c>(); 
        List<Community__c>  lblist;   
        
        lblist= [select id,Name__c,description__c,Default_Image_Name__c,IsActive__c,Owner.name,Owner.Id,Owner.title, CreatedDate from Community__c where IsActive__c = True Order by LastModifiedDate Desc ];                           
         Set<string> lbidsEnt=new Set<string>();
            for(Community__c ids:lblist){
                lbidsEnt.add(ids.id);
            }  
            //Community Follow
            communityfollow = [select Community_Id__c, Status__c, User_Id__c from Community_Member__c where Community_Id__c=:lbidsEnt and Status__c='Approved' Limit 900];
            lbidsEnt=new Set<string>();
            for(Community_Member__c com:communityfollow)
            {
                lbidsEnt.add(com.Community_Id__c);
            }
/*            entitySub = [select ParentId,id,Subscriber.name from EntitySubscription where ParentId = :lbidsEnt and SubscriberID =:UserInfo.getUserId() Limit 900];
            lbidsEnt=new List<string>();
            for(EntitySubscription ent:entitySub)
            {
                lbidsEnt.add(ent.ParentId);
            }*/
            
 
            perlist=[select id,Name__c,description__c,Default_Image_Name__c,IsActive__c,Owner.name,Owner.Id,Owner.title, CreatedDate from Community__c where Id IN:lbidsEnt and IsActive__c = True Order by LastModifiedDate Desc ];                           
            
            //Active Owner 
            lblist=new List<Community__c>();
            lblist= [select id,Name__c,description__c,Default_Image_Name__c,IsActive__c,Owner.name,Owner.Id,Owner.title, CreatedDate from Community__c where IsActive__c = True and owner.Id=:UserInfo.getUserId() Order by LastModifiedDate Desc ];                            
            for(Community__c lb: lblist)
            {
                   perlist.add(lb);             
            }
            
            //Active and Contributor
            lblist=new List<Community__c>();
            lblist= [select id,Name__c,description__c,Default_Image_Name__c,IsActive__c,Owner.name,Owner.Id,Owner.title, CreatedDate from Community__c where IsActive__c = True and owner.Id!=:UserInfo.getUserId() Order by LastModifiedDate Desc ];                            
            Set<string> lbIds=new Set<string>();
            for(Community__c lb: lblist)
            {
                   lbIds.add(lb.Id);             
            }   
             List<Community__Share>  lstContr = [SELECT ParentId FROM Community__Share where parentId=:lbIds and AccessLevel='Edit' and UserOrGroupId=:UserInfo.getUserId()];
            for(Community__c lb: lblist)
            {
                for(Community__Share lbs:lstContr)
                {
                    If(lb.Id==lbs.ParentId)
                    {
                       perlist.add(lb);             
                   }
                }   
            }
            
            return  GetCommunity( Text, Next,Prev,perlist,'');
            
    }   
    
     private static List<LearningBoardCustomClass> GetCommunity(Integer Text,Integer Next,Integer Prev,List<Community__c> Learning_Board,string Section)
        {
        NoOfTile=Text;
        list<LearningBoardCustomClass> ListFeaturedLB = new List<LearningBoardCustomClass>();
        list<Attachment> attachmentList = new List<Attachment>(); 
        list<id> learningBoardIds= new list<id>();
        List<Community__c> NewLearning_Board =new List<Community__c>();        
        
        integer icnt=1;

        for (Community__c lb: Learning_Board )
        {
            learningBoardIds.add(lb.id);
            NewLearning_Board.add(lb);
        }       
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
        integer inx=1;
        
        //---------------
        
        string typeComm = '\'' + 'TextPost' + '\'';

        List<FeedItem> feeddItmlst = [SELECT ParentId FROM FeedItem where Type='TextPost' and ParentId IN :learningBoardIds];
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
        system.debug('CmntCntMap'+CmntCntMap.size());
        system.debug('CmntCntMap'+CmntCntMap);

/*        //---------------
       List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c in :learningBoardIds];
        map<id,decimal> RatedItemMap = new map<id,decimal>();        
                   
        
        for (Rated_Item__c rtdItm :RatedItemLst) {
                    RatedItemMap.put(rtdItm.Item_identifier__C,rtdItm.Rating_Average__c);  
        }*/
        
        string strStaticImage = GetResourceURL('img_athena');
        
        for(Community__c lb: NewLearning_Board){
         LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();            
         lbCustom.TotalCount =NewLearning_Board.size();
            lbCustom.LBName = lb.Name__c; 
            
            if(lb.Name__c != null)
            {
               if(lb.Name__c.length() > 35)
                 {                            
                    lbCustom.LBName = lb.Name__c.substring(0, 35) + '...';
                 }
                 else
                 {
                    lbCustom.LBName = lb.Name__c;
                 }
            }
            

            if(lb.description__c != null){
                if(lb.description__c.length()>75){
                    
                    lbCustom.LBDescription = lb.Description__c.substring(0,75) + '...';
                }
                else{
                    lbCustom.LBDescription=lb.description__c;
                }
            }

            /*If(RatedItemMap.containskey(lb.id))
            {
                lbCustom.AvgRating=RatedItemMap.get(lb.id);
            }
            else
            {
                lbCustom.AvgRating=0;
            }*/
            
            lbCustom.existing=true; 
            lbCustom.LBOwnerID=lb.Owner.Id;
            
            //lbCustom.LBOwnerName = lb.Owner.Name;  
            //Restricting Owner Name for specific characters
            
            if(lb.Owner.Name != null)
            {
            lbCustom.LBOwnerName = lb.Owner.Name;
                 if(lb.Owner.Name.length() > 15)
                 {                            
                    lbCustom.LBOwnerName = lb.Owner.Name.substring(0, 16) + '...';
                 }
                 else
                 {
                    lbCustom.LBOwnerName = lb.Owner.Name;
                 }
            }
                                        
            //lbCustom.LBOwnerTitle = lb.Owner.title;
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
            
            
            lbCustom.LBOwnerURL = getUserImages(lb.Owner.Id);   
            lbCustom.LBCreateDate=(lb.CreatedDate).format('MMM dd ');
         //   lbCustom.NavigationLink='/apex/AthenaLearningBoardDtls?id=' + lb.id;
            lbCustom.LBNoOfComments =   CommentCounts(lb.id);  
            if(CmntCntMap.containskey(lb.id))
            {
                lbCustom.LBNoOfComments =   CmntCntMap.get(lb.id);
            }
            else
            {
            lbCustom.LBNoOfComments=0;
            }
            
            //lbCustom.LBNoOfLikes =   LikedItemCounts(lb.id); 
            lbCustom.LbId = lb.id;
            lbCustom.Active=lb.IsActive__c;
            lbCustom.StaticImage = true;
            lbCustom.ServerPath ='https://'+URL.getSalesforceBaseUrl().getHost();
            string strStaticImg = strStaticImage;   
          //  lbCustom.LikeIcon=lbCustom.ServerPath+strStaticImg+'/img_athena/hpit_athena_likeIcon.png';
            lbCustom.CommentIcon =lbCustom.ServerPath+strStaticImg+'/img_athena/hpit_athena_chatIcon.png';
            for(Attachment att: attachmentList){
                if(lb.id == att.ParentId  && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
                    lbCustom.AttachmentId = att.Id;
                    lbCustom.StaticImage=false;
                }  
            }

            if(lbCustom.StaticImage == true)
            {
            lbCustom.LBImgURL=lbCustom.ServerPath+strStaticImg+'/img_athena/' + lb.Default_Image_Name__c;
            }
            else
            {
            lbCustom.LBImgURL=lbCustom.ServerPath+'/servlet/servlet.FileDownload?file='+lbCustom.AttachmentId;
            }
            lbCustom.FeaIndex =inx;
            
           if(Prev==-1)
            {
                if(inx>next)
                    {
                        ListFeaturedLB.add(lbCustom);
                        system.debug('No Of Tile'+NoOfTile);
                        system.debug('ListFeaturedLB size'+ListFeaturedLB.size());
                        if(ListFeaturedLB.size()==NoOfTile)
                            {
                                break;
                            }
                    }
            }
            if(next==-1 )
              {
            if(inx>=(prev-NoOfTile))
                {
                   ListFeaturedLB.add(lbCustom);
                   system.debug('No Of Tile'+NoOfTile);
                   system.debug('ListFeaturedLB size'+ListFeaturedLB.size());
                   if(ListFeaturedLB.size()==NoOfTile)
                    {
                        break;
                    }
                }
            }
            inx++;  
        }  
        TotalNumberOfLB=ListFeaturedLB.size();  
        system.debug('@@@@@@@@@@@@ListFeaturedLB'+ListFeaturedLB);    
        return ListFeaturedLB;
        
        }
    //End by sree
}