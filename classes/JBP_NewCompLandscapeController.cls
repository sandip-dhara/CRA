/**********************************************************
 * Class Name: JBP_NewCompLandscapeController
 * Author: HP 
 * Date: 01-April-2013 
 * Requirement #: 5373
 * Description: Controller Class for Competative Landscape VF Page
 ***********************************************************/
public class JBP_NewCompLandscapeController{
    public List<competitorClass> CompetitiveList{get;set;}
    public JBP_Competitive_Landscape__c competitiveRecord {get;set;}
    public String displayGBU{get;set;}
    public Id GBUId{get;set;}
    public List<JBP_Competitive_Landscape__c> addCompetitorList;
    public String retUrl {get;set;}
    private List<JBP_Competitive_Landscape__c> addedCompetitorList;
    private Map<Id,String> addedCompetitorMap; 
    /**
    * @description: Class Constructor method
    * @param: StandardController Apex Page
    */
    public JBP_NewCompLandscapeController(ApexPages.StandardController controller){
        retUrl = ApexPages.currentPage().getParameters().get('retURL');
        //displayGBU = ApexPages.currentPage().getParameters().get('GBU');
        GBUId = ApexPages.currentPage().getParameters().get('GBUId');
        GBU_Specialization_Plans__c subPlan = [select toLabel(GBU_Specialization__c) from GBU_Specialization_Plans__c where id=:GBUId];
        CompetitiveList= new List<competitorClass>();
        this.competitiveRecord =(JBP_Competitive_Landscape__c)controller.getRecord();
        if((competitiveRecord == null)||(competitiveRecord.GBU_Specialization_Plan__c == null)){
            competitiveRecord = new JBP_Competitive_Landscape__c ();      
            
            displayGBU = subPlan.GBU_Specialization__c;
            if(null == GBUId){    
                String retID =null;
                if(retURL!=null){
                    retID = retURL.replaceAll('/','');
                }
                competitiveRecord.GBU_Specialization_Plan__c= retID;
            }else{
                competitiveRecord.GBU_Specialization_Plan__c= GBUId;
            } 
        }
        addedCompetitorList= [Select Id, Competitor__c, Competitor__r.Name from JBP_Competitive_Landscape__c where GBU_Specialization_Plan__c=: GBUId];
        addedCompetitorMap = new Map<Id,String>();
        for(JBP_Competitive_Landscape__c compVar : addedCompetitorList)
            addedCompetitorMap.put(compVar.Competitor__c,compVar.Competitor__r.Name);
        for(Integer i=0;i<5;i++){
            CompetitiveList.add(new competitorClass(competitiveRecord.GBU_Specialization_Plan__c));
        }
    }
    /**
    * @description Check Duplicate Records & perform database commit
    * @return: return page url, null in case of any Error
    * 
    */
    public pageReference Save(){
        Set<Id> checkDuplicateCompetitor = new set<id>();
        List<JBP_Competitive_Landscape__c> cpList = new List<JBP_Competitive_Landscape__c>();
        Integer rowId=0;
        for(competitorClass cpr : CompetitiveList){
            rowId=rowId+1;
            if(cpr.competitor.Competitor__c!= null){
                if(addedCompetitorMap.containsKey(cpr.competitor.Competitor__c)){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,addedCompetitorMap.get(cpr.competitor.Competitor__c)+' ' +label.Competitor_already_exist+' ' +'at Row ' + rowId));
                    return null;
                }
                if(checkDuplicateCompetitor.contains(cpr.competitor.Competitor__c)){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Duplicate_Competitor+' ' +'at Row ' + rowId));
                    return null;
                }else{
                    checkDuplicateCompetitor.add(cpr.competitor.Competitor__c);
                }
                cpList.add(cpr.competitor);
            }
            else if(cpr.competitor.Competitor__c == null && (cpr.competitor.Current_Share_of_Business__c!= null || cpr.competitor.Current_Share_of_Business_Prcnt__c != null || cpr.competitor.Share_of_Services__c!= null || cpr.competitor.Share_of_Services_Prcnt__c!= null || cpr.competitor.Comments__c!= null)){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.JBP_Competitor+' '+'at Row ' + rowId));
                return null;
            }
        }
        if(cpList.size()>0)
        try{
            insert cpList;
        }Catch(Exception e){
            System.debug('**Exception in JBP_NewCompLandscapeController ****' + e.getTypeName() + ': ' + e.getMessage() + ' -- ' + e.getCause()+'##'+e.getStackTraceString());
        }
        pageReference pr = new pageReference(retUrl);
        pr.setRedirect(true);
        return pr;
    }
    public pageReference Cancel(){
        pageReference pr = new pageReference(retUrl);
        pr.setRedirect(true);
        return pr;
    }
    /**
    * @description used as wrapper class for storing data of each line
    */
    public class competitorClass{
        public JBP_Competitive_Landscape__c competitor{get;set;}
        public competitorClass(id JBPId){
            this.competitor= new JBP_Competitive_Landscape__c();
            this.competitor.GBU_Specialization_Plan__c= JBPId;
        }
    }
}