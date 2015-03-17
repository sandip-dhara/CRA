/**********************************************************
* Class Name:JBP_pickSIController
* Author: HP  
* Date: 10-April-2013 
* Requirement # Request Id: 6209
* Description: This class returns a wrapper list containg SI records from which a user selects and add the SI  to sub plan.
**********************************************************/
public with sharing class JBP_pickSIController{
    
    //Variable Declaration
    public list<SIWrapperClass> SIWrapperList{get;set;}
    public id gbuId;
    public id jbpId;
    
    /*
    @Description: This is the constructor. Capture the sub plan Id and JBP Plan Id from the URL.
    @param: none.
    @return: void.
    */
    public JBP_pickSIController(){
        gbuId = ApexPages.currentPage().getParameters().get('gbuId');
        jbpId = ApexPages.currentPage().getParameters().get('jbpId');
    }
    
    /*
    @Description: This method retrives a list of Strategic Initiative(SI) based on the sub-plan as well as JBP Plan and the list is displayed in the VF page.
    @param: none.
    @return: list<SIWrapperClass>.
    */
    
    public list<SIWrapperClass> getAssociatedSI(){
        SIWrapperList = new list<SIWrapperClass>();
        set<id> removeSIIdSet = new set<id>();
        //Do not show those Strategic initiativeswhich are already associated to the Sub plan. 
        for(Strategic_Initiative_Junction__c sij:[SELECT Strategic_Initiative__c 
                                                  FROM Strategic_Initiative_Junction__c 
                                                  WHERE GBU_Specialization_Plan__c =:gbuId]){
            removeSIIdSet.add(sij.Strategic_Initiative__c);
        }
        for(JBP_Strategic_Initiative__c SIjbp:[SELECT id, name, Strategic_Initiative_Name_picklist__c, Description__c, Expected_Result_Curr__c,Start_Date__c,End_Date__c, Complete__c, HP_Investment_Curr__c, Partner_Investment_Curr__c
                                               FROM JBP_Strategic_Initiative__c 
                                               WHERE Joint_Business_Plan__c =:jbpId AND id NOT IN: removeSIIdSet]){
            SIWrapperList.add(new SIWrapperClass(SIjbp));
        }
       return SIWrapperList;
    }
    
    /*
    @Description: This method retrives a list of  SI selected in the VF page and adds them to the Sub-Plan(GBU_Specialization_Plan__c) by inserting a record in the Strategic Initiative Junction Object. This is a junction between SI and Sub Plan (GBU Specialization Plan).
    @param: none.
    @return: pageReference.
    */
    
    public pageReference Add(){
        list<Strategic_Initiative_Junction__c> siJunctionList = new list<Strategic_Initiative_Junction__c>();
        for(SIWrapperClass SISelected :SIWrapperList){
            if(SISelected.selected){
                Strategic_Initiative_Junction__c sij = new Strategic_Initiative_Junction__c(GBU_Specialization_Plan__c = gbuId,
                                                                                            Strategic_Initiative__c    = SISelected.jbpStI.id);
                siJunctionList.add(sij);
            }
        }
        if(siJunctionList.size()>0){
            try{
                insert siJunctionList;
            }catch(exception e){}
            pageReference pageRef = new PageReference('/'+gbuId);
            return pageRef;
        }
        else{
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.Please_select_a_record));
            return null;
        }
    }
    
    /*
    @Description: This method returns a pagereference which redirects the user to return on the GBU page when the user hits the cancel Button.
    @param: none.
    @return: pageReference.
    */
    
    public pageReference cancel(){
        pageReference pageRef = new PageReference('/'+gbuId);
        return pageRef;
    }
    
    //This is a wrapper class. This is used to wrap the Boolean (to determine the selected records) and the SI .
    public class SIWrapperClass{
        public boolean selected{get;set;}
        public JBP_Strategic_Initiative__c jbpStI{get;set;}
        public SIWrapperClass(JBP_Strategic_Initiative__c jbpSI){
            this.jbpStI = jbpSI;
            this.selected= false;     
        }       
    }
}