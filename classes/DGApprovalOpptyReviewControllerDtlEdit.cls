/*********************************************************
Author: Mousumi Panda
Created Date: 26-APR-2013
Release: R5
Capability: Deal Governance
Description:Controller for Detail page and Edit for Opportunity Review 
***********************************************************/

public with sharing class DGApprovalOpptyReviewControllerDtlEdit{

    public user activeUser {get;set;}
    public Opportunity oppty {get; set;}
    public Approval__c appr;
    public ApexPages.StandardController std; 
    public String id;
    public List<PersuitResourceWrapperClass> PersuitResourceWrapper;
    public boolean isaddrow;
    public List<Opportunity_Pursuit_Resource_Requirement__c> TobeDeletedItem;
    public Approval__c apprv;
    

    public DGApprovalOpptyReviewControllerDtlEdit(ApexPages.StandardController controller) { 
        std = controller;
        this.apprv=(Approval__c)std.getRecord();
        this.id = ApexPages.currentPage().getParameters().get('id');
         //apprv=ApexPages.currentPage().getParameters().get('Appid');
         
        TobeDeletedItem =new List<Opportunity_Pursuit_Resource_Requirement__c>();
        oppty = opportunityInfo();
    }
    /*Formatting for the Total Opportunity value in the detail page*/
    public Opportunity opportunityInfo() {
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


    /* code for displaying the list of Attachments 
    public List<Attachment> getAttachments(){
        AttachList = [Select Description, Id, Name, CreatedDate, CreatedById from Attachment where ParentId = :Id ORDER BY CreatedDate DESC];
        return AttachList;
    }*/
/*getter setter for pursuit resource rows in edit page*/
    public List<PersuitResourceWrapperClass> getPersuitResourceWrapper(){

        system.debug('PersuitResourceWrapper***********'+PersuitResourceWrapper);
        If(PersuitResourceWrapper== null){
            List<Opportunity_Pursuit_Resource_Requirement__c > PursuitResource= [Select  Pursuit_Team_Name_Role__c,Region_subregion_Country__c,Estimated_Start_Date__c,Estimated_End_Date__c,Requested_Hours__c From Opportunity_Pursuit_Resource_Requirement__c WHERE Approval__c = :Id];
            PersuitResourceWrapper= new List<PersuitResourceWrapperClass>();
            if(PursuitResource!= null){
                for(Opportunity_Pursuit_Resource_Requirement__c pr: PursuitResource){
                    PersuitResourceWrapperClass persuitresWrapper = new PersuitResourceWrapperClass(pr);
                    persuitresWrapper.index = PersuitResourceWrapper.size()+1;
                    PersuitResourceWrapper.add(persuitresWrapper);
                }
            }



        }
        /*add row in getter setter*/
        If(isaddrow == true){
            Opportunity_Pursuit_Resource_Requirement__c OPRR = new Opportunity_Pursuit_Resource_Requirement__c();
            OPRR.Approval__c=id;
            system.debug('Current Index when u ckick add row  u add one row*****'+PersuitResourceWrapper.size());

            PersuitResourceWrapperClass persuitresWrapper = new PersuitResourceWrapperClass(OPRR);
            persuitresWrapper.index = PersuitResourceWrapper.size()+1;
            PersuitResourceWrapper.add(persuitresWrapper);
            isaddrow=false;
        }



        return PersuitResourceWrapper;
    }
/*If records are commited to the database,delete will delete record from database*/
    public void deleteFromDb(Integer deleteIndex){
        PersuitResourceWrapperClass pprwc = PersuitResourceWrapper[deleteIndex];
        system.debug('************deleteindex::::'+deleteIndex);
        system.debug('************PersuitResourceWrapper[deleteIndex]::::'+PersuitResourceWrapper[deleteIndex]);
        system.debug('************pprwc ::::'+pprwc);
        If(pprwc.opursuitresourcesObj.Id != null){

            Opportunity_Pursuit_Resource_Requirement__c objpersuitres = pprwc.opursuitresourcesObj;
            delete objpersuitres;
            TobeDeletedItem.add(objpersuitres);
        }
    }
    /*setting the isaddrow to true when you click on addrow button*/
    public void addRow(){
        isaddrow=true;

    }
    /*Custom save to save the data form wrapper class obj target object*/
    public PageReference customSave(){ 
        try{


            List<PersuitResourceWrapperClass> PursuitResourceWrapperlist = getPersuitResourceWrapper();     
            List<Opportunity_Pursuit_Resource_Requirement__c> listUpdate = new List<Opportunity_Pursuit_Resource_Requirement__c>();
            List<Opportunity_Pursuit_Resource_Requirement__c> listInsert = new List<Opportunity_Pursuit_Resource_Requirement__c>();
            for(PersuitResourceWrapperClass prwl : PursuitResourceWrapperlist){
                If(prwl.opursuitresourcesObj.Id != null){
                    Opportunity_Pursuit_Resource_Requirement__c objpursuitresorce = prwl.opursuitresourcesObj;
                    listUpdate.add(objpursuitresorce);
                }
                else{
                    If(prwl.opursuitresourcesObj.Pursuit_Team_Name_Role__c!=null|| prwl.opursuitresourcesObj.Region_subregion_Country__c!=null || prwl.opursuitresourcesObj.Estimated_Start_Date__c!=null || prwl.opursuitresourcesObj.Estimated_End_Date__c!=null || prwl.opursuitresourcesObj.Requested_Hours__c!=null ){
                        Opportunity_Pursuit_Resource_Requirement__c objpursuitresorce = prwl.opursuitresourcesObj;
                        listInsert.add(objpursuitresorce);
                    }
                }

            }
            upsert apprv;
            if(!listUpdate.isEmpty())
                update listUpdate;
            if(!listInsert.isEmpty())
                insert listInsert;


            PageReference pr = new PageReference('/apex/DGApprovalOpportunityReviewDetail?id='+Id);
            pr.setRedirect(true);
            system.debug('Id!!!!!!!!!!!!!!!'+Id);
            return pr;
        }catch(Exception e){
            ApexPages.addmessages(e);
            return null;
        }
    }
    /*custom cancel to return to the detail page*/ 
    public PageReference customCancel(){

        std.cancel();
        PageReference pr = new PageReference('/apex/DGApprovalOpportunityReviewDetail?id='+Id);
        pr.setRedirect(true);
        return pr;

    }
    /*Custom edit for editing the opproval detail*/
    public PageReference customEditOR(){ 
        try{
            PageReference pr = new PageReference('/apex/DGApprovalOpportunityReviewEdit?id='+id);
            pr.setRedirect(true);
            system.debug('Id!!!!!!!!!!!!!!!'+Id);
            return pr;
        }catch(Exception e){
            ApexPages.addmessages(e);
            return null;
        }
    }

 


/*Remove row from the UI on clicking of delete link*/

    public pagereference removeOffRow(){

        Integer deleteIndex = Integer.valueof(ApexPages.currentPage().getParameters().get('delrowindex')) - 1;
        system.debug('CurrentIndex******before delete Removing row'+deleteIndex);

        deleteFromDb(deleteIndex);

        PersuitResourceWrapper.remove(deleteIndex);
        for(integer i = deleteIndex; i<PersuitResourceWrapper.size(); i++)
        {
            PersuitResourceWrapper[i].index--;
        }

        System.debug('Delete******Index***AfterRemoving row'+deleteIndex);
        return null; 
    }
    /*wrapper class for pursuit resource data*/
    public class PersuitResourceWrapperClass
    {

        public integer index {get;set;}
        public Opportunity_Pursuit_Resource_Requirement__c opursuitresourcesObj{get;set;}
        public PersuitResourceWrapperClass(Opportunity_Pursuit_Resource_Requirement__c opursuitresourcesObj){
            system.debug('Index****wrapper class:'+this.index);
            this.opursuitresourcesObj=opursuitresourcesObj;
        }
    }

   public Class AttachWrapper{
        public Boolean isChecked{set;get;}
        public String checkedOutBy{set;get;}
        public Decimal versionNumber{set;get;}
        public Attachment at{set;get;}
        public AttachWrapper(Attachment att,Boolean checked,String checkedout,Decimal version){
            this.at=att;
            this.isChecked=checked;
            this.checkedOutBy=checkedout;
            this.versionNumber=version;
            
        
        }
        
    }


}