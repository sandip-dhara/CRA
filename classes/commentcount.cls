public with sharing class commentcount {

    public string Learningid {get;set;}    
    public commentcount () {
        this.Learningid = ApexPages.currentPage().getParameters().get('id');    
    }                
    public integer LrngCommentCount{
        get{
            integer i; 
            List<FeedItem> commCount = [Select id,parentId from FeedItem where parentID='a6wZ00000008otq'];
            return commentCount1('a6wZ00000008otq');
        }
        set;
    }
    public static Integer CommentCount1(string id){
        List<FeedItem> commCount = [Select id from FeedItem where parentID=:id];
        return commCount.size(); 
    }
    public static pagereference CommentCount2(string id){
        List<FeedItem> commCount = [Select id from FeedItem where parentID=:id];
        PageReference newPage = new PageReference('/home.jsp' );
        system.debug('$$');
        return newpage;
    }
}