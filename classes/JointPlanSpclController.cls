/**
 * Class Name: JointPlanSpclController 
 * Author: HP
 * Date: 27-Mar-2013 
 * Requirement # Request Id: 5357
 * Description: To check if there are Program product Association records, if exists should not allow to change the All product eligible to true
 */
public with sharing class JointPlanSpclController {

    public string mainAcctID{get;set;}
    public string PlanBG {get;set;}

    /* Constructer */
    public JointPlanSpclController(ApexPages.StandardController std)
    {  
        mainAcctID = [select Partner_Account__c from JBP__c where id = :std.getId()].Partner_Account__c;
        PlanBG  = [select BG__c from JBP__c where id = :std.getId()].BG__c;
    }
    /**
     * @description: To return the List of Extended Profile Category Item
     * @return: List of Extended profile category Item Asgn records
     * 
     */
    public list<Extended_Profile_Category_Item_Asgn__c> getspclList(){
       return  [Select Item_Type__c,Location__r.Name,Item_Business_Area_Group__c,Extended_Profile_Category_Item__r.Name,Name,Effective_Date__c,Expiry_Date__c, Status__c, Extended_Profile_Category_Item__r.Extended_Profile_Category__c 
                 From Extended_Profile_Category_Item_Asgn__c 
                 where Account__c =:mainAcctID and Effective_Date__c<=TODAY and (Expiry_Date__c>=TODAY or Expiry_Date__c = Null)
                 and Status__c LIKE:'%'+ 'Assigned' +'%' and ((Item_Type__c =: Label.Specialisation and (Item_Business_Area_Group__c LIKE :'%'+PlanBG+'%'or Item_Business_Area_Group__c=: Label.Pan_HP)) or (Extended_Profile_Category_Item__r.Extended_Profile_Category__r.Name=: Label.Partner_Membership_PartnerOne and (Item_Business_Area_Group__c LIKE:'%'+PlanBG+'%' or Item_Business_Area_Group__c=: Label.Pan_HP)))
                 Order By Item_Type__c,Item_Business_Area_Group__c];
    }   
}