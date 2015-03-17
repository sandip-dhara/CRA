public class ExtendedRiskActUserClass {

   /* public final Risk_Accountable_User__c RAU;
    public String CurRiskName{get;set;}
    public String CurRiskDescription{get;set;}
    public String CurRiskID{get;set;}
    public ExtendedRiskActUserClass(ApexPages.StandardController controller) {
        this.RAU = (Risk_Accountable_User__c)controller.getRecord();
        String upId = ApexPages.currentPage().getParameters().get('id');
        CurRiskID = ApexPages.currentPage().getParameters().get('CF00NZ00000013Vi9');
        if(String.isNotEmpty(upId)){ //Update Risk Accountable User
            Risk__c rcobj = [select Name__c, id, Description__c, Resolution__c, Status__c from Risk__c where id =:RAU.Risk_ID__c];
            CurRiskName = rcobj.Name__c;
            CurRiskID = rcobj.id;
            CurRiskDescription = rcobj.Description__c;
        }
        else if(String.isNotEmpty(CurRiskID)){ //new a risk accountable user
            Risk__c rcobj = [select id, Name__c, Description__c, Resolution__c, Status__c from Risk__c where Name=:CurRiskID];
            CurRiskName = rcobj.Name__c;
            CurRiskID = rcobj.Id;
            CurRiskDescription = rcobj.Description__c;
        }
    }
    public PageReference save(){
        try{
            if(SaveValidation(RAU) == 'sucess'){
                upsert RAU;
                PageReference RAUPage = new PageReference('/'+RAU.Risk_ID__c);            
                //PageReference ORCPage = new ApexPages.StandardController(ORC).view();
                RAUPage.setRedirect(true);
                return RAUPage;
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please check your input. The same user may added for this Risk'));
                return null;
            }
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please check your input. The same user may added for this Risk'));
            return null;
        }
    }
    public String SaveValidation(Risk_Accountable_User__c rauc){
        try{
            List <Risk_Accountable_User__c> RAUList = [select Name from Risk_Accountable_User__c where Risk_ID__c=:rauc.Risk_ID__c and User__c =:rauc.User__c];
            if(RAUList.size()> 0){
                return 'Failed';
            }
            else{
                return 'sucess';
            }
        }
        catch(exception e){
            return null;
        }
        //TBD
        //The Same User cannot be added to the same risk
    }*/
}