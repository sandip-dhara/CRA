public class ODP_Extension_VisualAdminConsoleNing {
    public List<Flight_Plan__c> FPS{get;set;}
    public ODP_Extension_VisualAdminConsoleNing(ApexPages.StandardController controller) {
        AggregateResult[] aggr = [select count(id) cc,Flight_Plan_ID__c from Offering_Release__c group by Flight_Plan_ID__c order by count(id) desc limit 6];
        List<string> ids = new List<string>();
        for(AggregateResult ar:aggr){
            ids.add(String.valueOf(ar.get('Flight_Plan_ID__c')));
        }
        FPS = [select id,Name__c from Flight_Plan__c where id in :ids];
    }

}