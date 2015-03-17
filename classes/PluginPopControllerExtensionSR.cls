public with sharing class PluginPopControllerExtensionSR
{
    private final Support_Request__c sr;
    public String LinkColor {get; set;}
    public String ReferenceContentCaption {get; set;}
    public PluginPopControllerExtensionSR(ApexPages.StandardController stdController) {
        this.sr = (Support_Request__c)stdController.getRecord();
        roi__RVWebservice__c st = roi__RVWebservice__c.getValues('Settings');
        if(st == null || st.roi__LinkColor__c == null || st.roi__LinkColor__c == '') {
            LinkColor = 'blue';
        } else {
            LinkColor = st.roi__LinkColor__c;
        }
        if(st == null || st.roi__Reference_Content_Label__c == null || st.roi__Reference_Content_Label__c == '') {
            ReferenceContentCaption = 'Reference View';
        } else {
            ReferenceContentCaption = st.roi__Reference_Content_Label__c;
        }
    }
    public String getRelatedContent() {
        return (new presearchSR.SFSoap()).RetrieveOpportunityMatches(UserInfo.getSessionId() + '|||https://' + ApexPages.currentPage().getHeaders().get('Host') + '/services/Soap/u/23.0/' + UserInfo.getOrganizationId().substring(0, 15) + '|||' + sr.Opportunity__c);
    }
}