global class scheduledCCLeadDropOffTriggerBatch implements Schedulable{
   global void execute(SchedulableContext sc) {
      CCLeadDropOffTriggerBatch b = new CCLeadDropOffTriggerBatch(); 
      database.executebatch(b);
   }
}