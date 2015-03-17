/*
* NAME : ApttusButtonIntermediate
* NOTE : this class is used when user clicks on "Send for wet Signature" button, it will update sent for wet signature bid date to current time/date
* Author : Apttus (Axay Varu)
*/
public with sharing class ApttusButtonIntermediate {
    
    public ID ids {get; set;}
    public Apttus__APTS_Agreement__c agmt{get;  set;}
    public String action {get;	set;}
    public String toUrl {get;	set;}
    
    public ApttusButtonIntermediate(ApexPages.StandardController controller) {
    	agmt = (Apttus__APTS_Agreement__c) controller.getRecord();
    }
    /*
    public ApttusButtonIntermediate() {
    }*/
    public PageReference navigateTo () { // action method load on Page Load
    	ids = null;
    	System.debug('***Inside NavigateTo::'+agmt);
    	ids = ApexPages.currentPage().getParameters().get('id');
    	action = ApexPages.currentPage().getParameters().get('action');
    	PageReference pr = null;
    	if(ids != null)
    		{
        		agmt = [SELECT ID,Sent_for_eSignature_Date__c,Sent_for_Wet_Signature_Bid_Date__c,Date_fully_signed_eSignature__c FROM Apttus__APTS_Agreement__c WHERE ID = :ids LIMIT 1];
    			}
    	if(action == 'eSignature') // this portion is removed - not used
    		{
        		agmt.Sent_for_eSignature_Date__c = System.now();
        		toUrl = '/apex/Apttus_DocuSign__SelectAttachment?id='+ids;
    			}
    	else if(action == 'wetSignature')
    		{
        		agmt.Sent_for_Wet_Signature_Bid_Date__c = System.now();
        		toUrl = '/apex/Apttus__SendEmail?id='+ids+'&action=Send_To_Other_Party_For_Signatures';
    			}
    	else if(action == 'signedSignature') // this is also removed - not used
    		{
        		agmt.Date_fully_signed_eSignature__c = System.now();
        		toUrl = '';
    			}
    	else
    	{
    		agmt = null;
    		toUrl = '/'+ids;
    	}
        if(agmt != null)
        	{
        		update agmt;
        		}
        return new PageReference(toUrl);
    	
    }

}