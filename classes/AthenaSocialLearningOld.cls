public class AthenaSocialLearningOld {
  
    Public String strSearchValue{get;set;}
    Public boolean ShowSearch{get;set;}
    Public static integer MostLikedNoOfDays{get;set;}
    Public static integer MostCommentedNoOfDays{get;set;}
    public string AvailTags{get;set;}
    
    
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
        public string NavigationLink{get;set;}
        public Decimal AvgRating{get;set;}
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
        
        
       List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c in :learningBoardIds];
        map<id,decimal> RatedItemMap = new map<id,decimal>();        
                   
        
        for (Rated_Item__c rtdItm :RatedItemLst) {
                    RatedItemMap.put(rtdItm.Item_identifier__C,rtdItm.Rating_Average__c);  
        }
        
        /*if((Section=='Personalized') && (IsProducer(UserInfo.getUserId()) ||(IsModerator(UserInfo.getUserId()))))
        {
        
                LearningBoardCustomClass lbproducer= new LearningBoardCustomClass();
                lbproducer.StaticImage = True;
                            lbproducer.FeaIndex =inx;
                            inx++;
                lbproducer.LBName='Create new board';
                lbproducer.LBDescription ='';
                lbproducer.Active=False;
                lbproducer.existing=False;
                lbproducer.LBOwnerName='';
                lbproducer.LBCreateDate='';
                lbproducer.LBOwnerURL = '';   
                lbproducer.LBImgURL='https://'+URL.getSalesforceBaseUrl().getHost() + GetResourceURL('athena_images') +'/images/athenaCreateLearning.png';
            
                lbproducer.NavigationLink='/apex/AthenaCreateLearningBoard';
                ListFeaturedLB.add(lbproducer);
                LearningBoardCustomClass lbLearning= new LearningBoardCustomClass();
                lbLearning.StaticImage = True;
                lbLearning.LBOwnerURL = '';   
                lbLearning.NavigationLink='/apex/AthenaSearchLearnings';
                lbLearning.LBImgURL='https://'+URL.getSalesforceBaseUrl().getHost() + GetResourceURL('img_athena') +'/img_athena/antena_defaultImgLearning.png';
                
                lbLearning.FeaIndex =inx;
                  inx++;
                lbLearning.LBDescription ='';
                
                lbLearning.LBCreateDate='';
                lbLearning.LBOwnerName='';
                lbLearning.LBName='My Learnings';
                lbLearning.Active=False;
                lbLearning.existing=False;
                ListFeaturedLB.add(lbLearning);           
                        
        }*/
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
            lbCustom.LBOwnerName = lb.Owner.Name;  
            lbCustom.LBOwnerURL = getUserImages(lb.Owner.Id);   
            lbCustom.LBCreateDate=(lb.CreatedDate).format('dd MMM yy');
            lbCustom.NavigationLink='/apex/AthenaLearningBoardDtls?id=' + lb.id;
            lbCustom.LBNoOfComments =   CommentCounts(lb.id);  
            lbCustom.LBNoOfLikes =   LikedItemCounts(lb.id); 
            lbCustom.LbId = lb.id;
            lbCustom.Active=lb.Is_Active__c;
            lbCustom.StaticImage = true;
            lbCustom.ServerPath ='https://'+URL.getSalesforceBaseUrl().getHost();
            string strStaticImg=    GetResourceURL('athena_images');
            lbCustom.LikeIcon=lbCustom.ServerPath+strStaticImg+'/images/hpit_athena_likeIcon.png';
            lbCustom.CommentIcon =lbCustom.ServerPath+strStaticImg+'/images/hpit_athena_chatIcon.png';
            for(Attachment att: attachmentList){
                if(lb.id == att.ParentId  && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
                    lbCustom.AttachmentId = att.Id;
                    lbCustom.StaticImage=false;
                }  
            }

            if(lbCustom.StaticImage == true)
            {
            lbCustom.LBImgURL=lbCustom.ServerPath+strStaticImg+'/images/' + lb.Default_Image_Name__c;
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
        Learning_Board=[select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,  Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and Featured__c = True Order by LastModifiedDate Desc ];
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
                 lblist=[select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c]; 
             }
             else
             {
                 lblist= [select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True];                           
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
                
            String  GString= '%'+ newSearchText + '%';
            SET<ID> finalLrngBrdIdSet = new SET<ID>();
            SET<ID> LrngIdSet = new SET<ID>();

            List<Learning_Board__c> lrngBrdSrchRslt= new List<Learning_Board__c>([SELECT Id,Name__c,Name FROM Learning_Board__c WHERE (Name__c like : GString OR Short_description__c Like : GString)]);
            for(Learning_Board__c Lrng : lrngBrdSrchRslt){
                finalLrngBrdIdSet.add(Lrng.id);
            }


            List<Tag_Item__c> tagItmLst=[
            SELECT Item_Identifier__c FROM Tag_Item__c where Tag_ID__c IN (SELECT ID FROM Tag__c WHERE Value__c =: newSearchText) and Item_Name__c=:AthenaUtility.LearningBoard];
            for(Tag_Item__c TagItm : tagItmLst){
                finalLrngBrdIdSet.add(TagItm.Item_Identifier__c);
            }

            List<Learning__c> lrngSrchRslt= new List<Learning__c>([SELECT Id,Name__c,Name FROM Learning__c WHERE (Name__c like : GString OR Short_description__c Like : GString)]);
            for (Learning__c l :lrngSrchRslt){
               LrngIdSet.add(l.id);
            }

            List<Tag_Item__c> tagItmLst1=[
            SELECT Item_Identifier__c FROM Tag_Item__c where Tag_ID__c IN (SELECT ID FROM Tag__c WHERE Value__c =: newSearchText) and Item_Name__c=:AthenaUtility.Learning];
            for(Tag_Item__c TagItm : tagItmLst1){
                LrngIdSet.add(TagItm.Item_Identifier__c);
            }

            List<Learning_Board_learning__c> LBList = [select id,Learning_ID__c,Learning_Board_ID__c from Learning_Board_learning__c where Learning_ID__c IN:LrngIdSet];
            for (Learning_Board_learning__c Lbid : LBList){
                            finalLrngBrdIdSet.add(lbid.Learning_Board_ID__c);
            }

            List<Learning_Board__c> searchResult = [select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,  Featured__c,Owner.name,Owner.Id,CreatedDate from Learning_Board__c where Is_Active__c = True and id IN:finalLrngBrdIdSet];
            system.debug('Veeresh searchResult :' + searchResult) ;            
             string strSection='';    
             return  GetLearningBoard( Text, Next,Prev,searchResult,strSection);
    }

    
    
    Public AthenaSocialLearningOld(){
        strSearchValue = ApexPages.currentPage().getParameters().get('SearchVal');  
        AvailTags=AthenaUtility.getAvailableTags();  
        MostLikedNoOfDays=0;        
        MostCommentedNoOfDays=0;
        
        if (AthenaUtility.ApplicationSettingValue(AthenaUtility.MostLikedTrendDays)!= ''){
            MostLikedNoOfDays=Integer.valueOf(AthenaUtility.ApplicationSettingValue(AthenaUtility.MostLikedTrendDays));     
        }
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
    }
        @RemoteAction
    public static List<LearningBoardCustomClass> GetMostLikedTrends(Integer Text,Integer Next,Integer Prev)
    {
       Integer TrendDays=Integer.valueOf(AthenaUtility.ApplicationSettingValue(AthenaUtility.MostLikedTrendDays));
//        AthenaSocialLearningOld.MostLikedNoOfDays=TrendDays;
           string staticLBName='\'' + 'Learning Board' + '\'';          
             AggregateResult[] groupedResults = Database.query('SELECT Count(Id) Con,Liked_Item_ID__r.Item_Identifier__c value FROM User_Liked_Item__c WHERE LastModifiedDate >= N_DAYS_AGO:' + TrendDays +' and Liked_Item_ID__c in (SELECT Id FROM Liked_Item__c where Item_Name__c = ' + staticLBName +') GROUP BY  Liked_Item_ID__r.Item_Identifier__c order by count(id) desc');
             
             //AggregateResult[] groupedResults = [SELECT Count(Id) Con,Liked_Item_ID__r.Item_Identifier__c value FROM User_Liked_Item__c WHERE LastModifiedDate >= N_DAYS_AGO:30 and Liked_Item_ID__c in (SELECT Id FROM Liked_Item__c where Item_Name__c = 'Learning Board') GROUP BY  Liked_Item_ID__r.Item_Identifier__c order by count(id) desc];
             Map<string,integer> MostLikedMap = new Map<string,integer>();
             List<string> LrngBrdIds = new List<string>();
    
            for (AggregateResult GR : groupedResults){
    
                MostLikedMap.Put(string.ValueOf(GR.get('value')),integer.ValueOf(GR.get('Con')));
                LrngBrdIds.add(string.ValueOf(GR.get('value')));
                
            }
            system.debug('groupedResults ' + groupedResults );
            system.debug('MostLikedMap' + MostLikedMap);
            system.debug('LrngBrdIds' + LrngBrdIds);
             NoOfTile=Text;
            list<Learning_Board__c> Learning_Board= [select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where id =:LrngBrdIds];

            list<LearningBoardCustomClass> lstMostLikedTrends = new List<LearningBoardCustomClass>();
            list<Attachment> attachmentList = new List<Attachment>(); 
            integer inx=1;
          boolean AllAdded=false;
                    boolean Added=false;

        for (AggregateResult GR : groupedResults){
            if(AllAdded)
            {
                break;
            }
            Added=false;
            for (Learning_Board__c lb : Learning_Board){
                if(Added)
                {
                break;
                }
                if(lb.id == GR.get('value')){
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
                    lbCustom.NavigationLink='/apex/AthenaLearningBoardDtls?id=' + lb.id;
                    lbCustom.LBNoOfComments =   CommentCounts(lb.id);  
                    lbCustom.LBNoOfLikes = MostLikedMap.get(lb.id);  //LikedItemCounts(lb.id); 
                    lbCustom.LbId = lb.id;
                    lbCustom.StaticImage = true;
                    lbCustom.ServerPath ='https://'+URL.getSalesforceBaseUrl().getHost();
                    string strStaticImg=    GetResourceURL('athena_images');
                    lbCustom.LikeIcon=lbCustom.ServerPath+strStaticImg+'/images/hpit_athena_likeIcon.png';
                    lbCustom.CommentIcon =lbCustom.ServerPath+strStaticImg+'/images/hpit_athena_chatIcon.png';
                    for(Attachment att: attachmentList){
                        if(lb.id == att.ParentId  && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg' || att.ContentType == 'image/gif')){
                            lbCustom.AttachmentId = att.Id;
                            lbCustom.StaticImage=false;
                        }  
                    }

                    if(lbCustom.StaticImage == true)
                    {
                    lbCustom.LBImgURL=lbCustom.ServerPath+strStaticImg+'/images/' + lb.Default_Image_Name__c;
                    }
                    else
                    {
                    lbCustom.LBImgURL=lbCustom.ServerPath+'/servlet/servlet.FileDownload?file='+lbCustom.AttachmentId;
                    }
                    lbCustom.FeaIndex =inx;
                    inx++; 
                   if(Prev==-1)
                    {
                        if(inx>next )
                            {
                                lstMostLikedTrends.add(lbCustom);
                                Added=true;
                                if(lstMostLikedTrends.size()==NoOfTile)
                                    {
                                        AllAdded=true;
                                        //break;
                                    }
                            }                            
                    }
                    if(next==-1 )
                      {
                    if(inx>=(prev-NoOfTile) )
                        {
                           lstMostLikedTrends.add(lbCustom);
                           Added=true;
                           if(lstMostLikedTrends.size()==NoOfTile)
                            {
                            //break;
                            AllAdded=true;
                            }
                        }                        
                    }
                     
                }               
                }
                
            }        
       
        return  lstMostLikedTrends;
    }
             
    @RemoteAction
    public static List<LearningBoardCustomClass> GetMostCommentedTrends(Integer Text,Integer Next,Integer Prev)
    {
    
    //----Start
     Integer TrendDays=Integer.valueOf(AthenaUtility.ApplicationSettingValue(AthenaUtility.MostCommentedTrendDays));
     //        MostCommentedNoOfDays=TrendDays;
        string typeComm='\'' + 'TextPost' + '\'';
        //Fetch all the Comments for all learning boards in N number days
        //List<FeedItem> feeddItmlst = [SELECT ParentId FROM FeedItem where Type='TextPost' and CreatedDate>= N_DAYS_AGO:NoOfDays and ParentId IN (Select id from learning_board__c)];    
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
        List<Learning_Board__c> lrngBrdLst=[SELECT id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,Owner.name,Owner.Id, Featured__c,CreatedDate FROM Learning_Board__c where id in:lrngBrdIdLstTmp];
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
    
        
           // List<Learning_Board__c> Learning_Board = CommentedLBs();
        
            
            
            system.debug('GetMostCommentedTrends');
            system.debug('CommentedLBs' + lstLearningBoard);

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
                    string strStaticImg=    GetResourceURL('athena_images');
                    lbCustom.LikeIcon=lbCustom.ServerPath+strStaticImg+'/images/hpit_athena_likeIcon.png';
                    lbCustom.CommentIcon =lbCustom.ServerPath+strStaticImg+'/images/hpit_athena_chatIcon.png';
                    for(Attachment att: attachmentList){
                        if(lb.id == att.ParentId  && (att.ContentType == 'image/jpeg' || att.ContentType == 'image/png' || att.ContentType == 'image/jpg'  || att.ContentType == 'image/gif' )){
                            lbCustom.AttachmentId = att.Id;
                            lbCustom.StaticImage=false;
                        }  
                    }
                    if(lbCustom.StaticImage == true){
                        lbCustom.LBImgURL=lbCustom.ServerPath+strStaticImg+'/images/' + lb.Default_Image_Name__c;
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
             
             lblist= [select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True Order by LastModifiedDate Desc ];                           
            //Active Following  
            for(Learning_Board__c lb: lblist)
            {                
               entitySub = [select id,Subscriber.name from EntitySubscription where ParentId = :lb.id and SubscriberID =:UserInfo.getUserId()];
               if (entitySub.size()==1 && lb.Is_Active__c == true )
               {
                   perlist.add(lb);
               }               
            }
            
            //Active Owner 
            lblist= [select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and owner.Id=:UserInfo.getUserId() Order by LastModifiedDate Desc ];                            
            for(Learning_Board__c lb: lblist)
            {
                   perlist.add(lb);             
            }
            
            //Active and Contributor
            lblist= [select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and owner.Id!=:UserInfo.getUserId() Order by LastModifiedDate Desc ];                            
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
            lblist= [select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = False and owner.Id=:UserInfo.getUserId() Order by LastModifiedDate Desc ];                            
            for(Learning_Board__c lb: lblist)
            {
                   perlist.add(lb);             
            }
            
            //InActive and Contributor
            lblist= [select id,Name__c,description__c,Default_Image_Name__c,Is_Active__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = False and owner.Id!=:UserInfo.getUserId() Order by LastModifiedDate Desc ];                            
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
            
        //string strSection='Personalized';
        return  GetLearningBoard( Text, Next,Prev,perlist,'');
    }
       
}