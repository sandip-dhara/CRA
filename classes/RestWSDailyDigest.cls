@RestResource(urlMapping='/RestDailyDigest/*')
global with sharing class RestWSDailyDigest {
 global class ClsFeedComment
    {
        public string FeedItemId {get;set;}
        public Id CommentId {get;set;}
        public string CommentName {get;set;}      
        public string Comment {get;set;}
        public string  CommentedUserId {get;set;}
        public string CommentedUserName {get;set;}
        public Datetime CommentedDate {get;set;}
        public integer  CommentedLikes {get;set;}
        public string CmtUsrPhoto {get;set;}
        public string CmtUserNm {get;set;}
        public string CommentBody {get;set;}
        public string CommentType {get;set;}
        public string LinkUrl {get;set;}
        public boolean IsLink {get;set;}
        public string Type {get;set;}
        
    }
    Static string strAttachment='View File';
    DateTime d;
    string createdDate='';
    String fullFileURL = '';
     set<ID> setParentIds=new set<ID>();
     
     global class ClsFeedPost
     {
        public string Id {get;set;}
        public string LinkUrl {get;set;}
     }
     
     global class RestResponseDaily
     {
        public List<ClsFeedPost> LstFeedPost {get;set;}
        public List<ClsFeedComment> lstFeedComment {get;set;}
        public List<user> lstuser {get;set;}
        
     }
     
     
    @HttpGet
    global static RestResponseDaily GetFeedItem()
    {
          RestResponseDaily rstDaily=new RestResponseDaily();
        List<ClsFeedPost> lstFeedI=new List<ClsFeedPost>();
 
         ClsFeedPost clsFP=null;
         list<FeedItem> lstFeedItem= [SELECT Id, LinkUrl,RelatedRecordId,Type, ParentId, CreatedById, CreatedDate, LikeCount, CommentCount, Title, Body, IsDeleted FROM FeedItem  where Type in ('TextPost','LinkPost','ContentPost')    order by LastModifiedDate desc];
         for(FeedItem FeedItm:lstFeedItem)
         {
         clsFP=new ClsFeedPost();
         clsFP.Id=FeedItm.Id;
         clsFP.LinkUrl=FeedItm.LinkUrl;
         lstFeedI.add(clsFP);
         //setParentIds.add(FeedItm.ParentId);
         }
         rstDaily.LstFeedPost=lstFeedI;
        rstDaily.lstFeedComment= GetFeedItemComment();
    List<user> lstUsr=  [SELECT Id, email from user];
        rstDaily.lstuser=lstUsr;
              return rstDaily;
      //string str='Mahesh';
      //return str;
    }
    
        
    
    global static List<ClsFeedComment> GetFeedItemComment()
    {
    String fullFileURL = '';
    set<Id> setCreateIds=new set<Id>();
      List<ClsFeedComment> lstFeedCmt=new List<ClsFeedComment>();
      ClsFeedComment CPC=null;
      List<FeedComment> lstFeedComment =[SELECT Id, FeedItemId, ParentId,CreatedById, CreatedBy.name, CreatedDate, CommentBody, IsDeleted, InsertedById, CommentType, RelatedRecordId FROM FeedComment   order by CreatedDate];
      for(FeedComment FeedCmt:lstFeedComment)
      {
            
            CPC=new ClsFeedComment();
            setCreateIds.add(FeedCmt.CreatedById);
            CPC.FeedItemId=FeedCmt.FeedItemId;
            CPC.CommentId=FeedCmt.Id;
            CPC.CommentName=FeedCmt.CommentBody;
            CPC.CommentedUserId=FeedCmt.CreatedById;
            CPC.CommentedDate=FeedCmt.CreatedDate;
            CPc.CmtUserNm=FeedCmt.CreatedBy.name;  
            CPc.CommentType=FeedCmt.CommentType;
            if(CPc.CommentType=='ContentComment')
            {
                CPc.IsLink=true;
                CPc.LinkUrl=fullFileURL+FeedCmt.RelatedRecordId;
            }
            else
            {
                CPc.IsLink=false;
            }
            CPc.CommentBody=FeedCmt.CommentBody;
         
            lstFeedCmt.add(CPC);
                        
        }
      return lstFeedCmt;
    }
    
    
    
}