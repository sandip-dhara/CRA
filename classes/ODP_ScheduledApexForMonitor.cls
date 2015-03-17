global class ODP_ScheduledApexForMonitor implements Schedulable {

   //public static String CRON_EXP = '0 * * * * ?';
   
   global void execute(SchedulableContext ctx) {
      ODP_RefreshRiskStatus.RefreshRiskStatus(); 
   }   
}