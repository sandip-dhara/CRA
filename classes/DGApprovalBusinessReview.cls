/***********************************************************
Author: Mousumi Panda
Created Date: 26-APR-2013
Release: R5
Capability: Deal Governance
Description:Controller class for New/Create Opportunity Business Review 
************************************************************/

public with sharing class DGApprovalBusinessReview{
    public String id;
    public String rectypeid{get;set;}
    public String AppId;
    public String OptyId;
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
    public String solMix{set;get;}
    public boolean IsELA{get;set;}
    public integer iCounter{get;set;}
    public Boolean isProfessionalExist;
    public Opportunity opp{get;set;}
    
    
    public DGApprovalBusinessReview() {
        OptyId = ApexPages.currentPage().getParameters().get('Id');
        AppId = ApexPages.currentPage().getParameters().get('AppId');
        Opp = [select Amount from Opportunity where Id =:OptyId];
        If(ApexPages.currentPage().getParameters().get('RecordType') != null)
        {
        rectypeid=ApexPages.currentPage().getParameters().get('RecordType');
        }
        iCounter = 0;
        oppty = fetchOpptyStatistics();
        
        
        if(oppty.Business_Group2__c=='SW'){
            businessGroup='HP Software';
        }
        else{
            businessGroup=oppty.Business_Group2__c;
        }
        
        If(AppId != null && AppId != '')
        {
        
            approvalObj = [SELECT Account_id__c,Account_Name__c,Is_Professional_Service_Exist__c,Account__c,AC_By_Additional_Approver__c,Additional_Language_to_include_on_Quote__c,Additional_Pursuit_BudgetUSD__c,Agreement_Name__c,Alliance_Markup__c,All_sides_in_agreement__c,Anticipated_Carve_Out_from_License__c,Approval_Comments__c,Approval_Description__c,Approval_Long_Name__c,Approval_Routing_Note__c,Approver__c,Billing_Model_TS__c,Billing_Model__c,Business_Justification__c,Case_Country_Time_Zone__c,Case_Origin__c,CA_eMail__c,CA_Name__c,Close_Date__c,Comments__c,Competitive__c,Competitors__c,Contract_Type__c,CreatedById,CreatedDate,CurrencyIsoCode,CurrencyIsoCode__c,Current_Approval_Level__c,Customer_Address__c,Customer_Contact_Name_Title__c,Customer_Contact_Name__c,Customer_Phone_No__c,Date_of_Response__c,Date_Time_bid_is_due_to_the_customer__c,Deal_Composition__c,Description_of_Price_Hold_Discount__c,Dis_on_the_Quote_Itemized__c,Education__c,ELA_Structure__c,ELA_Term_in_months__c,Email_of_BU_Contact_Responsible_for_Mult__c,Engagement_Margin__c,Future_License_Price_Hold_Discount__c,Geographic_License_Option__c,Governing_Terms__c,Gross_Margin__c,Header_or_Item_Discount__c,Id,Identifier__c,If_Other_Please_Specify_Type__c,If_yes_is_the_PM_in_the_region_ES_10pt__c,Inbound_regions_for_multi_region_deal__c,Installed_Base_SW_Relicensing__c,IsDeleted,Is_Deal_being_financed__c,Is_this_part_of_an_ES_deal__c,Language_on_Quote__c,LastActivityDate,LastModifiedById,LastModifiedDate,Lead_Org__c,Meeting_Review_Request_Date__c,Multi_Region_Deal__c,Name,Name_of_Channel_Partner__c,Name__c,Net_Education__c,Net_Hardware_0__c,Net_Packaged_Services__c,Net_Product__c,Net_Professional_Services__c,Net_PS_Net_Travel_Packaged_Services__c,Net_SaaS__c,Net_Support__c,Net_Travel_Expenses__c,Office_jet_ProSupplies_Pricing_Margin__c,Office_jet_Pro_HW_Pricing_Margin__c,Opportunity_Close_Date__c,Opportunity_Id__c,Opportunity_Name__c,Opportunity_Owner_Role__c,Opportunity_Owner__c,Opportunity_Request_Type__c,Opportunity_Start_Date__c,Opportunity_Structure__c,Opportunity_system_id__c,Opportunity_Total_Value__c,Opportunity_Type__c,Opportunity__c,Other__c,Overall_Risk_Rating__c,OwnerFullName__c,OwnerId,Owners_BG__c,Owner_Email__c,Partner_Involvement__c,Payment_Terms__c,Potential_Inter_region_250K_Revenue_Spl__c,Previous_Contract_Discounts__c,Education_Discount__c,EM_via_SWIPER__c,SaaS_Discount__c,Upfront_Support__c,Highest_Individual_Packaged_Services_Dis__c,Premier_Support__c,Previous_Contract_Gross_Value__c,Previous_Contract_Net_Value__c,Previous_Deal_Value__c,Previous_Discount_Percent__c,Pricing_Approach__c,Pricing_Margin__c,Primary_Services_Opportunity_Structure__c,Product_Discount_Pct__c,Promotion_being_used__c,Proposal_Center_Contact_Email__c,Proposal_Due_Date__c,Prosposal_Due_Date__c,Pursuit_Budget_USD__c,Quote_End_Date__c,Quote_Net_Value__c,Quote_Number__c,Quote_Proposal_Expiration_Date__c,Quote_Service_Level_s__c,Quote_Start_Date__c,Quote_Value__c,Reason_for_Carve_Out__c,RecordTypeId,Regions_Involved__c,Region_Account_Region__c,Requestor_Comments__c,Revenue_Splits__c,Risk_Rating__c,SaaS__c,SAID_of_Existing_SW_Installation__c,Sales_Stage__c,Search_Date_From__c,Search_Date_To__c,Services__c,SN_Discount__c,Software__c,Solution_Mix__c,Status__c,Submitted_Date__c,Submitter__c,Support_Duration__c,Support_Type__c,SystemModstamp,System_Pricing_Margin__c,Template_Id__c,Third_Party_Products__c,Total_Opportunity_Value__c,Upfront_Support_Pricing_Methodology__c,What_is_Being_Requested__c,X3P_Royalty_Products_with_HP_SKUs_Includ__c FROM Approval__c where id =:AppId];
            system.debug('*******************   '+ approvalObj.Solution_Mix__c);
            solutionMixVals=new List<SelectOption>();
            
            //SolutionMix();
            //if(approvalObj.solution_mix__c!=null){
                //isSolutionMix=true;   
                solMix=approvalObj.Solution_Mix__c;             
               SolutionMix();
               
              // solutionMixVals.add(new selectOption('Product','Product'));
               
            //}
        
        }
        else
        {
         approvalObj = new Approval__c(Opportunity__c=OptyId,RecordTypeId=rectypeid);
         solutionMixVals=new List<SelectOption>();
         IsSoftware='N/A';
         elastructure='--None--';
         approvalObj.Software__c='N/A';
         approvalObj.Language_on_Quote__c='Country Standard';
         approvalObj.Payment_Terms__c='Country Standard';
         /*approvalObj.Education_Discount__c=0;
         approvalObj.EM_via_SWIPER__c=0;
         approvalObj.Highest_Individual_Packaged_Services_Dis__c=0;
         approvalObj.SaaS_Discount__c=0;
         approvalObj.Upfront_Support__c=0;*/
         approvalObj.CurrencyISOCode = oppty.CurrencyISOCode;
         isSolutionMix=false;
         SolutionMix();
         NetValueCaluculation();   
        }  
           
    }
    
    public void fieldReadonly(){
        String fieldSW = approvalObj.Software__c;   
    }
    
      
    
    /* NetValueCaluculation () for auto caluculating line item  value from line items which are match with custom setting to some Net_Product__c,Net_Support__c,Net_Packaged_Services__c,Net_Professional_Services__c and Net_Education__c 
        added by Praveen Kumar Reddy @R6    */
    public void NetValueCaluculation(){
    /*
     custom setting to store the for which fields what are the line item pl codes to caluculate linte item value for BG's. 
    */
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
        /*
            it sums the line item values which pl codes match with custom setting pl code and populate to corresponding field
        */
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
                        {
                        netPackServiceVal=netPackServiceVal+oli.subtotal;
                        iCounter = iCounter + 1;
                        }
                }
            }
            if(netProfServicePls!=null && netProfServicePls!=''){
                if(oli.Product_Line__c!=null && oli.Product_Line__c != ''){
                    if(netProfServicePls.contains(oli.Product_Line__c.substring(0,oli.Product_Line__c.indexof('-',0)).trim()))
                        {
                        
                        if(Label.Is_Professional_service_Codes.contains(oli.Product_Line__c.substring(0,oli.Product_Line__c.indexof('-',0)).trim()))                        
                        approvalObj.Is_Professional_Service_Exist__c=true;
                        netProfServiceVal=netProfServiceVal+oli.subtotal;
                        iCounter = iCounter + 1;
                        }
                }
            }
           
            if(netEduPls!=null && netEduPls!=''){
                if(oli.Product_Line__c!=null && oli.Product_Line__c != ''){
                    if(netEduPls.contains(oli.Product_Line__c.substring(0,oli.Product_Line__c.indexof('-',0)).trim()))
                        {
                        netEducationVal=netEducationVal+oli.subtotal;
                        iCounter = iCounter + 1;
                        }
                }
            }
            
            
            approvalObj.Net_Product__c=netProductVal;
            approvalObj.Net_Support__c=netSupportVal;
            approvalObj.Net_Packaged_Services__c=netPackServiceVal;
            approvalObj.Net_Professional_Services__c=netProfServiceVal;
            approvalObj.Net_Education__c=netEducationVal;
            
            if(iCounter == 2 || iCounter == 3)
            {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please create a services OBR as it has Service and Education/Packaged Service');           
            }
            
            
            
        }
        
        
    }
    /* solutionMix() is for poplating the solution mix values from approval product classification item which values match with opportunityline item GBU or PL or SUB PL*/
    /*
        this method is for identifying values for solution mix. if approval opportunity linte item GBU or PL or Sub PL is in approval product classification item. if product is in approval product classification item then solution mix will contain only Product as value,if services in in approval product classification item then solution mix will contain only Services as value. if both product and service are in approval product classification item then solution mix will contain Product and Service as values.
    */
    public void solutionMix(){
        OBR_Solution_Mix_Mapper__c solutionMixCust;
        List<SelectOption> solutionMixVals1=new List<SelectOption>();
        try{
        /* custom setting contain the data related BG's which BG and which line item should match with Approval product classification item
        */
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
                /* logic for checking if particaular BG want's check products and services GBU's are in the Approval Product Classification item */
                for(Approval_Product_Classification_item__c apitem:[select id,Value__c,Weight__c,Solution_Mix__c from Approval_Product_Classification_Item__c  where Approval_Product_Classification__r.BG_Name__c includes (:oppty.Business_Group2__c) and Approval_Product_Classification__r.Prod_Level__c='GBU' ]){        
                    if(BGUNamesMap.containsKey(apitem.Value__c)){
                        apSolutionMixVals.add(apitem.solution_mix__c);
                    }
                    
                }
                if(apSolutionMixVals.size()>1){
                                      
                    for(String smixvals: apSolutionMixVals){
                        isSolutionMix=true;
                        solutionMixVals1.add(new selectOption(smixvals,smixvals));
                        solutionMixVals1.sort();
                    }
                    solutionMixVals.add(new SelectOption('Select a value','Select a value'));
                    for(SelectOption sol: solutionMixVals1){
                        solutionMixVals.add(sol);
                    }
                    
                }else if(apSolutionMixVals.size()==1){
                     for(String smixvals: apSolutionMixVals){
                        isSolutionMix=true;
                        solutionMixVals.add(new selectOption(smixvals,smixvals));
                    }
                }
                else{
                    isSolutionMix=false;
                }
                
            }
            /* logic for checking if particaular BG want's check products and services Product Line's are in the Approval Product Classification item */
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
                                        
                    for(String smixvals: apSolutionMixVals){
                        isSolutionMix=true;
                        solutionMixVals1.add(new selectOption(smixvals,smixvals));
                        solutionMixVals1.sort();
                    }
                    solutionMixVals.add(new SelectOption('Select a value','Select a value'));
                    for(SelectOption sol: solutionMixVals1){
                        solutionMixVals.add(sol);
                    }
                }else if(apSolutionMixVals.size()==1){
                     for(String smixvals: apSolutionMixVals){
                        isSolutionMix=true;
                        solutionMixVals.add(new selectOption(smixvals,smixvals));
                    }
                }
                else{
                    isSolutionMix=false;
                }
                
            }
            /* logic for checking if particaular BG want's check products and services Sub Product Line's are in the Approval Product Classification item */
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
                    
                    for(String smixvals: apSolutionMixVals){
                        isSolutionMix=true;
                        solutionMixVals1.add(new selectOption(smixvals,smixvals));
                        solutionMixVals1.sort();
                    }
                    solutionMixVals.add(new SelectOption('Select a value','Select a value'));
                    for(SelectOption sol: solutionMixVals1){
                        solutionMixVals.add(sol);
                    }
                }else if(apSolutionMixVals.size()==1){
                     for(String smixvals: apSolutionMixVals){
                        isSolutionMix=true;
                        solutionMixVals.add(new selectOption(smixvals,smixvals));
                    }
                }
                else{
                    isSolutionMix=false;
                }
                
            }
            if(SolutionMixVals.Size() > 0)
            approvalObj.Solution_Mix__c = string.valueof(SolutionMixvals[0]);
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
        solMix=approvalObj.Solution_Mix__c;
        return null;
        }
    
        Public PageReference SoftwareSelection(){
    system.debug('##@@'+approvalObj.Software__c);
    
        IsSoftware = approvalObj.Software__c;
        if(IsSoftware!= null){
         if(IsSoftware.Contains('Private Stack Perpet Lic to ES (ELA)') || IsSoftware.Contains('License + Support (ELA)'))
         IsELA = true;
         else
         IsELA = false;
        }
        return null;
        }
        
        
    
        
    Public PageReference ELAStructure(){
    system.debug('##@@'+approvalObj.ELA_Structure__c);
        elastructure = approvalObj.ELA_Structure__c;
        return null;
        }

/*Formatting the Total Opportunity value*/
    public Opportunity fetchOpptyStatistics() {
     
      Opportunity op;
        
        try{
            op = [Select Name, Id, SW_Premier__c,Account_Region__c, type,Account_Shipping_Country__c, Non_standard_Opportunity__c ,Confidential__c ,Multi_Country_Type__c ,Account.Confidential_Account__c,Account.Id,Account.Name,Owner.Name, Opportunity_ID__c, Deal_Registration_Status__c, CloseDate, StageName, Total_First_12_Month_Value__c,Proposal_Due_Date__c, CurrencyIsoCode, Total_First_Fiscal_Yr_Value__c, Total_Margin_Amount__c,Total_Margin_Percentage__c, Amount, RecordtypeId, SAP_Feed__c,Business_Group2__c,Primary_Partner__r.Name from Opportunity where id =: OptyId];
            activeUser = [Select Name, Id, CurrencyIsoCode,Global_Business_Unit__c, DefaultCurrencyIsoCode from User where Id=: userinfo.getuserid()];
            if (activeUser.DefaultCurrencyIsoCode != op.CurrencyIsoCode){
                op = [Select Name, Id, CloseDate,Account_Region__c, Account_Shipping_Country__c ,Non_standard_Opportunity__c ,Confidential__c ,Multi_Country_Type__c ,Account.Confidential_Account__c,Account.Id,Account.Name,Owner.Name,Opportunity_ID__c,StageName,type,Proposal_Due_Date__c, ConvertCurrency(Total_First_12_Month_Value__c),  CurrencyIsoCode, ConvertCurrency(Total_First_Fiscal_Yr_Value__c), ConvertCurrency(Total_Margin_Amount__c), Total_Margin_Percentage__c, ConvertCurrency(Amount), RecordtypeId, SAP_Feed__c,Business_Group2__c from Opportunity where id =: OptyId];

            }
        }Catch(Exception e){}
        return op;   
    }

/*custom save to making the status to open and redirect to the detail page*/
    public PageReference customSave(){ 
        try{
            if(approvalObj.software__c!= null){
                system.debug('*****  '+approvalObj.software__c);
                if(string.valueOf(approvalObj.software__c).contains('N/A')){
                    system.debug('***** inside if ');
                   // String software=approvalObj.software__c;
                    String software=approvalObj.software__c.remove('N/A');
                    approvalObj.software__c=software;
                }
                
            }
            
            If(AppID != null && AppID != '')
            {
             update approvalObj;
            }
            else
            {
            
            approvalObj.status__c='Open';
            system.debug('RecordType'+rectypeid);
            approvalObj.RecordTypeId=rectypeid;
            insert approvalObj;
            }            
            PageReference pr = new PageReference('/apex/DGApprovalBusinessReviewDetail?Id='+approvalObj.id);
            pr.setRedirect(true);

            return pr;
        }catch(Exception e){
            ApexPages.addmessages(e);
            return null;
        }
    }  

/*custom cancel to redirect to the detail page*/
    public PageReference Cancel(){

        If(AppID != null && AppID != '')
        {
        PageReference pr = new PageReference('/apex/DGApprovalBusinessReviewDetail?id='+AppId);
        pr.setRedirect(true);
        return pr;      
        }
        else
        {
        return new PageReference('/'+Oppty.id);
        }

    }   

}