/**
 * Filter Feed Items for blacklisted words
 * Author: Quinton Wall - qwall@salesforce.com
 */
trigger BlacklistWordFilterOnPost on FeedItem (before insert) 
{
     new BlacklistFilterDelegate().filterFeedItems(trigger.new);
}