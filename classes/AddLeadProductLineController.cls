/**********************************************************
* Class Name: AddLeadProductLineController
* Author: Accenture
* Date: 02-JUL-2012 
* Requirement # Request Id: 1769, CR#2056
* Description: Controller to add Lead Products to Lead
***********************************************************/

public class AddLeadProductLineController {
    
    public Product_Interest__c leadproduct{get;set;}    
    public String leadId;
    
    public AddLeadProductLineController(ApexPages.StandardController controller) {
        leadproduct = new Product_Interest__c(); 
        if (ApexPages.currentPage().getParameters().get('leadId') != null) {
        	leadId = ApexPages.currentPage().getParameters().get('leadId');
        	leadproduct.Lead__c = leadId;
    	}
    }
    
    /**
    * @description: Save method to add Lead Products to Lead
    * @return: Redirects to Lead Page after save
    */
    public PageReference save() {   
        try {
            if (leadproduct != null) {
                insert leadproduct;  
            }           
   		} catch (DMLException dmlEx) {
            CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'Lead', 'AddLeadProductLineController', '');
            for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
            }
         	return null;
        }           
        PageReference retPage = null;
        if (leadId != null && leadId != '') {
            retPage = new PageReference('/'+leadId);
        }
        return retPage;              
    }
    
    /**
    * @CR: 2056
    * @description: Save method to add Lead Products to Lead
    * @return: Redirects to Add Product Line after save
    */
    public PageReference saveAndNew() {   
        PageReference returnPage = save();
        returnPage = new Pagereference('/apex/AddLeadProductLine?leadId='+leadId);
        returnPage.setRedirect(true);        
        return returnPage;            
    }
    
    /**
    * @description: Cancel method 
    * @return: Redirects to Lead Page 
    */
    public PageReference cancel() {     
        PageReference retPage = null;
        if (leadId != null && leadId != '') {   
            retPage = new PageReference('/'+leadId);
            retPage.setRedirect(true);
        }
        return retPage;              
    }
}