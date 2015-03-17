public class CPQBMIwithRequestintermediateController {
    public Support_Request__c oSupportRequest; 
    public User objUser= new User();
    public CPQBMIwithRequestintermediateController(ApexPages.StandardController controller) {
       objUser = [select Business_Group__c,Country,Region__c from user where id=:userinfo.getuserid()]; 
    }
    public Pagereference redirectToNewRequestPage(){
        
        String reDirectURL='';
        reDirectURL=requestNewQuote();
        PageReference Page=new PageReference(reDirectURL);
        page.setRedirect(true);
        return page;
    }
    
    public String requestNewQuote()
    {
        String sRedirectURL='';
        String redirectVFPageName='';
        String recordTypeName='';
        Map<String,Support_Request_FS_CS__c> sRequestFieldSetCSMap = Support_Request_FS_CS__c.getAll();
        oSupportRequest= new Support_Request__c();
        Map<String,String> oPageParamMap=ApexPages.currentPage().getParameters();
        if(!oPageParamMap.isEmpty()){
            if(oPageParamMap.containskey('BMIId')){
                for(BigMachines__Quote__c objBMIQuote : [select id,Name,BigMachines__Transaction_Id__c,CurrencyIsoCode,BigMachines__Account__c,BigMachines__Description__c,BigMachines__Total_Amount__c,BigMachines__Opportunity__c,BigMachines__Status__c,BigMachines__Amount__c,BigMachines__Total__c from BigMachines__Quote__c where Name=:oPageParamMap.get('BMIId')]){
                    oSupportRequest.Request_Description__c = objBMIQuote.BigMachines__Description__c;
                    oSupportRequest.BMI_Quote_Id__c = objBMIQuote.Id;
                    oSupportRequest.BMI_ID__c = objBMIQuote.Name;
                    oSupportRequest.CurrencyIsoCode = objBMIQuote.CurrencyIsoCode;
                    if(oPageParamMap.containskey('Type')){
                        if(oPageParamMap.get('Type') == 'RequestAssistance'){
                            oSupportRequest.BMI_Quote_URL__c = Label.CPQRequestAssistanceURL + 'id='+objBMIQuote.BigMachines__Transaction_Id__c;
                        }
                    
                    }
                }
                for(HP_Quote__c objHPQuote : [select id from HP_Quote__c where BMI_Id__c =: oPageParamMap.get('BMIId')]){
                    oSupportRequest.HP_Quote__c = objHPQuote.Id;
                }
            }
            if(oPageParamMap.containskey('OpptyId')){
                oSupportRequest.Opportunity__c = oPageParamMap.get('OpptyId');
                for(Opportunity objOppty:[select id,Route_To_Market__c,StageName,Managed_By__c,Business_Group2__c,CurrencyIsoCode,Name,Account.Name,Account.ShippingStreet,Account.ShippingCity,Account.ShippingState,Account.ShippingCountry,Account.ShippingPostalCode from Opportunity where id=:oPageParamMap.get('OpptyId')]){
                    oSupportRequest.Address_1__c = objOppty.Account.ShippingStreet;
                    oSupportRequest.State_Province__c = objOppty.Account.ShippingState;
                    oSupportRequest.City__c = objOppty.Account.ShippingCity;
                    oSupportRequest.Country__c = objOppty.Account.ShippingCountry;
                    oSupportRequest.Address_Postal__c = objOppty.Account.ShippingPostalCode;
                }
            }
            if(oPageParamMap.containskey('PANum')){
                oSupportRequest.Purchase_Agreement__c = oPageParamMap.get('PANum');
            }
            if(oPageParamMap.containskey('PACAC')){
                oSupportRequest.PA_CAC__c = oPageParamMap.get('PACAC');
            }
            if(oPageParamMap.containskey('BMIURL')){
                oSupportRequest.BMI_Quote_URL__c = EncodingUtil.urlDecode(oPageParamMap.get('BMIURL') , 'UTF-8');
            }
            if(oPageParamMap.containskey('DealId')){
                oSupportRequest.Special_Pricing_Revision__c = oPageParamMap.get('DealId');
            }
        }
        if(sRequestFieldSetCSMap!=null){
            for(Support_Request_FS_CS__c requestType : sRequestFieldSetCSMap.values()){
                if((requestType.SupportReqType__c.equals('Quote-to-Order') && requestType.Request_SubType__c.equals('Config / Price / Quote'))&&SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',requestType.Eligible_BG__c).contains(objUser.Business_Group__c)){
                    if(requestType.isBG_Specific_RecordType__c && objUser.Business_Group__c!=null)
                        recordTypeName = objUser.Business_Group__c+'-'+requestType.RecordType_Name__c;
                    else
                        recordTypeName = requestType.RecordType_Name__c;
                    if(requestType.isVisualforce__c && requestType.Visualforce_Page_Name__c != null && !SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',requestType.Non_Eligible_Countries__c).contains(objUser.Country)){
                        oSupportRequest.Request_Submitted_From__c = requestType.View_VF_Page_Name__c;
                        redirectVFPageName = requestType.Visualforce_Page_Name__c;
                        oSupportRequest.RecordTypeId = SupportRequestRoutingRulesTriggerUtil.getRecordTypeIDByName(recordTypeName);
                        oSupportRequest.Support_Type__c = requestType.SupportReqType__c;
                        oSupportRequest.Sub_Type__c = requestType.Request_SubType__c;
                    }
                    if((requestType.punchOut_BG__c!=null && !requestType.isVisualforce__c)|| (requestType.isVisualforce__c && SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',requestType.Non_Eligible_Countries__c).contains(objUser.Country))){
                        if(requestType.punchOut_BG__c.contains(objUser.Business_Group__c)){
                            oSupportRequest.recordTypeId=SupportRequestRoutingRulesTriggerUtil.getRecordTypeIDByName(recordTypeName);
                            oSupportRequest.Request_Description__c =Label.SupportRequest_PunchOutDescription;
                            oSupportRequest.Support_Type__c = requestType.SupportReqType__c;
                            oSupportRequest.Sub_Type__c = requestType.Request_SubType__c;
                        }
                    }
                }
            }
            if(oSupportRequest.RecordTypeId != null && oSupportRequest.Opportunity__c != null){
                if(!oPageParamMap.isEmpty()){
                    if(oPageParamMap.containskey('SpecialPricing')){
                        if(oPageParamMap.get('SpecialPricing') == 'Y'){
                            if(redirectVFPageName.contains('PPS')){
                                oSupportRequest.CPQ_Request_Type__c = 'Special Pricing (New OPG)';
                            }
                            else{
                                oSupportRequest.CPQ_Request_Type__c = 'Special Pricing Only';
                            }
                            oSupportRequest.Special_Pricing__c = 'Special Pricing Exists';
                        }
                    }
                }
                insert oSupportRequest;
                system.debug('****redirectVFPageName*****'+redirectVFPageName);
                if(redirectVFPageName == ''){
                    sRedirectURL= '/'+oSupportRequest.id;
                }
                else{
                    sRedirectURL= '/apex/'+redirectVFPageName+'?id='+oSupportRequest.id;
                }
            }
        }
        else{
            System.debug('*******Unable to get the Support Request Maps');
        }
        return(sRedirectURL);
    }
}