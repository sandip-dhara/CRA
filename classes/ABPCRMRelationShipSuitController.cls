/**********************************************************
* Trigger Name: ABPCRMRelationShipSuitController 
* Author: HP
* Date: 19/09/2012
* Requirement # Request Id:3255 
* Description: ABPCRMRelationShipSuitController has been using create & edit the Customer Relationship Map records .
              
***********************************************************/


public class ABPCRMRelationShipSuitController {
public Customer_Relationship_Map__c RelSuite;
public String retURL {get;set;}
public ID AccId ;
    
    public ABPCRMRelationShipSuitController(ApexPages.StandardController controller) {
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        this.RelSuite = (Customer_Relationship_Map__c)controller.getRecord();
        this.AccId= RelSuite.Account_Plan__c;
        
       
    }
    
    public Customer_Relationship_Map__c getRelSuite()
    {
    return RelSuite;
    }
 public List<SelectOption> AbpContacts {get
        {List<Customer_Relationship_Map__c> ContactList = new List<Customer_Relationship_Map__c>();
      ContactList = [Select Contact__r.Id,Contact__r.Name,Contact__c from Customer_Relationship_Map__c  where Account_Plan__c =:this.AccId and
             Contact__c <> :this.RelSuite.Contact__c ];
        List<SelectOption> options= new List<SelectOption>();
        options.add(new SelectOption('','Please Select'));
        for (Customer_Relationship_Map__c option:ContactList)
            {
            if(option.Contact__r != null)
            options.add(new SelectOption(option.Contact__r.name,option.Contact__r.name));
            
            }
            return options;
        }
        set;
     }
    
   
    Public PageReference Save()
    {
    try { 

            ApexPages.StandardController controller = new ApexPages.StandardController(RelSuite);
            
            //controller.save();
            upsert this.RelSuite;
            pageReference pr = cancel();
            return pr;
            
            }
            catch (DmlException dmlEx) {
            for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
            }
            return null;
            }
            
    }
            
   // }
    
     public pageReference cancel(){
        pageReference pr = new pageReference(retURL);
        pr.setRedirect(true);
        return pr;
        
    }
    
     
     
    
}