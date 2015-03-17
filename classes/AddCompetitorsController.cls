/**********************************************************
* Class Name: AddCompetitorsController
* Author: Accenture
* Date: 27-March-2012 
* Requirement # Request Id:
* Description: Controller class for Competitor Add page.
***********************************************************/
public class AddCompetitorsController {

    public List<CompetitorClass> competitorList {get;set;}
    public Competitors__c competitorRecord {get;set;}
    private Map<Id,String> addedCompetitorMap;
    private List<Competitors__c> addedCompetitorList;
    public Boolean hasEditAccess {get;set;}
    public Id oppID {get;set;}
    public String retUrl {get;set;}
    public Id OpptyId{set;get;}
    
    /**
    * @description: Class Constructor method
    * @param StandardController Apex Page
    * 
    */
    public AddCompetitorsController(ApexPages.StandardController stdController) {
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        competitorList = new List<CompetitorClass>();
        addedCompetitorMap = new Map<Id,String>();
        this.competitorRecord = (Competitors__c)stdController.getRecord();
        if(competitorRecord==null || competitorRecord.Opportunity__c==null){
            competitorRecord = new Competitors__c();
            oppID = ApexPages.currentPage().getParameters().get('oppId');
            if(oppID ==null){
                
                String retID ='';
                if(retURL!=null){
                    retID = retURL.replaceAll('/','');
                }
                competitorRecord.Opportunity__c = retID;
            }else{
                competitorRecord.Opportunity__c = oppID;
            }
        }
        
        addedCompetitorList = [Select Id, Name, Opportunity__c, Competitor_Account__c,Competitor_Account__r.Name, Primary__c 
                                   From Competitors__c 
                                   where Opportunity__c=:competitorRecord.Opportunity__c]; 
        OpptyId=competitorRecord.Opportunity__c;
        for(Competitors__c addedCompetitor : addedCompetitorList){
            addedCompetitorMap.put(addedCompetitor.Competitor_Account__c,addedCompetitor.Competitor_Account__r.Name);
        }
        for(Integer i=0;i<5;i++){
            competitorList.add(new CompetitorClass(competitorRecord.Opportunity__c));
        }
        
    }
    
    /**
    * @description Check Duplicate Records & perform database commit
    * @return: return page url, null in case of any Error
    * 
    */
    public pageReference save(){
        Boolean isPrimaryChecked = False;
        pageReference pr = cancel();
        List<Competitors__c> cmptList = new List<Competitors__c>();
        Set<Id> checkDuplicateCompetitor = new Set<id>();
        for(CompetitorClass cmpt : competitorList){
            if(cmpt.competitor.Competitor_Account__c != null){
                if(addedCompetitorMap.containsKey(cmpt.competitor.Competitor_Account__c)){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,addedCompetitorMap.get(cmpt.competitor.Competitor_Account__c)+ ' ' + Label.Account_Already_Exist));
                    return null;
                }
                if(cmpt.competitor.Primary__c == true){
                    isPrimaryChecked = true;
                }
                if(checkDuplicateCompetitor.contains(cmpt.competitor.Competitor_Account__c)){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Duplicate_Accounts_Found_in_the_List));
                    return null;
                }else{
                    checkDuplicateCompetitor.add(cmpt.competitor.Competitor_Account__c);
                }
                cmptList.add(cmpt.competitor);
            }
        }
        try {
            if(cmptList != null && cmptList.size() > 0){
                insert cmptList;
            }
        }
        catch(DmlException dmlEx){
            CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Competitors__c', 'AddCompetitorsController', '');
            for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
            }
            return null;
        }
        catch(Exception e){
            CreateApexErrorLog.insertHandledExceptions(e, null, 'Competitors__c', 'AddCompetitorsController', '');
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
        return pr;
    }
    
    /**
    * @description: Checks if logged in user has edit access on current opportunity record
    * 
    */
    public void checkOptyEditAccess() {
        system.debug('--->checkOptyEditAccess(), oppID : ' + oppID);
        hasEditAccess = true;
        if (oppID != null) {
            String editAccessResult = CheckOptyAccess.checkOptyEditAccess(oppID);
            if (editAccessResult != Label.SUCCESS) {
                hasEditAccess = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.Insufficient_Privileges));
            }
        }
        system.debug('--->checkOptyEditAccess(), hasEditAccess : ' + hasEditAccess);
    }
    
    /**
    * @description return to previous page
    * @return: return page url from retURL page paramter value
    * 
    */
    public pageReference cancel(){
        pageReference pr = new pageReference(retUrl);
        pr.setRedirect(true);
        return pr;
    }
    
    /**
     * @description used as wrapper class for storing data of each line
     * 
     * @author Accenture
     */
    public class CompetitorClass{
        public Competitors__c competitor{get;set;}
        public CompetitorClass(id optyId){
            this.competitor = new Competitors__c();
            this.competitor.Opportunity__c = optyId;
        }
    }
}