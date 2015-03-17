/**
* Class Name: CPQESSNRequestFormController
* Author: HP - Mohit
* Date: 07-Nov-2012 
* Description: Contains CPQ ESSN functionality and used for CPQESSNRequestForm,CPQESSNViewRequestForm,CPQESSNEmailForm pages
*/

public class CPQESSNRequestFormController {
    
    
    public Boolean shipToAddress{get;set;}
    public Boolean invoiceToAddress{get;set;}
    public Boolean customerSection{get;set;}
    public Boolean demoSection{get;set;}
    public Boolean otherSection{get;set;}
    public Boolean technicalSection{get;set;}
    public Boolean servicesSection{get;set;}
    public Boolean specialPriceSection{get;set;}
    public Boolean outputSection{get;set;}
    public Boolean attachments{get;set;}
    
    public Boolean isShowGlobalDeal{get;set;}
    public Boolean isShowForm{get;set;}
    public Boolean showTechnicalSection{get;set;}
    public Boolean showSpecialSection{get;set;}
    public Boolean showServiceSection{get;set;}
    public Boolean showOutputSection{get;set;}
    public Boolean showDemoSection{get;set;}
    
    public Boolean showSpecialRevisionFields{get;set;}
    public Boolean showRevisionButton{get;set;}
    public Boolean showRevisionForm{get;set;}
    public Boolean showReadOnlyRevisionForm{get;set;}
    public Boolean showRevisionSpecialSection{get;set;}
    
    public Boolean restrictIndirectAlert {get;set;}
       
    
    public Boolean showQuoteToAddress{get;set;}
    public Boolean showShipToAddress{get;set;}
    public Boolean showInvoiceToAddress{get;set;}
    
    //public Boolean showRevisionFields{get;set;}
    
    public String routingEmailAddress{get;set;}
    //public String selectedTerritory{get;set;}
    public String totalAttachmentSize{get;set;}
    public double totalSize{get;set;}
    
    public List<SelectOption> otherCriteria { get;set; }
    public List<SelectOption> territory { get;set; }
    public List<SelectOption> countryList { get;set; }

          
    private Support_Request__c objSupportRequest;
    string pageMode = '';
    string parentRequestId = '';
    private lIST<CPQFieldMapping__c> ListCPQAllFieldsMappings;
    public Map<String,List<CPQFieldMapping__c>> mapCPQFormWithFieldAPI{get;set;}
    public Map<String,World_Region__c> mapCountryWithWorldRegion{get;set;}
    public opportunity objOppty{get;set;}
    public User objUser;
    public Boolean byPassValidations;
    public List<Attachment> showAllAttachment{
        get { return getshowAllAttachmentget(); }
    } 
    
    public CPQESSNRequestFormController(ApexPages.StandardController controller) {
        ListCPQAllFieldsMappings = new lIST<CPQFieldMapping__c>(); 
        isShowGlobalDeal = false;
        isShowForm = false;
        showRevisionButton = false;
        showRevisionForm = false;
        showReadOnlyRevisionForm = false;
        showRevisionSpecialSection = false;
        restrictIndirectAlert = true;
        byPassValidations = false;
        mapCountryWithWorldRegion = new Map<String,World_Region__c>();
        this.objSupportRequest = (Support_Request__c )controller.getRecord();
        objUser = [select Business_Group__c,Country,Region__c from user where id=:userinfo.getuserid()];
        objOppty = [select id,Route_To_Market__c,StageName,Managed_By__c,Business_Group2__c,CurrencyIsoCode,Name,Account.Name,Account.MDCP_Organization_ID__c,Account.ShippingStreet,Account.ShippingCity,Account.ShippingState,Account.ShippingCountry,Account.ShippingPostalCode from Opportunity where id=:objSupportRequest.Opportunity__c ];
        for(World_Region__c objWorldRegion : [select id,Name,Region__c,Sub_Region1__c,Country_Name__c from World_Region__c where Country_Name__c != '' order by Country_Name__c]){
            mapCountryWithWorldRegion.put(objWorldRegion.Country_Name__c,objWorldRegion);
        }
        pageMode = Apexpages.currentPage().getParameters().get('pageMode');
        parentRequestId = Apexpages.currentPage().getParameters().get('parentRequest');
        system.debug('******parentRequestId *****'+parentRequestId);
        if(pageMode == 'Revision'){
            objSupportRequest.Type_of_Request__c = 'Revision';
            showRevisionForm = true;
            byPassValidations = true;
        }
        
           
        if(pageMode == 'SpecialRevision'){
            showRevisionSpecialSection = true;
            showRevisionForm = true;
            objSupportRequest.Special_Pricing__c = 'New';
            objSupportRequest.Type_of_Request__c = 'Revision';
            showSpecialRevisionFields = true;
            byPassValidations = true;
        }
        if(pageMode == 'ViewFromList'){
            showRevisionButton = true;
            routingCriteria();
            countryPopulate();
        }
        if(pageMode != 'View' && pageMode != 'ViewFromList' && pageMode != 'Revision' && pageMode != 'SpecialRevision'){
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
            objSupportRequest.Quote_Language__c= 'English';
            objSupportRequest.Service_Support__c='Standard Recommendation';
            If(objUser.Region__c == 'AMS')
                objSupportRequest.Routing_Region__c = 'Americas';
            else if(objUser.Region__c == 'APJ')
                objSupportRequest.Routing_Region__c = 'Asia Pacific';
            else
                objSupportRequest.Routing_Region__c = objUser.Region__c;
            if(objUser.Business_Group__c == 'ES'|| objUser.Business_Group__c == 'SW')
                objSupportRequest.Request_Description__c = '';
            //objSupportRequest.CPQ_Routing_Country__c = objUser.Country;
            //populateRegionAndSubRegion(objOppty.Account.ShippingCountry);
            routingCriteria();
            countryPopulate();
            
        }
        if(Apexpages.currentPage().getParameters().get('savedRequest')!= '' && Apexpages.currentPage().getParameters().get('savedRequest') != null){
            objSupportRequest.Route_To_Market_RTM__c = objOppty.Route_To_Market__c;
        }
        
        //fetchNodesAndEmailIdFromRouting();
        if([select isESSN_Pull_Through__c from Support_Request__c where id=:objSupportRequest.Id].isESSN_Pull_Through__c){
            ListCPQAllFieldsMappings = [select Name,Required__c,Configuration_only__c,Field_API_Name__c,Field_Label_Name__c,Form_Section_Name__c,Legal_Quote__c,Order__c,Special_Pricing_Only__c,B2B_Portal_Quote__c,B2B_Portal_Update__c,B2B_Portal_Set_Up__c,B2B_Portal_Quote_Required__c,B2B_Portal_Update_Required__c,Configuration_only_Required__c,Legal_Quote_Required__c,Special_Pricing_Only_Required__c from CPQFieldMapping__c where isESSN_Pull_Through__c = true order by Order__c];
        }
        else{
            ListCPQAllFieldsMappings = [select Name,Required__c,Configuration_only__c,Field_API_Name__c,Field_Label_Name__c,Form_Section_Name__c,Legal_Quote__c,Order__c,Special_Pricing_Only__c,B2B_Portal_Quote__c,B2B_Portal_Update__c,B2B_Portal_Set_Up__c,B2B_Portal_Quote_Required__c,B2B_Portal_Update_Required__c,Configuration_only_Required__c,Legal_Quote_Required__c,Special_Pricing_Only_Required__c from CPQFieldMapping__c order by Order__c];
        }
        
        visibilityOfFields();
        if(pageMode == 'View')
            showReadOnlyRevisionForm = true;
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
            if(string.valueof(countries.get('Country__c')) == objUser.Country && pageMode != 'View' && pageMode != 'ViewFromList' && pageMode != 'Revision' && pageMode != 'SpecialRevision')
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
                //delete obj;
                Database.DeleteResult deleteAttachment = Database.delete(obj,false);
            }
        }
    }
    
    
    public List<SelectOption> getcountryWithISO() {
            
            List<SelectOption> options = new List<SelectOption>();
            List<String> oCountries= new List<String>();
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
    
    
    public PageReference visibilityOfSpecialRevisionFields() {
        showSpecialRevisionFields = false;
        if(objSupportRequest.Special_Pricing__c == 'Revision' || objSupportRequest.Special_Pricing__c == 'Special Pricing Exists'){
            showSpecialRevisionFields = true;
        }
        return null;
    }
    
   
    
    public PageReference visibilityOfFields() {
        routingCriteria();
        mapCPQFormWithFieldAPI = new Map<String,List<CPQFieldMapping__c>>();
        mapCPQFormWithFieldAPI.put('Opportunity',new list<CPQFieldMapping__c>());
        mapCPQFormWithFieldAPI.put('Special_Left',new list<CPQFieldMapping__c>());
        mapCPQFormWithFieldAPI.put('Special_Right',new list<CPQFieldMapping__c>());
        mapCPQFormWithFieldAPI.put('Services',new list<CPQFieldMapping__c>());
        mapCPQFormWithFieldAPI.put('Service_AMS',new list<CPQFieldMapping__c>());
        mapCPQFormWithFieldAPI.put('Service_AMS_Bottom',new list<CPQFieldMapping__c>());
        mapCPQFormWithFieldAPI.put('Service_EMEA',new list<CPQFieldMapping__c>());
        mapCPQFormWithFieldAPI.put('Service_APJ',new list<CPQFieldMapping__c>());
        mapCPQFormWithFieldAPI.put('Output',new list<CPQFieldMapping__c>());
        mapCPQFormWithFieldAPI.put('Customer',new list<CPQFieldMapping__c>());
        mapCPQFormWithFieldAPI.put('Pricing',new list<CPQFieldMapping__c>());
        mapCPQFormWithFieldAPI.put('Technical',new list<CPQFieldMapping__c>());
        mapCPQFormWithFieldAPI.put('Request',new list<CPQFieldMapping__c>());
        mapCPQFormWithFieldAPI.put('Demo',new list<CPQFieldMapping__c>());
        showQuoteToAddress = true;
        showShipToAddress = true;
        showInvoiceToAddress = true;
        showTechnicalSection = false;
        showSpecialSection = false;
        showServiceSection = false;
        showOutputSection = false;
        showDemoSection = false;
        for(CPQFieldMapping__c objCPQFieldMapping : ListCPQAllFieldsMappings){
            if(objSupportRequest.CPQ_Request_Type__c== 'Configuration only (with list price)'){
                if(objCPQFieldMapping.Configuration_only__c){
                    createCPQFieldMap(objCPQFieldMapping);
                }
            }
            else if(objSupportRequest.CPQ_Request_Type__c== 'Special Pricing Only'){
                if(objCPQFieldMapping.Special_Pricing_Only__c){
                    createCPQFieldMap(objCPQFieldMapping);
                }
                showShipToAddress = false;
                showInvoiceToAddress = false;
            }
            else if(objSupportRequest.CPQ_Request_Type__c== 'Legal Quote' ){
                if(objCPQFieldMapping.Legal_Quote__c){
                    createCPQFieldMap(objCPQFieldMapping);
                }

            }
            else if(objSupportRequest.CPQ_Request_Type__c== 'B2B Portal Quote (Products/Configuration exist)' ){
                if(objCPQFieldMapping.B2B_Portal_Quote__c){
                    createCPQFieldMap(objCPQFieldMapping);
                }
                showShipToAddress = false;
                showInvoiceToAddress = false;
                objSupportRequest.Special_Pricing__c = 'Special Pricing Exists';
                showSpecialSection = true;
            }
            else if(objSupportRequest.CPQ_Request_Type__c== 'Update Offering'){
                //B2B Portal Update (Products/Configuration/Pricing update) equivalent to Update Offering changes in R4
                if(objCPQFieldMapping.B2B_Portal_Update__c){
                    createCPQFieldMap(objCPQFieldMapping);
                }
                showQuoteToAddress = false;
                showShipToAddress = false;
                showInvoiceToAddress = false;
            }
            else if(objSupportRequest.CPQ_Request_Type__c== 'B2B Portal Set-Up (new)' ){
                if(objCPQFieldMapping.B2B_Portal_Set_Up__c){
                    createCPQFieldMap(objCPQFieldMapping);
                }
            }
            if(showRevisionSpecialSection){
                if(objCPQFieldMapping.Special_Pricing_Only__c){
                    createCPQFieldMap(objCPQFieldMapping);
                }
            }

        }
        system.debug('********mapCPQFormWithFieldAPI******'+mapCPQFormWithFieldAPI.get('Output').size());
        if(mapCPQFormWithFieldAPI.get('Technical').size()>0){
            showTechnicalSection = true;
        }
        if(mapCPQFormWithFieldAPI.get('Special_Left').size()>0 || mapCPQFormWithFieldAPI.get('Special_Right').size()>0){
            showSpecialSection = true;
        }
        if(mapCPQFormWithFieldAPI.get('Services').size()>0){
            showServiceSection = true;
        }
        if(mapCPQFormWithFieldAPI.get('Output').size()>0){
            showOutputSection = true;
        }
        if(mapCPQFormWithFieldAPI.get('Demo').size()>0){
            showDemoSection = true;
        }
        //sectionVisibility();
        return null;
    }
    
    public void sectionVisibility(){
        shipToAddress = false;
        invoiceToAddress = false;
        outputSection = false;
        specialPriceSection = false;
        technicalSection = false;
        otherSection = false;
        customerSection = false;
        demoSection = false;
        servicesSection = false;
        attachments = false;
        //String objectName = 'Support_Request__c';
        //List<CPQFieldMapping__c> cpqMapping=mapCPQFormWithFieldAPI.get('Pricing');
        //Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        if(objSupportRequest.get('Ship_To_Address_1__c') != null && objSupportRequest.get('Ship_To_Address_1__c') != ' ')
            shipToAddress = true;
        if(objSupportRequest.get('Ship_To_Address_2__c') != null && objSupportRequest.get('Ship_To_Address_2__c') != ' ')
            shipToAddress = true;
        if(objSupportRequest.get('Ship_To_Address_3__c') != null && objSupportRequest.get('Ship_To_Address_3__c') != ' ')
            shipToAddress = true;
        if(objSupportRequest.get('Ship_To_City__c') != null && objSupportRequest.get('Ship_To_City__c') != ' ')
            shipToAddress = true;
        if(objSupportRequest.get('Ship_To_State_Province__c') != null && objSupportRequest.get('Ship_To_State_Province__c') != ' ')
            shipToAddress = true;
        if(objSupportRequest.get('Ship_To_Postal_Code__c') != null && objSupportRequest.get('Ship_To_Postal_Code__c') != ' ')
            shipToAddress = true;
        if(objSupportRequest.get('Ship_To_Country__c') != 'None')
            shipToAddress = true;
        if(objSupportRequest.get('Invoice_To_Address_1__c') != null && objSupportRequest.get('Invoice_To_Address_1__c') != ' ')
            invoiceToAddress = true;
        if(objSupportRequest.get('Invoice_To_Address_2__c') != null && objSupportRequest.get('Invoice_To_Address_2__c') != ' ')
            invoiceToAddress = true;
        if(objSupportRequest.get('Invoice_To_Address_3__c') != null && objSupportRequest.get('Invoice_To_Address_3__c') != ' ')
            invoiceToAddress = true;
        if(objSupportRequest.get('Invoice_To_City__c') != null && objSupportRequest.get('Invoice_To_City__c') != ' ')
            invoiceToAddress = true;
        if(objSupportRequest.get('Invoice_To_State_Province__c') != null && objSupportRequest.get('Invoice_To_State_Province__c') != ' ')
            invoiceToAddress = true;
        if(objSupportRequest.get('Invoice_Postal_Code__c') != null && objSupportRequest.get('Invoice_Postal_Code__c') != ' ')
            invoiceToAddress = true;
        if(objSupportRequest.get('Invoice_To_Country__c') != 'None')
            invoiceToAddress = true;
        if((objSupportRequest.get('CC_Email_Address__c') != null && (objSupportRequest.get('CC_Email_Address__c') != ' ')) || (objSupportRequest.get('Additional_Information__c') != null && objSupportRequest.get('Additional_Information__c') != ' ')) 
            otherSection = true;
        if(objSupportRequest.get('Special_Pricing__c') != null && objSupportRequest.get('Special_Pricing__c') != ' ')
            specialPriceSection = true;
        if((objSupportRequest.get('Special_Pricing__c') == 'Revision'  || objSupportRequest.get('Special_Pricing__c') == 'Special Pricing Exists') && (objSupportRequest.get('Special_Pricing_Revision__c')!= null && objSupportRequest.get('Special_Pricing_Revision__c') != ' '))
            specialPriceSection = true;
        if((objSupportRequest.get('Special_Pricing__c') == 'Revision' && (objSupportRequest.get('Routing_Region__c') == 'AMS' || objSupportRequest.get('Routing_Region__c') == 'Americas')) && (objSupportRequest.get('Pricing_Revision_Reason__c') != null && objSupportRequest.get('Pricing_Revision_Reason__c') != ' '))
            specialPriceSection = true;
        if((objSupportRequest.get('Special_Pricing__c') == 'Revision' && (objSupportRequest.get('Routing_Region__c') == 'AMS' || objSupportRequest.get('Routing_Region__c') == 'Americas')) && (objSupportRequest.get('Pricing_Revision_Reason_Other__c') != null && objSupportRequest.get('Pricing_Revision_Reason_Other__c') != ' '))
            specialPriceSection = true;
        if(objSupportRequest.get('Customer_First_Name__c') != null && objSupportRequest.get('Customer_First_Name__c') != ' ')
            customerSection = true;
        if(objSupportRequest.get('Customer_Last_Name__c') != null && objSupportRequest.get('Customer_Last_Name__c') != ' ')
            customerSection = true;
        if(objSupportRequest.get('Customer_Telephone_number__c') != null && objSupportRequest.get('Customer_Telephone_number__c') != ' ')
            customerSection = true;
        if(objSupportRequest.get('Customer_Email_Address__c') != null && objSupportRequest.get('Customer_Email_Address__c') != ' ')
            customerSection = true;
        if(showAllAttachment.size() != 0)
            attachments = true;
        for(String sectionName:mapCPQFormWithFieldAPI.keySet()){
            for(CPQFieldMapping__c mapping:mapCPQFormWithFieldAPI.get(sectionName)){
                String filedapiname=mapping.FIELD_API_NAME__C;
                if(sectionName == 'Special_Left' || sectionName == 'Special_Right'){
                    if(objSupportRequest.get(filedapiname) != null && objSupportRequest.get(filedapiname) != ' ')
                        specialPriceSection = true;                     
                }else if(sectionName == 'Services' || sectionName == 'Service_AMS' || sectionName == 'Service_EMEA' || sectionName == 'Service_APJ'){
                    if(objSupportRequest.get(filedapiname) != null && objSupportRequest.get(filedapiname) != ' ')
                        servicesSection = true;              
                }else if(sectionName == 'Technical'){
                    if(objSupportRequest.get(filedapiname) != null && objSupportRequest.get(filedapiname) != ' ')
                        technicalSection = true;
                    //system.debug('Field Value:'+objSupportRequest.get(filedapiname));
                }else if(sectionName == 'Output'){
                    if(objSupportRequest.get(filedapiname) != null && objSupportRequest.get(filedapiname) != ' ')
                        outputSection = true;
                }else if(sectionName == 'Demo'){
                    if(objSupportRequest.get(filedapiname) != null && objSupportRequest.get(filedapiname) != ' ')
                        demoSection = true;
                }else if(sectionName == 'Customer'){
                    if(objSupportRequest.get(filedapiname) != null && objSupportRequest.get(filedapiname) != ' ')
                        customerSection = true;
                }                      
            }
        }
        system.debug('section-Technical:'+technicalSection);
        system.debug('section-Customer:'+customerSection);
        system.debug('section-Special price:'+specialPriceSection);
        system.debug('section-Service'+servicesSection);
        system.debug('section-Other'+otherSection);
    }
    
    public void createCPQFieldMap(CPQFieldMapping__c objCPQFieldMapping){
        List<CPQFieldMapping__c> listCPQFieldMapping;
        Boolean isAlready = false;
        if(mapCPQFormWithFieldAPI.containsKey(objCPQFieldMapping.Form_Section_Name__c)){
            listCPQFieldMapping = mapCPQFormWithFieldAPI.get(objCPQFieldMapping.Form_Section_Name__c);
            if(!listCPQFieldMapping.isEmpty()){
                for(CPQFieldMapping__c obj:listCPQFieldMapping){
                    if(obj.Field_API_Name__c == objCPQFieldMapping.Field_API_Name__c){
                        isAlready = true;
                    }
                }
            }
            if(!isAlready){
                listCPQFieldMapping.add(objCPQFieldMapping);
            }
            
        }
        else{
            listCPQFieldMapping = new List<CPQFieldMapping__c>();
            listCPQFieldMapping.add(objCPQFieldMapping);
        }
        if(!listCPQFieldMapping.isEmpty()){
            mapCPQFormWithFieldAPI.put(objCPQFieldMapping.Form_Section_Name__c,listCPQFieldMapping);
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
        restrictIndirectAlert = false;
        if(!byPassValidations){
            string errorMsgForRequiredFields ='';
            Boolean requiredMissing = false;
            for(List<CPQFieldMapping__c> listESSNFieldMapping : mapCPQFormWithFieldAPI.values()){
                for(CPQFieldMapping__c objESSNFieldMapping : listESSNFieldMapping){
                    if((objSupportRequest.CPQ_Request_Type__c == 'Special Pricing Only' && objESSNFieldMapping.Special_Pricing_Only_Required__c) || (objSupportRequest.CPQ_Request_Type__c == 'Configuration only (with list price)' && objESSNFieldMapping.Configuration_only_Required__c) || (objSupportRequest.CPQ_Request_Type__c == 'Legal Quote' && objESSNFieldMapping.Legal_Quote_Required__c) || (objSupportRequest.CPQ_Request_Type__c == 'B2B Portal Quote (Products/Configuration exist)' && objESSNFieldMapping.B2B_Portal_Quote_Required__c) || (objSupportRequest.CPQ_Request_Type__c == 'Update Offering' && objESSNFieldMapping.B2B_Portal_Update_Required__c)){
                        if(objSupportRequest.get(objESSNFieldMapping.Field_API_Name__c) == '' || objSupportRequest.get(objESSNFieldMapping.Field_API_Name__c) == null){
                            errorMsgForRequiredFields = errorMsgForRequiredFields +' '+objESSNFieldMapping.Field_Label_Name__c+' ,';
                            requiredMissing = true;
                        }
                    }
                }
            }
            if(objSupportRequest.CPQ_Request_Type__c == 'B2B Portal Quote (Products/Configuration exist)' || objSupportRequest.CPQ_Request_Type__c == 'Special Pricing Only'){
                if(objSupportRequest.Special_Pricing__c == '' || objSupportRequest.Special_Pricing__c == null){
                    requiredMissing = true;
                    errorMsgForRequiredFields =errorMsgForRequiredFields +' Special Pricing ,';
                }
                if(objSupportRequest.Special_Pricing__c == 'Revision' || objSupportRequest.Special_Pricing__c == 'Special Pricing Exists'){
                    if(objSupportRequest.Special_Pricing_Revision__c =='' || objSupportRequest.Special_Pricing_Revision__c == null){
                        requiredMissing = true;
                        errorMsgForRequiredFields =errorMsgForRequiredFields +' Special Pricing - Deal ID ,';
                    }    
                }
                if(objSupportRequest.Special_Pricing__c == 'New'){
                    if(objSupportRequest.Pricing_Justification_and_Summary__c =='' || objSupportRequest.Pricing_Justification_and_Summary__c == null){
                        errorMsgForRequiredFields =errorMsgForRequiredFields +' Pricing Justification and Summary ,';
                        requiredMissing = true;
                    }    
                }
            }
            if(objSupportRequest.Combination_HW_SW_Support_Level_Term__c == 'Proactive Care 24x7' || objSupportRequest.Combination_HW_SW_Support_Level_Term__c == 'Proactive Care 6 hr CTR' || objSupportRequest.Combination_HW_SW_Support_Level_Term__c == 'Proactive 24' || objSupportRequest.Combination_HW_SW_Support_Level_Term__c == 'Proactive Care NBD'){
                if(objSupportRequest.Customer_First_Name__c == '' || objSupportRequest.Customer_First_Name__c == null){
                    requiredMissing = true;
                    errorMsgForRequiredFields =errorMsgForRequiredFields +' Customer First Name ,';
                }
                if(objSupportRequest.Customer_Last_Name__c == '' || objSupportRequest.Customer_Last_Name__c == null){
                    requiredMissing = true;
                    errorMsgForRequiredFields =errorMsgForRequiredFields +' Customer Last Name ,';
                }
            }
            
            for(string requiredField : SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',Label.CPQESSNRequiredField)){
                List<String> listLableWithAPI = requiredField.split(':');
                if((objSupportRequest.CPQ_Request_Type__c == 'Update Offering' &&  (listLableWithAPI[1] == 'Address_1__c' || listLableWithAPI[1] == 'City__c' || listLableWithAPI[1] == 'Country__c' || listLableWithAPI[1] == 'Address_Postal__c' ))){
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

            string redirectURL;
            if(parentRequestId == null){
                redirectURL = '/apex/CPQESSNViewRequestForm?id='+objSupportRequest.id+'&pageMode=View';
            }
            else{
                redirectURL = '/apex/CPQESSNViewRequestForm?id='+objSupportRequest.id+'&pageMode=View&parentRequest='+parentRequestId;
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
        if(pageMode == 'View' && (objSupportRequest.CPQ_Notification_Status__c == '' || objSupportRequest.CPQ_Notification_Status__c == null)){
            
            string eMailpage = '/apex/CPQESSNEmailForm?id='+objSupportRequest.id+'&pageMode=View'+'&email=Y';
            PageReference Page=new PageReference(eMailpage);
            Page.setRedirect(true);
            Blob b2; 
            try{ 
                b2 = Page.getContent(); 
            }catch(VisualforceException e){
                b2 = Blob.valueOf('<head>BLob when occur error----------------------Test------</head>');
            }
            
            string emailBody = b2.toString();
            system.debug('*****emailBody1****'+emailBody);
            //string emailBody = Page.getContent().toString();
            emailBody = emailBody.replaceAll(Label.CPQ_Remove_uncheckbox_email,'False');
            emailBody = emailBody.replaceAll(Label.CPQ_Remove_checkbox_email,'True');
            emailBody = emailBody.replaceAll(emailBody.substring(emailBody.indexof('<head>'),emailBody.indexof('</head>')+7),'');
            system.debug('*****emailBody2****'+emailBody);
            //string temp = emailBody.substring(emailBody.indexof('<script'),emailBody.indexof('</script>')+9).replaceAll('\n','<br/>');
            //system.debug('**********temp****'+temp);
            //emailBody = emailBody.replaceAll('\n','<br/>');
            Pattern p = Pattern.compile('<script.*[A-Za-z0-9/][^<>]*');
            Matcher m = p.matcher(emailBody);
            system.debug('********found****'+m.find());
            //string temp = m.replaceAll('');
            //system.debug('**********temp****'+temp);
            emailBody = m.replaceAll('');
            emailBody = emailBody.replaceAll('</script>','');
            emailBody = emailBody.replaceAll('(\\<.*?>)', '');
            emailBody = emailBody.replaceAll('&nbsp;','');
            emailBody = emailBody.replaceAll('amp;','');
            emailBody = emailBody.replaceAll('&quot;','');
            system.debug('*****emailBody****'+emailBody);
             //Call Webservice for Email R4.0
            CPQSendSupReqAttachment oSupReqAttach= new CPQSendSupReqAttachment();
            CPQSendSupReqAttachment.SupportRequestInput oSupInput=new CPQSendSupReqAttachment.SupportRequestInput();
            oSupInput.SupportRequestNumber=objSupportRequest.Name;
            oSupInput.ExtractXML='Y';
            oSupInput.ContentType='text/plain';
            oSupInput.EmailBody=emailBody;
            String SuccessMessage = oSupReqAttach.InvokeSRAttachmentWS(oSupInput);
            system.debug('*****SuccessMessage****'+SuccessMessage);
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
        //objSupportRequest.CPQ_Other_Routing_Criteria__c = selectedCriteria;
        update objSupportRequest;
        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Request Saved....'));
       
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