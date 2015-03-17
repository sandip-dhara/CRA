/**********************************************************
* Class Name: BUQualityScoreCardController
* Author: HP
* Date:15/06/2013
* Requirement # Request Id:6495 
* Description: Controller for BU Plan Quality Scorecard.
              
***********************************************************/


public class BUQualityScoreCardController {
public BU_plan_Scorecard__c bupScorecard;
public String returl {get;set;}
public String SelectedVal {get; set;}
public ID BUPlanId ;
public String SummaryScore=null;
public String abpName{get;set;}
public String user {get; set;}
 public Boolean msgfalse{get;set;}
 public List<BU_Plan_Approval__c> apprecords;

   public BUQualityScoreCardController(ApexPages.StandardController controller) {
        this.bupScorecard= (BU_plan_Scorecard__c)controller.getRecord();
        BUPlanId = ApexPages.currentPage().getParameters().get('buId');
        user = UserInfo.getUserId();
        msgfalse = false;
    }
    
    public BU_plan_Scorecard__c getRelSuite()
    {
    return bupScorecard;
    } 
   public List<SelectOption> getTypes(){
            Schema.sObjectType sobject_type = BU_plan_Scorecard__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('BU_plan_Answer_1__c').getDescribe().getPickListValues();
        
            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));                      
          }
      return options;
   } 
   public List<SelectOption> getAns2(){
            Schema.sObjectType sobject_type = BU_plan_Scorecard__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('BU_plan_Answer_2__c').getDescribe().getPickListValues();
        
            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));                      
          }
      return options;
   } 
   public List<SelectOption> getAns3(){
            Schema.sObjectType sobject_type = BU_plan_Scorecard__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('BU_plan_Answer_3__c').getDescribe().getPickListValues();
        
            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));                      
          }
      return options;
   } 
    public List<SelectOption> getAns4(){
            Schema.sObjectType sobject_type = BU_plan_Scorecard__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('BU_plan_Answer_4__c').getDescribe().getPickListValues();
        
            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));                      
          }
      return options;
   } 
    public List<SelectOption> getAns5(){
            Schema.sObjectType sobject_type = BU_plan_Scorecard__c.getSObjectType();

            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
          
            List<Schema.PicklistEntry> pick_list_values = field_map.get('BU_plan_Answer_5__c').getDescribe().getPickListValues();
        
            List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));                      
          }
      return options;
   } 
      

    Public PageReference Save()
    {
     if(Test.isRunningTest()){ 
         } 
         else
         {
     apprecords = [Select id,Approver__c,Plan_Status__c From BU_Plan_Approval__c where  Business_Unit_Plan__c=:BUPlanId ORDER BY Name DESC limit 1  ];
     }
     
     If( apprecords.size()>0){
     
     If ( apprecords[0].Approver__c == user && apprecords[0].Plan_Status__c != 'Approved' ){
            try { 
            List<BU_plan_Scorecard__c>  scoreIds = [select id, Business_Unit_Plan__c from BU_plan_Scorecard__c where Business_Unit_Plan__c=:BUPlanId ];          
            if(scoreIds.size()>0){
            bupScorecard.id=scoreIds[0].id;        
            update this.bupScorecard;
            }
            else{            
            bupScorecard.Business_Unit_Plan__c=ApexPages.currentPage().getParameters().get('buId'); 
            insert this.bupScorecard;
            }            
            //return new PageReference('/'+BUPlanId);
            //pageReference page = new pageReference(returl);
            PageReference page = new PageReference('/' + BUPlanId);
           // page.setRedirect(true);
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
                    PageReference page = new PageReference('/apex/BUQualityScoreCard?buId=' + BUPlanId); 

            If ( !(apprecords[0].Approver__c == user) ){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'You Cannot Edit/Save the Scorecard,Only Approvers are given privileges to do it.Please Click on "Cancel" to close the Quality Scorecard'));
                 return null;
                  page.getParameters().put('msg','success');
                 return null;
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'BU Plan is already approved'));
                page.getParameters().put('msg','success');
                return null;
            }
            
        }   
        }
        else{
        system.debug('else block');
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'You have no Approvers selected for this BU Plan '));
         PageReference page = new PageReference('/apex/BUQualityScoreCard?buId=' + BUPlanId); 
        page.getParameters().put('msg','success');
        return null;   
        }   
    
    }        
            
   // }
    
     public pageReference cancel(){
        pageReference pr = new pageReference('/' + BUPlanId);
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