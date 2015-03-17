/**
* Class Name: SUPPORTRequest_PPS_Form_Controller
* Author: HP - Shaijan
* Date: 07-Nov-2012 
* Description: Contains CPQ PPS functionality and used for SUPPORTRequest_PPS_Form,PPSViewRequestForm ,CPQPPSEmailForm  pages
*/

public class SUPPORTRequest_PPS_Form_Controller {
    
    public Boolean technicalSection{get;set;}
    public Boolean geoSection{get;set;}
    public Boolean customerSection{get;set;}
    public Boolean outputSection{get;set;}
    public Boolean otherSection{get;set;}
    public Boolean specialPriceSection{get;set;}
    public Boolean attachments{get;set;}
    
    public Boolean showShipToAddress{get;set;}
    public Boolean showQuoteAddress{get;set;}
    public Boolean showInvoiceToAddress{get;set;}
    public Boolean showOutputSection{get;set;}
    public Boolean showSpecialPricing{get;set;}
    public Blob objAttachement{get;set;}
    public Boolean showSpecialRevisionFields{get;set;}
    public Boolean SPDeal{get;set;}
    public Boolean restrictIndirectAlert {get;set;}
    public Boolean showRevisionButton{get;set;}
    public Boolean showRevisionForm{get;set;}
    public Boolean showReadOnlyRevisionForm{get;set;}
    public Boolean showSpecialSection{get;set;}
    public Boolean showPricingEscalationSection{get;set;}
    public double totalSize{get;set;}
    public String totalAttachmentSize{get;set;}
    public String routingEmailAddress{get;set;}
    public String selectedTerritory{get;set;}
    
    public List<SelectOption> otherCriteria { get;set; }
    public List<SelectOption> territory { get;set; }
    public List<SelectOption> countryList { get;set; }    
    public List<SupportRequest_Routing_Rules__c> srRulesList;
    
    public Boolean showSpecialRequired{get;set;}
    public Boolean showRevisionSpecialSection{get;set;}
    public Support_Request__c objSupportRequest{get;set;}
    public Map<String,SupportRequest_Routing_Rules__c> mapNodeAndRoutingRule{get;set;}
    string pageMode = '';
    string parentRequestId = '';
    private lIST<PPS_Field_And_Type_Mapping__c> ListPPSAllFieldsMappings;
    public Map<String,List<PPS_Field_And_Type_Mapping__c>> mapPPSFormWithFieldAPI{get;set;}
    public Map<String,World_Region__c> mapCountryWithWorldRegion{get;set;}
    public opportunity objOppty{get;set;}
    public User objUser;
    public List<Attachment> showAllAttachment{
        get { return getshowAllAttachmentget(); }
    }
    public Boolean showPricingEscalationReadOnly{get;set;}
    public Boolean byPassValidations;
    
    public SUPPORTRequest_PPS_Form_Controller(ApexPages.StandardController controller) {
        ListPPSAllFieldsMappings = new lIST<PPS_Field_And_Type_Mapping__c>();
        showRevisionButton = false;
        showRevisionForm = false;
        showReadOnlyRevisionForm = false;
        showRevisionSpecialSection = false;
        showSpecialPricing = false;
        showSpecialRequired = false;
        restrictIndirectAlert = true;
        showPricingEscalationReadOnly = false;
        SPDeal = false;
        byPassValidations = false;
        this.objSupportRequest = (Support_Request__c )controller.getRecord();
        objUser = [select Business_Group__c,Country,Region__c from user where id=:userinfo.getuserid()];
        objOppty = [select id,Route_To_Market__c,StageName,Managed_By__c,Business_Group2__c,CurrencyIsoCode,Name,Account.Name,Account.MDCP_Organization_ID__c,Account.ShippingStreet,Account.ShippingCity,Account.ShippingState,Account.ShippingCountry,Account.ShippingPostalCode from Opportunity where id=:objSupportRequest.Opportunity__c ];
        pageMode = Apexpages.currentPage().getParameters().get('pageMode');
        parentRequestId = Apexpages.currentPage().getParameters().get('parentRequest');
        if(pageMode == 'Revision'){
            objSupportRequest.Type_of_Request__c = 'Revision';
            showRevisionForm = true;
            byPassValidations = true;
        }
        if(pageMode == 'View')
            showReadOnlyRevisionForm = true;
        if(pageMode == 'SpecialRevision'){
            showRevisionSpecialSection = true;
            showRevisionForm = true;
            objSupportRequest.Special_Pricing__c = 'New';
            objSupportRequest.Type_of_Request__c = 'Revision';
            showSpecialRevisionFields = true;
            byPassValidations = true;
        }
        if(pageMode == 'PricingRevision'){
            objSupportRequest.Type_of_Request__c = 'New';
            objSupportRequest.CPQ_Request_Type__c= 'Pricing Escalation';
            showPricingEscalationReadOnly = true;
        }
        if(pageMode == 'ViewFromList'){
            showRevisionButton = true;
            countryPopulate();
            routingCriteria(); 
       }
        if(pageMode != 'View' && pageMode != 'ViewFromList' && pageMode != 'Revision' && pageMode != 'SpecialRevision' && pageMode != 'PricingRevision'){
           // objSupportRequest.CPQ_Notification_Status__c = '';
            objSupportRequest.Type_of_Request__c = 'New';
            objSupportRequest.Route_To_Market_RTM__c = objOppty.Route_To_Market__c;
            objSupportRequest.Address_1__c = objOppty.Account.ShippingStreet;
            objSupportRequest.State_Province__c = objOppty.Account.ShippingState;
            objSupportRequest.City__c = objOppty.Account.ShippingCity;
            objSupportRequest.Country__c = objOppty.Account.ShippingCountry;
            objSupportRequest.Address_Postal__c = objOppty.Account.ShippingPostalCode;
            objSupportRequest.CurrencyIsoCode = objOppty.CurrencyIsoCode;
            objSupportRequest.Lead_Country__c = objOppty.Account.ShippingCountry;
            objSupportRequest.Owner_BG__c = objOppty.Business_Group2__c;
            objSupportRequest.Owner_BG__c = objUser.Business_Group__c;
            objSupportRequest.Sales_Stage_For_Request_Form__c = objOppty.StageName;
            objSupportRequest.Config_ID_Products_Customer_SKU__c = System.Label.Config_ID_Products_Customer_SKU_Label;
            objSupportRequest.Quote_Language__c= 'English';
            If(objUser.Region__c == 'AMS')
                objSupportRequest.Routing_Region__c = 'Americas';
            else if(objUser.Region__c == 'APJ')
                objSupportRequest.Routing_Region__c = 'Asia Pacific';
            else
                objSupportRequest.Routing_Region__c = objUser.Region__c;
            /*if(!SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',System.Label.CPQ_Restrict_PrePopulate_Routing_Country).contains(objUser.Business_Group__c+':'+objUser.Region__c))
                objSupportRequest.CPQ_Routing_Country__c = objUser.Country;*/
            //populateRegionAndSubRegion(objOppty.Account.ShippingCountry);
            routingCriteria();
            countryPopulate();
        }
        if(Apexpages.currentPage().getParameters().get('savedRequest')!= '' && Apexpages.currentPage().getParameters().get('savedRequest') != null){
            objSupportRequest.Route_To_Market_RTM__c = objOppty.Route_To_Market__c;
        }
        ListPPSAllFieldsMappings = [select Name,Field_Label_Name__c,B2B_Portal_Quote_Products_Configuration__c,Escalation__c ,B2B_Portal_Set_Up_new__c,B2B_Portal_Update_Products_Configuratio__c,Manual_Quote__c,  Field_API_Name__c,Form_Section_Name__c,Order__c, Special_Pricing_only_New_OPG__c,Required__c,Special_Pricing_Required__c,B2B_Portal_Quote_Required__c,Manual_Quote_Required__c,Pricing_Escalation_Required__c,Update_Offering_Required__c  from PPS_Field_And_Type_Mapping__c order by Order__c];

        if(objSupportRequest.Special_Pricing__c == 'Revision' || objSupportRequest.Special_Pricing__c == 'Special Pricing Exists'){
            SPDeal = true;
        }
        
        visibilityOfFields();
        if(Apexpages.currentPage().getParameters().get('email') == 'Y')
            sectionVisibility();
    }
    
    public void routingCriteria(){
        otherCriteria = new List<SelectOption>();
        territory = new List<SelectOption>();
        Set<String> criteriaSet = new Set<String>(); 
        Set<String> territorySet = new Set<String>();
        criteriaSet.add('');
        territorySet.add('');
        territory.add(new SelectOption('' ,'--None--'));
        otherCriteria.add(new SelectOption('' ,'--None--'));
        for(SupportRequest_Routing_Rules__c rules : [select id,Territory__c,Other_Criteria__c from SupportRequest_Routing_Rules__c where (Support__c ='Quote-to-Order' AND Support_Sub_Type__c='Config / Price / Quote' AND BUSINESS_GROUP__C=: objUser.BUSINESS_GROUP__C And Region__c =: objSupportRequest.Routing_Region__c) And ((Account__c =: objOppty.Account.Name OR Account__c ='') AND ((Country__c =: objSupportRequest.CPQ_Routing_Country__c OR Country__c = '') AND (Global_Business_Unit__c =: objSupportRequest.Business_Unit__c OR Global_Business_Unit__c = '') AND (Managed_By__c =: objSupportRequest.Managed_By__c OR Managed_By__c = '')) AND (CPQ_Route__c =: objSupportRequest.Route_To_Market_RTM__c OR CPQ_Route__c = '') AND (Request_For__c =: objSupportRequest.CPQ_Request_Type__c OR Request_For__c = '')) order by BUSINESS_GROUP__C NULLS Last,Global_Business_Unit__c NULLS Last,CPQ_Route__c NULLS Last,Managed_By__c NULLS Last,Account__c NULLS Last,Country__c NULLS Last,Territory__c NULLS Last,Other_Criteria__c NULLS Last]){
            if(rules.Territory__c <> NULL && (!territorySet.contains(rules.Territory__c))){
                territorySet.add(rules.Territory__c);
                territory.add(new SelectOption(rules.Territory__c,rules.Territory__c));
            }
            if(rules.Other_Criteria__c <> NULL && (!criteriaSet.contains(rules.Other_Criteria__c))){
                criteriaSet.add(rules.Other_Criteria__c);
                otherCriteria.add(new SelectOption(rules.Other_Criteria__c,rules.Other_Criteria__c));
            }
        }
    }
    
    public void countryPopulate(){
        countryList = new List<SelectOption>();
        countryList.add(new SelectOption('' ,'--None--'));
        for(AggregateResult countries: [select Country__c from SupportRequest_Routing_Rules__c where Support__c ='Quote-to-Order' AND Support_Sub_Type__c='Config / Price / Quote' AND BUSINESS_GROUP__C=: objUser.BUSINESS_GROUP__C And Region__c =: objSupportRequest.Routing_Region__c AND Country__c != Null Group By Country__c]){
            if(string.valueof(countries.get('Country__c')) == objUser.Country && !SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',System.Label.CPQ_Restrict_PrePopulate_Routing_Country).contains(objUser.Business_Group__c+':'+objUser.Region__c) && pageMode != 'View' && pageMode != 'ViewFromList' && pageMode != 'Revision' && pageMode != 'SpecialRevision' && pageMode != 'PricingRevision')
                objSupportRequest.CPQ_Routing_Country__c = objUser.Country;
            countryList.add(new SelectOption(string.valueof(countries.get('Country__c')),string.valueof(countries.get('Country__c'))));
        }
        countryList.sort();
    }
    
    public List<Attachment> getshowAllAttachmentget(){
        List<Attachment> listAttachments = [select id,Name,LastModifiedDate,CreatedBy.Name,ContentType,BodyLength from Attachment where ParentId =:objSupportRequest.Id ];
        totalSize = 0;
        if(!listAttachments.isEmpty()){
            for(Attachment objAttachement : listAttachments){
                totalSize += objAttachement.BodyLength;
            }
        }
        if(totalSize < decimal.valueOf(Label.CPQAttachmentSize)){
            totalAttachmentSize = 'Total size of attachments are '+Decimal.valueof(totalSize/(1024*1024)).setscale(2)+' MB. ';
        }
        else{
            
            totalAttachmentSize = Label.CPQAttachmentHelpText.replace('CPQ_Quote',String.valueof(Decimal.valueof(totalSize/(1024*1024)).setscale(2)));
        }
        
        return listAttachments;
    }
    
    public void deleteAcctachment() {
        Id attachmentId = Apexpages.currentPage().getParameters().get('DelId');
        for(Attachment obj : showAllAttachment){
            if(obj.Id == attachmentId){
                delete obj;
            }
        }
    }
    
    public void populateRegionAndSubRegion(String accountCountry){
        mapCountryWithWorldRegion = new Map<String,World_Region__c>();
        for(World_Region__c objWorldRegion : [select id,Name,Region__c,Sub_Region1__c,Country_Name__c from World_Region__c where Country_Name__c != '' order by Country_Name__c]){
            mapCountryWithWorldRegion.put(objWorldRegion.Country_Name__c,objWorldRegion);
        }
        
        if(objUser.Country != null){
            if(!mapCountryWithWorldRegion.isEmpty()){
                if(mapCountryWithWorldRegion.get(objUser.Country) != null){
                    objSupportRequest.Routing_Sub_Region__c = mapCountryWithWorldRegion.get(objUser.Country).Sub_Region1__c;
                }
            }
        }
        else{
            if(accountCountry != ''){
                if(!mapCountryWithWorldRegion.isEmpty()){
                    if(mapCountryWithWorldRegion.get(accountCountry) != null){
                        objSupportRequest.Routing_Sub_Region__c = mapCountryWithWorldRegion.get(accountCountry).Sub_Region1__c;
                    }
                }
            }
        }
    }
    
    public List<SelectOption> getcountryWithISO() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> oCountries= new List<String>();
        //Modified Code Start//
        mapCountryWithWorldRegion = new Map<String,World_Region__c>();
        for(World_Region__c objWorldRegion : [select id,Name,Region__c,Sub_Region1__c,Country_Name__c from World_Region__c where Country_Name__c != '' order by Country_Name__c]){
            mapCountryWithWorldRegion.put(objWorldRegion.Country_Name__c,objWorldRegion);
        }
        //End of Modified Code//
        oCountries.addAll(mapCountryWithWorldRegion.keySet());
        oCountries.sort();
        if(objOppty.Account.ShippingCountry != null)
            if(mapCountryWithWorldRegion.get(objOppty.Account.ShippingCountry)!= null)
                options.add(new SelectOption(mapCountryWithWorldRegion.get(objOppty.Account.ShippingCountry).Name,objOppty.Account.ShippingCountry));
        else
            options.add(new SelectOption('None','--None--'));
        for(String nodeString : oCountries){
            options.add(new SelectOption(mapCountryWithWorldRegion.get(nodeString).Name,nodeString));
        }
        return options;
    }
    
   /* public void fetchNodesAndEmailIdFromRouting(){
        mapNodeAndRoutingRule = new Map<String,SupportRequest_Routing_Rules__c>();
        //routingEmailAddress ='';
        for(SupportRequest_Routing_Rules__c objRoutingRules : [select NotificationToEmail__c,EMAIL_TEMPLATE__C,Territory__c,Region__c,Sub_Region__c,Account__c from SupportRequest_Routing_Rules__c where BUSINESS_GROUP__C=: objUser.BUSINESS_GROUP__C]){
            mapNodeAndRoutingRule.put(objRoutingRules.Territory__c,objRoutingRules);
            if(objRoutingRules.Account__c == objOppty.Account.Name && objRoutingRules.Region__c == objSupportRequest.Routing_Region__c && objRoutingRules.NotificationToEmail__c != null && objRoutingRules.NotificationToEmail__c != ''){
                routingEmailAddress = objRoutingRules.NotificationToEmail__c;
            }
        }
    }
    public List<SelectOption> getallTerritory() {
        if(routingEmailAddress == null){
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('None','--None--'));
            for(String nodeString : mapNodeAndRoutingRule.keyset()){
                if(nodeString != '' && nodeString != null)
                    options.add(new SelectOption(nodeString,nodeString));
            }
            return options;
        }
        else{
            return null;
        }  
    }*/
   
    public PageReference visibilityOfSpecialRevisionFields() {
        showSpecialRevisionFields = false;
        if(objSupportRequest.Special_Pricing__c == 'Revision' || objSupportRequest.Special_Pricing__c == 'Special Pricing Exists'){
            showSpecialRevisionFields = true;
        }
        return null;
    }
    
    public PageReference visibilityOfFields() {
        routingCriteria();
        mapPPSFormWithFieldAPI = new Map<String,List<PPS_Field_And_Type_Mapping__c>>();
        mapPPSFormWithFieldAPI.put('Opportunity',new list<PPS_Field_And_Type_Mapping__c>());
        mapPPSFormWithFieldAPI.put('Special_Left',new list<PPS_Field_And_Type_Mapping__c>());
        mapPPSFormWithFieldAPI.put('Special_Right',new list<PPS_Field_And_Type_Mapping__c>());
        mapPPSFormWithFieldAPI.put('Services',new list<PPS_Field_And_Type_Mapping__c>());
        mapPPSFormWithFieldAPI.put('Output',new list<PPS_Field_And_Type_Mapping__c>());
        mapPPSFormWithFieldAPI.put('Customer',new list<PPS_Field_And_Type_Mapping__c>());
        mapPPSFormWithFieldAPI.put('Pricing',new list<PPS_Field_And_Type_Mapping__c>());
        mapPPSFormWithFieldAPI.put('Technical',new list<PPS_Field_And_Type_Mapping__c>());
        mapPPSFormWithFieldAPI.put('Request',new list<PPS_Field_And_Type_Mapping__c>());
        mapPPSFormWithFieldAPI.put('pricing_escalation',new list<PPS_Field_And_Type_Mapping__c>());
        showOutputSection = false;
        showSpecialPricing = false;
        showSpecialSection = false;
        showPricingEscalationSection = false;
        for(PPS_Field_And_Type_Mapping__c objPPSFieldMapping : ListPPSAllFieldsMappings){       
           if(objSupportRequest.CPQ_Request_Type__c == 'Special Pricing (New OPG)'){
                if(objPPSFieldMapping.Special_Pricing_only_New_OPG__c){
                    createPPSFieldMap(objPPSFieldMapping);
                }
                showShipToAddress = false;
                showInvoiceToAddress = false;
                showQuoteAddress = true;
                showSpecialRequired = true;
                
            }
            else if(objSupportRequest.CPQ_Request_Type__c== 'Manual Quote (for new/existing products)'){
                if(objPPSFieldMapping.Manual_Quote__c){
                    createPPSFieldMap(objPPSFieldMapping);
                }
                showShipToAddress = false;
                showInvoiceToAddress = false;
                showQuoteAddress = true;
                showSpecialRequired = false;
            }
            else if(objSupportRequest.CPQ_Request_Type__c== 'B2B Portal Quote (Products/Configuration exist/New)'){
                if(objPPSFieldMapping.B2B_Portal_Quote_Products_Configuration__c){
                    createPPSFieldMap(objPPSFieldMapping);
                }
                showShipToAddress = false;
                showInvoiceToAddress = false;
                showQuoteAddress = true;
            }
            else if(objSupportRequest.CPQ_Request_Type__c== 'Update Offering'){
                if(objPPSFieldMapping.B2B_Portal_Update_Products_Configuratio__c){
                    createPPSFieldMap(objPPSFieldMapping);
                }
                objSupportRequest.Special_Pricing__c = 'Revision';
                showSpecialRevisionFields = true;
                showShipToAddress = false;
                showInvoiceToAddress = false;
                showQuoteAddress = false;
                showSpecialRequired = false;
                
            }
            else if(objSupportRequest.CPQ_Request_Type__c== 'B2B Portal Set-Up (new)'){
                if(objPPSFieldMapping.B2B_Portal_Set_Up_new__c){
                    createPPSFieldMap(objPPSFieldMapping);
                }
                showShipToAddress = true;
                showInvoiceToAddress = true;
                showQuoteAddress = true;
                showSpecialRequired = false;
            }
            else if(objSupportRequest.CPQ_Request_Type__c== 'Pricing Escalation'){
                if(objPPSFieldMapping.Escalation__c){
                    createPPSFieldMap(objPPSFieldMapping);
                }
                showShipToAddress = true;
                showInvoiceToAddress = true;
                showQuoteAddress = true;
            }
            if(showRevisionSpecialSection){
                if(objPPSFieldMapping.Special_Pricing_only_New_OPG__c){
                    createPPSFieldMap(objPPSFieldMapping);
                }
            }
        }
        if(mapPPSFormWithFieldAPI.get('Output').size()>0){
            showOutputSection = true;
        }
        if(mapPPSFormWithFieldAPI.get('Special_Right').size()>0 || mapPPSFormWithFieldAPI.get('Special_Left').size()>0){
            showSpecialPricing = true;
        }
        if(mapPPSFormWithFieldAPI.get('Special_Left').size()>0){
            showSpecialSection = true;
        }
        if(mapPPSFormWithFieldAPI.get('pricing_escalation').size()>0){
            showPricingEscalationSection = true;
        }
        //sectionVisibility();
        return null;
    }
    
    public void createPPSFieldMap(PPS_Field_And_Type_Mapping__c objPPSFieldMapping){
        List<PPS_Field_And_Type_Mapping__c> listPPSFieldMapping;
        Boolean isAlready = false;
        if(mapPPSFormWithFieldAPI.containsKey(objPPSFieldMapping.Form_Section_Name__c)){
            listPPSFieldMapping = mapPPSFormWithFieldAPI.get(objPPSFieldMapping.Form_Section_Name__c);
            if(!listPPSFieldMapping.isEmpty()){
                for(PPS_Field_And_Type_Mapping__c obj:listPPSFieldMapping){
                    if(obj.Field_API_Name__c == objPPSFieldMapping.Field_API_Name__c){
                        isAlready = true;
                    }
                }
            }
            if(!isAlready){
                listPPSFieldMapping.add(objPPSFieldMapping);
            }
            
        }
        else{
            listPPSFieldMapping = new List<PPS_Field_And_Type_Mapping__c>();
            listPPSFieldMapping.add(objPPSFieldMapping);
        }
        if(!listPPSFieldMapping.isEmpty()){
            mapPPSFormWithFieldAPI.put(objPPSFieldMapping.Form_Section_Name__c,listPPSFieldMapping);
        }
    }
    
    public void sectionVisibility(){
        geoSection = false;
        technicalSection = false;
        customerSection = false;
        outputSection = false;
        otherSection = false;
        specialPriceSection = false;
        attachments = false;
        if(objSupportRequest.get('Geo_Split_AP__c') != null && objSupportRequest.get('Geo_Split_AP__c') != ' ')
            geoSection = true;
        if(objSupportRequest.get('Geo_Split_LA__c') != null && objSupportRequest.get('Geo_Split_LA__c') != ' ')
            geoSection = true;
        if(objSupportRequest.get('Geo_Split_EU__c') != null && objSupportRequest.get('Geo_Split_EU__c') != ' ')
            geoSection = true;
        if(objSupportRequest.get('Geo_Split_JP__c') != null && objSupportRequest.get('Geo_Split_JP__c') != ' ')
            geoSection = true;
        if(objSupportRequest.get('Geo_Split_NA__c') != null && objSupportRequest.get('Geo_Split_NA__c') != ' ')
            geoSection = true;
        if(objSupportRequest.get('Ship_To_Address_1__c') != null && objSupportRequest.get('Ship_To_Address_1__c') != ' ')
            geoSection = true;
        if(objSupportRequest.get('Config_ID_Products_Customer_SKU__c') != null && objSupportRequest.get('Config_ID_Products_Customer_SKU__c') != ' ')   
            technicalSection = true;
        if(objSupportRequest.get('Customer_First_Name__c') != null && objSupportRequest.get('Customer_First_Name__c') != ' ')
            customerSection = true;
        if(objSupportRequest.get('Customer_Last_Name__c') != null && objSupportRequest.get('Customer_Last_Name__c') != ' ')
            customerSection = true;
        if(objSupportRequest.get('Customer_Telephone_number__c') != null && objSupportRequest.get('Customer_Telephone_number__c') != ' ')
            customerSection = true;
        if(objSupportRequest.get('Customer_Email_Address__c') != null && objSupportRequest.get('Customer_Email_Address__c') != ' ')
            customerSection = true;
        if((objSupportRequest.get('CC_Email_Address__c') != null && (objSupportRequest.get('CC_Email_Address__c') != ' ')) || (objSupportRequest.get('Additional_Information__c') != null && objSupportRequest.get('Additional_Information__c') != ' ')) 
            otherSection = true;
        if(objSupportRequest.get('Special_Pricing__c') != null && objSupportRequest.get('Special_Pricing__c') != ' ')
            specialPriceSection = true;
        if((objSupportRequest.get('Special_Pricing__c') == 'Revision'  || objSupportRequest.get('Special_Pricing__c') == 'Special Pricing Exists') && (objSupportRequest.get('Special_Pricing_Revision__c')!= null && objSupportRequest.get('Special_Pricing_Revision__c') != ' '))
            specialPriceSection = true;
        if((objSupportRequest.get('CPQ_Request_Type__c') == 'Special Pricing (New OPG)') && (objSupportRequest.get('RFP_RFQ_RFI_Driven__c') != null && objSupportRequest.get('RFP_RFQ_RFI_Driven__c') != ' '))
            specialPriceSection = true;
        if((objSupportRequest.get('CPQ_Request_Type__c') == 'Special Pricing (New OPG)') && (objSupportRequest.get('Contract_Driven__c') != null && objSupportRequest.get('Contract_Driven__c') != ' '))
            specialPriceSection = true;
        if((objSupportRequest.get('CPQ_Request_Type__c') == 'Special Pricing (New OPG)') && (objSupportRequest.get('Driving_B2B__c') != null && objSupportRequest.get('Driving_B2B__c') != ' '))
            specialPriceSection = true;
        if((objSupportRequest.get('CPQ_Request_Type__c') == 'Special Pricing (New OPG)') && (objSupportRequest.get('Contract_Number__c') != null && objSupportRequest.get('Contract_Number__c') != ' '))
            specialPriceSection = true;
        if((objSupportRequest.get('CPQ_Request_Type__c') == 'Special Pricing (New OPG)') && (objSupportRequest.get('Website_Address__c') != null && objSupportRequest.get('Website_Address__c') != ' '))
            specialPriceSection = true;
        if((objSupportRequest.get('CPQ_Request_Type__c') == 'Special Pricing (New OPG)') && (objSupportRequest.get('Distributor_Name__c') != null && objSupportRequest.get('Distributor_Name__c') != ' '))
            specialPriceSection = true;     
        if((objSupportRequest.get('CPQ_Request_Type__c') == 'Special Pricing (New OPG)') && (objSupportRequest.get('Distributor_Location_ID__c') != null && objSupportRequest.get('Distributor_Location_ID__c') != ' '))
            specialPriceSection = true;
        if((objSupportRequest.get('CPQ_Request_Type__c') == 'Special Pricing (New OPG)') && (objSupportRequest.get('Reseller_Name__c') != null && objSupportRequest.get('Reseller_Name__c') != ' '))
            specialPriceSection = true;
        if((objSupportRequest.get('CPQ_Request_Type__c') == 'Special Pricing (New OPG)') && (objSupportRequest.get('Reseller_Location_ID__c') != null && objSupportRequest.get('Reseller_Location_ID__c') != ' '))
            specialPriceSection = true;
        if((objSupportRequest.get('CPQ_Request_Type__c') == 'Special Pricing (New OPG)') && (objSupportRequest.get('Authorized_Users_to_Edit__c') != null && objSupportRequest.get('Authorized_Users_to_Edit__c') != ' '))
            specialPriceSection = true;
        if((objSupportRequest.get('CPQ_Request_Type__c') == 'Special Pricing (New OPG)') && (objSupportRequest.get('Distributor_Name__c') != null && objSupportRequest.get('Distributor_Name__c') != ' '))
            specialPriceSection = true;
        if(showAllAttachment.size() != 0)
            attachments = true;

        for(String sectionName:mapPPSFormWithFieldAPI.keySet()){
            for(PPS_Field_And_Type_Mapping__c mapping:mapPPSFormWithFieldAPI.get(sectionName)){
                String filedapiname=mapping.FIELD_API_NAME__C;  
                if(sectionName == 'Technical'){
                    if(objSupportRequest.get(filedapiname) != null && objSupportRequest.get(filedapiname) != ' ')
                        technicalSection = true;
                }else if(sectionName == 'Customer'){
                    if(objSupportRequest.get(filedapiname) != null && objSupportRequest.get(filedapiname) != ' ')
                        customerSection = true;
                }else if(sectionName == 'Output'){
                    if(objSupportRequest.get(filedapiname) != null && objSupportRequest.get(filedapiname) != ' ')
                        outputSection = true;
                }else if(sectionName == 'Special_Left' || sectionName == 'Special_Right'){
                    if(objSupportRequest.get(filedapiname) != null && objSupportRequest.get(filedapiname) != ' ')
                        specialPriceSection = true;
                }                                   
            }
        }
    }
    
        
    public PageReference submitRequest() {
        if (objSupportRequest.isRequestSubmitted__c)
        {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CPQ_Request_already_Submitted));
            return null;
        }
        if(objSupportRequest.Parent_Support_Request_Number__c==null)
        if (objSupportRequest.Due_Date2__c <= datetime.now()&& objSupportRequest.Due_Date2__c <> NULL)
        {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CPQ_Due_Date_Validation));
            return null;
        }
        //Checks to see if geo split total is 100% before submission
        if(objSupportRequest.Geo_Split_AP__c != null && objSupportRequest.Geo_Split_LA__c != null && objSupportRequest.Geo_Split_EU__c!= null && objSupportRequest.Geo_Split_JP__c!= null && objSupportRequest.Geo_Split_NA__c!= null){
            double GeoTotalValue = objSupportRequest.Geo_Split_AP__c +objSupportRequest.Geo_Split_LA__c +objSupportRequest.Geo_Split_EU__c+objSupportRequest.Geo_Split_JP__c+objSupportRequest.Geo_Split_NA__c;
            if(GeoTotalValue  <> 100){
                 Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Geo Split total is ' + GeoTotalValue  + '%. Please adjust Geo Split amounts to equal 100%'));
                 return null;
            }
        }
        
        
        
        restrictIndirectAlert = false;
        if(!byPassValidations){
            string errorMsgForRequiredFields ='';
            Boolean requiredMissing = false;
            for(List<PPS_Field_And_Type_Mapping__c> listPPSFieldMapping : mapPPSFormWithFieldAPI.values()){
                for(PPS_Field_And_Type_Mapping__c objPPSFieldMapping : listPPSFieldMapping){
                    if((objSupportRequest.CPQ_Request_Type__c == 'Special Pricing (New OPG)' && objPPSFieldMapping.Special_Pricing_Required__c) || (objSupportRequest.CPQ_Request_Type__c == 'Manual Quote (for new/existing products)' && objPPSFieldMapping.Manual_Quote_Required__c) || (objSupportRequest.CPQ_Request_Type__c == 'Update Offering' && objPPSFieldMapping.Update_Offering_Required__c) || (objSupportRequest.CPQ_Request_Type__c == 'B2B Portal Quote (Products/Configuration exist/New)' && objPPSFieldMapping.B2B_Portal_Quote_Required__c) || (objSupportRequest.CPQ_Request_Type__c == 'Pricing Escalation' && objPPSFieldMapping.Pricing_Escalation_Required__c)){
                        if(objSupportRequest.get(objPPSFieldMapping.Field_API_Name__c) == '' || objSupportRequest.get(objPPSFieldMapping.Field_API_Name__c) == null){
                            errorMsgForRequiredFields = errorMsgForRequiredFields +' '+objPPSFieldMapping.Field_Label_Name__c+' ,';
                            requiredMissing = true;
                        }
                    }
                }
            }
            if(objSupportRequest.CPQ_Request_Type__c == 'Special Pricing (New OPG)' || objSupportRequest.CPQ_Request_Type__c == 'Manual Quote (for new/existing products)' || objSupportRequest.CPQ_Request_Type__c == 'Update Offering' || objSupportRequest.CPQ_Request_Type__c == 'Pricing Escalation'){
                if(objSupportRequest.Special_Pricing__c == '' || objSupportRequest.Special_Pricing__c == null){
                    errorMsgForRequiredFields =errorMsgForRequiredFields +' Special Pricing ,';
                    requiredMissing = true;
                }
                if(objSupportRequest.CPQ_Request_Type__c != 'Manual Quote (for new/existing products)'){
                    if(objSupportRequest.Special_Pricing__c == 'Revision' || objSupportRequest.Special_Pricing__c == 'Special Pricing Exists'){
                        if(objSupportRequest.Special_Pricing_Revision__c =='' || objSupportRequest.Special_Pricing_Revision__c ==null){
                            errorMsgForRequiredFields =errorMsgForRequiredFields +' Special Pricing - Deal ID ,';
                            requiredMissing = true;
                        }    
                    }
                 }
            }
            if(objSupportRequest.CPQ_Request_Type__c == 'Manual Quote (for new/existing products)' || objSupportRequest.CPQ_Request_Type__c == 'B2B Portal Quote (Products/Configuration exist/New)' || objSupportRequest.CPQ_Request_Type__c == 'Update Offering' || objSupportRequest.CPQ_Request_Type__c == 'Pricing Escalation'){
                if(objSupportRequest.Config_ID_Products_Customer_SKU__c == '' || objSupportRequest.Config_ID_Products_Customer_SKU__c == null){
                    errorMsgForRequiredFields =errorMsgForRequiredFields +' Config ID / Products / Customer SKU / Configuration Details / Quantities / Pricing ,';
                    requiredMissing = true;
                }
                if(objSupportRequest.Request_Description__c == '' || objSupportRequest.Request_Description__c == null){
                    errorMsgForRequiredFields =errorMsgForRequiredFields +' Request Description ,';
                    requiredMissing = true;
                }
            }
            if(objSupportRequest.CPQ_Request_Type__c == 'Manual Quote (for new/existing products)' || objSupportRequest.CPQ_Request_Type__c == 'B2B Portal Quote (Products/Configuration exist/New)' || objSupportRequest.CPQ_Request_Type__c == 'Update Offering'){
                if(objSupportRequest.Additional_Information__c == '' || objSupportRequest.Additional_Information__c == null){
                    errorMsgForRequiredFields =errorMsgForRequiredFields +' Additional Information ,';
                    requiredMissing = true;
                }
            }
            for(string requiredField : SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',Label.CPQPPSRequiredFields)){
                List<String> listLableWithAPI = requiredField.split(':');
                if(((objSupportRequest.CPQ_Request_Type__c == 'Update Offering' || objSupportRequest.CPQ_Request_Type__c== 'Configuration only')&&  (listLableWithAPI[1] == 'Address_1__c' || listLableWithAPI[1] == 'City__c' || listLableWithAPI[1] == 'Country__c' || listLableWithAPI[1] == 'Address_Postal__c' ))){
                }
                else{
                    if(objSupportRequest.get(listLableWithAPI[1]) == '' || objSupportRequest.get(listLableWithAPI[1]) == null){
                        errorMsgForRequiredFields = errorMsgForRequiredFields +' '+listLableWithAPI[0]+' ,';
                        requiredMissing = true;
                    }
                }
                
            }
            if(requiredMissing){
                errorMsgForRequiredFields = errorMsgForRequiredFields.removeEnd(',');
                if(errorMsgForRequiredFields.split(',').size() > 1)
                    errorMsgForRequiredFields += ' Fields are mandatory.Please Specify the values';
                else
                    errorMsgForRequiredFields += ' Field is mandatory.Please Specify the values';
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMsgForRequiredFields));
                return null;
            }
        }
        
        List<SupportRequest_Routing_Rules__c> listRoutingRules = [select NotificationToEmail__c,CPQ_Boundary_System__c from SupportRequest_Routing_Rules__c where (Support__c ='Quote-to-Order' AND Support_Sub_Type__c='Config / Price / Quote' AND BUSINESS_GROUP__C=: objUser.BUSINESS_GROUP__C And Region__c =: objSupportRequest.Routing_Region__c) And ((Account__c =: objOppty.Account.Name OR Account__c ='') AND ((Country__c =: objSupportRequest.CPQ_Routing_Country__c OR Country__c = '') AND (Global_Business_Unit__c =: objSupportRequest.Business_Unit__c OR Global_Business_Unit__c = '') AND (Managed_By__c =: objSupportRequest.Managed_By__c OR Managed_By__c = '') AND(CPQ_Route__c =: objSupportRequest.Route_To_Market_RTM__c OR CPQ_Route__c = '') AND Territory__c =: objSupportRequest.CPQ_Routing_Territory__c AND Other_Criteria__c=: objSupportRequest.CPQ_Other_Routing_Criteria__c)) AND (Request_For__c =: objSupportRequest.CPQ_Request_Type__c OR Request_For__c = '') order by BUSINESS_GROUP__C NULLS Last,Global_Business_Unit__c NULLS Last,CPQ_Route__c NULLS Last,Managed_By__c NULLS Last,Account__c NULLS Last,Country__c NULLS Last,Territory__c NULLS Last,Other_Criteria__c NULLS Last];
        if(listRoutingRules.isEmpty()){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Not_Valid_Routing));
            return null;
        }
        try{
        objSupportRequest.Submitted_Date__c = date.today();
        objSupportRequest.CPQ_Submitted_Date__c = datetime.now();
        objSupportRequest.isRequestSubmitted__c = true;
        objSupportRequest.Status__c ='Quote Request Sent/Submitted';
        objSupportRequest.CPQ_Routing_Email__c = listRoutingRules[0].NotificationToEmail__c;
        objSupportRequest.CPQ_Boundary_System__c = listRoutingRules[0].CPQ_Boundary_System__c;
        objSupportRequest.CPQ_Notification_Status__c = '';
        update objSupportRequest;
        
        
       /* string eMailpage = '/apex/CPQPPSEmailForm?id='+objSupportRequest.id+'&pageMode=View';
        PageReference Page=new PageReference(eMailpage);
        Page.setRedirect(true);
        
        Blob b1; 
        try{ 
        b1 = Page.getContent(); 
        }catch(VisualforceException e){
        b1 = Blob.valueOf('<head>BLob when occur error----------------------Test------</head>');
        }
      
        string emailBody = b1.toString();
        emailBody = emailBody.replaceAll(Label.CPQ_Remove_uncheckbox_email,'False');
        emailBody = emailBody.replaceAll(Label.CPQ_Remove_checkbox_email,'True');
        emailBody = emailBody.replaceAll(emailBody.substring(emailBody.indexof('<head>'),emailBody.indexof('</head>')+7),'');
        Pattern p = Pattern.compile('<script .*[A-Za-z0-9/][^<>]*');
        Matcher m = p.matcher(emailBody);
        emailBody = m.replaceAll('');
        emailBody = emailBody.replaceAll('</script>','');
        emailBody = emailBody.replaceAll('(\\<.*?>)', '');
        emailBody = emailBody.replaceAll('&nbsp;','');
        emailBody = emailBody+new CPQXMLUtilController().generateXML('Support_Request__c','SupportRequest__c',objSupportRequest.id);
        Messaging.singleEmailMessage mail = new Messaging.singleEmailMessage();
        Blob b = Blob.valueOf(new CPQXMLUtilController().generateXML('Support_Request__c','SupportRequest__c',objSupportRequest.id));
        List<Messaging.Emailfileattachment> fileAttachments  = new   List<Messaging.Emailfileattachment>();
        if(totalSize < 10485760){
        for(Attachment  aa : showAllAttachment)
        {
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment(); 
            efa.setFileName(aa.Name); 
            efa.setBody(aa.Body); 
            fileAttachments.add(efa);
         }
        }
        String addresses = objSupportRequest.Requestor_email__c + ';'+objSupportRequest.CPQ_Routing_Email__c;
        String[] toAddresses = addresses.split(';', 0);
        if(objSupportRequest.CC_Email_Address__c != null){
            if(objSupportRequest.CC_Email_Address__c.contains('@hp.com')){
                String addresses1 = objSupportRequest.CC_Email_Address__c+';';
                String hpCCAddresses;
                for(string CCEmail:addresses1.split(';', 0)){
                    if(CCEmail.contains('@hp.com'))
                        if (hpCCAddresses == null)
                                hpCCAddresses = CCEmail+';';
                        else
                        hpCCAddresses = hpCCAddresses + CCEmail+';';
                }
                String[] ccAddresses = hpCCAddresses.split(';', 0);
                mail.setCCAddresses(ccAddresses);
            }
        }
        mail.setSubject('SF.com-' + objSupportRequest.Name+'-'+objSupportRequest.Type_of_Request__c+'-'+objSupportRequest.CPQ_Request_Type__c+'-'+objOppty.Account.Name+'-'+objSupportRequest.Request_Description__c+'-'+objSupportRequest.Opportunity_ID_Formula__c);
        mail.setHtmlBody(emailBody);
        mail.setToAddresses(toAddresses);
        mail.setFileAttachments(fileAttachments);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});*/
        string redirectURL;
        if(parentRequestId == null){
            redirectURL = '/apex/PPSViewRequestForm?id='+objSupportRequest.id+'&pageMode=View';
        }
        else{
            redirectURL = '/apex/PPSViewRequestForm?id='+objSupportRequest.id+'&pageMode=View&parentRequest='+parentRequestId;
        }
        PageReference FinalPage=new PageReference(redirectURL);
        FinalPage.setRedirect(true);
        return FinalPage;
        }
        Catch(exception e){ 
            //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            objSupportRequest.Submitted_Date__c = null;
            objSupportRequest.CPQ_Submitted_Date__c = null;
            objSupportRequest.isRequestSubmitted__c = false;
            objSupportRequest.Status__c ='New';
            objSupportRequest.CPQ_Routing_Email__c = null;
            objSupportRequest.CPQ_Boundary_System__c = null;
            objSupportRequest.CPQ_Notification_Status__c = null;
            ApexPages.addMessages(e);
            return null;
        }
    }
    public void sendEmailFromWebservice(){
        //sectionVisibility();
        if(pageMode == 'View' && (objSupportRequest.CPQ_Notification_Status__c == '' || objSupportRequest.CPQ_Notification_Status__c == null))
       {
            string eMailpage = '/apex/CPQPPSEmailForm?id='+objSupportRequest.id+'&pageMode=View'+'&email=Y';
            PageReference Page=new PageReference(eMailpage);
            Page.setRedirect(true);
            
            Blob b2; 
            try{ 
            b2 = Page.getContent(); 
            }catch(VisualforceException e){
            b2 = Blob.valueOf('<head>BLob when occur error----------------------Test------</head>');
            }
      
            string emailBody = b2.toString();
            //string emailBody = Page.getContent().toString();
            emailBody = emailBody.replaceAll(Label.CPQ_Remove_uncheckbox_email,'False');
            emailBody = emailBody.replaceAll(Label.CPQ_Remove_checkbox_email,'True');
            emailBody = emailBody.replaceAll(emailBody.substring(emailBody.indexof('<head>'),emailBody.indexof('</head>')+7),'');
            //string temp = emailBody.substring(emailBody.indexof('<script'),emailBody.indexof('</script>')+9).replaceAll('\n','<br/>');
            //emailBody = emailBody.replaceAll('\n','<br/>');
            Pattern p = Pattern.compile('<script.*[A-Za-z0-9/][^<>]*');
            Matcher m = p.matcher(emailBody);
            //string temp = m.replaceAll('');
            emailBody = m.replaceAll('');
            emailBody = emailBody.replaceAll('</script>','');
            emailBody = emailBody.replaceAll('(\\<.*?>)', '');
            emailBody = emailBody.replaceAll('&nbsp;','');
            emailBody = emailBody.replaceAll('amp;','');
            emailBody = emailBody.replaceAll('&quot;','');
             //Call Webservice for Email R4.0
            CPQSendSupReqAttachment oSupReqAttach= new CPQSendSupReqAttachment();
            CPQSendSupReqAttachment.SupportRequestInput oSupInput=new CPQSendSupReqAttachment.SupportRequestInput();
            oSupInput.SupportRequestNumber=objSupportRequest.Name;
            oSupInput.ExtractXML='N';
            oSupInput.ContentType='text/plain';
            oSupInput.EmailBody=emailBody;
            String SuccessMessage = oSupReqAttach.InvokeSRAttachmentWS(oSupInput);
            if(SuccessMessage == 'SUCCESS'){
                objSupportRequest.CPQ_Notification_Status__c = SuccessMessage;
                update objSupportRequest;
            }
            else{
                objSupportRequest.Submitted_Date__c = null;
                objSupportRequest.CPQ_Submitted_Date__c = null;
                objSupportRequest.isRequestSubmitted__c = false;
                objSupportRequest.Status__c ='New';
                objSupportRequest.CPQ_Notification_Status__c = SuccessMessage ;
                update objSupportRequest;
            }
        }
    }
    public PageReference saveRequest() {
        if (objSupportRequest.isRequestSubmitted__c)
        {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CPQ_Request_already_Submitted));
            return null;
        }
        if (objSupportRequest.Due_Date2__c <= datetime.now()&& objSupportRequest.Due_Date2__c <> NULL){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CPQ_Due_Date_Validation));
            }
        else
        {
            //objSupportRequest.CPQ_Other_Routing_Criteria__c = selectedCriteria;
            update objSupportRequest;
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Request Saved....'));
        }
        return null;
        
       
    }
    public PageReference cancelRequest() {
        if (objSupportRequest.isRequestSubmitted__c)
        {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CPQ_Request_already_Submitted));
            return null;
        }
        Delete objSupportRequest;
        PageReference Page=new PageReference('/'+objSupportRequest.Opportunity__c);
        page.setRedirect(true);
        return page;
    }
}