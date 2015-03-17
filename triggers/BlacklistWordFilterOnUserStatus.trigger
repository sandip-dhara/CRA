/**
 * Filter UserStatus updates for blacklisted words
 * Author: Quinton Wall - qwall@salesforce.com
 */
trigger BlacklistWordFilterOnUserStatus  on User (before update) {
	
	List<User> usersWithStatusChanges = new List<User>();
	
	//only test for blacklist filtering if the trigger was executed
	//because of a status change
	for(User u : trigger.new)
	{
		if(u.CurrentStatus != trigger.oldMap.get(u.Id).currentStatus)
			usersWithStatusChanges.add(u);
	}
	
	if(!usersWithStatusChanges.isEmpty())
		new BlacklistFilterDelegate().filterUserStatus(usersWithStatusChanges);

}