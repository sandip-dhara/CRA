global class CustFeed {
global List<ConnectApi.FeedItem> getNewsFeed()
{
    return ConnectApi.ChatterFeeds.getFeedItemsFromFeed(null, ConnectApi.FeedType.News,'me').items;
    //return ConnectApi.ChatterFeeds.getFeedItem(null,'a6tZ00000008RVn');
}

}