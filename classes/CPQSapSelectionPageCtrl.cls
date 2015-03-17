public with sharing class CPQSapSelectionPageCtrl {
    public string GetSAPURL{get;set;}
    public Opportunity oOpp;
    public CPQSapSelectionPageCtrl(ApexPages.StandardController controller) {
        this.oOpp = (Opportunity)controller.getRecord();
        string pageMode = ApexPages.currentPage().getParameters().get('pageMode');
        if(pageMode == 'CreateQuote'){
            GetSAPURL = System.Label.CPQSAPUrl + '&I_ACC_NAME='+ApexPages.currentPage().getParameters().get('I_ACC_NAME')+ '&I_OPP_ID='+ApexPages.currentPage().getParameters().get('I_OPP_ID') + '&I_OPP_NAME='+ApexPages.currentPage().getParameters().get('I_OPP_NAME') + '&i_rpl_status='+ ApexPages.currentPage().getParameters().get('i_rpl_status')+ '&I_COUNTRY='+ApexPages.currentPage().getParameters().get('I_COUNTRY')+'&Mode=1&iframe=X';
            //GetSAPURL  = 'https://hp--configdev--c.cs10.visual.force.com/apex/CPQSAPLandingPage?Discounts=22&HIDiscount=12&QuoteEndDate=2014-05-30&OpportunityID=OPP-0001455856&QuoteNetValue=34&QuoteNumber=QuoteNumber&CAemail=mohit.bhatia%40hp.com&QuoteStartDate=2013-05-31&CAName=&ServiceLevel=ServiceLevel&ContractNetValue=44&ContractGrossValue=45&DiscountPercentage=22&ContractItemizedDiscounts=33&QuoteGrossValue=12&Currency=INR&RequestType=RequestType&SpecialPricing=N';
        }
        else if(pageMode == 'EditQuote'){
            //GetSAPURL = System.Label.CPQSAPEditUrl+'&I_Quote=20066605';
            GetSAPURL = System.Label.CPQSAPUrl+'&I_Quote='+ApexPages.currentPage().getParameters().get('I_Quote')+ '&I_ACC_NAME='+ApexPages.currentPage().getParameters().get('I_ACC_NAME')+ '&I_OPP_ID='+ApexPages.currentPage().getParameters().get('I_OPP_ID') + '&I_OPP_NAME='+ApexPages.currentPage().getParameters().get('I_OPP_NAME') + '&i_rpl_status='+ ApexPages.currentPage().getParameters().get('i_rpl_status')+ '&I_COUNTRY='+ApexPages.currentPage().getParameters().get('I_COUNTRY')+'&Mode='+ApexPages.currentPage().getParameters().get('Mode')+'&iframe=X';
        }
    }

}