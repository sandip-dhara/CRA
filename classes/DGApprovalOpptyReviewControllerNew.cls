/*****************************************************
Author: Mousumi Panda
Created Date: 26-APR-2013
Release: R5
Capability: Deal Governance
Description:Controller for New/Create form for Opportunity Review 
***********************************************************/


public with sharing class DGApprovalOpptyReviewControllerNew {
    public ApexPages.StandardController std; 
    public String id;
    public List<PersuitResourceWrapperClass> PersuitResourceWrapper;
    public boolean isaddrow;
    public Approval__c approvalObj{get;set;}
    public String rectypeid{set;get;}
    public user activeUser {get;set;}
    public Opportunity oppty {get; set;}
    public Boolean isInsert;
    public DGApprovalOpptyReviewControllerNew(ApexPages.StandardController controller) {
        this.id = ApexPages.currentPage().getParameters().get('id');
        rectypeid = ApexPages.currentPage().getParameters().get('RecordType');
        PersuitResourceWrapper=new List<PersuitResourceWrapperClass>();
        approvalObj = new Approval__c(Opportunity__c=id,RecordTypeId=rectypeid); 
        isaddrow=false;
        isInsert=false;
        oppty = fetchOpptyStatistics();
    }
/*Total Opportunity Value Formatting*/
    public Opportunity fetchOpptyStatistics() {

        Opportunity op;
        try{
            op = [Select Name, Id, SW_Premier__c, Account.Name, Opportunity_ID__c, Deal_Registration_Status__c, CloseDate, StageName, Total_First_12_Month_Value__c,  CurrencyIsoCode, Total_First_Fiscal_Yr_Value__c, Total_Margin_Amount__c,Total_Margin_Percentage__c, Amount, RecordtypeId, SAP_Feed__c from Opportunity where id =: id];
            activeUser = [Select Name, Id, CurrencyIsoCode,Global_Business_Unit__c, DefaultCurrencyIsoCode from User where Id=: userinfo.getuserid()];
            if (activeUser.DefaultCurrencyIsoCode != op.CurrencyIsoCode){
                op = [Select Name, Id, CloseDate, StageName, ConvertCurrency(Total_First_12_Month_Value__c),  CurrencyIsoCode, ConvertCurrency(Total_First_Fiscal_Yr_Value__c), ConvertCurrency(Total_Margin_Amount__c), Total_Margin_Percentage__c, ConvertCurrency(Amount), RecordtypeId, SAP_Feed__c from Opportunity where id =: id];

            }
        }Catch(Exception e){}
        return op;   
    }


/*getter seter for add row*/
    public List<PersuitResourceWrapperClass> getPersuitResourceWrapper(){
        If(isaddrow == true){
            system.debug('******addrow2*******'+isaddrow);
            Opportunity_Pursuit_Resource_Requirement__c prAddRow=new Opportunity_Pursuit_Resource_Requirement__c();
            system.debug('******addrow3*******'+isaddrow);
            PersuitResourceWrapperClass persuitresWrapper = new PersuitResourceWrapperClass(prAddRow);
            system.debug('******addrow4*******'+isaddrow);
            persuitresWrapper.index = PersuitResourceWrapper.size()+1;
            system.debug('******index *******'+PersuitResourceWrapper.size());
            PersuitResourceWrapper.add(persuitresWrapper);
            system.debug('******PersuitResourceWrapper*******'+PersuitResourceWrapper);
            isaddrow = false;
        }
        return PersuitResourceWrapper;
    }
    /*Add row functionality*/
    public pageReference addRow(){
        system.debug('******addrow*******0'+isaddrow);
        isaddrow=true;

        system.debug('******addrow*******1'+isaddrow);
        return null;
    }
    /* Custom save for adding the Pursuit Resource to the save*/ 
    public PageReference customSave(){ 
        Savepoint sp = Database.setSavepoint();
        try{
            approvalObj.status__c='Open';
            approvalObj.RecordTypeId = rectypeid;
            approvalObj.Opportunity__c=id;
            approvalObj.currencyisocode=oppty.currencyisocode;
            if(isInsert!=true)
            insert approvalObj;
          }catch(Exception e){
              ApexPages.addmessages(e);
            return null;
          }
        try{
        system.debug('ap*****  '+approvalObj.id);
        
        List<Opportunity_Pursuit_Resource_Requirement__c> opprrToInsertList=new List<Opportunity_Pursuit_Resource_Requirement__c >();
        for (PersuitResourceWrapperClass ppwc: PersuitResourceWrapper) {
            ppwc.opursuitresourcesObj.Approval__c= approvalObj.Id;
            opprrToInsertList.add(ppwc.opursuitresourcesObj);
        }
        system.debug('List*********  '+opprrToInsertList.size());
        insert opprrToInsertList;
        PageReference pr = new PageReference('/apex/DGApprovalOpportunityReviewDetail?id='+approvalObj.Id);
        pr.setRedirect(true); 
        return pr;
        }
        catch(Exception e){
          //Database.rollback( sp );
          isInsert=true;
          string msg=e.getMessage();
          system.debug('msg***************'+msg);
          ApexPages.addmessages(e);
        return null;
        }
       
    }  
    /*Delete row from pursuit resource rows.*/
    public pagereference removeOffRow(){

        Integer deleteIndex = Integer.valueof(ApexPages.currentPage().getParameters().get('delrowindex')) - 1;
        system.debug('CurrentIndex******before delete Removing row'+deleteIndex);



        PersuitResourceWrapper.remove(deleteIndex);
        for(integer i = deleteIndex; i<PersuitResourceWrapper.size(); i++)
        {
            PersuitResourceWrapper[i].index--;
        }

        System.debug('Delete******Index***AfterRemoving row'+deleteIndex);
        return null; 
    }  
/*Wrapper class for adding and deleting row on fly without committing to the database.*/
    public class PersuitResourceWrapperClass
    {

        public integer index {get;set;}
        public Opportunity_Pursuit_Resource_Requirement__c opursuitresourcesObj{get;set;}
        public PersuitResourceWrapperClass(Opportunity_Pursuit_Resource_Requirement__c opursuitresourcesObj){
            system.debug('Index****wrapper class:'+this.index);
            this.opursuitresourcesObj=opursuitresourcesObj;
        }
    }



}