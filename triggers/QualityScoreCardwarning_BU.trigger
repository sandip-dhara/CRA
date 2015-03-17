/**********************************************************
* Class Name: QualityScoreCardwarning_BU
* Author: HP
* Date:15/06/2013
* Requirement # Request Id:6495 
* Description:Trigger to display error message when Quality Scorecard not filled before Approval.
              
***********************************************************/

trigger QualityScoreCardwarning_BU on BU_Plan_Approval__c (before insert, before update) {

String[] zeroFieldNames = new String[5];
BU_Plan_Approval__c apr = Trigger.New[0];
Business_Unit_Plan__c bup = [Select id,Q1__c,Q2__c,Q3__c,Q4__c,Q5__c,Score__c from Business_Unit_Plan__c where id =: apr.Business_Unit_Plan__c];
List<BU_plan_Scorecard__c> score = [Select id from BU_plan_Scorecard__c where Business_Unit_Plan__c = :bup.id];
String salesforceurl = system.label.SFDC_URL;
 for ( BU_Plan_Approval__c account : system.Trigger.New) {
     
     If(account.Plan_Status__c == 'Approved'&&(bup.Q1__c == 0 || bup.Score__c == NULL || bup.Score__c == 0.0 ||  bup.Q1__c == NULL ||bup.Q2__c == 0 ||bup.Q2__c == NULL || bup.Q3__c == 0 ||bup.Q3__c == NULL || bup.Q4__c == 0 || bup.Q4__c == NULL ||bup.Q5__c == 0 ||bup.Q5__c == NULL || score.size() == 0 )){
        
        String errorString = '<b><br/>Some of the questions in the BU Plan Quality Score Card have been left unanswered.Please complete the BU Plan Quality Score Card <br/></b><a style="size:100%;color: #FF0000;></a> ';
        
        errorString += '</font><a style="size:100%;color: #FF0000; font-size: 10pt; width: 10%; font-weight:bold;text-align:left" href=\''+salesforceurl+''+ bup.Id + '\'> ' + 'Please click here to go back to the BU plan to access the Quality Scorecard'  + '</a>';
        
        account.addError(errorString);
     
    }


}
     update bup;

}