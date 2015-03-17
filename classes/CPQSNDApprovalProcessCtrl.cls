/***********************************************************
Author: Shaijan Thomas
Created Date: 18-07-2013
Release: R6
Capability: CPQ
Description:Controller class for special pricing approval creation 
************************************************************/
public with sharing class CPQSNDApprovalProcessCtrl
{
    public Approval__c objApp {get;set;}
    public boolean isSaved{get;set;}
    public boolean isSubmit{set;get;}
    public approval__c approvaldetails;
    public ID OPPID{get;set;}
    public list<CPQ_Special_Pricing_Approval_Process__c> CList{get;set;}
    public CPQSNDApprovalProcessCtrl(ApexPages.StandardController controller) 
    {
        isSaved = true;
        CList = [select Name,FieldLabel__c,Section__c,IN_OUT__c,Required__c  from  CPQ_Special_Pricing_Approval_Process__c Order by Order__c];
        List<String> sAddFields = new List<String>();
        for(CPQ_Special_Pricing_Approval_Process__c obj : CList  )
            sAddFields.add(obj.Name);
        sAddFields.add('Status__c');
        sAddFields.add('Approval_Long_Name__c');
        if(!test.isRunningTest())
            controller.addFields(sAddFields);
        this.objApp = (Approval__c)controller.getRecord();
        OPPID = objApp.Opportunity__c;
        if(objApp.status__c=='Submitted' || objApp.status__c=='Approved' || objApp.status__c=='Rejected')
        {
            isSubmit=true;
            isSaved = false;
        }
        else
            isSubmit=false;
       //objApp.Quote_Detail__c = System.Label.CPQSAPUrl+'&Mode=3&I_Quote='+objApp.Quote_Number__c+ '&I_ACC_NAME='+objApp.Account_Name__c+ '&I_OPP_ID='+objApp.Opportunity_Id__c+ '&I_OPP_NAME='+objApp.Opportunity_Name__c + '&i_rpl_status='+objApp.Opportunity__r.Account.RPL_status__c+ '&I_COUNTRY='+objApp.Opportunity__r.Country__c+'&iframe=X';  
    }  
    public PageReference SaveRecord() 
    {
        update objApp;
        isSaved = false;
        return null;
    }
    public PageReference CancelRecord() 
    {
        string GetSAPURL = '/apex/CPQSAPSelectionPage?id='+objApp.Opportunity__c+'&Mode=2&pageMode=EditQuote&I_Quote='+objApp.Quote_Number__c+ '&I_ACC_NAME='+objApp.Account_Name__c+ '&I_OPP_ID='+objApp.Opportunity_Id__c+ '&I_OPP_NAME='+objApp.Opportunity_Name__c + '&i_rpl_status='+objApp.Opportunity__r.Account.RPL_status__c+ '&I_COUNTRY='+objApp.Opportunity__r.Country__c+'&Mode=2&iframe=X';
        Delete objApp;
        PageReference Page=new PageReference(GetSAPURL);
        page.setRedirect(false);
        return page;
    }
     public PageReference EditRecord() 
    {
       isSaved = true; 
       return null;
    }
}