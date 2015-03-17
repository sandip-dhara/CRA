/***********************************************************
Author: Shaijan Thomas
Created Date: 22-07-2013
Release: R6
Capability: CPQ
Description:Controller class for special pricing, Quote and Request Assistance
************************************************************/
public class CPQSAPLandingPageCtrl {
    public string newPageUrl {get;set;}
    public string UrlName{get;set;}
    public string UrleMail{get;set;}
    public string SpecialPricing, QuotetoOrder, OpportunityID;
    public string QuoteNumber{get;set;}
    public list < CPQSAPLandingPageCS__c > oCustomSetting = new list < CPQSAPLandingPageCS__c > ();
    public Case oCase{get;set;}
    public Boolean showCaseEditPage{get;set;}
    public Opportunity objOppty{get;set;}
    public Boolean showOrderForm{get;set;}
    public String QuoteDetailURL{get;set;}
    
    public List<String> listDescriptionFields{get;set;}
    public Map<String,String> mapDescriptionLabelWithValue{get;set;}
    
    public CPQSAPLandingPageCtrl() {
        showCaseEditPage = false;
        showOrderForm = false;
        listDescriptionFields = new List<String>();
        mapDescriptionLabelWithValue = new Map<String,String>();
        system.debug('***Hiting URL *** '+ApexPages.currentPage());
        SpecialPricing = ApexPages.currentPage().getParameters().get('SpecialPricing');
        QuotetoOrder = ApexPages.currentPage().getParameters().get('QuotetoOrder');
        OpportunityID = ApexPages.currentPage().getParameters().get('OpportunityID');
        QuoteNumber = ApexPages.currentPage().getParameters().get('QuoteNumber');
        UrleMail = ApexPages.currentPage().getParameters().get('CAemail');
        UrlName = ApexPages.currentPage().getParameters().get('CAName');
    }
    public PageReference OnLoadCreateCaseorApproval() {
        try {
            if(ApexPages.currentPage().getParameters().get('CaseId') != null && ApexPages.currentPage().getParameters().get('CaseId') != ''){
                newPageUrl = '/' + ApexPages.currentPage().getParameters().get('CaseId');
                return null;
            }
            if(ApexPages.currentPage().getParameters().get('QuoteDetailURL') != null && ApexPages.currentPage().getParameters().get('QuoteDetailURL') != ''){
                Case objCase = [select id,CPQ_Quote_URL__c from Case where id=: ApexPages.currentPage().getParameters().get('QuoteDetailURL')];
                if(objCase != null){
                    newPageUrl = objCase.CPQ_Quote_URL__c;
                }
                return null;
            }
            string urlParameter;
            oCase = new case ();
            try {
                objOppty = [select id,Name,Opportunity_ID__c,Owner.Name,owner.Email,AccountId,Account.Name,Route_To_Market__c,Account.RPL_status__c,Country__c,Account.World_Region1__r.Name from opportunity where Opportunity_ID__c = : OpportunityID];
            } catch (exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Opportunity Id is null or Invalid : ' + OpportunityID));
            }
            if (SpecialPricing == 'Y') {
                ID ApprovalRecordTypeID = Schema.SObjectType.Approval__c.getRecordTypeInfosByName().get('SND').getRecordTypeId();
                Approval__c oApproval = new Approval__c();
                oApproval.RecordTypeId = ApprovalRecordTypeID;
                oApproval.Approval_Description__c = 'Special Pricing Request for Quote : ' + QuoteNumber;
                if(objOppty != null){
                    oApproval.Quote_Detail__c = System.Label.CPQSAPUrl+'&Mode=3&I_Quote='+QuoteNumber+ '&I_ACC_NAME='+objOppty.Account.Name+ '&I_OPP_ID='+objOppty.Opportunity_ID__c+ '&I_OPP_NAME='+objOppty.Name + '&i_rpl_status='+objOppty.Account.RPL_status__c+ '&I_COUNTRY='+objOppty.Account.World_Region1__r.Name+'&iframe=X';
                    oApproval.Opportunity__c = objOppty.Id;
                }
                for (CPQSAPLandingPageCS__c oCSObj: [select Name, Date__c, Decimal__c, FieldAPI__c, ObjectAPI__c, URLParameter__c from CPQSAPLandingPageCS__c where ObjectAPI__c= 'Approval__c']){
                    urlParameter = ApexPages.currentPage().getParameters().get(oCSObj.URLParameter__c);
                    if (urlParameter != null && urlParameter != '')
                        if (oCSObj.Decimal__c) {
                            try {
                                system.debug('********urlParameter ******'+urlParameter );
                                if(urlParameter.contains(' '))
                                      urlParameter = urlParameter.removeEnd(' ').trim();
                                if(urlParameter.contains(',')){
                                    urlParameter = urlParameter.remove(',');
                                }
                                if(urlParameter.contains('-')){
                                    urlParameter = urlParameter.removeEnd('-').trim();
                                    oApproval.put(oCSObj.FieldAPI__c, Decimal.valueOf(urlParameter)*(-1.0));
                                }
                                else if(urlParameter.contains('+')){
                                    urlParameter = urlParameter.removeEnd('+').trim();
                                    oApproval.put(oCSObj.FieldAPI__c, Decimal.valueOf(urlParameter));
                                }
                                else
                                    oApproval.put(oCSObj.FieldAPI__c, Decimal.valueOf(urlParameter));
                            } catch (exception e) {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, oCSObj.FieldAPI__c + ' has a value : ' + urlParameter + ', which is a invalid Integer or Decimal'));
                            }
                        } 
                        else if (oCSObj.Date__c) {
                            try {
                                oApproval.put(oCSObj.FieldAPI__c, Date.valueOf(urlParameter));
                            } catch (exception e) {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, oCSObj.FieldAPI__c + ' Field found Invalid Date format : ' + urlParameter));
                            }
                        } else
                            oApproval.put(oCSObj.FieldAPI__c, urlParameter);
                }
                oApproval.CA_Name__c = UrlName;
                oApproval.CA_eMail__c = UrleMail;
                oApproval.Status__c = 'Open';
                oApproval.Case_Origin__c = 'Self Service UI';
                oApproval.Approval_Type__c = 'Special Negotiated Discount';
                oApproval.Approval_Flow_Type__c='Hybrid';
                oApproval.Case_Country_Time_Zone__c = CPQConvertTimeZone.ConvertTimeZoneValue(string.valueof(UserInfo.getTimeZone()));
                if(ApexPages.currentPage().getParameters().get('RequestType') == 'ZQ')
                    oApproval.Request_Type__c = 'New Business Quote';
                else if(ApexPages.currentPage().getParameters().get('RequestType') == 'ZQRN')
                    oApproval.Request_Type__c = 'Renewal Amendment';
                oApproval.Competitors__c = '';    
                if(ApexPages.hasMessages(ApexPages.Severity.ERROR))
                    return null;
                for (Competitors__c objOpportunityCompetitors : [Select Competitor_Name__c from  Competitors__c where Opportunity__c=:objOppty.Id])
                {
                  oApproval.Competitors__c = oApproval.Competitors__c +  objOpportunityCompetitors.Competitor_Name__c + '; \n\r';
                }
                insert oApproval;
                newPageUrl = '/apex/CPQSNDApprovalProcessPage?id=' + oApproval.id;
            }
            else{
                //ID CaseRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CO Case').getRecordTypeId();
                if(objOppty != null){
                    oCase.Opportunity__c = objOppty.Id;
                    oCase.AccountId = objOppty.AccountId;
                    oCase.Route_to_Market__c = objOppty.Route_To_Market__c;
                    oCase.Sold_to_Party__c = objOppty.Account.Name;
                    oCase.CPQ_Quote_URL__c = System.Label.CPQSAPUrl+'&Mode=3&I_Quote='+QuoteNumber+ '&I_ACC_NAME='+objOppty.Account.Name+ '&I_OPP_ID='+objOppty.Opportunity_ID__c+ '&I_OPP_NAME='+objOppty.Name + '&i_rpl_status='+objOppty.Account.RPL_status__c+ '&I_COUNTRY='+objOppty.Account.World_Region1__r.Name+'&iframe=X';
                    system.debug('*********oCase.CPQ_Quote_URL__c*******'+oCase.CPQ_Quote_URL__c);
                    QuoteDetailURL = System.Label.CPQSAPUrl+'&Mode=3&I_Quote='+QuoteNumber+ '&I_ACC_NAME='+objOppty.Account.Name+ '&I_OPP_ID='+objOppty.Opportunity_ID__c+ '&I_OPP_NAME='+objOppty.Name + '&i_rpl_status='+objOppty.Account.RPL_status__c+ '&I_COUNTRY='+objOppty.Country__c+'&iframe=X';
                    oCase.CPQ_Quote_Number__c = QuoteNumber;
                }
                oCase.Origin='Self Service';
                oCase.Business_Type__c = 'Standard';
                oCase.Reason = 'Other';
                oCase.Description = '';
                oCase.Subject = 'Self-Service Quote Request '+QuoteNumber;
                oCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CO Case').getRecordTypeId();
                if(QuotetoOrder == 'Y'){
                    oCustomSetting = [select Date__c, Decimal__c, FieldAPI__c, ObjectAPI__c, URLParameter__c from CPQSAPLandingPageCS__c where ObjectAPI__c ='Case' or ObjectAPI__c = 'ODescription'];
                    oCase.Request_Type__c = 'Orders';
                    showOrderForm = true;
                }
                else{
                    oCustomSetting = [select Name, Date__c, Decimal__c, FieldAPI__c, ObjectAPI__c, URLParameter__c from CPQSAPLandingPageCS__c where ObjectAPI__c= 'Case' or ObjectAPI__c = 'RDescription'];
                    if(ApexPages.currentPage().getParameters().get('RequestType') != null && ApexPages.currentPage().getParameters().get('RequestType') != ''){
                        if(ApexPages.currentPage().getParameters().get('RequestType') == 'ZQ')
                            oCase.Request_Type__c = 'New Business Quote';
                        else if(ApexPages.currentPage().getParameters().get('RequestType') == 'ZQRN')
                            oCase.Request_Type__c = 'Renewal Amendment';
                    }
                    
                }
                for (CPQSAPLandingPageCS__c oCSObj: oCustomSetting) {
                    urlParameter = ApexPages.currentPage().getParameters().get(oCSObj.URLParameter__c);
                    if (oCSObj.ObjectAPI__c == 'ODescription' || oCSObj.ObjectAPI__c == 'RDescription'){
                        //oCase.Description += '\r\n' + oCSObj.FieldAPI__c + ' : ' + urlParameter;
                        listDescriptionFields.add(oCSObj.FieldAPI__c);
                        mapDescriptionLabelWithValue.put(oCSObj.FieldAPI__c,urlParameter);
                        system.debug('*******listDescriptionFields*******'+listDescriptionFields);
                        system.debug('*******mapDescriptionLabelWithValue*******'+mapDescriptionLabelWithValue);
                    }
                    else if (urlParameter != null && urlParameter != ''){
                        if (oCSObj.Decimal__c) {
                            try {
                                if(urlParameter.contains(' '))
                                      urlParameter = urlParameter.removeEnd(' ').trim();
                                if(urlParameter.contains(',')){
                                    urlParameter = urlParameter.remove(',');
                                }
                                if(urlParameter.contains('-')){
                                    urlParameter = urlParameter.removeEnd('-').trim();
                                    oCase.put(oCSObj.FieldAPI__c, Decimal.valueOf(urlParameter)*(-1.0));
                                }
                                else if(urlParameter.contains('+')){
                                    urlParameter = urlParameter.removeEnd('+').trim();
                                    oCase.put(oCSObj.FieldAPI__c, Decimal.valueOf(urlParameter));
                                }
                                else
                                    oCase.put(oCSObj.FieldAPI__c, Decimal.valueOf(urlParameter));
                            } catch (exception e) {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, oCSObj.FieldAPI__c + ' has a value : ' + urlParameter + ', which is a invalid Integer or Decimal'));
                            }
                        }
                        else if (oCSObj.Date__c) {
                            try {
                                oCase.put(oCSObj.FieldAPI__c, Date.valueOf(urlParameter));
                            } catch (exception e) {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, oCSObj.FieldAPI__c + ' Field found Invalid Date format : ' + urlParameter));
                            }
                        } 
                        else
                            oCase.put(oCSObj.FieldAPI__c, urlParameter);
                    }
                }
                for (user obj : [select Id,eMail,Name,Business_Group__c,Region__c,Country, TimeZoneSidKey from user where (Email = : UrleMail or Id = :Userinfo.getUserId()) and IsActive = true and UserType = 'Standard']){
                    if (obj.eMail == UrleMail){
                        oCase.OwnerId = obj.Id;
                        oCase.Case_Origin_is_Interface__c = true;
                    }
                    if(obj.id == Userinfo.getUserId()){
                        oCase.Case_Requestor__c = obj.Name;
                        oCase.Case_Requestor_Email__c = obj.eMail;
                        oCase.BG__c = obj.Business_Group__c;
                        oCase.Region__c = obj.Region__c;
                        oCase.Country__c = obj.Country;
                        oCase.Requestor_s_TimeZone__c = CPQConvertTimeZone.ConvertTimeZoneValue(string.valueof(obj.TimeZoneSidKey));
                    }
                }
                if(!oCase.Case_Origin_is_Interface__c){
                    oCase.Description = oCase.Description +'\n\r CA Name : ' + UrlName +'\n\r CA eMail : ' + UrleMail;
                }
                oCase.Description = oCase.Description +'\n\r Quote Number  : ' + QuoteNumber;
                if(ApexPages.hasMessages(ApexPages.Severity.ERROR))
                    return null;
                else
                    showCaseEditPage = true;
            }
        }
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }
    
    public PageReference insertCase() {
        try{
            if(oCase!=null){
                system.debug('*******mapDescriptionLabelWithValue*******'+mapDescriptionLabelWithValue);
                for(String fieldLabel : mapDescriptionLabelWithValue.keyset()){
                    oCase.Description += '\r\n' + fieldLabel + ' : ' + mapDescriptionLabelWithValue.get(fieldLabel);
                }
                insert oCase;
                //newPageUrl = '/' + oCase.id;
                PageReference FinalPage=new PageReference('/apex/CPQSAPLandingPage?CaseId='+oCase.id);
                FinalPage.setRedirect(true);
                return FinalPage;
            }        
        }
        catch (exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }

        return null;
    }
    
    public PageReference insertAndCloseCase() {
        try{
            if(oCase!=null){
                for(String fieldLabel : mapDescriptionLabelWithValue.keyset()){
                    oCase.Description += '\r\n' + fieldLabel + ' : ' + mapDescriptionLabelWithValue.get(fieldLabel);
                }
                insert oCase;
                //newPageUrl = '/' + oCase.id+'/s?retURL=/'+oCase.id+'&co=1';
                PageReference FinalPage=new PageReference('/apex/CPQSAPLandingPage?CaseId='+oCase.id+'/s?retURL=/'+oCase.id+'&co=1');
                FinalPage.setRedirect(true);
                return FinalPage;
            }        
        }
        catch (Exception e) {
            system.debug('*****e*****'+e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }

        return null;
    }
}