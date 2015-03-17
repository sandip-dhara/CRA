/**********************************************************
* Class Name: QualityScoreCardwarning
* Author: HP
* Date:15/06/2013
* Requirement # Request Id:6495 
* Description:Trigger to display error message when Quality Scorecard not filled before Approval.
              
***********************************************************/
trigger QualityScoreCardwarning on ABP_Approval__c (before insert, before update) {

String[] zeroFieldNames = new String[9];
ABP_Approval__c apr = Trigger.New[0];
Account_Plan__c abp = [Select id, Plan_Status__c,Account_Summary_Score__c ,Customer_Biz_Priority_Score__c,Total_Customer_Experience_Score__c,Partner_Landscape_Score__c,Competitive_Landscapes_Score__c,Business_Unit_Plans_Score__c,HP_Strategic_Initiatives_Score_1__c,Customer_Relationship_Maps_Score__c from Account_Plan__c where id =: apr.Account_Plan__c];
List<ABP_Scorecard__c> score = [Select id from ABP_Scorecard__c where Account_Plan__c = :abp.id];
String salesforceurl =  System.Label.SFDC_URL;

System.debug('========'+salesforceurl);
 for ( ABP_Approval__c account : system.Trigger.New) {
     system.debug ('++++++'+score.size());
     If(account.Plan_Status__c == 'Approved'&&(abp.Business_Unit_Plans_Score__c == NULL||abp.Total_Customer_Experience_Score__c == NULL||abp.Customer_Biz_Priority_Score__c == NULL||abp.Account_Summary_Score__c == NULL|| abp.Account_Summary_Score__c == 0 || abp.Business_Unit_Plans_Score__c == 0 || abp.Competitive_Landscapes_Score__c == NULL ||abp.Partner_Landscape_Score__c== NULL ||abp.HP_Strategic_Initiatives_Score_1__c == NULL|| abp.Competitive_Landscapes_Score__c == 0 ||abp.Customer_Relationship_Maps_Score__c == NULL||abp.HP_Strategic_Initiatives_Score_1__c == NULL || abp.HP_Strategic_Initiatives_Score_1__c == 0 || abp.Customer_Biz_Priority_Score__c == 0|| abp.Customer_Relationship_Maps_Score__c == 0 ||abp.Partner_Landscape_Score__c == 0 ||abp.Total_Customer_Experience_Score__c == 0 || score.size() ==0 )){
        if (abp.Business_Unit_Plans_Score__c == NULL || abp.Business_Unit_Plans_Score__c == 0) {
                zeroFieldNames[0] = 'Business Unit Plans';
        } 
        if (abp.Customer_Biz_Priority_Score__c == NULL ||abp.Customer_Biz_Priority_Score__c == 0) {
                zeroFieldNames[1] = 'Customer Business Priorities';
        } 
        if (abp.Account_Summary_Score__c == NULL ||abp.Account_Summary_Score__c == 0) {
                zeroFieldNames[2] = 'Account Summary';            
        } 
        if (abp.Competitive_Landscapes_Score__c == NULL ||abp.Competitive_Landscapes_Score__c == 0) {
                zeroFieldNames[3] = 'Competitive Landscapes';            
        } 
         
        if (abp.HP_Strategic_Initiatives_Score_1__c == NULL ||abp.HP_Strategic_Initiatives_Score_1__c== 0) {
                zeroFieldNames[4] = 'HP Strategic Initiatives';            
        } 
        if (abp.Customer_Relationship_Maps_Score__c == NULL || abp.Customer_Relationship_Maps_Score__c== 0) {
                zeroFieldNames[5] = 'Customer Relationship Maps';            
        } 
        if (abp.Partner_Landscape_Score__c== NULL ||abp.Partner_Landscape_Score__c == 0) {
                zeroFieldNames[6] = 'Partner Alliance';            
        } 
        if (abp.Total_Customer_Experience_Score__c == NULL ||abp.Total_Customer_Experience_Score__c == 0) {
                zeroFieldNames[7] = 'Total Customer Experience';            
        } 
        String errorString = '<b><br/>The score Card is Incomplete,Please ensure the Quality Scorecard is filled-in for the sections listed below : <br/></b><font  color="red"> ';
        Integer count = 0;
            errorString += '<ul>';
            for (String s :zeroFieldNames) {
                if (!(s == null)){
                    //if (!(count == 0)) errorString += ',';
                    errorString += '<b><br/> <li>' + s ;
                }
            }
            errorString += '</ul>';
        errorString += '</font></b> <a style="size:100%;color: #FF0000; font-size: 10pt; width: 10%; font-weight:bold;text-align:left" href=\''+salesforceurl+'' + abp.Id + '\'> ' + 'Please click here to go back to the account plan and access the Quality Scorecard'  + '</a>';
        
        account.addError(errorString);
     
    }


}
     update abp;

}