/**********************************************************
* Class Name: ABPQualityScoreCardController
* Author: HP
* Date:15/06/2013
* Requirement # Request Id:6495 
* Description: Controller for Account Plan Quality Scorecard.
              
***********************************************************/

public class ABPQualityScoreCardController {
public ABP_Scorecard__c abpScoreCard;
public String returl {get;set;}
public String SelectedVal {get; set;}
public ID accPlanId ;
public String SummaryScore=null;
public String abpName{get;set;}
public String user {get; set;}
public List<ABP_Approval__c> apprecords;


    
    public ABPQualityScoreCardController(ApexPages.StandardController controller) {
        this.abpScoreCard= (ABP_Scorecard__c)controller.getRecord();
        accPlanId = ApexPages.currentPage().getParameters().get('abpId');
          user = UserInfo.getUserId();
          msgfalse = false;
    }
    
    public ABP_Scorecard__c getRelSuite()
    {
    return abpScoreCard;
    } 
   public List<SelectOption> getTypes(){
            Schema.sObjectType sobject_type = ABP_Scorecard__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('Account_Summary_Answer__c').getDescribe().getPickListValues();
        
            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));                      
          }
      return options;
   } 
   
   
            public List<SelectOption> getinnagenda(){
            Schema.sObjectType sobject_type = ABP_Scorecard__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('Innovation_Agenda_Answer__c').getDescribe().getPickListValues();
        
            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));                      
          }
      return options;
   } 
   
          public List<SelectOption> getcbp(){
            Schema.sObjectType sobject_type = ABP_Scorecard__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('Customer_Business_Priorities_Answer__c').getDescribe().getPickListValues();
        
            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));                      
          }
      return options;
   } 
       public List<SelectOption> getHPSI_1(){
            Schema.sObjectType sobject_type = ABP_Scorecard__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('HP_Strategic_Initiatives_Answer_2__c').getDescribe().getPickListValues();
        
            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));                      
          }
      return options;
   } 
    public List<SelectOption> getHPSI_2(){
            Schema.sObjectType sobject_type = ABP_Scorecard__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('HP_Strategic_Initiatives_Answer_1__c').getDescribe().getPickListValues();
        
            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));                      
          }
      return options;
   } 
   public List<SelectOption> getBUplans(){
            Schema.sObjectType sobject_type = ABP_Scorecard__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('Business_Unit_Plans_Answer__c').getDescribe().getPickListValues();
        
            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));                      
          }
      return options;
   } 
    public List<SelectOption> getComLand(){
            Schema.sObjectType sobject_type = ABP_Scorecard__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('Competitive_Landscapes_Answer__c').getDescribe().getPickListValues();
        
            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));                      
          }
      return options;
   } 
   
    public List<SelectOption> getCRMaps_1(){
            Schema.sObjectType sobject_type = ABP_Scorecard__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('Customer_Relationship_Maps_Answer_1__c').getDescribe().getPickListValues();
        
            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));                      
          }
      return options;
   } 
    public List<SelectOption> getCRMaps_2(){
            Schema.sObjectType sobject_type = ABP_Scorecard__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('Customer_Relationship_Maps_Answer_2__c').getDescribe().getPickListValues();
        
            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));                      
          }
      return options;
   } 
    public List<SelectOption> getCRMaps_3(){
            Schema.sObjectType sobject_type = ABP_Scorecard__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('Customer_Relationship_Maps_Answer_3__c').getDescribe().getPickListValues();
        
            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));                      
          }
      return options;
   } 
    
  public List<SelectOption> getCRMaps_4(){
            Schema.sObjectType sobject_type = ABP_Scorecard__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('Customer_Relationship_Maps_Answer_4__c').getDescribe().getPickListValues();
        
            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));                      
          }
      return options;
   } 
    
   public Boolean msgfalse{get;set;}
    Public PageReference Save()
    {      
      if(Test.isRunningTest()){ 
         } 
         else
         {
             apprecords = [Select id,Approver__c,Plan_Status__c From ABP_Approval__c where Account_Plan__c=:accPlanId ORDER BY Name DESC limit 1  ];
         } 
     If( apprecords.size()>0){
     If ( (apprecords[0].Approver__c == user) && (!apprecords[0].Plan_Status__c.equals('Approved'))){
            try { 
                List<ABP_Scorecard__c>  scoreIds = [select id, Account_Plan__c from ABP_Scorecard__c where Account_Plan__c=:accPlanId];          
                if(scoreIds.size()>0){
                abpScoreCard.id=scoreIds[0].id;        
                update this.abpScoreCard;
                }
                else{            
                abpScoreCard.Account_Plan__c=ApexPages.currentPage().getParameters().get('abpId'); 
                insert this.abpScoreCard;
                }            
                //return new PageReference('/'+accPlanId);
                //pageReference page = new pageReference(returl);
                PageReference page = new PageReference('/' + accPlanId);
                //page.setRedirect(false);
                msgfalse = true;
                Apexpages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Record Saved Successfully'));
                return null;
            }
            catch (DmlException dmlEx) {
                for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
                }
                return null;
            }
                         
        }
        else{
            PageReference page = new PageReference('/apex/ABPQualityScoreCardPage?abpId=' + accPlanId);
            If ( !(apprecords[0].Approver__c == user) ){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'You Cannot Edit/Save the Scorecard,Only Approvers are given privileges to do it.Please Click on "Cancel" to close the Quality Scorecard'));
                 //page.setRedirect(true);
                 page.getParameters().put('msg','success');
                 return null;
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Account Plan is already approved'));
                //page.setRedirect(true);
                page.getParameters().put('msg','success');
                return null;
            }   
        }   
        }
        else{
        system.debug('else block');
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'You have no Approvers selected for this Account Plan'));
        PageReference page = new PageReference('/apex/ABPQualityScoreCardPage?abpId=' + accPlanId); //ApexPages.currentPage(); 
        //page.setRedirect(true);
        page.getParameters().put('msg','success');
        return null;  
        }   
    }
            
   // }
    
     public pageReference cancel(){
        pageReference pr = new pageReference('/' + accPlanId);
        pr.setRedirect(false);
        return null;        
    }
    
    public String getSummaryScore() {
    return SummaryScore;
        }

    public void setSummaryScore(String SummaryScore) { 

        this.SummaryScore= SummaryScore; 
        } 
   
    public class MyException extends Exception {}
     
    
}