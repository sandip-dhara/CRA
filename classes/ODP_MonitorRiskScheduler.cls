global class ODP_MonitorRiskScheduler
{
    global void StockPriceJobScheduler() {}
    public static void start()
    {
        //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        
        System.schedule('ODP_MonitorRisk', '0 0 * * * ?', new ODP_ScheduledApexForMonitor());

        //System.schedule('MonitorRisk3', '0 34 * * * ?', new ODP_ScheduledApexForMonitor());
        //System.schedule('MonitorRisk4', '0 36 * * * ?', new ODP_ScheduledApexForMonitor());
        //System.schedule('MonitorRisk5', '0 38 * * * ?', new ODP_ScheduledApexForMonitor());
        //System.schedule('MonitorRisk6', '0 40 * * * ?', new ODP_ScheduledApexForMonitor());
        //System.schedule('MonitorRisk', '0 30 * * * ?', new ODP_ScheduledApexForMonitor());
        //System.schedule('MonitorRisk', '0 40 * * * ?', new ODP_ScheduledApexForMonitor());
        //System.schedule('MonitorRisk', '0 50 * * * ?', new ODP_ScheduledApexForMonitor());
        //System.schedule('MonitorRisk', '0 36 * * * ?', new ODP_ScheduledApexForMonitor());
        //System.schedule('MonitorRisk', '0 42 * * * ?', new ODP_ScheduledApexForMonitor());
        //System.schedule('MonitorRisk', '0 48 * * * ?', new ODP_ScheduledApexForMonitor());
        //System.schedule('MonitorRisk', '0 54 * * * ?', new ODP_ScheduledApexForMonitor());
        
    }
}