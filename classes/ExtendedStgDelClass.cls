public class ExtendedStgDelClass {

    public String CurStageName{get;set;}
    public String CurStageId{get;set;}
    public String CurDeliverableId{get;set;}
    public String CurDeliverableName{get;set;}
    public String CurRoleName{get;set;}
    public final Stage_Deliverable__c sd;
    List <Stage_Deliverable__c> Stgdels;   
    public ExtendedStgDelClass(ApexPages.StandardController controller) {
        this.sd = (Stage_Deliverable__c)controller.getRecord();
        String upId = ApexPages.currentPage().getParameters().get('id');
        CurStageId = ApexPages.currentPage().getParameters().get('CF00NZ000000133qP');
        try{
            if(String.isNotEmpty(upId)){ //update the stage deliverable
                Stage_Deliverable__c sdc = [select Stage_Name__c, Stage_ID__c, Deliverable_Name__c from Stage_Deliverable__c where id =: upId];
                CurStageId = sdc.Stage_ID__c;
                CurStageName = sdc.Stage_Name__c;
                CurDeliverableName = sdc.Deliverable_Name__c;
            }
            else if(String.isNotEmpty(CurStageId)){ //new the stage deliverable
                Stage__c stgbj = [select id, Name__c from Stage__c where Name =: CurStageId];
                CurStageId = stgbj.id;
                CurStageName = stgbj.Name__c;
            }
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()));
        }
    }
    
    public List<Stage_Deliverable__c> getStgdels(){
            
        return [select Stage_ID__c, Deliverable_ID__c, Owner_Role_ID__c, Deliverable_ID__r.Name__c, Stage_ID__r.Name__c, Owner_Role_ID__r.Role_Name__c from Stage_Deliverable__c order by Stage_ID__r.Name__c];       
    }
    
    public void DynamicDeliName(){
        list<Deliverable__c> DeliList= [select Name__c from Deliverable__c where id =:sd.Deliverable_ID__c];
        if(DeliList.size() == 1)
        {
            CurDeliverableName = DeliList[0].Name__c;
        }
    }
    private string Validate(Stage_Deliverable__c sdc )
    {
        string result = 'success';
        try{
            Stage_Deliverable__c[] sdList= [select Name from Stage_Deliverable__c where Stage_ID__c  =:sdc.Stage_ID__c and Owner_Role_ID__c =:sdc.Owner_Role_ID__c and Deliverable_ID__c =:sdc.Deliverable_ID__c ];
            String upId = ApexPages.currentPage().getParameters().get('id');
            if(!String.isNotEmpty(upId)) 
            {    //save new         
                if(sdList.size() > 0 )
                {
                    result = 'The same Deliverable Name as a same role alredy exist, Please confirm your input';
                }
            }else
            {   //update
                if(sdList.size() > 0 )
                {
                    Stage_Deliverable__c cmSD= [select Name from Stage_Deliverable__c where id =: upId];
                    if(sdList[0].Name != cmSD.Name){                                                    
                        result = 'The same Deliverable Name as a same role alredy exist, Please confirm your input';
                    }                
                }
            }         
        }
        catch(exception e){
            result = 'Validate data occur Exception:' + e.getMessage();
        }
        return result;
    }
    
        
    public PageReference save(){
        try{            
            string validateStr = Validate(sd); 
            if(validateStr == 'success'){
                upsert sd;
                //PageReference sdPage = new ApexPages.StandardController(sd).view();
                //sdPage.setRedirect(true);
                //return sdPage; 
                string s = '/' + sd.Stage_ID__c;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, s));

                return new Pagereference(s);                                 
            }
             else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, validateStr));       
                return null;
             }          
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please Check your input before saving. Name must be provided and unique'));        
            return null;        
        }   
    }
      
    
}