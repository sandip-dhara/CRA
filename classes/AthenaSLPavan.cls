public class AthenaSLPavan {
    
    Private Integer featuredIndex;
    Private Integer PersonalizedIndex;    
    Private Integer searchIndex;
    //pavan
    Public Integer PageSize{get;set;}
    //pavan
    
    Public String strSearchValue{get;set;}
    Public boolean ShowSearch{get;set;}
    
    Public AthenaSLPavan(){  
        PageSize=4;  
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
    //Pavan Added on 20-JAN-2014
         String userAgent = ApexPages.currentPage().getHeaders().get('User-Agent');
        //if (userAgent.contains('iPhone') || (userAgent.contains('Blackberry')) || (userAgent.contains('JellyBean')))
            //PageSize=2;
        //else if (userAgent.contains('iPad'))
            //PageSize=4;
        //else if (userAgent.contains('internet explorer') || userAgent.contains('safari') || userAgent.contains('chrome') || userAgent.contains('Mozilla'))
           // pagesize=6;
        //else 
           // pagesize=8;
        }     
    
    //Pavan Added on 20-JAN-2014
    
    Public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
    
    Public User GetLoggedinUserDtls(){    
        User u = [Select Name From User where User.id= :UserInfo.getUserId()];
        return U;
    }  
//pavan
    Public Boolean IsProducerProfile()
    {
        String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
        //User u = [Select ID From User where User.id= :UserInfo.getUserId()];
        //List<PermissionSet> PS= New List<PermissionSet>();
        //PermSet=[SELECT Id, Name, Label, UserLicenseId FROM PermissionSet where  IsOwnedbyprofile=FALSE and id in (SELECT  PermissionSetId FROM PermissionSetAssignment where AssigneeId=:UserInfo.getUserId())];
         If(usrProfileName=='ES Base Profile')
         {
            List<PermissionSet> PermSet=[SELECT Id, Name, Label, UserLicenseId FROM PermissionSet where  IsOwnedbyprofile=FALSE and id in (SELECT  PermissionSetId FROM PermissionSetAssignment where AssigneeId=:UserInfo.getUserId())];
            for(PermissionSet PS: PermSet)
             {
                If(PS.Name=='ES_Social_Learning_Producer')
                return true;
             }
             return false;
         }
         else if (usrProfileName=='ES IT Administrator')
         {
            return True;
         }
         else if (usrProfileName=='IT Administrator')
         {
            return True;
         }
         else
         {
            return False;
         }
         
    }
 //pavan
    Public class LearningBoardCustomClass{
        public id AttachmentId{get;set;}        
        public String LBName{get;set;}
        public String LBDescription{get;set;}   
        public String LBid{get;set;}
        public String LBOwnerName{get;set;} 
        public String LBOwnerURL{get;set;}
        public datetime LBCrtDate{get;set;}
        public integer LBNoOfLikes{get;set;}
        public integer LBNoOfComments{get;set;} 
        public boolean StaticImage{get;set;} 
        public string LBOwnerID{get;set;}
        //pavan
        public boolean Active{get;set;}
        public boolean existing{get;set;}
        //pavan
    }

    //Featured Start    
    Public ApexPages.standardSetController FeaturedCon{    
    get{
        if(FeaturedCon == null){
            FeaturedCon = new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,description__c,  Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and Featured__c = True]));                      
            //pavan
            FeaturedCon.setPageSize(PageSize);
        }    //pavan    
        return FeaturedCon;   
    }    
    set;}      
    
    Public void featuredNext(){
        FeaturedCon.next();
        featuredIndex=0;
    }       
    
    Public void featuredPrevious(){
        FeaturedCon.previous();
        featuredIndex=0;       
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
            List<EntitySubscription> entitySub=new List<EntitySubscription>();
            List<Learning_Board__c>  perlist= new List<Learning_Board__c>();    
            List<Learning_Board__c>  lblist; 
            AthenaUserAccess UA=new AthenaUserAccess();
            //pavan
            if(IsProducerProfile())
            {
                lblist=[select id,Name__c,description__c,Is_Active__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c]; 
                    
            }
            else{
                lblist=[select id,Name__c,description__c,Is_Active__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True];                           
            }
            for(Learning_Board__c lb: lblist)
            {                
               entitySub = [select id,Subscriber.name from EntitySubscription where ParentId = :lb.id and SubscriberID =:UserInfo.getUserId()];
               //pavan
               if ((entitySub.size()==1 && lb.Is_Active__c == true)|| lb.owner.Id == UserInfo.getUserId())
               //pavan
               {
                   perlist.add(lb);
               }               
            }
            PersonalizedCon= new ApexPages.StandardSetController(perlist);
            PersonalizedCon.setPageSize(6);
            }
        return PersonalizedCon;   
    }    
    set;}

    Public void perNext(){
        PersonalizedCon.next(); 
        PersonalizedIndex=0;
    }
    
    Public void perPrevious(){
        PersonalizedCon.previous();
        PersonalizedIndex=0;       
    }
            
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
    //Personalized End

    // Search -- Start        
    Public void dosearch()
    {
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
            //system.debug('pagesize@Searchcon'+pagesize);
            searchCon.setPageSize(PageSize);
        }        
        return searchCon;    
    }    
    set;}
    
    Public void searchNext(){
        searchCon.next();        
        searchIndex=0;
    }
        
    Public void searchPrevious(){
        searchCon.previous();    
        searchIndex=0;
    }
   
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
    //Search -- End     
    
    //Common Method -- Start   
    Private void getLearningBoards(String Section) {    
        list<Attachment> attachmentList = new List<Attachment>(); 
        list<id> learningBoardIds= new list<id>();
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
    
        attachmentList = [SELECT Body, ContentType, Name,ParentId FROM Attachment WHERE Parentid in :learningBoardIds];
        
        //pavan
        if(Section == 'Personalized' && IsProducerProfile() ) 
            {
            LearningBoardCustomClass lbproducer= new LearningBoardCustomClass();
            
            //lbproducer.LBOwnerID=lb.Owner.Id;
            //lbproducer.LBOwnerName = lb.Owner.Name;  
            //lbproducer.LBOwnerURL = getUserImage(lb.Owner.Id);    
            //lbproducer.LBCrtDate = lb.CreatedDate;  
            //lbproducer.LBNoOfComments =   CommentCount(lb.id);  
            //lbproducer.LBNoOfLikes =   LikedItemCount(lb.id); 
            //lbproducer.LbId = lb.id;
            lbproducer.StaticImage = True;
            lbproducer.LBName='Create New Board';
            lbproducer.Active=False;
            lbproducer.existing=False;
            PersonalizedLBList.add(lbproducer);
                        
            }
    //pavan
        for(Learning_Board__c lb: Learning_Board){
            LearningBoardCustomClass lbCustom= new LearningBoardCustomClass();            
            
            lbCustom.LBName = lb.Name__c; 
            lbCustom.existing=True;
            if(lb.description__c!=null){
                if(lb.description__c.length()>53){
                    
                    lbCustom.LBDescription = lb.Description__c.substring(0,53) + '...';
                }
                else{
                    lbCustom.LBDescription=lb.description__c;
                }
            }
            if(Section == 'Personalized')
            {
                LbCustom.Active=lb.Is_Active__c;
            }
            else
            {
                LbCustom.Active=True;
            }
            lbCustom.LBOwnerID=lb.Owner.Id;
            lbCustom.LBOwnerName = lb.Owner.Name;  
            lbCustom.LBOwnerURL = getUserImage(lb.Owner.Id);    
            lbCustom.LBCrtDate = lb.CreatedDate;  
            lbCustom.LBNoOfComments =   CommentCount(lb.id);  
            lbCustom.LBNoOfLikes =   LikedItemCount(lb.id); 
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
   
    
    Private String getUserImage(Id uid){
        User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id=:uid];
        return u.smallPhotoUrl;
    }
        
    Private integer LikedItemCount(string itemIdentifier)
    {
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
    
    //Common Method -- End
    
}