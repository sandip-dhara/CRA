public class ExtendedServiceLinesClass {

    public final Service_Line__c SLC;
  
    public ExtendedServiceLinesClass(ApexPages.StandardController controller) {
        this.SLC = (Service_Line__c)controller.getRecord(); 
    }
      
    public PageReference save(){
        try{
            upsert SLC;
            PageReference SLCPage = new ApexPages.StandardController(SLC).view();
            SLCPage.setRedirect(true);
            return SLCPage;             
         
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please Check your input before saving. Name must be provided and unique'));        
            return null;        
        }   
    }
    public PageReference DoSaveNew(){
        try{
            upsert SLC;
            string s = '/' + ('' + SLC.get('Id')).subString(0, 3) + '/e?';
            return new Pagereference(s); 
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please Check your input before saving. Name must be provided and unique'));        
            return null;        
        }
    }
    

}