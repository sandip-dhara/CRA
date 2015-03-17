global class scheduledBatchable implements Schedulable{
   global void execute(SchedulableContext sc) {
      CCDeleteExpiredClosedLeads b = new CCDeleteExpiredClosedLeads (); 
      database.executebatch(b);
   }
}