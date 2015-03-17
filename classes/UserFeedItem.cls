public with sharing class UserFeedItem {
    

    public integer LCommentCount{
        get{     
            List<FeedItem> commCount = [Select id from FeedItem where parentID='a6tZ00000008REE'];
            return commCount.size();
        }
        set;}
        
     public void get_comment_count(){
          List<FeedItem> commCount = [Select id from FeedItem where parentID='a6tZ00000008REE'];
            LCommentCount = commCount.size();
     }   
}