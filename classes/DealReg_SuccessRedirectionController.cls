/**********************************************************
* Class Name: DealReg_SuccessRedirectionController
* Author: HP Release 3
* Date: 15-Oct-2012 
* Requirement # Request Id:
* Description: Used to Redirect the page to success once submit for approval
***********************************************************/
public class DealReg_SuccessRedirectionController {

    public Id opptyId;
    
/*
*@description : Below method returns Success Message
*/ 
    public string getSuccess(){
    return 'Deal has been submitted for Approval';
    }
    
    public DealReg_SuccessRedirectionController (ApexPages.StandardController controller) {
       opptyId =ApexPages.currentPage().getParameters().get('id');
     }
       
/*
*@description : Below method returns Opportunity Detail page
*/     
        public Pagereference sucessMessage(){
            PageReference page=new PageReference('/'+opptyId);
            return page;
           }
    
}