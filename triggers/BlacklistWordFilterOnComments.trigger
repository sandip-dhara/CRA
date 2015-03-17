/**
 * Filter Feed Comments for blacklisted words
 * Author: Quinton Wall - qwall@salesforce.com
 */
trigger BlacklistWordFilterOnComments on FeedComment (before Insert) 
{
	 new BlacklistFilterDelegate().filterFeedComments(trigger.new);
	
}