public class JunctionRelatedOpportunitiesController {
    public List<JunctionRelatedOpportunitiesClass> realtedOpptyList{get;set;}
    private Related_Opportunities__c stdJunctionRecord;
    public JunctionRelatedOpportunitiesController(ApexPages.StandardController stdController) {
        this.stdJunctionRecord = (Related_Opportunities__c)stdController.getRecord();
        realtedOpptyList = new List<JunctionRelatedOpportunitiesClass>();
        for(Integer i=0;i<5;i++)
            realtedOpptyList.add(new JunctionRelatedOpportunitiesClass(stdJunctionRecord));
    }
    
    public pageReference Save(){
        List<Related_Opportunities__c> junctonRecordsToInsert = new List<Related_Opportunities__c>();
        for(JunctionRelatedOpportunitiesClass relOpty: realtedOpptyList){
            if(relOpty.oppty.Related_Opportunity__c!=null){
                junctonRecordsToInsert.add(relOpty.oppty);
                //now for reverse mapping
                Related_Opportunities__c reverseLinkOpty = new Related_Opportunities__c();
                reverseLinkOpty.Opportunity__c = relOpty.oppty.Related_Opportunity__c;
                reverseLinkOpty.Related_Opportunity__c = relOpty.oppty.Opportunity__c;
                junctonRecordsToInsert.add(reverseLinkOpty);
            }
        }
        if(junctonRecordsToInsert!=null & junctonRecordsToInsert.size()>0){
            try{
                insert junctonRecordsToInsert;
            }catch(DmlException dmlEx){
                for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
                }
                return null;
            }
            catch(Exception e){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                return null;
            }
        }
        String retUrl = ApexPages.currentPage().getParameters().get('retURL');
        pageReference pr = new pageReference(retUrl);
        pr.setRedirect(true);
        return pr;
    }
    public pageReference Cancel(){
        String retUrl = ApexPages.currentPage().getParameters().get('retURL');
        pageReference pr = new pageReference(retUrl);
        pr.setRedirect(true);
        return pr;
    }
    
    public class JunctionRelatedOpportunitiesClass{
        public Related_Opportunities__c oppty{get;set;}
        public JunctionRelatedOpportunitiesClass(Related_Opportunities__c oppty){
            this.oppty = oppty.clone();
        }
    }
}