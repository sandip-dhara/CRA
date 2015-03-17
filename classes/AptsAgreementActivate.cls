/*
* Class Name : AptsAgreementActivate
* NOTE : This controller is used when user clicks on 'Generate Legal Issue SOAR Form' Button,
* 		 controller will shows the Legal Issue data from Legal Issue Object, Legal Issue Object have the sample data without any Agreement,
*		 If user if first time coming to this page for current agreement these sample data is shown and insert new data having this agreement's ID,
*		 and is,Second time user comes to this page Previously inserted Legal Issue data Shown.
* 		 controller also contains the logic for Number of Times HP Response edited and no. of time Legal Issue Generated.
* Author : Apttus(Axay Varu)
*/
public with sharing class AptsAgreementActivate{
    
    public String agreementId{get;set;}
    public List<Legal_Issue__c> lstLegalIssuesName{get;set;}
    public List<Legal_Issue__c> lstLegalIssuesInsert{get;set;}
    public List<Legal_Issue__c> lstLegalIssue{get;set;}
    
    public Legal_Issue__c legalIssueObject{get;set;}
    public Boolean isActive{get;set;}
    public Boolean idnull{get;set;}
    public List<LegalIssueWrapper> liw  {get;   set;}
    
    public AptsAgreementActivate(){
        legalIssueObject = new Legal_Issue__c();
        idnull = false;
        liw = new List<LegalIssueWrapper>();
        
        agreementId = Apexpages.currentpage().getparameters().get('Id');
        if(agreementId == '' || agreementId == null)
        {   
            idnull = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Sorry...Agreement ID is NULL,Press Return to go back.'));
        }
        String strIsActive = Apexpages.currentpage().getparameters().get('isActive'); // i guess this is not used anywhere
        if(strIsActive == null || strIsActive == ''){
            isActive = false;
        }
        else{
            isActive = true;
        }
        //System.debug('Agreement ID : '+agreementId);
        //Legal_Issue_Name__c,
        lstLegalIssue = [Select Id,Agreement__c,Risk_Category__c,Initial_Content__c,Paragraph__c,Sequence__c,
                        Final_Content__c,Risk_Rating__c,Additional_Legal_Dept_Reviewer__c,Legal_Recommendation__c,Number_of_times_HP_Response_Changed__c
                        From Legal_Issue__c
                        Where Agreement__c = :agreementId ORDER BY Sequence__c]; // get all legal issue with this agreement ID
        System.debug('Record Found : '+lstLegalIssue.size());
       
                      
        if(lstLegalIssue.size() > 0){
            //System.debug('Legal Issue Found with this Agreement ID : '+agreementId);
            legalIssueObject.Risk_Rating__c = lstLegalIssue[0].Risk_Rating__c;
            legalIssueObject.Legal_Recommendation__c = lstLegalIssue[0].Legal_Recommendation__c;
            legalIssueObject.Additional_Legal_Dept_Reviewer__c = lstLegalIssue[0].Additional_Legal_Dept_Reviewer__c;
            //legalIssueObject.Sequence__c = lstLegalIssue[0].Sequence__c;
        }         
    }
        
    public PageReference returnAgreement()
    {
        return new PageReference('/apex/AptsAgmtHome');
    }
    public void disableInlineEdit() //we are not using this function
    {
            return;
    }
    public void InsertLegalIssues(){
        lstLegalIssuesInsert = new List<Legal_Issue__c>();
        if(lstLegalIssue.size() > 0){
            lstLegalIssuesInsert = lstLegalIssue;
        }
        else{            
           List<Legal_Issue_Sample_Data__c> lisample = [SELECT ID,NAME,Risk_Category__c,Sequence__c FROM Legal_Issue_Sample_Data__c ORDER BY Sequence__c LIMIT 7];
           for(Legal_Issue_Sample_Data__c lisd : lisample) {
           		Legal_Issue__c newLegalIssue = new Legal_Issue__c();
           		newLegalIssue.Agreement__c = agreementId;
           		newLegalIssue.Risk_Category__c = lisd.Risk_Category__c;
           		newLegalIssue.Sequence__c = lisd.Sequence__c;
           		lstLegalIssuesInsert.add(newLegalIssue);
           }
           
           insert lstLegalIssuesInsert;
           lstLegalIssue = [Select Id,Agreement__c,Risk_Category__c ,Initial_Content__c,Paragraph__c,Sequence__c,
                                Final_Content__c,Risk_Rating__c,Additional_Legal_Dept_Reviewer__c,Legal_Recommendation__c,Number_of_times_HP_Response_Changed__c
                                From Legal_Issue__c
                                Where Agreement__c = :agreementId AND Sequence__c != null ORDER BY Sequence__c];
           //System.debug('****in Agreement ID == null ::'+lstLegalIssuesInsert.size());
         }
        for(Legal_Issue__c li : lstLegalIssue)
        {
            liw.add(new LegalIssueWrapper(li.Initial_Content__c,li.Sequence__c));
        }        
    }
    
    public PageReference SaveAndContinue(){
        
        
        Apttus__APTS_Agreement__c agmt = [SELECT ID,Number_of_times_SOAR_form_Generated__c FROM Apttus__APTS_Agreement__c WHERE ID = :agreementId];
        if(agmt.Number_of_times_SOAR_form_Generated__c == null)
        {
            
            agmt.Number_of_times_SOAR_form_Generated__c = 1;
        }
        else
        {   agmt.Number_of_times_SOAR_form_Generated__c = agmt.Number_of_times_SOAR_form_Generated__c + 1;  }
        
        update agmt;
        updateEntity();
        if(isActive){
            return new PageReference('/apex/Apttus__AgreementActivate?id='+agreementId);
        }
        else{
            return new PageReference('/apex/Apttus__SelectTemplate?id='+agreementId+'&action=Generate_Supporting_Document&templateType=Supporting_Document');
        }        
    }
    
    public PageReference Cancel(){
        if(lstLegalIssuesInsert.size() > 0 && lstLegalIssue.size() == 0){
            delete lstLegalIssuesInsert;
        }
        return new PageReference('/'+agreementId);
    }
    private void updateEntity()
    {
        Integer iter = 0;
        for(Legal_Issue__c LI : lstLegalIssuesInsert) // logic to increment count if HP Response changed
        {
                LI.Risk_Rating__c = legalIssueObject.Risk_Rating__c;
                LI.Legal_Recommendation__c = legalIssueObject.Legal_Recommendation__c;
                LI.Additional_Legal_Dept_Reviewer__c = legalIssueObject.Additional_Legal_Dept_Reviewer__c;
                //System.debug('HP Resp OLD : '+lstLegalIssuesInsert[iter].Initial_Content__c+' ** HP Res NEW : '+lstLegalIssue[iter].Initial_Content__c);
                if(lstLegalIssuesInsert[iter].Initial_Content__c != liw[iter].HPResponse)
                {
                    //System.debug('In Logic..');
                    if(lstLegalIssue[iter].Number_of_times_HP_Response_Changed__c == null)
                    {
                        lstLegalIssue[iter].Number_of_times_HP_Response_Changed__c = 0;
                    }
                    LI.Number_of_times_HP_Response_Changed__c = lstLegalIssue[iter].Number_of_times_HP_Response_Changed__c + 1;
                }
            iter++;
        }       
        update lstLegalIssuesInsert;
    }
	// Legal Issue Wrapper holds the data for Sequense and HP Response Changed logic
    public class LegalIssueWrapper
    {
        public String HPResponse    {get;   set;}
        public Decimal sequence {get;   set;}
        public LegalIssueWrapper(String HPResponse,Decimal sequence)
        {
            this.HPResponse = HPResponse;
            this.sequence = sequence;
        }
    }    
}