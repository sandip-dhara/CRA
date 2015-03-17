@RestResource(urlMapping='/TestSP/*')
global with sharing class RestWSTestSP{
    @HttpGet
        global static List<Topics> doGet() {
        //RestWSResult result = new RestWSResult();

        List<Learning__c> lstLearning = [Select id,Doc_Id__c From Learning__c where url__c!=null and Type__C='Upload Document' and URL__C like '%Sharepoint%'];
        List<Collateral__c> lstCollateral = [Select id,Sharepoint_Document_ID__c From Collateral__c where url__c!=null and Type__C='Upload Document' and URL__C like '%Sharepoint%'];
        List<Topics> tpcs = new List<Topics>();
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();

        
        for(Learning__c lb : lstLearning){
                 Topics tpc = new Topics();
                 tpc.id = lb.id;
                 tpc.docid = lb.Doc_Id__c;
                 tpcs.add(tpc);
            }
         for(Collateral__c col : lstCollateral){
                 Topics tpc = new Topics();
                 tpc.id = col.id;
                 tpc.docid = col.Sharepoint_Document_ID__c;
                 tpcs.add(tpc);
            }
         
        return tpcs;
    }
    
    global class Topics{
        Public String id {get;set;}
        Public String docid {get;set;}
    }
}