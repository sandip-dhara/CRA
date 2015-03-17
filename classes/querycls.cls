public class querycls
{
    public List<Business_Impact__c> bi {get;set;}
    public List<Business_Impact_Cause__c> bic {get;set;}
    public List<Root_Cause_Control__c> rcc {get;set;}

    set<id> bicdff=new set<id>();
    set<id> bdff=new set<id>();
    Map<id,string> bimap=new Map<id,string>();
    Map<id,string> rcmap=new Map<id,string>();
    Map<id,string> prmap=new Map<id,string>();
    public map<id, list<Business_Impact_Cause__c>> tempBusMap {get;set;}
    public map<id, list<Root_Cause_control__c>> tempRootCauseMap{get;set;}
     
    public querycls()
    {
        querymet();
    }
    
    public void querymet()
    {
         tempBusMap= new map<id, list<Business_Impact_Cause__c>>();
         tempRootCauseMap= new map<id, list<Root_Cause_control__c>>();
        bi = [select id,name,Business_Impact_Name__c from Business_Impact__c where Potential_Risk_ID__c='a8eZ00000004D8b'];
        
        for(Business_Impact__c biite : bi)
        {
            bdff.add(biite.id);
        }

        bic=[SELECT Id, Root_Cause_ID__c,Root_Cause_ID__r.name, Business_Impact_ID__c,Business_Impact_ID__r.description__c FROM Business_Impact_Cause__c where Business_Impact_ID__c In :bdff];
       
        for(Business_Impact_Cause__c bff : bic)
        {
            
            bicdff.add(bff.Root_Cause_ID__c);
            if(tempBusMap.containsKey(bff.Business_Impact_ID__c)){
                list<Business_Impact_Cause__c> tempList = tempBusMap.get(bff.Business_Impact_ID__c);
                tempList.add(bff);
                tempBusMap.put(bff.Business_Impact_ID__c, tempList);
            }else{
                list<Business_Impact_Cause__c> tempList = new list<Business_Impact_Cause__c>();
                tempList.add(bff);
                tempBusMap.put(bff.Business_Impact_ID__c, tempList);
            }
        }
        
        for(Root_Cause_Control__c rootCause : [Select Process_Control_ID__c,Process_Control_ID__r.Name,Root_Cause_ID__c from Root_Cause_Control__c where Root_Cause_ID__c In : bicdff]){
            if(tempRootCauseMap.containsKey(rootCause.Root_Cause_ID__c)){
                list<Root_Cause_Control__c> tempList = tempRootCauseMap.get(rootCause.Root_Cause_ID__c);
                tempList.add(rootCause);
                tempRootCauseMap.put(rootCause.Root_Cause_ID__c, tempList);
            }else{
                list<Root_Cause_Control__c> tempList = new list<Root_Cause_Control__c>();
                tempList.add(rootCause);
                tempRootCauseMap.put(rootCause.Root_Cause_ID__c, tempList);
            }
        
        }
}
}