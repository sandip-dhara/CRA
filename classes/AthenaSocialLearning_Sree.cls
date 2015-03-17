public class AthenaSocialLearning_Sree {
    
    Private Integer featuredIndex;
    Private Integer PersonalizedIndex;    
    Private Integer searchIndex;
    Private Integer lb_flag;
    
    Public String strSearchValue{get;set;}
    Public boolean ShowSearch{get;set;}
    
    Public AthenaSocialLearning_Sree(){    
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
    
    
    Public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
    
    Public User GetLoggedinUserDtls(){    
        User u = [Select Name From User where User.id= :UserInfo.getUserId()];
        return U;
    }    
 
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
    }

    //Featured Start    
    Public ApexPages.standardSetController FeaturedCon{    
    get{
        if(FeaturedCon == null){
            FeaturedCon = new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,description__c,  Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and Featured__c = True]));                      
            FeaturedCon.setPageSize(6);
        }        
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
            //List<EntitySubscription> entitySub=new List<EntitySubscription>();
            List<Learning_Board__c>  perlist= new List<Learning_Board__c>();    
            List<Learning_Board__c>  lblist= [select id,Name__c,description__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True];                           
            
            // Get all LearningBoard Ids
            Set<Id> LBIds = new Set<Id>();
            for (Learning_Board__c lb :lblist) {
                LBIds.add(lb.Id);
            }
            
            // Get all EntitySubscription records
            List<EntitySubscription> entitySub = new List<EntitySubscription>([SELECT Id, Subscriber.name,ParentId FROM EntitySubscription WHERE ParentId IN :LBIds AND SubscriberID = :UserInfo.getUserId()]);
            
            // Get Map to relate which EntitySubscription records are retrieved for each LearningBoard (using LearningBoard Id)
            Map<Id, List<EntitySubscription>> LbEsMap = new Map<Id, List<EntitySubscription>>();
            
            for (Id LBId :LBIds) {
                List <EntitySubscription> esList = new List<EntitySubscription>();
                for (EntitySubscription es :entitySub) {
                    if (es.ParentId == LBId) {
                        esList.add(es);
                    }
                }
                LbEsMap.put(LBId, esList);
            }
            
            
            for(Learning_Board__c lb: lblist)
            {
                //entitySub = [select id,Subscriber.name from EntitySubscription where ParentId = :lb.id and SubscriberID =:UserInfo.getUserId()];
                if (LbEsMap.get(lb.Id).size() == 1 || lb.owner.Id == UserInfo.getUserId())
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
            //Search based on Learning Board name and description
            List<Learning_Board__c> searchResult;
            searchResult= [select id,Name__c,description__c,  Featured__c,Owner.name,Owner.Id,CreatedDate from Learning_Board__c where Name__c like:newSearchText  or short_description__c like:newSearchText];      
//                  

            //Search based on Learning name and description
            List<Learning__c> searchResult_Learning;
            searchResult_Learning= [select id from Learning__c where Name__c like:newSearchText or short_description__c like:newSearchText];            
//            
              
            Set<Id> LIds = new Set<Id>();
    
            for (Learning__c l :searchResult_Learning) {
                LIds.add(l.Id);
            }
            //Getting the Learning Boards of the searched learnings
            List<Learning_Board__c> searchResultLearningBoard = new List<Learning_Board__c>([select id,Name__c,description__c,  Featured__c,Owner.name,Owner.Id,CreatedDate from Learning_Board__c where id in(select Learning_Board_ID__c from Learning_Board_Learning__c where Learning_ID__c in :LIds)]);
            for (Learning_Board__c l :searchResultLearningBoard ) {
                lb_flag = 0;              
                 for(Learning_Board__c l1 :searchResult ){
                    if(l.id == l1.id){
                        lb_flag = 1;
                    }
                }
                if(lb_flag != 1){
                    searchResult.add(l);
                }
            }
            searchCon= new ApexPages.StandardSetController(searchResult); 
            searchCon.setPageSize(6);
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