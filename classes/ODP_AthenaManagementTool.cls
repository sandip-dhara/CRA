public with sharing class ODP_AthenaManagementTool {
    
    public void StartMoniterRisk(){
    try{
        ODP_MonitorRiskScheduler.start(); 
    }catch(Exception e){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()));
    }
        //StockPriceJobScheduler.start();
    }
    
    public ODP_AthenaManagementTool (){
       
    }
}