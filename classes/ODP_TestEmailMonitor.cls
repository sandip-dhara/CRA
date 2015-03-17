public with sharing class ODP_TestEmailMonitor {
    
    public void StartMoniterRisk(){
    try{
        ODP_MonitorRiskScheduler.start(); 
    }catch(Exception e){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()));
    }
        //StockPriceJobScheduler.start();
    }
    
    public ODP_TestEmailMonitor (){
        List<CronJobDetail> pIList = [Select Id,JobType 
                                    From CronJobDetail
                                    WHERE Name ='MonitorRisk'];
    }
}