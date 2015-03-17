public class ODP_Extension_CustomerCommitment {
    public string myEditStates {get;set;}
    public string UserID {get;set;}
    public Customer_Commitment__c cuscomObj{get;set;}
    public List<Core_team_member__c> ctmList{get;set;}
    public string retURL {get;set;}
    public string CurObjID{get;set;}
    public string OfId{get;set;}
    public ODP_Extension_CustomerCommitment(ApexPages.StandardController controller) {
        cuscomObj = (Customer_Commitment__c )controller.getRecord();
        CurObjID = ApexPages.currentPage().getParameters().get('id');
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        OfId=  ApexPages.currentPage().getParameters().get('OFId');   
        if(CurObjID  == null){
            myEditStates = 'Create';
            if(string.isNotEmpty(OfId)){
                //retURL =  ApexPages.currentPage().getParameters().get('retURL').substring(1);
                cuscomObj.Project_ID__c = OfId;
                Offering_Release__c proOBJ = [select id, Name__c from offering_release__c where id=: OfId];
                ctmList = [select id, Role_Name__c, User__c,User__r.Id,  User__r.Last_First_Name__c, Release_Name__c from Core_team_member__c where Release_Name__c =: proOBJ.Name__c];    
            }
        }
        else{
            myEditStates = 'Update';
            cuscomObj = [SELECT id, 
                            Commitment_Description__c,
                            Commitment_Owner__c,
                            Customer_Name__c,
                            Due_Date__c,
                            Project_ID__c
                         FROM Customer_Commitment__c 
                         WHERE id =: cuscomObj.id 
                        ];
            Offering_Release__c proOBJ = [select id, Name__c from offering_release__c where id=: cuscomObj.Project_ID__c];
            ctmList = [select id, Role_Name__c, User__c,User__r.Id,  User__r.Last_First_Name__c, Release_Name__c from Core_team_member__c where Release_Name__c =: proOBJ.Name__c];            
        }
    }
    

     public List<SelectOption> CTMName{
      get{
            List<SelectOption> options = new List<SelectOption>();
            if(ctmList != null){             
            for(core_team_member__c ctmobj:ctmList){
              options.add(new SelectOption(ctmobj.id,ctmobj.User__r.Last_First_Name__c + ' | ' + ctmobj.Role_Name__c));                           
            }
            }
            return options;
         }
    }
    
    private string saveData(){
        try{
            upsert cuscomObj;
            return 'success';
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: saving data exception. Please contact IT administrators if any assistance needed.'));
            return 'failed';   
        }
    }
    public PageReference Save(){
        string saveflag = saveData();
        if(saveflag == 'success')
        {
            PageReference CUSCOMPage = new PageReference('/'+OfId);
            CUSCOMPage.setRedirect(true);
            return CUSCOMPage;
        }
        else
        {
            return null;
        }
    }


}