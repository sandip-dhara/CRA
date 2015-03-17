/*
* NAME : ReceiveFromOtherPartyOrHP
* NOTE : Class used when user clicks on "Receive from HP Review" or "Receive from Other Party Review" Button,
*		 if clicked on "Receive from Other Party Review" this will update status progress to "Other Party Review Completed", set Last Customer Response to current Date Time,
*		 and increments the number of times other party Review by 1.
*		 if clicked on "Receive from HP Review" this will update status progress to "HP Review Completed", set HP Review Completed to current Date/Time,
*		 and increments the number of times HP Review by 1.
* Author : Apttus (Axay Varu)
*/
public with sharing class ReceiveFromOtherPartyOrHP {
	
	public static ID AgreementID {get;set;}
	public static string action {get;set;}
	
	public PageReference changeAgreementStatus()
	{
		AgreementID = ApexPages.currentPage().getParameters().get('id');
		action = ApexPages.currentPage().getParameters().get('action');
		
		Apttus__APTS_Agreement__c  agrmnt = [SELECT ID,Other_Party_Review_Status__c,HP_Review_Status__c,Last_customer_response__c,Number_of_times_HP_Review__c,Number_of_times_Other_Party_Review__c FROM Apttus__APTS_Agreement__c WHERE ID = :AgreementID];
		
		if(action.equals('receiveOther') && AgreementID != null) // if pressed on Receive from Other Party Review
		{
			//Do Something when Click on Receive from Other Party Review
			
			agrmnt.Other_Party_Review_Status__c = 'Other Party Review Completed';
			agrmnt.Last_customer_response__c = System.now();
			if(agrmnt.Number_of_times_Other_Party_Review__c != null){
				agrmnt.Number_of_times_Other_Party_Review__c = agrmnt.Number_of_times_Other_Party_Review__c + 1;
			}
			else{
				agrmnt.Number_of_times_Other_Party_Review__c = 1;
			}
		}
		else if(action.equals('receiveHP') && AgreementID != null) // if pressed on Receive from HP Review
		{
			//Do Something when Click on Receive from HP Review
			agrmnt.HP_Review_Status__c = 'HP Review Completed';
			agrmnt.HP_Review_Completed_Date__c = System.now();
			if(agrmnt.Number_of_times_HP_Review__c != null){
				agrmnt.Number_of_times_HP_Review__c = agrmnt.Number_of_times_HP_Review__c + 1;
			}
			else{
				agrmnt.Number_of_times_HP_Review__c = 1;
			}
		}
		
		update agrmnt;
		
		return new PageReference('/'+AgreementID);
	}

}