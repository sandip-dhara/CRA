/**********************************************************
* Class Name: LeadAssignmentController
* Author: Accenture
* Date: 16-JULY-2012  
* Requirement # Request Id: #1171, #1182
* Description: Custom Lead Assignment using Sales Territory 
*               and Product Speciality 
*************************************************************/
public class LeadAssignmentController {
    /* Class Properties */
    public Map<Id, Lead> leadRecords;
    public List<Lead> leads;
    public Set<Id> qualifiedLeadIds;
    public String leadId;
    public String errorMessage1 {get;set;}
    public String errorMessage2 {get;set;}
    public String successMessage1 {get;set;}
    public String successMessage2 {get;set;}
    public Boolean errorFlag {get;set;}
    public Boolean successFlag {get;set;}
    public Boolean isOwnerChanged{get;set;}
    public String ownerChageMsg{get;set;}
    public static Set<Id> leadIdSet;
    private Map<Id,Set<Id>> salesTerrUsers;
    private String OPPTYTYPE = Label.New_Business;
    private String RTM_DIRECT = Label.Direct;
    private String RTM_ALL = Label.LC_RTM_ALL;
    private String LEADOBJECT = Label.Lead;
    private String QUALIFIEDLEAD = Label.QualifiedLead;
    private String ACCEPTEDSTATE = Label.Accepted;
    private String qualifiedRT;
    private String adminQueue;
    private Map<Id, Set<String>> leadProductsKeyMap;
    private Map<Id, String> leadPrimaryCampainMap;
    private Map<Id, List<Product_Specialty_User_Assignment__c>> leadUserMap;
    public List<Lead> LeadList = new List<Lead>();
    
    /*
    * @description: Constructor of a class 
    */ 
    public LeadAssignmentController(ApexPages.StandardSetController controller) {
        /* To get slelected records for mass assignment */
        leads = (List<Lead>)controller.getSelected();
        /* To get Id for the single lead assignment */
        leadId = ApexPages.currentPage().getParameters().get('id');
        /* Initializing properties */
        salesTerrUsers = new Map<Id,Set<Id>>();
        leadUserMap = new Map<Id, List<Product_Specialty_User_Assignment__c>>();
        leadIdSet = new Set<Id>();
        leadRecords = new Map<Id, Lead>();
        leadPrimaryCampainMap = new Map<Id, String>();
        qualifiedLeadIds = new Set<Id>();
        errorFlag = false;
        successFlag = false;
        isOwnerChanged =false;
        errorMessage1 = '';
        errorMessage2 = '';
        successMessage1 = Label.Error_Message;
        successMessage2 = '';
        ownerChageMsg = '';

        if (leads  != null) {
            for (Lead lead: leads) {
                leadIdSet.add(lead.Id);
            }
        }
        if (leadId != null && leadId != '') {
            leadIdSet.add(leadId);
        }
        for (lead lead : [Select Id, Description, Name, OwnerId, Account_Name__c, Lead_State__c, campaign__r.Sub_Business_Unit__c, First_Assignment_Date__c From Lead Where Id IN: leadIdSet]) {
            /* Checking 'Lead Status' and 'Account' on lead */
            if (lead.Account_Name__c == null) {
                errorFlag = true;
                isOwnerChanged = false;
                if (errorMessage1 == '') {
                    errorMessage1 = Label.Error_Message_1+' \n';
                    errorMessage1 +=  '[Lead Name: '+lead.Name+'] \n';
                } else {
                    errorMessage1 +=  '[Lead Name: '+lead.Name+'] \n';
                }
            } else {
                leadRecords.put(lead.Id, lead);
            }
        }
        /* To store mapping of lead and primary campaign's sub-business unit. This map is used in lead assignment */
        for (CampaignMember campaignMember : [Select Id, Primary__c, LeadId, Campaign.Sub_Business_Unit__c 
                                                From CampaignMember
                                                Where Primary__c = true 
                                                And LeadId IN : leadRecords.keySet()]) {
        
            leadPrimaryCampainMap.put(campaignMember.LeadId, campaignMember.Campaign.Sub_Business_Unit__c);
        }
        /* To get record type id of the 'Qulified Lead' */
        Schema.DescribeSObjectResult describeResult = Schema.SObjectType.Lead; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = describeResult.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Qualified Lead');
        /* Storing record type id in class property */
        if (rtByName != null) {
            qualifiedRT = rtByName.getRecordTypeId();
        }
        /* To get LEAD_ASSIGN_EXCEPTION Queue Id */
        
       for(Group groupInfo : [Select Id, Name From Group Where Type = 'Queue' And Name =: Label.LEAD_ASSIGN_EXCEPTION]){
         adminQueue = groupInfo.Id;
        }
    }
    
    /**
    * @description: Identifying lead owner (Lead Assignment) and changing lead to 'Qualified Lead'
    */
    public PageReference assignLeads() {
        leads = new List<Lead>();
        /* To get users from Sales Territory and Product Specialty */
        identifyUsersWithSalesTerrAndProdSpcl();
        for (Lead lead : leadRecords.values()) {
            //R6: Req. : 8035 : First assignment date is the first time the Lead is assigned to an SR. Shouldn't change after the first assignment.
            System.debug('****************First Assignment Date: '+lead.First_Assignment_Date__c); 
            if(lead.First_Assignment_Date__c == null)
                  lead.First_Assignment_Date__c=DateTime.now();
        
            //R6 : End. 
        
            List<Product_Specialty_User_Assignment__c> commonUsers = leadUserMap.get(lead.Id);
            List<Product_Specialty_User_Assignment__c> commonBUGBUUsers = new List<Product_Specialty_User_Assignment__c>();
            String matchingUser = '';
            System.debug('>>> commonUsers '+commonUsers);
            
            String notes = '\n' + System.today() + ' ';
            if (commonUsers != null && commonUsers.size() > 0) {
                for (Product_Specialty_User_Assignment__c prdUserAsgn : commonUsers) {
                    /* If multiple users found then assigning lead owner who's primary campaigns Sub_BU is matching with Users's GBU */
                    if (prdUserAsgn.user__r.Global_Business_Unit__c == leadPrimaryCampainMap.get(lead.Id) && prdUserAsgn.user__r.Global_Business_Unit__c !=null) {
                        commonBUGBUUsers.add(prdUserAsgn);
                     }
                   }
                /* Assigning lead owner */
                  /* Author: HP       
                 * Date: 10-AUG-2012        
                 * Requirement # CR Id-1863,1789(R2.0)       
                 * @description -  Modifying User Display in Notes 
                 */ 
                if (commonBUGBUUsers.size()==1)
                {
                    lead.OwnerId = commonBUGBUUsers[0].User__c;
                    if(UserInfo.getUserId()!= commonBUGBUUsers[0].User__c)
                    isOwnerChanged = True;
                    ownerChageMsg = Label.Lead_Owner_Change;
                    for(Product_Specialty_User_Assignment__c commonUsr: commonUsers)
                    {
                    if(commonUsr.User__c != commonBUGBUUsers[0].User__c)
                    {
                        notes += '[User Email: '+commonUsr.User__r.Email+', Product Specialty: '+commonUsr.Product_Specialty__r.Name+'], \n';                    
                        System.debug('***************Notes'+Notes);
                    }
                    }
                }
                else if(commonBUGBUUsers.size()>1)
                 {
                    lead.OwnerId = commonBUGBUUsers[0].User__c;
                    if(UserInfo.getUserId()!= commonBUGBUUsers[0].User__c){
                   { isOwnerChanged = True;
                    ownerChageMsg = Label.Lead_Owner_Change;
                   }
                    }
                    //commonBUGBUUsers.remove(0);
                    for(Product_Specialty_User_Assignment__c commonBUGBU: commonUsers)
                    {  
                        if(commonBUGBU.User__c != commonBUGBUUsers[0].User__c)            
                        {
                            notes += '[User Email: '+commonBUGBU.User__r.Email+', Product Specialty: '+commonBUGBU.Product_Specialty__r.Name+'], \n'; 
                            System.debug('***************Notes'+Notes);
                        }
                    }
                    
                 }
                    else if(commonUsers.size()==1)
                    {
                    lead.OwnerId = commonUsers[0].User__c;
                    if(UserInfo.getUserId() != commonUsers[0].User__c)
                   {     
                       isOwnerChanged = True;
                        ownerChageMsg = Label.Lead_Owner_Change;
                   }
                    }
                    
                    else if(commonUsers.size()>1)
                    {
                    lead.OwnerId = commonUsers[0].User__c;
                    if(UserInfo.getUserId() != commonUsers[0].User__c)
                    {
                        isOwnerChanged = True;
                        ownerChageMsg = Label.Lead_Owner_Change;
                    }
                    commonUsers.remove(0);

                    for(Product_Specialty_User_Assignment__c CU:commonUsers)
                    {
                        notes += '[User Email: '+CU.User__r.Email+', Product Specialty: '+CU.Product_Specialty__r.Name+'], \n';
                    }
                    
                    }
                /* Assigning Qualified Record Type */
                lead.RecordTypeId = qualifiedRT;
                String oldDescription = '';
                if (lead.Description != null) {
                    oldDescription = lead.Description;
                }
                lead.Description = oldDescription + '\n' + notes;
                lead.Lead_State__c= 'New';
                leads.add(lead);
                System.debug('******lead.RecordTypeId*'+lead.RecordTypeId);
                
                successFlag = true;
                successMessage2 +=  ' [ Lead Name: '+lead.Name+'] \n';
            } else {
                /* If no common user found from product specialty and sales territory, then assigning leads to Admin Queue */
                
                lead.OwnerId = adminQueue;
                lead.RecordTypeId = qualifiedRT;
                String oldDescription = '';
                if (lead.Description != null) {
                    oldDescription = lead.Description + '\n ********************** \n'+ System.today() + '\n';
                }
                lead.Description =  oldDescription + Label.No_Common_Users ;
                lead.Lead_State__c= 'New';
                leads.add(lead);
                system.debug('>>> Assigning Queue ');
                successFlag = true;
                successMessage2 +=  ' [Lead Name: '+lead.Name+'] \n';
                isOwnerChanged = True;
                ownerChageMsg = 'Lead owner has been changed';
                System.debug('**********adminQueue****'+adminQueue);
            }
        }
        try {
            if (leads.size() > 0) {
                update leads;
              }
        }catch (DMLException dmlEx) {
            successFlag = false;
            errorFlag = true;
            isOwnerChanged = false;
            for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
            }
            CreateApexErrorLog.insertHandledExceptions(dmlEx, null, LEADOBJECT, 'LeadAssignment', 'Class');
        }
        /* @return: Lead details page for single lead and list view page for mass assignment */
        PageReference retPage = new PageReference('/00Q');
        if (errorFlag) {
            if (errorMessage1 != '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage1));
            }
            if (errorMessage2 != '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage2));
            }
            retPage = null;
        } else if (leadId != null) {
            if(isOwnerChanged && UserInfo.getUserId() !=null)
            {
            System.debug('********isOwnerChanged *********'+isOwnerChanged );
             retPage = null;
            }
            else
            retPage = new PageReference('/'+LeadId);
        }
        return retPage;
    }
    
    /**
    * @description: Validation method to check lead products before lead assignments
    */
    private void validateLeadProducts(){
        Set<String> valueSet = new Set<String>();
        for (Lead lead : leadRecords.values()) {
            valueSet = leadProductsKeyMap.get(lead.Id);
            if (valueSet == null) {
                leadProductsKeyMap.remove(lead.Id);
                leadRecords.remove(lead.Id);
                errorFlag = true;
                isOwnerChanged = false;
                if (errorMessage2 == '') {
                    errorMessage2 = Label.No_Products_Added+' \n';
                    errorMessage2 +=  '[Lead Name: '+lead.Name+'] \n';
                } else {
                    errorMessage2 +=  '[Lead Name: '+lead.Name+'] \n';
                }
            }
        }
    }
    
    public PageReference returnBack() {
        /* @return: Lead details page for single lead and list view page for mass assignment */
        PageReference retPage = new PageReference('/00Q');
        if (leadId != null) {
            retPage = new PageReference('/'+leadId);
        }
        return retPage;
    }
        
    /**
    * @description: To identify common set of users from product Speciality and sales territory
    * @return: List of common users in sales territory and product specialty
    */
    private void identifyUsersWithSalesTerrAndProdSpcl() {
        /* Initializing Collections: Maps and Sets */
        leadProductsKeyMap = new Map<Id, Set<String>>();
        Map<Id, Set<Id>> leadProductSplMap = new Map<Id, Set<Id>>();
        Set<Id> uniqueProductSet = new Set<Id>();
        Set<String> productLines = new Set<String>();
        Set<String> subProductLines = new Set<String>();
        Set<Id> uniqueProdSpcltySet = new Set<Id>();
        Set<String> psKeySet;
        /* Fetching all the product interest records */
        for (Product_Interest__c productInterest : [Select Id, Product__c, Product__r.Sub_Product_Line__c, 
                                                            Product__r.Product_Line__c, Lead__c 
                                                    From Product_Interest__c
                                                    Where Lead__c IN : leadIdSet]) {
            if (productInterest.Lead__c != null) {
                psKeySet = leadProductsKeyMap.get(productInterest.Lead__c);
                if (psKeySet == null) {
                    psKeySet = new Set<String>();                                
                } 
            }
            /* Colletion of products, product-lines and sub-product lines */
            productLines.add(productInterest.Product__r.Product_Line__c);
            subProductLines.add(productInterest.Product__r.Sub_Product_Line__c);
            uniqueProductSet.add(productInterest.Product__c);
            psKeySet.add(productInterest.Product__r.Product_Line__c);
            /* Lead => Product Interest mapping */
            leadProductsKeyMap.put(productInterest.Lead__c, psKeySet);
        }
        /* To validate lead products are available or not on lead record */
        validateLeadProducts();
        
        /* Fetching all product specialty definition using product-lines and sub-product lines */
        /* Author: HP       
         * Date: 8-AUG-2012        
         * Requirement # CR Id-0122(R2.0)       
         * @description -  Modifying Query to check Route to Market as 'All' 
         */ 
        for(Product_Specialty_Definition__c prodSpcltyDefObj : [Select Route__c, Product__r.Sub_Product_Line__c, Product__r.Product_Line__c, Product__c, 
                                                                    Product_Specialty__c, Opportunity_Type__c, Id 
                                                                From Product_Specialty_Definition__c  
                                                                Where (Route__c =: RTM_DIRECT
                                                                OR Route__c =: RTM_ALL)
                                                                AND (Opportunity_Type__c =: OPPTYTYPE 
                                                                OR Opportunity_Type__c =:Label.OpptyType_ALL)  
                                                                AND (Product__r.Sub_Product_Line__c In : subProductLines
                                                                    OR Product__r.Product_Line__c In : productLines)]) {

           System.debug('******prodSpcltyDefObj*'+prodSpcltyDefObj);
           System.debug('******leadProductsKeyMap*'+leadProductsKeyMap);
            /* To collect Lead => Product Specialty Mapping */
            for (Id leadId : leadProductsKeyMap.keySet()) {
                if (leadProductsKeyMap.get(leadId).contains(prodSpcltyDefObj.Product__r.Product_Line__c)){
                System.debug('**********In 349');
                    Set<Id> prodSpcltySet = leadProductSplMap.get(leadId);
                    if(prodSpcltySet == null){
                        prodSpcltySet = new Set<Id>();
                    }
                    prodSpcltySet.add(prodSpcltyDefObj.Product_Specialty__c);
                    leadProductSplMap.put(leadId,prodSpcltySet);
                    uniqueProdSpcltySet.addAll(prodSpcltySet);
                    System.debug('******prodSpcltySet*'+prodSpcltySet);
                    System.debug('******uniqueProdSpcltySet*'+uniqueProdSpcltySet);

                }
            }
          /* End of for-loop*/
        }
        
        /* Fetching map of Lead => Sales Territory Users */
        salesTerrUsers = OppAccntTerrUser.callFetchAccntUserLogic(leadIdSet, LEADOBJECT);
        System.debug('*********salesTerrUsers*'+salesTerrUsers);
        System.debug('*********salesTerrUsers*'+salesTerrUsers.values());
             
           /* Author: HP       
         * Date: 8-AUG-2012        
         * Requirement # CR Id-0122(R2.0)       
         * @description -  Modifying Query to check Lead Eligibility Criteria for User
         */ 
        System.debug('*************uniqueProdSpcltySet'+uniqueProdSpcltySet);
        for (Product_Specialty_User_Assignment__c prodUserAsgnObj : [Select User__c, User__r.Global_Business_Unit__c, 
                                                                        User__r.Email, Product_Specialty__c, 
                                                                        Product_Specialty__r.Name,User__r.Lead_Eligibility_Flag__c, Id 
                                                                    From Product_Specialty_User_Assignment__c 
                                                                    Where Product_Specialty__c IN : uniqueProdSpcltySet
                                                                    AND User__r.Lead_Eligibility_Flag__c = TRUE]) {
                                                                                                                                       
            for(Id leadId : leadProductSplMap.keySet()){
                if(leadProductSplMap.get(leadId).contains(prodUserAsgnObj.Product_Specialty__c)){
                    List<Product_Specialty_User_Assignment__c> prodUserAssignments = leadUserMap.get(leadId);
                    if(prodUserAssignments == null){
                        prodUserAssignments = new List<Product_Specialty_User_Assignment__c>();
                    }
                    /* Checking that user is available in Lead-SalesTerritoryUserMap or not */
                    if(null != salesTerrUsers.get(leadId) && salesTerrUsers.get(leadId).contains(prodUserAsgnObj.User__c)){
                        prodUserAssignments.add(prodUserAsgnObj);                                                                                             
                    }
                    leadUserMap.put(leadId, prodUserAssignments);
                }
            }
        }
    }
}