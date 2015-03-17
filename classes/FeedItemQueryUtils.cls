public without sharing class FeedItemQueryUtils {
    public static List<FeedItem> getFeedItems(Id id) {
        return([Select id from FeedItem where parentID=: id]);
    }
}