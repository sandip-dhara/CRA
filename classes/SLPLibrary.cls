public class SLPLibrary {
  
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
      
      public PageReference  RedirectToSLP_GlobalSearch()
      {            
          //PageReference pRef = new PageReference('/apex/SLP_GlobalSearch');
                      
          //system.debug('Test Suman' + strSearchValue);
          
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
        
        integer icnt = 1;
        
        for (Learning_Board__c lb: Learning_Board )
        {
            if(icnt > Next)
            {
                learningBoardIds.add(lb.id);
                NewLearning_Board.add(lb);
             }
           icnt++;
        }
                
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
        integer inx=1;
        
        
       List<Rated_Item__c> RatedItemLst = [SELECT  Item_Name__c, Item_Identifier__c, Rating_Average__c,Id FROM Rated_Item__c where Item_Identifier__c in :learningBoardIds];
        map<id,decimal> RatedItemMap = new map<id,decimal>();        
                   
        
        for (Rated_Item__c rtdItm :RatedItemLst) {
                    RatedItemMap.put(rtdItm.Item_identifier__C,rtdItm.Rating_Average__c);  
        }
        
        string strStaticImage = GetResourceURL('athena_images');
        
        for(Learning_Board__c lb: NewLearning_Board){
         LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();            
         lbCustom.TotalCount =NewLearning_Board.size();
            lbCustom.LBName = lb.Name__c; 

            if(lb.description__c != null){
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
                                        
            
            lbCustom.LBOwnerURL = getUserImages(lb.Owner.Id);   
            lbCustom.LBCreateDate=(lb.CreatedDate).format('MMM dd ');
            lbCustom.NavigationLink='/apex/AthenaLearningBoardDtls?id=' + lb.id;
            lbCustom.LBNoOfComments =   CommentCounts(lb.id);  
            //lbCustom.LBNoOfLikes =   LikedItemCounts(lb.id); 
            lbCustom.LbId = lb.id;
            lbCustom.Active=lb.Is_Active__c;
            lbCustom.StaticImage = true;
            lbCustom.ServerPath ='https://'+URL.getSalesforceBaseUrl().getHost();
            string strStaticImg = strStaticImage;   
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
   
    
    Public SLPLibrary(){
    system.debug('SLPLibrary Suman');
        strSearchValue = ApexPages.currentPage().getParameters().get('SearchVal');  
        AvailTags=AthenaUtility.getAvailableTags();          
        MostCommentedNoOfDays=0;
                
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
 
        return  GetLearningBoard( Text, Next,Prev,perlist,'');
    }
       
}