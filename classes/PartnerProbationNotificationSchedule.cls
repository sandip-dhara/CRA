global class PartnerProbationNotificationSchedule implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        Integer batchSize;
        PartnerProbationNotificationTOPBMs b = new PartnerProbationNotificationTOPBMs(); //ur batch clas 
        String query='select id,name,ownerid from Lead where Partner_Owned__c=true and ConvertedOpportunityId__c = null';  
        if(test.isRunningTest()== true){
           query=query+' and name =\'testclassLead\' Limit 199';
           batchSize=199;
        }else{
           query=query;
           batchSize=200;
        }
        b.query=query;
        database.executeBatch(b,batchSize);
    }
}