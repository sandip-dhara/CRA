/**********************************************************
* Class Name: RelatedOpportunityController
* Author: Accenture
* Date: 28-March-2012 
* Requirement # Request Id:
* Description: Controller class for relating opportunity withother opportunity using lookup relationship.
***********************************************************/
public with sharing class RelatedOpportunityController {
    private Opportunity stdOpportunityRecord;
    public List<RelatedOpportunityClass> RelatedOpportunityList{get;set;}
    public Boolean hasEditAccess {get;set;}
    public String retUrl {get;set;}
    
    
    /**
    * @description: Class Constructor method
    * @param: Class Controller Apex Page
    * 
    */
    public RelatedOpportunityController(ApexPages.StandardController stdController) {
        this.stdOpportunityRecord = (Opportunity)stdController.getRecord();
        this.stdOpportunityRecord.Name = ApexPages.currentPage().getParameters().get('oppName');
        retUrl = ApexPages.currentPage().getParameters().get('retURL');
        RelatedOpportunityList = new List<RelatedOpportunityClass>();
        for(Integer i=0;i<5;i++){
            RelatedOpportunityList.add(new RelatedOpportunityClass(stdOpportunityRecord.id,stdOpportunityRecord.Name ));
        }    
    }
    
    /**
     * @description used as wrapper class for storing current & related oppportunity with each other.
     * 
     * @author Accenture
     */
    public class RelatedOpportunityClass{
        public ID currentOpptyID{get;set;}
        public String currentOpptyName{get;set;}
        public Opportunity RelatedOpportunity{get;set;}
        public RelatedOpportunityClass(Id optyId,String oppName){
            this.currentOpptyID = optyId;
            this.currentOpptyName = oppName;
            this.RelatedOpportunity = new Opportunity(Related_Opportunity__c=null);
        }
    }
    
    /**
    * @description: perform database commit
    * @return: return page url, null in case of any Error
    * 
    */
    public pageReference Save(){
        List<opportunity> optyToUpdate = new List<opportunity>();
        for(RelatedOpportunityClass relOpty: RelatedOpportunityList){
            if(relOpty.RelatedOpportunity.Related_Opportunity__c!=null){
                Opportunity tmpOpty = new Opportunity(id=relOpty.RelatedOpportunity.Related_Opportunity__c);
                tmpOpty.Related_Opportunity__c = relOpty.currentOpptyID;
                optyToUpdate.add(tmpOpty);
            }
        }
        if(optyToUpdate!=null & optyToUpdate.size()>0){
            try{
                update optyToUpdate;
            }catch(DmlException dmlEx){
                CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Opportunity', 'RelatedOpportunityController', '');
                for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
                }
                return null;
            }
            catch(Exception e){
                CreateApexErrorLog.insertHandledExceptions(e, null, 'Opportunity', 'RelatedOpportunityController', '');
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                return null;
            }
        }
        //String retUrl = ApexPages.currentPage().getParameters().get('retURL');
        pageReference pr = new pageReference(retUrl);
        pr.setRedirect(true);
        return pr;
    }
    
    /**
    * @description: Checks if logged in user has edit access on current opportunity record
    * 
    */
    public void checkOptyEditAccess() {
        hasEditAccess = true;
        Id oppID = ApexPages.currentPage().getParameters().get('id');
        if (oppID != null) {
            String editAccessResult = CheckOptyAccess.checkOptyEditAccess(oppID);
            if (editAccessResult != Label.SUCCESS) {
                hasEditAccess = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.Insufficient_Privileges));
            }
        }
    }
    
    /**
    * @description: return to previous page
    * @return: return page url from retURL page paramter value
    * 
    */
    public pageReference Cancel(){
        pageReference pr = new pageReference(retUrl);
        pr.setRedirect(true);
        return pr;
    }
}