/**********************************************************
* Class Name: LeadProductLookupController
* Author: Accenture
* Date: 02-JUL-2012 
* Requirement # Request Id: 1175
* Description: Controller class for Add Level 3 and Level 4 Products to Lead VF Page
***********************************************************
* Author: HP
* Date: 04-SEP-2012 
* Requirement # Request Id: 3218
* Description: Added Search logic on ProductCode,ProductLevel,GBU,ProductLine,BG
***********************************************************/

public class LeadProductLookupController {
    
    public List<Product2> products {set; get;}
    public String searchText {get;set;}
    public String ProdCode {get;set;}
    public String subprdLine {get;set;}
    public String GBU {get;set;}
    public String prdLine {get;set;}
    public String BG {get;set;}
    
     private String sortDirection = 'ASC';
     private String sortExp = 'Name';

       
            /* Author: HP
        * Date: 9-AUG-2012  
        * Requirement # Defect Id-1464(R2.0)
        * @description -  Change the query.Add column Product Level. 
        */ 
    public LeadProductLookupController(ApexPages.StandardController controller) {
        products = [Select Id, Name,  GBU__c, Business_Group__c, Product_Line__c,Sub_Product_Line__c, Product_Level__c, IsActive 
                    From Product2 
                    Where GBU__c != null AND Business_Group__c != null 
                    AND Product_Line__c!= null And IsActive = TRUE limit 25 ];  
    }
    
    /**
    * @description: Method Used by page, on page load to initalize start data
    * 
    */
    public void initialize() {
        searchText = System.currentPageReference().getParameters().get('lksrch');        
        searchProducts();                                                                  
    }
    
    
    
    /**
    * @description: run the search and return the records found. 
    */
    public void searchProducts() {
        String soql = 'Select Id, Name, ProductCode, GBU__c, Business_Group__c, Product_Line__c, Sub_Product_Line__c, Product_Level__c from Product2 where GBU__c != null AND Business_Group__c != null AND Product_Line__c != null And IsActive = TRUE';
        String whereCondition = '';
        String tmpSearchText = searchText;
        if (tmpSearchText != null && tmpSearchText != '') {
            system.debug('-->before query : '); 
            tmpSearchText = tmpSearchText.replaceAll('\\*','%');
            whereCondition = whereCondition +  ' and Name LIKE \'' + tmpSearchText +'%\' ';
        }
              
        if(subprdLine != null && subprdLine != ''){
            subprdLine = subprdLine .replaceAll('\\*','%');
            whereCondition = whereCondition +  ' and Sub_Product_Line__c LIKE \'' + subprdLine+'%\' '; 
        }
        if(GBU != null && GBU != ''){
            GBU = GBU.replaceAll('\\*','%');
            whereCondition = whereCondition +  ' and GBU__c LIKE \'' + GBU+'%\' ';         
        }
        if(prdLine != null && prdLine != ''){
            prdLine = prdLine.replaceAll('\\*','%');
            whereCondition = whereCondition +  ' and Product_Line__c LIKE \'' + prdLine +'%\' ';         
        }
        /*if(BG != null && BG != ''){
            BG = BG.replaceAll('\\*','%');
            whereCondition = whereCondition +  ' and Business_Group__c LIKE \'' + BG+'%\' ';         
        }*/
        if(BG != null && BG != ''){
           // BG = BG.replaceAll('\\*','%');
            whereCondition = whereCondition +  ' and Business_Group__c LIKE \'' + BG+'%\' ';         
        }

       /* else{
            whereCondition = '';
        }*/
        soql = soql + whereCondition + ' limit 25';
        System.debug('**********************'+soql);
        products = database.query(soql);            
    }
    
    /**
    * @description: used by the visualforce page to send the link to the right dom element
    * @return: String returns url lkfm(form) paramter value
    */
    public String getFormTag() {
        return System.currentPageReference().getParameters().get('lkfm');
    }

    /**
    * @description: sed by the visualforce page to send the link to the right dom element for the text box
    * @return: String returns url lknm paramter value
    */
    public String getTextBox() {
        return System.currentPageReference().getParameters().get('lknm');
    } 
    
    /**
    * @description: For displaying BG LOV in VF page
    * @return: List of Values of BG
    */
    public List<SelectOption> getBGs() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.sObjectType sobject_type = Product2.getSObjectType(); 
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();     
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Business_Group__c').getDescribe().getPickListValues();
        options.add(new SelectOption('','--None--'));
        for (Schema.PicklistEntry a : pick_list_values) { 
            options.add(new selectOption(a.getValue(),a.getLabel()));
        }
        return options;
    }
 
    /**
    * @description: For displaying GBU LOV in VF page
    * @return: List of Values of GBU
    */  
     public List<SelectOption> getGBUs() {
        List<SelectOption> option = new List<SelectOption>(); 
        Schema.sObjectType sobject_type = Product2.getSObjectType(); 
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();     
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
        List<Schema.PicklistEntry> pick_list_values = field_map.get('GBU__c').getDescribe().getPickListValues();
        option.add(new SelectOption('','--None--'));
        for (Schema.PicklistEntry a : pick_list_values) {
            option.add(new selectOption(a.getValue(),a.getLabel())); 
        }
        return option;
    } 
    
         /* Author: Yvette Ala
     * Date: 22-AUG-2012  
     * Requirement # Defect 2494(R2.0)
     * @description -  Add sorting capability on columns". 
     */
      
   /* Start of code for defect 2494*/
    public String sortExpression  
    {    
           get     {        
               return sortExp;
            }
            set  
            {
                // if the column is clicked on then switch between Ascending and Descending modes       
               if (value == sortExp)
                   sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
               else
                   sortDirection = 'ASC';

               sortExp = value;
            }
              
     }
             
    public String getSortDirection() {
        //if not column is selected     
        if (sortExpression == null || sortExpression == '')      
            return 'ASC';
        else
            return sortDirection;
    }
    
    public void setSortDirection(String value) {     
        sortDirection = value; 
    }
    
    public List<Product2> getProducts() {       
        return products;  
    }
             
    public PageReference ViewData() {
    
      //build the full sort expression       
      string sortFullExp = sortExpression  + ' ' + sortDirection;            
      //query the database based on the sort expression       
      products = Database.query('Select Id, Name, ProductCode, GBU__c, Business_Group__c, Product_Line__c, Sub_Product_Line__c, Product_Level__c from Product2 where GBU__c != null AND Business_Group__c != null AND Product_Line__c != null And IsActive = TRUE order by ' + sortFullExp + ' limit 1000');
    
      return null;   
      }
      /* End of code for defect 2494 */

               
}