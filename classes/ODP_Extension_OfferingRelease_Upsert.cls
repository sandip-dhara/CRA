public class ODP_Extension_OfferingRelease_Upsert{

    public ODP_Extension_OfferingRelease_Upsert(ApexPages.StandardController controller) {
        OffR= (Offering_Release__c)controller.getRecord();
        OffR.OwnerId = UserInfo.getUserId();
        OffR.Facilitator__c = UserInfo.getUserId();
        CanSelFP = true;
        CanSelStatus = false;
        if(OffR.Id==null)
        {
            myEditStates = 'Create';
            CanSelFP = false;
        }
        else
        {
            OffR = [select Name__c,Offering_Version__c,Primary_Business_Contacts__c, PPMC_Project_ID__c,BVP__c, Flight_Plan_ID__c,Offering_Category__c,Release_Type__c,Status__c,Practice__c,Facilitator__c,Release_Description__c,
                    Flight_Plan_Name__c, OwnerId, assumptions__c
                    from Offering_Release__c
                    where Id=:OffR.Id];
            myEditStates = 'Update';
            if(UserInfo.getUserId() == OffR.Facilitator__c)
            {
                CanSelStatus = true;
            }
            SelectFlightPlan = OffR.Flight_Plan_ID__c;
            SelectFlightPlanName = OffR.Flight_Plan_Name__c;
            if(OffR.Status__C != 'Start Up' && OffR.Status__C != 'Not Started')
            {
                CanSelFP = false;
            }
            
            List<ProcessInstance> PI = [Select Id,Status,CreatedDate 
                         From ProcessInstance 
                         WHERE TargetObjectId =:OffR.Id and status='Approved'];
                    
            if(PI.size() > 0)
            {
                CanSelFP = false;
            }
        }
    }
    
    public PageReference Save(){
        string saveflag = saveData();
        if(saveflag == 'success')
        {
            PageReference OFPage = new PageReference('/'+OffR.Id);
            OFPage.setRedirect(true);
            return OFPage;
        }
        else
        {
            return null;
        }
    }
    
    private string saveData(){
        try{
            List<Flight_Plan__c> StartUpFP = [select Id, Name__c from Flight_Plan__c where Name__c = :StarUpname];
            if(StartUpFP.Size() < 1)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed : Startup flight plan exception. Please contact IT administrators if any assistance needed.'));
                return 'failed'; 
            }
            if(myEditStates=='Create')
            {
                OffR.Flight_Plan_ID__c = StartUpFP[0].Id;
                if(OffR.Flight_Plan_ID__c != null){
                    system.debug('In the insert++++++');
                    insert OffR;
                    return 'success';
                }
                else{
                    return 'failed'; 
                }
            }
            else
            {
                system.debug('begin the update ++++++');
                if(CanSelFP && !String.isEmpty(SelectFlightPlan) && SelectFlightPlan!= String.valueOf(StartUpFP[0].Id))
                {
                    OffR.Flight_Plan_ID__c = SelectFlightPlan;
                    if(OffR.Flight_Plan_ID__c != null){
                        system.debug('In the update ++++++');
                        update OffR;
                        return 'success';
                    }
                    else{
                        system.debug('the update failed ++++++');
                        return 'failed'; 
                    }
                }
                else{
                    system.debug('the update no flight plan change++++++');
                    update OffR;
                    return 'success';
                }
            }
            
           return 'failed';

        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, e.getMessage()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed : duplicate project name. Please contact IT administrators if any assistance needed'));
            return 'failed';   
        }                 
    }
    
    //private String StarUpname = 'Startup';
    private String StarUpname = 'ESIT OpportunityStartup'; 
    public Offering_Release__c OffR{get;set;}
    public String myEditStates{get;set;}
    public Boolean CanSelFP{get;set;}
    public Boolean CanSelStatus{get;set;}
    public String SelectFlightPlan{get;set;}
    public String SelectFlightPlanName{get;set;}
    public List <SelectOption> FlightPlans{
        get{           
            List<SelectOption> options = new List<SelectOption>();
            if(SelectFlightPlanName == StarUpname )
            {
                options.add(new SelectOption('','None'));
                SelectFlightPlan = '';
            }
            for(Flight_Plan__c fp: [select Id,Name__c,Description__c from Flight_Plan__c where Is_Active__c = true and Name__c like '%Opportunity%'  order by Name__c]){
                if(fp.Name__C != StarUpname)
                {
                    options.add(new SelectOption(fp.Id,fp.Name__c + ' - ' + fp.Description__c));
                }
            }        
            return options;        
         }        
    }
}