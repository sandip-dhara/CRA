/***********************************************************
Author: Mousumi Panda
Created Date: 26-APR-2013
Release: R5
Capability: Deal Governance
Description:Controller class for Editing Opportunity Business Review 
*************************************************************/

public without sharing class DGApprovalBusinessReviewEdit{
 public void testclass(){
        
    }
    public DGApprovalBusinessReviewEdit(){
    
    }
    /*public String id;
    public user activeUser {get;set;}
    public Opportunity oppty {get; set;}
    public Approval__c appr;
    public ApexPages.StandardController std;
    public DGApprovalBusinessReviewEdit(ApexPages.StandardController controller) {
        this.id = ApexPages.currentPage().getParameters().get('id');
        std=controller;

        oppty = fetchOpptyStatistics();


    }*/
    /*Formatting the Total Opportunity value*/
   /* public Opportunity fetchOpptyStatistics() {
        system.debug('Oppty Id*************'+id);    
        Opportunity op;
        try{
            appr = [Select Opportunity__r.Id from Approval__c where id=:id];
            op = [Select Name, Id, SW_Premier__c, Account.Name, Opportunity_ID__c, Deal_Registration_Status__c, CloseDate, StageName, Total_First_12_Month_Value__c,  CurrencyIsoCode, Total_First_Fiscal_Yr_Value__c, Total_Margin_Amount__c,Total_Margin_Percentage__c, Amount, RecordtypeId, SAP_Feed__c from Opportunity where id =: appr.Opportunity__r.Id];
            activeUser = [Select Name, Id, CurrencyIsoCode,Global_Business_Unit__c, DefaultCurrencyIsoCode from User where Id=: userinfo.getuserid()];
            if (activeUser.DefaultCurrencyIsoCode != op.CurrencyIsoCode){
                op = [Select Name, Id, CloseDate, StageName, ConvertCurrency(Total_First_12_Month_Value__c),  CurrencyIsoCode, ConvertCurrency(Total_First_Fiscal_Yr_Value__c), ConvertCurrency(Total_Margin_Amount__c), Total_Margin_Percentage__c, ConvertCurrency(Amount), RecordtypeId, SAP_Feed__c from Opportunity where id =: appr.Opportunity__r.Id];

            }
        }Catch(Exception e){}
        return op;   
    }
    /*custom save to making the status to open and redirect to the detail page*/
    /*Public PageReference onSave()
    {
        appr.status__c='Open';
        std.save();

        PageReference pref=new PageReference('/apex/DGApprovalBusinessReviewDetail?id='+Id);
        pref.setRedirect(true);
        return pref;
    } 
    /*custom cancel to redirect to the detail page*/
    /*public PageReference customCancel(){

        std.cancel();
        PageReference pr = new PageReference('/apex/DGApprovalBusinessReviewDetail?id='+Id);
        pr.setRedirect(true);
        return pr;

    }*/ 

}