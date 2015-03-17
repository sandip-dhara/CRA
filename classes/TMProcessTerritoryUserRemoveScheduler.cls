// TM: Sreenath (R5 EF2 change request) CR-1052 7/18/2013 user inactivation need to inactive in territory & specialty starts
    
    /**
    * @description: Inactive territory users & set tobedeleted flag to True for SOM deletion of this user, when user is inactivated in user detail page.
    * @param - Map<Id, User> newUsers - Newly inactivated users
    * @param - Map<Id, User> oldUsers - previously Active users
    */ 

global class TMProcessTerritoryUserRemoveScheduler implements Schedulable{   
    global void execute(SchedulableContext sc) {
        Integer batchSize = Integer.valueOf(Batch_Size__c.getValues('TMProcessTerritoryUserRemoveBatch Size').Batch_Size__c);
        Id batchId = Database.executeBatch(new TMProcessTerritoryUserRemoveBatch(), batchSize);
     }
}