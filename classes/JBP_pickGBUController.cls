/**********************************************************
* Class Name:JBP_pickGBUController
* Author: HP  
* Date: 10-April-2013 
* Requirement # Request Id: 6195
* Description: This class returns a wrapper list containg sub plan records from which a select and add the sub plans to SI.
* Developer: Sameer N Miraj
**********************************************************/
public with sharing class JBP_pickGBUController{
    
    //Variable Decleration
    public list<gbuWrapperClass> gbuWrapperList{get;set;}
    public id siId;
    public id jbpId;
    
    /*
    @Description: This is the constructor. Capture the Strategic Initiative Id and JBP Plan Id from the URL.
    @param: none.
    @return: void.
    */
    public JBP_pickGBUController(){
        siId = ApexPages.currentPage().getParameters().get('siId');
        jbpId = ApexPages.currentPage().getParameters().get('jbpId');
    }
    
    /*
    @Description: This method retrives a list of Sub-Plan(GBU_Specialization_Plan__c) based on the SI and JBP Plan and the list is displayed in the VF page.
    @param: none.
    @return: list<gbuWrapperClass>.
    */
    
    public list<gbuWrapperClass> getAssociatedGBU(){
        gbuWrapperList = new list<gbuWrapperClass>();
        set<id> removeGbuId = new set<id>();
        
        //Do not show those subplan which are already associated to the Strategic initiatives. 
        for(Strategic_Initiative_Junction__c sij:[SELECT GBU_Specialization_Plan__c 
                                                  FROM Strategic_Initiative_Junction__c 
                                                  WHERE Strategic_Initiative__c =:siId])
        {                                                  
            removeGbuId.add(sij.GBU_Specialization_Plan__c);            
        }
        
        for(GBU_Specialization_Plans__c gbusp:[SELECT id, name, Joint_Business_Plan__c,GBU_Specialization__c, Total_FY_Planned_Sales__c, Total_Actual_FY_Sales__c, Total_FY_Planned_SGA__c, Total_FY_Actual_SGA__c, Total_FY_Allocated_MDF__c, Total_FY_Spent_MDF__c
                                               FROM GBU_Specialization_Plans__c
                                               WHERE Joint_Business_Plan__c =:jbpId AND id NOT IN: removeGbuId])
        {                                               
            gbuWrapperList.add(new gbuWrapperClass(gbusp));
        }
       return gbuWrapperList;
    }
    
    /*
    @Description: This method retrives a list of Sub-Plan(GBU_Specialization_Plan__c) selected in the VF page and adds them to the SI by inserting a record in the Strategic Initiative Junction Object. This is a junction between SI and Sub Plan (GBU Specialization Plan).
    @param: none.
    @return: pageReference.
    */
    
    public pageReference Add(){
        list<Strategic_Initiative_Junction__c> siJunctionList = new list<Strategic_Initiative_Junction__c>();
        for(gbuWrapperClass gbSelected :gbuWrapperList){
            if(gbSelected.Selected){
                Strategic_Initiative_Junction__c sij = new Strategic_Initiative_Junction__c();
                sij.GBU_Specialization_Plan__c = gbSelected.gbu.id;
                sij.Strategic_Initiative__c = siId;
                siJunctionList.add(sij);
            }
        }
        if(siJunctionList.size()>0){
            try{
                insert siJunctionList;
            }catch(exception e){}
            pageReference pagaRef = new pageReference('/'+siId);
            return pagaRef;
        }
        else{
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.Please_select_a_record));
            return null;
        }
    }
    
    /*
    @Description: This method returns a pagereference which redirects the user to return on the SI page when the user hits the cancel Button.
    @param: none.
    @return: pageReference.
    */
    
    public pageReference cancel(){
        pageReference pageRef = new PageReference('/'+siId);
        return pageRef;
    }
    
    //This is a wrapper class. This is used to wrap the Boolean (to determine the selected records) and the Sub Plan record().
    public class gbuWrapperClass{
        public boolean selected{get;set;}
        public GBU_Specialization_Plans__c gbu{get;set;}
        public gbuWrapperClass(GBU_Specialization_Plans__c gbuSpecPlan){
            this.gbu = gbuSpecPlan;
            this.selected = false;     
        }       
    }
}