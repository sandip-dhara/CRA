/**
* NAME : Apts_OverwriteLegalIssueEditDelete
* NOTE : This is a controller to override the default Edit and Delete functionality and redirect to Agreement.
* Author : Apttus (Shabbir Lahori) 
*/
public with sharing class Apts_OverwriteLegalIssueEditDelete {
	public Legal_Issue__C legalIssueSO {public get; private set;}

	/**
	 *	Constructor to save the legal_Issue object
	 */
	public Apts_OverwriteLegalIssueEditDelete(ApexPages.StandardController stdController) {
		legalIssueSO = (Legal_Issue__C) stdController.getRecord();
	}
	
	/**
	 *	Redirect to the Agreement object of legal Issue.
	 */
	public PageReference forwardToAgreement() {
		PageReference pageRef = new PageReference('/'+legalIssueSO.Agreement__c);
		return pageRef;
	}
}