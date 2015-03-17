/**********************************************************
* Class Name: AddSalesLinkageController
* Author: Accenture
* Date: 26-March-2012 
* Requirement # Request Id:
* Description: Controller class for Sales process linkage Add page
***********************************************************/
public class AddSalesLinkageController{
    private Sales_Process_Linkage__c stdExternalIDRecord;
    public List<ExternalIDsClass> externalIDsList{get;set;}
    public Boolean hasEditAccess {get;set;}
    public Id oppID {get;set;}
    public String retUrl {get;set;}
    
    /**
    * @description: Class Constructor method
    * @param: Class Controller Apex Page
    * 
    */ 
    public AddSalesLinkageController(ApexPages.StandardController stdController) {
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        this.stdExternalIDRecord = (Sales_Process_Linkage__c)stdController.getRecord();
        if(stdExternalIDRecord==null || stdExternalIDRecord.Opportunity__c==null){
            stdExternalIDRecord = new Sales_Process_Linkage__c();
            oppID = ApexPages.currentPage().getParameters().get('oppId');
            if(oppID ==null){
                
                String retID ='';
                if(retURL!=null){
                    retID = retURL.replaceAll('/','');
                }
                stdExternalIDRecord.Opportunity__c = retID;
            }else{
                stdExternalIDRecord.Opportunity__c = oppID;
            }
        }
        externalIDsList = new List<ExternalIDsClass>();
        for(Integer i=0;i<5;i++){
            externalIDsList.add(new ExternalIDsClass(stdExternalIDRecord.Opportunity__c));
        }
    }
    
    /**
    * @description: Checks if logged in user has edit access on current opportunity record
    * 
    */
    public void checkOptyEditAccess() {
        hasEditAccess = true;
        if (oppID != null) {
            String editAccessResult = CheckOptyAccess.checkOptyEditAccess(oppID);
            if (editAccessResult != Label.SUCCESS) {
                hasEditAccess = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.Insufficient_Privileges));
            }
        }
    }
    
    /**
    * @description: Add New Table Row in table
    * 
    * 
    */
    public void AddNewRow(){
        externalIDsList.add(new ExternalIDsClass(stdExternalIDRecord.Opportunity__c));
    }
    
    /**
    * @description: Check Duplicate Records & perform database commit
    * @return: return page url, null in case of any Error
    * 
    */
    public pageReference Save(){
        List<Sales_Process_Linkage__c> toInsertExIdList = new List<Sales_Process_Linkage__c>();
        for(ExternalIDsClass exId : externalIDsList){
            system.debug('*********************exId.externalID.ID__c : ' + exId.externalID.ID__c);
            if(exId.externalID.ID_Type__c==null && (exId.externalID.ID__c != '' && exId.externalID.ID__c != null)){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_ID_Type_None));
                return null;
            }else{
                if(exId.externalID.ID_Type__c!=null){
                    toInsertExIdList.add(exId.externalID);
                }
            }
        }
        if(toInsertExIdList!=null || toInsertExIdList.size()>0){
            try{
                insert toInsertExIdList;
            }catch(DmlException dmlEx){
                CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Sales_Process_Linkage__c', 'AddSalesLinkageController', '');
                for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                    if(dmlEx.getDmlMessage(i).contains('duplicate value found')){
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.salesLinkage_Duplicate_Value_Found));
                    }else{
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
                    }
                }
                return null;
            }
            catch(Exception e){
                CreateApexErrorLog.insertHandledExceptions(e, null, 'Sales_Process_Linkage__c', 'AddSalesLinkageController', '');
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
    * @description: return to previous page
    * @return: return page url from retURL page paramter value
    * 
    */
    public pageReference Cancel(){
        pageReference pr = new pageReference(retUrl);
        pr.setRedirect(true);
        return pr;
    }
    
    /**
     * @description used as wrapper class for storing data of each line
     * 
     * @author Accenture
     */
    public class ExternalIDsClass{
        public Sales_Process_Linkage__c externalID{get;set;}
        public ExternalIDsClass(id optyId){
            this.externalID = new Sales_Process_Linkage__c();
            this.externalID.Opportunity__c = optyId;
        }
    }
}