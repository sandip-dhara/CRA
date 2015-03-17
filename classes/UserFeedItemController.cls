public with sharing class UserFeedItemController {    
    public String inputText{get;set;}
    public String parID;
    public integer CommentCount {set;get;}
    public Set<Id> feedOwnerIDSet;
    public Map<Id, User> feedOwnerMap;
    public List<FeedItem> FeedLikeList;
    public List<FeedDetailsClass> fdcList {get; set;}
    public class FeedDetailsClass {
        public FeedItem fitem {get; set;}
        public User u {get; set;}
        FeedDetailsClass(FeedItem fi, User usr) {
            fitem = fi;
            u = usr;
        }
    }
    Public UserFeedItemController() {
        parID = ApexPages.currentPage().getParameters().get('id');
        FeedLikeList=[select Body,CommentCount,ContentSize,InsertedById,IsDeleted,LikeCount,ParentId,Type,CreatedDate from FeedItem where parentID =:parID];
        feedOwnerIDSet = new Set<Id> ();
        CommentCount = FeedLikeList.size();
        system.debug('Count'+FeedLikeList.size());
        for (FeedItem fi :FeedLikeList) {
            feedOwnerIDSet.add(fi.InsertedById);
        }
        feedOwnerMap = new Map<Id, User>([SELECT Id, Name, SmallPhotoUrl, FullPhotoUrl From User WHERE Id IN :feedOwnerIDSet]);
        fdcList = new List<FeedDetailsClass>();
        for (FeedItem fi: FeedLikeList) {
            FeedDetailsClass fdc = new FeedDetailsClass(fi, feedOwnerMap.get(fi.InsertedById));
            fdcList.add(fdc);
        }        
    }      
    public PageReference PostAction() {
        FeedItem FIList = new FeedItem();
        FIList.Body = inputText;
        FIList.ParentID = parID;
        insert FIList;
        xyz();
        InputText='';
        return null;
    } 
    public void xyz(){
        parID = ApexPages.currentPage().getParameters().get('id');
        FeedLikeList=[select Body,CommentCount,ContentSize,InsertedById,IsDeleted,LikeCount,ParentId,Type,CreatedDate from FeedItem where parentID =:parID];
        feedOwnerIDSet = new Set<Id> ();
        CommentCount = FeedLikeList.size();
        system.debug('CommentCount##'+CommentCount);
        for (FeedItem fi :FeedLikeList) {
            feedOwnerIDSet.add(fi.InsertedById);
        }
        feedOwnerMap = new Map<Id, User>([SELECT Id, Name, SmallPhotoUrl, FullPhotoUrl From User WHERE Id IN :feedOwnerIDSet]);
        fdcList = new List<FeedDetailsClass>();
        for (FeedItem fi: FeedLikeList) {
            FeedDetailsClass fdc = new FeedDetailsClass(fi, feedOwnerMap.get(fi.InsertedById));
            fdcList.add(fdc);
        }
      }           
}