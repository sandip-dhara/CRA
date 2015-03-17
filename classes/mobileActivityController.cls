public with sharing class mobileActivityController {


    public String feedItemInputText { get; set; }
    public String feedCommentID { get; set; }
    public String LoggedInUserDetails { get; set; }
    public ConnectApi.FeedItemPage feedItemPage{get;set;}
    
    public String CommunityId { get; set; }
    
    public Object TextSegmentType{get{
        return ConnectApi.MessageSegmentType.Text;
    }}
    public Object MentionSegmentType{get{
        return ConnectApi.MessageSegmentType.Mention;
    }}
    
    public mobileActivityController(AthenaLearningBoardDtls controller) {
        CommunityId  = controller.LearningBoardId;
        // Get the chatter news feed.
        feedItemPage = ConnectApi.ChatterFeeds.getFeedItemsFromFeed(null, ConnectApi.FeedType.Record, CommunityId, 25, null, null, null, null);
    }
        
    public mobileActivityController(ApexPages.StandardController stdController) {
    
        CommunityId  = stdController.getID();
        // Get the chatter news feed.
        feedItemPage = ConnectApi.ChatterFeeds.getFeedItemsFromFeed(null, ConnectApi.FeedType.Record, CommunityId, 25, null, null, null, null);
    }
    
     public PageReference postNewFeedItemLB() {
        PageReference PageRef=new PageReference('/apex/mobileLearningBoardMockup?id='+CommunityId);
        // Post to the chatter news feed.
        ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, CommunityId, feedItemInputText);
        PageRef.setRedirect(true);
        return PageRef;
     }
     
         
     public PageReference postNewFeedItemLBTablet() {
        PageReference PageRef=new PageReference('/apex/tabletViewBoard?id='+CommunityId);
        // Post to the chatter news feed.
        ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, CommunityId, feedItemInputText);
        PageRef.setRedirect(true);
        return PageRef;
     }
    
     public PageReference postNewFeedItem() {
        PageReference PageRef=new PageReference('/apex/mobileCommunityMockup?id='+CommunityId);
        // Post to the chatter news feed.
        ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, CommunityId, feedItemInputText);
        PageRef.setRedirect(true);
        return PageRef;
     }
     
      public PageReference postNewFeedItemTabletLB() {
        PageReference PageRef=new PageReference('/apex/tabletLearningBoardMockup?id='+CommunityId);
        // Post to the chatter news feed.
        ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, CommunityId, feedItemInputText);
        PageRef.setRedirect(true);
        return PageRef;
     }
    
     public PageReference postNewFeedItemTablet() {
        PageReference PageRef=new PageReference('/apex/tabletCommunityMockup?id='+CommunityId);
        // Post to the chatter news feed.
        ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, CommunityId, feedItemInputText);
        PageRef.setRedirect(true);
        return PageRef;
     }
     
     public PageReference postNewComment() {
     
        PageReference PageRef=new PageReference('/apex/mobileCommunityMockup?id='+CommunityId);
        
        FeedComment fcomment = new FeedComment();
        fcomment.FeedItemId = feedCommentID; //Id of the FeedItem on which you want to comment
        fcomment.CommentBody = feedItemInputText;
        insert fcomment;

        
        PageRef.setRedirect(true);
        return PageRef;
     }
     
     public PageReference postNewCommentLB() {
     
        PageReference PageRef=new PageReference('/apex/mobileLearningBoardMockup?id='+CommunityId);
        
        FeedComment fcomment = new FeedComment();
        fcomment.FeedItemId = feedCommentID; //Id of the FeedItem on which you want to comment
        fcomment.CommentBody = feedItemInputText;
        insert fcomment;

        
        PageRef.setRedirect(true);
        return PageRef;
     }
     
     public PageReference postNewCommentTablet() {
     
        PageReference PageRef=new PageReference('/apex/tabletViewBoard?id='+CommunityId);
        
        FeedComment fcomment = new FeedComment();
        fcomment.FeedItemId = feedCommentID; //Id of the FeedItem on which you want to comment
        fcomment.CommentBody = feedItemInputText;
        insert fcomment;

        
        PageRef.setRedirect(true);
        return PageRef;
     }
     
      public PageReference postNewCommentTabletLB() {
     
        PageReference PageRef=new PageReference('/apex/tabletLearningBoardMockup?id='+CommunityId);
        
        FeedComment fcomment = new FeedComment();
        fcomment.FeedItemId = feedCommentID; //Id of the FeedItem on which you want to comment
        fcomment.CommentBody = feedItemInputText;
        insert fcomment;

        
        PageRef.setRedirect(true);
        return PageRef;
     }

     /*public static void addMessageSegments(ConnectApi.MessageBodyInput messageInput, String text) {
        List<ConnectApi.MessageSegmentInput> segments = messageInput.messageSegments;

        // Break out @-mentions like [First Last] from input text.
        Integer openBracket = text.indexOf('[');

        //if #1: no [ implies no @[first last]
        if (openBracket == -1) {
            ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
            textSegment.text = text;
            segments.add(textSegment);
        }

        else {
            Integer nextInput = 0;
            while (openBracket != -1) {
                Integer closeBracket = text.indexOf(']', openBracket);
                //if #2: no ] means there are no more @[first last] to identify
                if (closeBracket == -1) {
                    break;
                }

                //if #3: grab all text before the [ and store as a text segment
                if (openBracket > nextInput) {
                    ConnectApi.TextSegmentInput beforeText = new ConnectApi.TextSegmentInput();
                    beforeText.text = text.substring(nextInput, openBracket);
                    segments.add(beforeText);
                }

                //if #4: grab text between [ ] and query for user
                if (closeBracket - openBracket > 0) {
                    String userName = text.substring(openBracket + 1, closeBracket);
                    User theUser = [SELECT Id FROM User WHERE Name = :userName];
                    ConnectApi.MentionSegmentInput mention = new ConnectApi.MentionSegmentInput();
                    mention.id = theUser.id;
                    segments.add(mention);
                }

                //check for more @[first last] after the one we just identified
                nextInput = closeBracket + 1;
                openBracket = text.indexOf('[', nextInput);
            }

            //if #5: grab all text after the last mention and store as a text segment
            if (nextInput < text.length() - 1) {
                ConnectApi.TextSegmentInput endText = new ConnectApi.TextSegmentInput();
                endText.text = text.substring(nextInput);
                segments.add(endText);
            }
        }
    }*/
}