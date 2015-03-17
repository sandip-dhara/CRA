/***************************************************************
Author: Mousumi Panda
Created Date: 26-APR-2013
Release: R5
Capability: Deal Governance
Description:Controller is used to overriding the New page to route to record type selection page
****************************************************************/

public with sharing class DGApprovalRecordTypeUrlController {
    public string parentId{get;set;}
    public string lookupIdCheck;

    public DGApprovalRecordTypeUrlController (ApexPages.StandardController controller) {
        string returl= ApexPages.currentPage().getParameters().get('retURL');
        lookupIdCheck= ApexPages.currentPage().getParameters().get('CF00NG0000009G4CJ_lkid');
       
        if(lookupIdCheck=='' || lookupIdCheck==null){
         parentId = returl.substringAfter('/');
        
        }
        else{
        parentId = lookupIdCheck;
        }
        }
/*To get the URL and  pass the parameter to view the record type*/
    public PageReference url() {
        SObject parent = Database.query('select RecordType.DeveloperName from Opportunity' 
                + ' where Id = :parentId');
        String parentDeveloperName = (String) parent.getSobject('RecordType').get('DeveloperName');
        system.debug('parent----'+parent);
        system.debug('parentDeveloperName----'+parentdevelopername);
        PageReference Newpage = new PageReference('/apex/DGApprovalRecordSelectionPage');
        newPage.getParameters().put('RecordidName', parentdevelopername);
        newPage.getParameters().put('Opportunityid', parentid);
        return NewPage;
    }


}