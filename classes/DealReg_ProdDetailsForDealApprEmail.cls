/**
* Class Name: ProductDetailsForDealApprovalEmail
* Author: HP
* Date: 12-OCT-2012 
* This class is used to get the product details to send deal approval mail to configured users when
* their is a change in oppty for the status approved / rejected. This email template will be called from the workflow.
* Last Modified :Modified for Deal Registration 
*/
public Class DealReg_ProdDetailsForDealApprEmail
    {
        Public List<WrapperProductrLineItemForEmail> optyStatus {get; set;}
        Public List<Product_Registration__c> optyStatusList {get; set;}
        Public List<Product_Registration__c> optyValues {get; set;}
        public static ID dealOpptyID;
        public ID getDealOpptyID(){ return dealOpptyID; }
        public void setDealOpptyID(ID oId){
        dealOpptyID = oId;
        DealReg_ProdDetailsForDealApprEmail();
        } 
        
   /*
   * This Constroctor is used to get the product details to send deal approval mail to configured users when
   * their is a change in oppty for the status approved / rejected. This email template will be called from the workflow.
   */  
   Public void DealReg_ProdDetailsForDealApprEmail()
     {       
       List<Deal_Registration__c> optyDealStatus=new list<Deal_Registration__c>();
       List<Product_Registration__c> programList =new List<Product_Registration__c>();       
       List<String> programLineObjList= null;       
       List<String> productStatusObjList=null;
       Set<String> rejectionObjReasonSet=null;   
       Set<String> HPCommentsObjSet=null;    
       Set<String> programSet= new Set<String>();
       optyValues= new List<Product_Registration__c>();      
       optyStatus = new List<WrapperProductrLineItemForEmail>();

       optyDealStatus=[Select id from Deal_Registration__c where Opportunity__c=:dealOpptyID];
        //Below code used to render business with product line  in email template second table and java set is used to restrict the duplicate rending the business unit
       programList =[Select Deal_Registration__r.Program__r.Name from Product_Registration__c where Deal_Registration__c in: optyDealStatus];
       
       for(Product_Registration__c productRegistrationListObj:programList)
        {
          programLineObjList= new List<String>();
          productStatusObjList= new List<String>();
          rejectionObjReasonSet= new Set<String>();
          HPCommentsObjSet= new Set<String>();
          
         if(!programSet.contains(productRegistrationListObj.Deal_Registration__r.Program__r.Name)){
          List<Product_Registration__c> productLineListVal = [Select Product_Line__c,Status__c,Deal_Registration__r.Rejection_Reason__c,Deal_Registration__r.Rejection_Comments__c from Product_Registration__c where Deal_Registration__r.Program__r.Name =: productRegistrationListObj.Deal_Registration__r.Program__r.Name and Deal_Registration__c in: optyDealStatus ];

             for(Product_Registration__c prodList:productLineListVal){
            // Below logic is used to add space if Status is not available for PL or vice verse  
              if(prodList.Product_Line__c !=null && prodList.Status__c!=null)
                 {
                    programLineObjList.add(prodList.Product_Line__c);
                    productStatusObjList.add(prodList.Status__c);
                  }
               else if(prodList.Product_Line__c!=null && prodList.Status__c==null)
                 {
                    programLineObjList.add(prodList.Product_Line__c);
                    productStatusObjList.add(' ');
                 }
               else
                  {
                    programLineObjList.add(' ');
                    productStatusObjList.add(prodList.Status__c); 
                  }
                  // To eliminate duplicate rendering, at any given point of view only one time rejection reason should render so used Set(Java)
                rejectionObjReasonSet.add(prodList.Deal_Registration__r.Rejection_Reason__c);  
                HPCommentsObjSet.add(prodList.Deal_Registration__r.Rejection_Comments__c);                
             } 
               
               programSet.add(productRegistrationListObj.Deal_Registration__r.Program__r.Name);
               optyStatus.add(new WrapperProductrLineItemForEmail(productRegistrationListObj.Deal_Registration__r.Program__r.Name,productStatusObjList,rejectionObjReasonSet,HPCommentsObjSet,programLineObjList));       
          }  
        } 
      // End of the second part in email template
      //Below code is used to render name, owner in first table in email template
       optyStatusList=[Select Opportunity__r.Name,Opportunity__r.Owner.Name,Opportunity__r.id,Opportunity__r.Country__c from Product_Registration__c where Opportunity__c=:dealOpptyID];
       Set<String> optyname= new Set<String>();
       for(Product_Registration__c opty:optyStatusList){
                if(!optyname.contains(opty.opportunity__r.name)){
                    optyValues.add(opty);
                    optyname.add(opty.opportunity__r.name);
                }
        } 
    }
  
     /**
     * This warapperclass used to send a deal approval email notification and used in 
     * getProductDetailsForDealApprovalEmail() method
     */  
    public class WrapperProductrLineItemForEmail {
    
        public List<String> productStatusLists{get; set;}
        public List<String> productLineLists{get;set;}
        public Set<String> rejectionReasonSet{get;set;}
        public Set<String> HPCommentsSet{get;set;}
        public String programName {get; set;}
        
        public WrapperProductrLineItemForEmail (String programNames,List<String> productStatusList,Set<String> rejectionReasonSets,Set<String> HPCommentsSets,List<String> prodList ) {
           this.programName =programNames;
           this.productStatusLists=productStatusList;
           this.rejectionReasonSet=rejectionReasonSets;
           this.HPCommentsSet=HPCommentsSets;
           this.productLineLists=prodList;           
        }       
      }
 }