/**********************************************************
* Page Name:ABPPdfController Class 
* Author: HP  
* Date: 15-JULY-2012 
* Requirement # Request Id: 
* Description: Generating PDF using Account Plan ID 
**********************************************************/
public class ABPPdfController {
    
    public final Account_Plan__c AcntPlan;
   
    public ID AbpId = ApexPages.currentPage().getParameters().get('Id');
    
      /**
   * @description: Constructor for ABPPdfController controller  
    * @param: parameter - ApexPages.StandardController controller
    */              
 
    public ABPPdfController (ApexPages.StandardController controller) {
    this.AcntPlan= (Account_Plan__c)controller.getRecord();
    
    }

   public ABPBean getpdfData()

    {
     /**
    * @description: Returns Strategic Initiatives
    * @return: parameter - List<Strategic_Initiative__c> List of  Strategic Initiatives 
    */           
     List<Strategic_Initiative__c> si=[select Name,Description_of_the_Initiative__c,Execution_Timeframe__c,HP_Solutions__c from Strategic_Initiative__c where Account_Plan__c =:AcntPlan.id];
      /**
    * @description: Returns Business Unit Plans
    * @return: parameter - List<Business_Unit_Plan__c> List of  Business Unit Plans. 
    */      
     List<Business_Unit_Plan__c> opty=[select bu.Name,bu.BU_Name__c,bu.Current_TAM__c,bu.Current_SOW__c,bu.FY11_Revenue_actuals__c,bu.FY12_Revenue_YTD__c,bu.FY13_Projected_Revenue__c,bu.FY14_Projected_Revenue__c,bu.FY15_Projected_Revenue__c from Business_Unit_Plan__c bu where bu.Account_plan__c=:AcntPlan.id] ;
     /**
    * @description: Returns CustomerBusinessProrities
    * @return: parameter - List<Customer_Business_Priority__c> List of  CustomerBusinessProrities. 
    */      
     List<Customer_Business_Priority__c> cust=[select cust.Name,cust.Short_Description__c,cust.Priority__c,cust.Timing__c,cust.LastModifiedDate  from Customer_Business_Priority__c cust where cust.Account_Plan__c=: AcntPlan.id];
     /**
    * @description: Returns Competitive LandScapes
    * @return: parameter - List<Competitive_Landscape__c> List of  Competitive LandScapes. 
    */      
     List<Competitive_Landscape__c> comp=[select comp.Business_Area__c,comp.Business_Group__c,comp.Current_HP_Share_of_Wallet__c,comp.Summary_of_Competitive_Landscape__c,comp.Competitor_1__c,comp.Competitor_2__c,comp.Competitor_3__c from  Competitive_Landscape__c comp where comp.Account_Plan__C=:  AcntPlan.id];
     /**
    * @description: Returns Customer Relationship Maps
    * @return: parameter - List<Customer_Relationship_Map__c> List of  Customer Relationship Maps. 
    */      
    List<Customer_Relationship_Map__c> influencer=[select influ.Contact__c,influ.Title__c,influ.Role__c,influ.Scope_of_the_contact__c,influ.EG_ESSN__c from Customer_Relationship_Map__c influ where influ.Account_Plan__c=: AcntPlan.id];
             /**
              *@description:Creating ABPBean Object
            */
             
              ABPBean sit=new ABPBean();
             /**
             *set the list of stategic Initiatives to ABPBean.
             */
                       sit.setstategic(si);
               /**
                *set the list of Business Unit Plans to ABPBean.
               */
                        sit.setoptyst(opty);
                /**
                *set the list of Customer Business Priorities to ABPBean.
               */
                        sit.setcustomPriority(cust);
                /**
                *set the list of Competitive LandScapes to ABPBean.
               */
                        sit.setcompetitive(comp);
                /**
                *set the list of Customer Relation Maps to ABPBean.
               */
                       sit.setinfluencer(influencer);
                        /**
                        *return the ABPBean object.
                        */
              return sit ;
    }
    
    }