public class ExtendedOfferingClass {

    public boolean disbledFiled{get;set;}
    //public String CurServiceLineID{get;set;}
    public String CurServiceLineIDID{get;set;}
    public String CurServiceLineName{get;set;}
    public String EditStatus {get;set;}
    public final Offering__c OC;
    public ExtendedOfferingClass(ApexPages.StandardController controller) {
        this.OC = (Offering__c)controller.getRecord();
        string upId = ApexPages.currentPage().getParameters().get('id');
        CurServiceLineIDID = Apexpages.currentPage().getParameters().get('CF00NZ00000012w8B');
        if(string.isNotEmpty(upId)) //update Offering
        {
            //disbledFiled = true;
            EditStatus = 'Update';
            Offering__c o = [select Service_Line_Name__c, Name__c, Description__c, Manager_User__c,Is_Active__c from Offering__c where id=:upId];
            Service_Line__c SLc = [select Name__c,id from Service_Line__c where id =:o.Service_Line_Name__c];            
            CurServiceLineIDID = o.Service_Line_Name__c;
            CurServiceLineName = SLc.Name__c; 
        }
        else if(string.isNotEmpty(CurServiceLineIDID)) //new Offering
        {
            EditStatus = 'New';
            //disbledFiled = false;
            Service_Line__c SLc = [select Name__c,id from Service_Line__c where Name =:CurServiceLineIDID limit 1];
            if(SLc != null)
            {
                CurServiceLineIDID = SLc.id;
                CurServiceLineName = SLc.Name__c;                
            }
            else
            {
                CurServiceLineIDID = '';
                CurServiceLineName = '';                
            }
        }
        
        if(string.isNotEmpty(CurServiceLineIDID))
        {
            disbledFiled = true;
        }
        else
        {
            disbledFiled = false;
        }     
    }
    
    public PageReference save()
    {
        try{
            string name = OC.Name__c;        
            string validateStr = offeringValidate(name); 
            if(validateStr == 'success'){
                upsert OC;
                PageReference OCPage = new PageReference('/'+OC.Service_Line_Name__c);            
                //PageReference OCPage = new ApexPages.StandardController(OC).view();
                OCPage.setRedirect(true);
                return OCPage;
            }
             else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, validateStr));       
                return null;
            }                       
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()));        
            return null;        
        } 
    }
    public PageReference DoSaveNew(){
        try{
            string name = OC.Name__c;        
            string validateStr = offeringValidate(name); 
            if(validateStr == 'success'){
                upsert OC;
                string s = '/' + ('' + OC.get('Id')).subString(0, 3) + '/e?';
                //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, s));
                return new Pagereference(s); 

            }
             else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, validateStr));       
                return null;
            }        
        }
        catch(exception e){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()));        
            return null;        
        }
    }
    
    public void DynamicSLName(){
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'exception'));    
        list<Service_Line__c> ServiceLineC= [select Name__c from Service_Line__c where id =:OC.Service_Line_Name__c];
        if(ServiceLineC.size() == 1)
        {
            CurServiceLineName = ServiceLineC[0].Name__c;
        }
        else
        {
            CurServiceLineName= '';
        }
    }
    
    public String offeringValidate(string offeringname)
    {
        string result = 'success';
        try{
            Offering__c[] offeringList= [select Name__c,Name from Offering__c where Name__c =:offeringname and Service_Line_Name__c =:OC.Service_Line_Name__c ];
            string upId = ApexPages.currentPage().getParameters().get('id');            
            if(!string.isNotEmpty(upId))             
            {    //save new         
                if(offeringList.size() > 0)
                {
                    result = 'The same offering in this Service Line alredy exist, Please confirm your input';
                }
            }else 
            {   //update
                if(offeringList.size() > 0)
                {                
                    Offering__c compareOffering= [select Name from Offering__c where id =: upId];
                    if(offeringList[0].Name != compareOffering.Name){                                    
                        result = 'The same offering in this Service Line alredy exist, Please confirm your input';
                    }               
                }
            }         }
        catch(exception e){
            result = 'Validate data occur Exception:' + e.getMessage();
        }
        return result;
    }
}