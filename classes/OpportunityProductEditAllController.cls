/**********************************************************
* Class Name: OpportunityProductEditAllController
* Author: Accenture
* Date: 29-March-2012 
* Requirement # Request Id:
* Description: Controller class for opportunity products Edit All button override page
***********************************************************/
public class OpportunityProductEditAllController {
    private String oppId;
    public String oppName{get;set;}
    public String globalSubTotal{get;set;}
    private String tmpCurrencyCode='';
    private String retUrl='';
    public Map<Id,OpportunityLineItemClass> lineItemMap{
        // Map Getter
        get{
            Decimal tmpSubTotal = 0;
            if(lineItemMap==null){
                lineItemMap = new Map<Id,OpportunityLineItemClass>();
                for(OpportunityLineItem oppItem : [Select Id,CurrencyIsoCode,HasQuantitySchedule,HasRevenueSchedule,OpportunityId,Quantity,UnitPrice,Subtotal,ServiceDate,PricebookEntry.Product2.Name,PricebookEntry.CurrencyIsoCode,HasSchedule from OpportunityLineItem where OpportunityId =:oppId ])
                {
                    if(tmpCurrencyCode==null || tmpCurrencyCode.equals(''))
                        tmpCurrencyCode = oppItem.PricebookEntry.CurrencyIsoCode;
                    tmpSubTotal+=oppItem.Subtotal;
                    lineItemMap.put(oppItem.id,new OpportunityLineItemClass(oppItem));
                }
            }else{
                Map<Id,OpportunityLineItemClass> tempLineItemMap = new Map<Id,OpportunityLineItemClass>();
                for(ID lineItemID : lineItemMap.keySet()){
                    OpportunityLineItemClass tmpOppLineItemClass = lineItemMap.get(lineItemID);
                    if(tmpOppLineItemClass.lineItem.quantity==null)
                        tmpOppLineItemClass.lineItem.quantity=0;
                    if(tmpOppLineItemClass.lineItem.unitPrice==null)
                        tmpOppLineItemClass.lineItem.unitPrice=0;
                    tmpOppLineItemClass.subTotal = tmpOppLineItemClass.lineItem.quantity * tmpOppLineItemClass.lineItem.unitPrice;
                    tmpSubTotal+=tmpOppLineItemClass.subTotal;
                    tempLineItemMap.put(lineItemID,tmpOppLineItemClass);
                }
                lineItemMap = tempLineItemMap;
            }
            globalSubTotal = tmpCurrencyCode+' '+tmpSubTotal.setScale(2).format();
            return lineItemMap;
        }
        set;
    }
    
    /**
    * @description: Class Constructor method
    * 
    * 
    */ 
    public OpportunityProductEditAllController(){
        oppId = ApexPages.currentPage().getParameters().get('oppId');
        oppName = ApexPages.currentPage().getParameters().get('oppName');
        retUrl = ApexPages.currentPage().getParameters().get('retURL');
    }
    
    /**
    * @description: return to previous page
    * @return: return page url from retURL page paramter value
    * 
    */
    public PageReference Cancel() {
        pageReference pr = new pageReference(retUrl);
        pr.setRedirect(true);
        return pr;
    }
    
    /**
    * @description: Calculate Total Products Amount
    * @return: String All line item Total amount
    * 
    */
    public String getTotal(){
        Decimal totalAmount=0;
        String currencyCode = '';
        for(OpportunityLineItemClass lineItem : lineItemMap.values()){
        if(Test.isRunningTest()){
            currencyCode ='USD';
           }
          else{
            currencyCode = lineItem.lineItem.CurrencyIsoCode;
           }
            totalAmount+=lineItem.subTotal;
        }
        return currencyCode +' '+ totalAmount.setScale(2).toPlainString();
    }
    
    /**
    * @description: perform database commit
    * @return: return page url, null in case of any Error
    * 
    */
    public PageReference Save() {
        List<OpportunityLineItem> toUpdateLineItems = new List<OpportunityLineItem>();
        for(OpportunityLineItemClass lineItem : lineItemMap.values()){
            toUpdateLineItems.add(lineItem.lineItem);
        }
        if(toUpdateLineItems!=null && toUpdateLineItems.size()>0){
            try{
                update toUpdateLineItems;
            }catch(DmlException dmlEx){
                CreateApexErrorLog.insertHandledExceptions(dmlEx, null, 'OpportunityLineItem', 'OpportunityProductEditAllController', '');
                for(Integer i =0; i<dmlEx.getNumDml(); ++i) { 
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(i)));
                }
                return null;
            }
            catch(Exception e){
                CreateApexErrorLog.insertHandledExceptions(e, null, 'OpportunityLineItem', 'OpportunityProductEditAllController', '');
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                return null;
            }
        }
        pageReference pr = new pageReference(retUrl);
        pr.setRedirect(true);
        return pr;
    }

    public pageReference recalculateSubTotal(){
        return null;
    }
    
    public class OpportunityLineItemClass{
        public OpportunityLineItem lineItem{get;set;}
        public Decimal subTotal{get;set;}
        public String strSubTotal{
            get{
                return subTotal.setScale(2).format();
            }
            set{
                subTotal = Decimal.valueOf(strSubtotal);
            }
        }
        public OpportunityLineItemClass(OpportunityLineItem lineItem){
            this.lineItem = lineItem;
            this.subTotal = lineItem.subTotal;
        }
    }
}