public with sharing class AthenaSocialLearningSmita {
 
    public Integer featuredIndex;

    public Integer PersonalizedIndex;    

    public String strSearchValue{get;set;}
    public Integer searchIndex;
    public boolean ShowSearch{get;set;}
    
    public String getSfInstance{
    get{
        return ApexPages.currentPage().getHeaders().get('Host');
        }
    }
public User GetLoggedinUserDtls{
    get{
        User u = [Select Name From User where User.id= :UserInfo.getUserId()];
        return U;
    }    
    set;}
 
    public class LearningBoardCustomClass{
            public id AttachmentId{get;set;}
            public String AttBody{get;set;}
            public String AttContentType{get;set;}
            public String LBName{get;set;}
            public String LBDescription{get;set;}   
            public String LBid{get;set;}
            public String LBOwnerName{get;set;} 
            public String LBOwnerURL{get;set;}
            public datetime LBCrtDate{get;set;}
            public Object LBNoOfLikes{get;set;}
            public Object LBNoOfComments{get;set;} 
            public boolean StaticImage{get;set;}  
    }   
        
    public AthenaSocialLearningSmita(){    
    strSearchValue = ApexPages.currentPage().getParameters().get('SearchVal');
       
    if(strSearchValue == null) 
    {
         ShowSearch=false;
        // System.debug('search value=' + strSearchValue);
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
    
    public ApexPages.standardSetController FeaturedCon{    
    get{
        if(FeaturedCon == null){
            FeaturedCon = new ApexPages.StandardSetController(Database.getQueryLocator([select id,Name__c,description__c,  Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True and Featured__c = True]));            
          
            FeaturedCon.setPageSize(4);
        }        
        return FeaturedCon;   
    }    
    set;}

    public List<LearningBoardCustomClass> FeaturedLBList {
        get
            {
                if(featuredIndex == 0){
                    featuredIndex=1;
                    FeaturedLBList.clear();
                    getAttachment('Featured');
                    }               
                return FeaturedLBList;
            }                 
            set;
            }
            


   
            
           Public String getUserImage(Id uid){
            User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id=:uid];
            return u.smallPhotoUrl;
            }

       
         
         
    Public integer LikedItemCount(string itemIdentifier)
    {
        List<Liked_Item__C> li = [select like_count__C from liked_item__C where Item_identifier__C = : itemIdentifier];
      //  return li.size();
        if(li.size()!=0)
        {
            return Integer.ValueOf(li[0].like_count__c);
        }
        else
        {
            return 0;
        }
    }         
        
        
        
        private Integer CommentCount(string id){

            List<FeedItem> commCount = [Select id from FeedItem where parentID=:id];
            return commCount.size();
           /* if(commCount.size()!=0)
            {
                integer i=0;
                for(FeedItem FI:commCount)
                {
                  i=i+1;                
                } 
                return i; 
            }
            else
            {
              return 0;
            }*/
        }


       public void featuredNext(){
        FeaturedCon.next();
        featuredIndex=0;
        System.debug('??????1');
       }       
       
       public void featuredPrevious(){
        FeaturedCon.previous();
        featuredIndex=0;       
       }
       
       
    //Personalized Start
    public ApexPages.standardSetController PersonalizedCon{    
    get{
        if(PersonalizedCon== null){
    
               List<Learning_Board__c>  lblist= [select id,Name__c,description__c,Owner.name,Owner.Id, Featured__c,CreatedDate from Learning_Board__c where Is_Active__c = True];                           

               List<EntitySubscription> entitySub=new List<EntitySubscription>();
               List<Learning_Board__c>  perlist= new List<Learning_Board__c>();
               for(Learning_Board__c lb: lblist)
               {                
                   entitySub = [select id,Subscriber.name from EntitySubscription where ParentId = :lb.id and SubscriberID =:UserInfo.getUserId()];
                    system.debug('User-->info'+UserInfo.getUserId()+'LB-->owner'+lb.owner.Id);
                   if (entitySub.size()==1 || lb.owner.Id == UserInfo.getUserId())
                   {
                       perlist.add(lb);
                   }               
               }
            PersonalizedCon= new ApexPages.StandardSetController(perlist);
            PersonalizedCon.setPageSize(4);
        }        
        system.debug('***' +PersonalizedCon);
        return PersonalizedCon;   
    }    
    set;}

   
            
             public List<LearningBoardCustomClass> PersonalizedLBList {
        get
            {
                if(PersonalizedIndex== 0){
                    PersonalizedIndex=1;
                    PersonalizedLBList.clear();
                    getAttachment('Personalized');                     
                    }                
                return PersonalizedLBList;
            }                 
            set;
            }

       public void perNext(){
        PersonalizedCon.next(); 
        PersonalizedIndex=0;
       }
       
       
       
       public void perPrevious(){
        PersonalizedCon.previous();
        PersonalizedIndex=0;       
       }
       
       

//Personalized End

// Search -- Start        
    public void dosearch()
    {
     ShowSearch=true;
     searchCon=null;
     searchIndex=0;                            
    }            
         
     public ApexPages.standardSetController searchCon{    
        get{
            if(searchCon== null){      
                String newSearchText= '%'+ strSearchValue + '%';               
    
                List<Learning_Board__c> searchResult;
                searchResult= [select id,Name__c,description__c,  Featured__c,Owner.name,Owner.Id,CreatedDate from Learning_Board__c where Name__c like:newSearchText];
                // Or Description__c like:newSearchText
                searchCon= new ApexPages.StandardSetController(searchResult); 
                searchCon.setPageSize(4);
            }        
            return searchCon;    
        }    
        set;}
   
                 public List<LearningBoardCustomClass> SearchResultLBList{
            get
                {
                  if(searchIndex== 0){
                    searchIndex=1;                    
                                                        
                    SearchResultLBList.clear();  
                    getAttachment('Search'); 
                    }                      
                    return SearchResultLBList;    
                               
                }                 
                set;
                }
       public void searchNext(){
        searchCon.next();        
        searchIndex=0;
       }
       
       
       public void searchPrevious(){
        searchCon.previous();    
        searchIndex=0;
       }
       
    //Search -- End        
    //Common Method -- Start
   
   public List<LearningBoardCustomClass> getAttachment(String Section) {
   
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
            //lbCustom.LBDescription = lb.Description__c;
             if(lb.description__c!=null){
                if(lb.description__c.length()>53){
                    
                    lbCustom.LBDescription = lb.Description__c.substring(0,53) + '...';
                }
                else{
                    lbCustom.LBDescription=lb.description__c;
                }
              }
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
                    lbCustom.AttBody = EncodingUtil.Base64Encode(att.body);
                    lbCustom.AttContentType = att.ContentType;
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
        if(Section == 'Featured')
        {
            return FeaturedLBList;
        }
        else if(Section == 'Personalized')
        {
            return PersonalizedLBList;
        }
        else if(Section == 'Search')
        {
            return SearchResultLBList;
        }
        return null;
   }
   //Common Method -- End
}