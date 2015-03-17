/*
Created By: Venkatesh Satyamoorthy/Abrar Mohammad/Praneeth Yalamati
Created Date: 29-Jul-2013
Release: R6
Capability: Deal Governance
Description: Class for showing information from Global Business Forum and its child regional profile as well as custom save
Revision
Version 1 –: Venkatesh S  - 29-Jul-2013 - Initial version 
*/

public class DGOpportunityExtensionController{

    public Global_Business_Forum__c oGBF{get;set;} 
    public List<Global_Business_Forum__c> listGBF;
    public string oOptyId;
    public boolean bIsaddrow;  
    public List<RegionalProfileWrapperClass> RegionalProfileWrapper;
    public List<Regional_Profile__c> listRPUI;
    public string sRPId{get;set;}
    public Opportunity oOpportunity{get;set;}

    public DGOpportunityExtensionController(ApexPages.StandardController controller) 
    {  
        oOptyId=ApexPages.currentPage().getParameters().get('id');
        oOpportunity=(Opportunity)controller.getRecord();
        listGBF = new list<Global_Business_Forum__c>([select id,name,Lead_Business_unit__c,Additional_business_unit__c,HP_Share_of_Customer_HW_Spend__c,Country_Coverage_Description__c,Country_Coverage_Standard_Element__c,Customer_Organization__c,Total_Contract_Length_In_Months__c,Details_of_any_existing_contract__c,eBusiness__c,E_Business_Description__c,E_Business_Standard_Element__c,Estimated_Contract_Start_Date__c,Exec_Sponsor_engaged_name_if_present__c,Expected_SLO_Description__c,Expected_SLO_Standard_Element__c,Factory_Custom_Integration_Services__c,Factory_Services_description__c,Factory_Services_standard_Element__c,Global_Customer_Segment__c,Global_Opportunity_Description__c,Global_Product_Offering__c,HP_Credit_received_Description__c,HP_Credit_received_Standard_Element__c,HQ_Country_per_Region__c,Lead_Region__c,Liquidated_Damages_Penalties__c,Opportunity__c,Opportunity_in_Forecast_or_Not__c,Opportunity_Presented_as__c,Other_e_g_cross__c,Penalties_Description__c,Penalties_standard_element__c,Preferred_Fulfillment_by_Region__c,Pricing_Methodology_Description__c,Pricing_Methodology_standard_Element__c,Product_Description__c,Product_Standard_Element__c,Project_Name__c,Regional_and_or_Global_Must_Win_deal__c,Solution_Offering__c,TAT_SLAs_Description__c,TAT_SLAs_Standard_Element__c,Turnaround_Times__c,Warranty_Services__c,Warranty_Services_Description__c,Warranty_Services_Standard_Element__c from Global_Business_Forum__c  where opportunity__c = :oOptyId]);

        RegionalProfileWrapper=new List<RegionalProfileWrapperClass>();
        if(listGBF.size()==0)
            oGBF = new Global_Business_Forum__c();
        else 
            oGBF = listGBF[0];
        bIsaddrow=True;
    }

    /* Custom Save method to save Global Business forum at its child record for insert and update*/
    public pagereference SaveGBF()
    {
        if(listGBF.size() == 0)
        {
            oGBF.opportunity__c = oOptyId;    
            try
            {
                Insert oGBF;
            }
            catch (DmlException dmlEx) 
            {
                ApexPages.addMessages(dmlEx);
                return null;
            }
        }
        else
        {
            oGBF.opportunity__c = oOptyId;   
            try
            {
                Update oGBF;
            }
            catch (DmlException dmlEx) 
            {
                ApexPages.addMessages(dmlEx);
                return null;
            }   
        }

        List<RegionalProfileWrapperClass> listRegionalProfileInsert= getRegionalProfileWrapper();
        List<Regional_Profile__c> listRP = new List<Regional_Profile__c>();
        for (RegionalProfileWrapperClass oRP: listRegionalProfileInsert)
        {
            oRP.oRegionalProfile.Global_Business_Forum__c = oGBF.id;
            listRP.add(oRP.oRegionalProfile);
        }
        try
        {
            insert listRP;
        }
        catch (DmlException dmlEx) 
        {
            ApexPages.addMessages(dmlEx);
            return null;
        }

        pagereference OpptyPage = new pagereference('/apex/DGOpportunityExtensionPage?id='+oOptyId);
        OpptyPage.setredirect(true);
        return OpptyPage;
    }
    
        /* Custom Save method to save Opportunity and be on the same page*/
    public pagereference SaveOpty()
    {
        try
        {
            update oOpportunity;
        }
        catch (DmlException dmlEx) 
        {
            ApexPages.addMessages(dmlEx);
            return null;
        }

        pagereference OpptyPage = new pagereference('/apex/DGOpportunityExtensionPage?id='+oOptyId);
        OpptyPage.setredirect(true);
        return OpptyPage;
    }

    /*Getter method to get the global business forum record*/
    public List<Regional_Profile__c> getRegionalPro()
    {
        if(listGBF.size() != 0){
            listRPUI = [select id,Account_revenue__c,Fulfilment_model__c,Global_Business_Forum__c,Headquarter_country__c,Number_of_countries__c,Region_Name__c from Regional_Profile__c where Global_Business_Forum__c = :listGBF[0].id];
            return listRPUI;
        }
        else
            return null;
    }

    /*Page redirection to approval request creation page upon clicking Approval Request button*/
    public pagereference ApprovalRequest(){
        Pagereference pApprovalRequest = new pagereference('/apex/DGApprovalRecordTypeUrlPage?CF00NG0000009G4CJ_lkid='+oOptyId+'&scontrolCaching=1&retURL=/'+oOptyId+'&sfdc.override=1');
        return pApprovalRequest;
    }

    /*Page redirection to edit page upon clicking Edit button*/
    public pagereference EditGBF(){
        pagereference GBUEdit = new pagereference('/apex/DGOpportunityExtensionEditPage?id='+oOptyId);
        GBUEdit.setredirect(true);
        return GBUEdit;
    }
    
    /*Page redirection to detail page upon clicking cancel button*/
    public pagereference CancelGBF(){
        pagereference GBUCancel = new pagereference('/apex/DGOpportunityExtensionPage?id='+oOptyId);
        GBUCancel.setredirect(true);
        return GBUCancel;
    }

    /*Wrapper class for showing the regional profile rows*/
    public class RegionalProfileWrapperClass
    {
        public integer index {get;set;}
        public Regional_Profile__c oRegionalProfile{get;set;}
        public RegionalProfileWrapperClass(Regional_Profile__c oRegionalProfile)
        {
            system.debug('Index****wrapper class:'+this.index);
            this.oRegionalProfile=oRegionalProfile;
        }
    }
    /*getter seter for add row*/
    public List<RegionalProfileWrapperClass> getRegionalProfileWrapper()
    {
        If(bIsaddrow == true)
        {
            Regional_Profile__c oRegionalProRow =new Regional_Profile__c();            
            RegionalProfileWrapperClass RegionalProWrapper = new RegionalProfileWrapperClass(oRegionalProRow);            
            RegionalProWrapper.index = RegionalProfileWrapper.size()+1;           
            RegionalProfileWrapper.add(RegionalProWrapper);
            bIsaddrow = false;
        }          
        return RegionalProfileWrapper;
    }
    
    /*Add row functionality*/
    public pageReference addRow()
    {
        system.debug('******addrow*******0'+bIsaddrow);
        bIsaddrow=true;

        system.debug('******addrow*******1'+bIsaddrow);
        return null;
    }
    
    /*Ability to delete row in regional profile*/
    public pagereference DeleteRow()
    {
        Regional_Profile__c oRPToDelete = new Regional_Profile__c();
        system.debug('@@##'+sRPId);
        oRPToDelete.Id = sRPId;
        delete oRPToDelete;
        return null;
    }

}