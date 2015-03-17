public class CPQPartnerHPQuoteController {

    public boolean displaywait {get;set;}
    public String SQRedirectURL {get;set;}
    public String SuccessMessage{get;set;}
    public Opportunity objOppty;
    public User objUser {get;set;}
    public boolean hideButtons{get;set;}
    public CPQPartnerHPQuoteController(ApexPages.StandardController controller) {
        this.objOppty = (Opportunity )controller.getRecord();
        displaywait = false;
        hideButtons = false;
        SuccessMessage = '';
        objUser = [select id,HPPID__c,Partner_Self_Service_Enabled__c,Region__c,Sub_Region__c,Location_Record_Id__c,Portal_Tab_Access__c from user where id=: UserInfo.getUserId()];
        if(objUser.Portal_Tab_Access__c != null){
            if(objUser.Portal_Tab_Access__c.contains('Deal Reg')){
                hideButtons = true;
            }
        }
        
        system.debug('********In Controller****');
    }
    
    public PageReference Wait() {
        displaywait = true;
        return null;
    }
    
    
    public PageReference createQuote() {
        displaywait = true;
        system.debug('*********In Function*****');
        SuccessMessage = '';
        if(!objUser.Partner_Self_Service_Enabled__c){
            SuccessMessage = label.CPQSQPartnerSelfService;
            displaywait = false;
            return null;
        }
        else if(objOppty.Account.MDCP_Organization_ID__c == null || objOppty.Account.MDCP_Organization_ID__c == '' ){
            SuccessMessage = label.CPQSQMDCPOrgID;
            displaywait = false;
            return null;
        }
        else{
            CPQCallSQService oCallSQService = new CPQCallSQService();
            Location__c objLocation = new Location__c();
            CPQCallSQService.ServiceRequestInput oSupInput=new CPQCallSQService.ServiceRequestInput();
            if(objUser.Location_Record_Id__c != null && objUser.Location_Record_Id__c != ''){
                objLocation = [select id,Source_System_Account_ID__c,WorldRegion_Region__c,WorldRegion_SubRegion1__c,World_Region1__c,World_Region1__r.Name,country__c from Location__c where id=: objUser.Location_Record_Id__c];
                if(objLocation != null){
                    oSupInput.Countrycode=objLocation.World_Region1__r.Name;
                    oSupInput.PartnerProId=objLocation.Source_System_Account_ID__c;
                    oSupInput.CountryName=objLocation.Country__c;
                }
            }
            oSupInput.CustOrgId=objOppty.Account.MDCP_Organization_ID__c;
            oSupInput.DealRegId=objOppty.Deal_Id__c;
            oSupInput.FirstName=UserInfo.getFirstName();
            oSupInput.LastName=UserInfo.getLastName();
            oSupInput.HPPUserId=objUser.HPPID__c;
            oSupInput.LanguageCode=UserInfo.getLanguage();
            oSupInput.OptyId=objOppty.Opportunity_ID__c;
            //oSupInput.OptyId= 'OPP-12345678';
            
            //oSupInput.PartnerProId=objOppty.Account.Source_System_Account_ID__c;
            //oSupInput.PartnerProId='0080800';
            oSupInput.mdcpOpsId = objOppty.Account.Mdcp_SiteId__c;
            oSupInput.mdcpOpsiId=objOppty.Account.MDCP_Site_Instance_Id__c;
            List<String> listCompetitorsMDCPID = new List<String>();
            for(Competitors__c objCompetitor : [select id,Competitor_Account__c,Competitor_Account__r.MDCP_Organization_ID__c from Competitors__c where Opportunity__c = : objOppty.Id]){
                if(objCompetitor.Competitor_Account__r.MDCP_Organization_ID__c != null && objCompetitor.Competitor_Account__r.MDCP_Organization_ID__c != '')
                    listCompetitorsMDCPID.add(objCompetitor.Competitor_Account__r.MDCP_Organization_ID__c);
            }
            if(!listCompetitorsMDCPID.isEmpty())
                oSupInput.ListofCompetitorOrgIds = listCompetitorsMDCPID;
            Map<String,String> mapPriceDescriptor = new Map<String,String>();
            mapPriceDescriptor.put(objOppty.CurrencyIsoCode,'');
            oSupInput.PriceDescriptor = mapPriceDescriptor;
            system.debug('*********oSupInput*********'+oSupInput);
            SuccessMessage = oCallSQService.InvokeSQWS(oSupInput);
            system.debug('***************SuccessMessage ***********'+SuccessMessage);
            if(SuccessMessage == 'Success'){
                displaywait = false;
                Map<String,CPQSQURL__c> mapobjCPQSQURL = CPQSQURL__c.getAll();
                if(objLocation != null){
                    if(objLocation.WorldRegion_Region__c != '' && objLocation.WorldRegion_Region__c != null){
                        if(objLocation.WorldRegion_Region__c == 'Americas'){
                            if(mapobjCPQSQURL.containskey(objLocation.WorldRegion_Region__c+':'+objLocation.WorldRegion_SubRegion1__c))
                                SQRedirectURL = mapobjCPQSQURL.get(objLocation.WorldRegion_Region__c+':'+objLocation.WorldRegion_SubRegion1__c).SQ_URL__c;
                        }
                        else{
                            SQRedirectURL = mapobjCPQSQURL.get(objLocation.WorldRegion_Region__c).SQ_URL__c;
                        }
                    }
                }
                
            }
            else{
                //SuccessMessage = 'Error';
                displaywait = false;
            }
        }
        return null;
    }
    
    public PageReference editQuote() {
        SuccessMessage = '';
        if(!objUser.Partner_Self_Service_Enabled__c ){
            SuccessMessage = label.CPQSQPartnerSelfService ;
            displaywait = false;
        }
        else{
            Map<String,CPQSQURL__c> mapobjCPQSQURL = CPQSQURL__c.getAll();
            List<Location__c> listLocation = [select id,Source_System_Account_ID__c,WorldRegion_Region__c,WorldRegion_SubRegion1__c,World_Region1__c,World_Region1__r.Name from Location__c where id=: objUser.Location_Record_Id__c];
            if(!listLocation.isEmpty()){
                if(listLocation[0].WorldRegion_Region__c != '' && listLocation[0].WorldRegion_Region__c != null){
                    if(listLocation[0].WorldRegion_Region__c == 'Americas'){
                        if(mapobjCPQSQURL.containskey(listLocation[0].WorldRegion_Region__c+':'+listLocation[0].WorldRegion_SubRegion1__c))
                            SQRedirectURL = mapobjCPQSQURL.get(listLocation[0].WorldRegion_Region__c+':'+listLocation[0].WorldRegion_SubRegion1__c).SQ_URL__c;
                    }
                    else{
                        SQRedirectURL = mapobjCPQSQURL.get(listLocation[0].WorldRegion_Region__c).SQ_URL__c;
                    }
                }
            }
            else{
                SuccessMessage = label.CPQSQNoLocationFoundPopUp;
            }
        }
        return null;
    }
    
}