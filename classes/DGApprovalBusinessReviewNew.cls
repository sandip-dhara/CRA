/***********************************************************
Author: Mousumi Panda
Created Date: 26-APR-2013
Release: R5
Capability: Deal Governance
Description:Controller class for New/Create Opportunity Business Review 
************************************************************/

public with sharing class DGApprovalBusinessReviewNew{

 public void testclass(){
        
    }
    public DGApprovalBusinessReviewNew(){
    }
    
    /*public String id;
    public String rectypeid{get;set;}
    public Approval__c approvalObj{get;set;}
    public user activeUser {get;set;}
    public Opportunity oppty {get; set;}
    public Boolean isSolutionMix{set;get;}
    public List<SelectOption> solutionMixVals{set;get;}
    public String businessGroup;
    public String SoftwareSelected{get;set;}
    Public String SolutionMix{get;set;}
    Public String IsSoftware{get;set;}
    Public String elastructure{get;set;} 
    
    public DGApprovalBusinessReviewNew(ApexPages.StandardController controller) {
        this.id = ApexPages.currentPage().getParameters().get('id');
        If(ApexPages.currentPage().getParameters().get('RecordType') != null)
        {
        rectypeid=ApexPages.currentPage().getParameters().get('RecordType');
        }
        
        isSolutionMix=false;
        IsSoftware='N/A';
        elastructure='--None--';
       //approvalObj.Opportunity__c=Id;
        approvalObj = new Approval__c(Opportunity__c=id,RecordTypeId=rectypeid);
        approvalObj.Software__c='N/A';
        oppty = fetchOpptyStatistics();
        if(oppty.Business_Group2__c=='SW'){
            businessGroup='HP Software';
        }
        else{
            businessGroup=oppty.Business_Group2__c;
        }
        solutionMixVals=new List<SelectOption>();
        
        
        SolutionMix();
        NetValueCaluculation();
    }
    
    public void fieldReadonly(){
        String fieldSW = approvalObj.Software__c;   
    }
    
    
    
    /* NetValueCaluculation () for autopopulating the product value from line items which lineitems product line name match with custom seting to some fields 
        added by Praveen Kumar Reddy @R6    */
    /*public void NetValueCaluculation(){
        Map<String,Product_Summarization_Mapper__c> productSumMapper=Product_Summarization_Mapper__c.getAll();
        Decimal netProductVal=0;
        Decimal netSupportVal=0;
        Decimal netPackServiceVal=0;
        Decimal netProfServiceVal=0;
        Decimal netEducationVal=0;
        String netProdPls;
        String netsupportPls;
        String netPackServicePls;
        String netProfServicePls;
        String netEduPls;
        
        if(productSumMapper.size()>0){
                
            for(Product_Summarization_Mapper__c psm : productSumMapper.values()){
                
               if(psm.name !=null && psm.name !='' && psm.pl_code__c!=null &&  psm.pl_code__c!=''){
                    if(psm.name == Label.DG_NetProduct ){
                        netProdPls=psm.pl_code__c;
                    }
                    if(psm.name == Label.DG_NetSupport){
                        netsupportPls=psm.pl_code__c;
                    }
                    if(psm.name == Label.DG_NetPackagedServices){
                        netPackServicePls=psm.pl_code__c;
                    }
                    if(psm.name == Label.DG_NetProfessionalServices){
                        netProfServicePls=psm.pl_code__c;
                    }
                 
                    if(psm.name == Label.DG_NetEducation){
                        netEduPls=psm.pl_code__c;
                    }
                }
            
            }
        }
        
        for(opportunityLineItem oli : [select id,business_group__c,gbu__c,Product_Line__c,subtotal from opportunityLineItem where opportunityID = : oppty.id]){
            if(netProdPls!=null && netProdPls!=''){
                if(oli.Product_Line__c!=null && oli.Product_Line__c != ''){
                    if(netProdPls.contains(oli.Product_Line__c.substring(0,oli.Product_Line__c.indexof('-',0)).trim()))
                        netProductVal=netProductVal+oli.subtotal;
                }
            }
            if(netsupportPls!=null && netsupportPls!=''){
                if(oli.Product_Line__c!=null && oli.Product_Line__c != ''){
                    if(netsupportPls.contains(oli.Product_Line__c.substring(0,oli.Product_Line__c.indexof('-',0)).trim()))
                        netSupportVal=netSupportVal+oli.subtotal;
                }
            }
            if(netPackServicePls!=null && netPackServicePls!=''){
                if(oli.Product_Line__c!=null && oli.Product_Line__c != ''){
                    if(netPackServicePls.contains(oli.Product_Line__c.substring(0,oli.Product_Line__c.indexof('-',0)).trim()))
                        netPackServiceVal=netPackServiceVal+oli.subtotal;
                }
            }
            if(netProfServicePls!=null && netProfServicePls!=''){
                if(oli.Product_Line__c!=null && oli.Product_Line__c != ''){
                    if(netProfServicePls.contains(oli.Product_Line__c.substring(0,oli.Product_Line__c.indexof('-',0)).trim()))
                        netProfServiceVal=netProfServiceVal+oli.subtotal;
                }
            }
           
            if(netEduPls!=null && netEduPls!=''){
                if(oli.Product_Line__c!=null && oli.Product_Line__c != ''){
                    if(netEduPls.contains(oli.Product_Line__c.substring(0,oli.Product_Line__c.indexof('-',0)).trim()))
                        netEducationVal=netEducationVal+oli.subtotal;
                }
            }
            
            
            approvalObj.Net_Product__c=netProductVal;
            approvalObj.Net_Support__c=netSupportVal;
            approvalObj.Net_Packaged_Services__c=netPackServiceVal;
            approvalObj.Net_Professional_Services__c=netProfServiceVal;
            approvalObj.Net_Education__c=netEducationVal;
            
            
            
        }
        
        
    }
    /* solutionMix() is for poplating the solution mix values from approval product classification item which values match with opportunityline item GBU or PL or SUB PL*/
    
   /* public void solutionMix(){
        OBR_Solution_Mix_Mapper__c solutionMixCust;
        try{
            solutionMixCust=OBR_Solution_Mix_Mapper__c.getInstance(oppty.Business_Group2__c);
        }catch(Exception e){
            solutionMixCust=null;
            isSolutionMix=false;
        }
        if(solutionMixCust!=null){
            
            Set<String> apSolutionMixVals=new Set<String>();
            if(solutionMixCust.Solution_Mix_Level__c == Label.DG_GBU){
                Map<String,String> BGUNamesMap=new Map<String,String>();
                for(OpportunityLineItem oli: [select id,GBU__c,Business_Group__c,Product_Line__c,Sub_Product_Line__c from opportunityLineItem where opportunityID = : oppty.id and business_group__c = :businessGroup]){
                    BGUNamesMap.put(oli.GBU__c,oli.GBU__c);
                }
                for(Approval_Product_Classification_item__c apitem:[select id,Value__c,Weight__c,Solution_Mix__c from Approval_Product_Classification_Item__c  where Approval_Product_Classification__r.BG_Name__c includes (:oppty.Business_Group2__c) and Approval_Product_Classification__r.Prod_Level__c='GBU' ]){        
                    if(BGUNamesMap.containsKey(apitem.Value__c)){
                        apSolutionMixVals.add(apitem.solution_mix__c);
                    }
                    
                }
                if(apSolutionMixVals.size()>1){
                    solutionMixVals.add(new SelectOption('None','None'));
                    
                    for(String smixvals: apSolutionMixVals){
                        isSolutionMix=true;
                        solutionMixVals.add(new selectOption(smixvals,smixvals));
                        solutionMixVals.sort();
                    }
                }else{
                     for(String smixvals: apSolutionMixVals){
                        isSolutionMix=true;
                        solutionMixVals.add(new selectOption(smixvals,smixvals));
                    }
                }
            }
            else if(solutionMixCust.Solution_Mix_Level__c== Label.DG_ProductLine ){
                Map<String,String> productLineMap=new Map<String,String>();
                for(OpportunityLineItem oli: [select id,GBU__c,Business_Group__c,Product_Line__c,Sub_Product_Line__c from opportunityLineItem where opportunityID = : oppty.id and business_group__c = :businessGroup]){
                    productLineMap.put(oli.Product_Line__c,oli.Product_Line__c);
                }
                for(Approval_Product_Classification_item__c apitem:[select id,Value__c,Weight__c,Solution_Mix__c from Approval_Product_Classification_Item__c  where Approval_Product_Classification__r.BG_Name__c includes (:oppty.Business_Group2__c) and Approval_Product_Classification__r.Prod_Level__c='Product Line' ]){        
                    if(productLineMap.containsKey(apitem.Value__c)){
                        apSolutionMixVals.add(apitem.solution_mix__c);
                    }
                    
                }
                if(apSolutionMixVals.size()>1){
                    solutionMixVals.add(new SelectOption('None','None'));
                    
                    for(String smixvals: apSolutionMixVals){
                        isSolutionMix=true;
                        solutionMixVals.add(new selectOption(smixvals,smixvals));
                        solutionMixVals.sort();
                    }
                }else{
                     for(String smixvals: apSolutionMixVals){
                        isSolutionMix=true;
                        solutionMixVals.add(new selectOption(smixvals,smixvals));
                    }
                }
            }
            else if(solutionMixCust.Solution_Mix_Level__c== Label.DG_SubProductLine){
                Map<String,String> subProductLineMap=new Map<String,String>();
                for(OpportunityLineItem oli: [select id,GBU__c,Business_Group__c,Product_Line__c,Sub_Product_Line__c from opportunityLineItem where opportunityID = : oppty.id and business_group__c = :businessGroup]){
                    
                    subProductLineMap.put(oli.Sub_Product_Line__c,oli.Sub_Product_Line__c);
                }
                for(Approval_Product_Classification_item__c apitem:[select id,Value__c,Weight__c,Solution_Mix__c from Approval_Product_Classification_Item__c  where Approval_Product_Classification__r.BG_Name__c includes (:oppty.Business_Group2__c) and Approval_Product_Classification__r.Prod_Level__c='Sub Product Line' ]){        
                    if(subProductLineMap.containsKey(apitem.Value__c.trim())){
                        apSolutionMixVals.add(apitem.solution_mix__c);
                    }
                    
                }
                if(apSolutionMixVals.size()>1){
                    solutionMixVals.add(new SelectOption('None','None'));
                    
                    for(String smixvals: apSolutionMixVals){
                        isSolutionMix=true;
                        solutionMixVals.add(new selectOption(smixvals,smixvals));
                        solutionMixVals.sort();
                    }
                }else{
                     for(String smixvals: apSolutionMixVals){
                        isSolutionMix=true;
                        solutionMixVals.add(new selectOption(smixvals,smixvals));
                    }
                }
            }
        }else{
            isSolutionMix=false;
        }
    }
    Public PageReference initialize(){
        pageReference pageRef=null;
                
            approvalObj.Lead_Org__c='EG-TS';
        
               
        return pageRef;
    }
    
    Public PageReference SWSpecificSection(){
    system.debug('##@@'+approvalObj.Solution_Mix__c);
        SolutionMix = approvalObj.Solution_Mix__c;
        return null;
        }
    Public PageReference SoftwareSelection(){
    system.debug('##@@'+approvalObj.Software__c);
        IsSoftware = approvalObj.Software__c;
        return null;
        }
    Public PageReference ELAStructure(){
    system.debug('##@@'+approvalObj.ELA_Structure__c);
        elastructure = approvalObj.ELA_Structure__c;
        return null;
        }

/*Formatting the Total Opportunity value*/
   /* public Opportunity fetchOpptyStatistics() {

        Opportunity op;
        try{
            op = [Select Name, Id, SW_Premier__c, Account.Name, Opportunity_ID__c, Deal_Registration_Status__c, CloseDate, StageName, Total_First_12_Month_Value__c,  CurrencyIsoCode, Total_First_Fiscal_Yr_Value__c, Total_Margin_Amount__c,Total_Margin_Percentage__c, Amount, RecordtypeId, SAP_Feed__c,Business_Group2__c from Opportunity where id =: id];
            activeUser = [Select Name, Id, CurrencyIsoCode,Global_Business_Unit__c, DefaultCurrencyIsoCode from User where Id=: userinfo.getuserid()];
            if (activeUser.DefaultCurrencyIsoCode != op.CurrencyIsoCode){
                op = [Select Name, Id, CloseDate, StageName, ConvertCurrency(Total_First_12_Month_Value__c),  CurrencyIsoCode, ConvertCurrency(Total_First_Fiscal_Yr_Value__c), ConvertCurrency(Total_Margin_Amount__c), Total_Margin_Percentage__c, ConvertCurrency(Amount), RecordtypeId, SAP_Feed__c,Business_Group2__c from Opportunity where id =: id];

            }
        }Catch(Exception e){}
        return op;   
    }

/*custom save to making the status to open and redirect to the detail page*/
   /* public PageReference customSave(){ 
        try{
            approvalObj.status__c='Open';
            system.debug('RecordType'+rectypeid);
            approvalObj.RecordTypeId=rectypeid;
            insert approvalObj;

            PageReference pr = new PageReference('/apex/DGApprovalBusinessReviewDetail?Id='+approvalObj.id);
            pr.setRedirect(true);

            return pr;
        }catch(Exception e){
            ApexPages.addmessages(e);
            return null;
        }
    } */  

}