/*Change History
Modified By: Ning Kang - 04/28/2014
Change Content: Everywhere in the sysem, do not show user system error messages

*/
public with sharing class ODP_Extension_WorkElementPredecessor {
    public Stage_Work_Element_Predecessor__c stageWorkElementPredecessor{get;set;}
    public Stage_Work_Element__c workElements = new Stage_Work_Element__c();
    public String myEditWEP{get;set;}
    public string UserID{get;set;}

    public string retURL{get;set;}
    public String[] splitString {get;set;}
    public List<Stage_Work_Element__c> workElementsList{get;set;}
    public List<Stage_Work_Element_Predecessor__c> wepList{get;set;}
    
    //add by june 05/26/2014
     public List<Stage_Work_Element_Predecessor__c> sweps{get;set;}
     public ID currentSWEId{get;set;}
     public Set<ID> wes{Get;set;}
     //--end--
    
    public ODP_Extension_WorkElementPredecessor(ApexPages.StandardController controller) {
        stageWorkElementPredecessor = (Stage_Work_Element_Predecessor__c)controller.getRecord();
        
        UserID = UserInfo.getUserId();
        
        retURL =  ApexPages.currentPage().getParameters().get('retURL');
        if(string.isNotEmpty(retURL)){
            retURL =  ApexPages.currentPage().getParameters().get('retURL');    
        }
        if(retURL!='' )
        {
         splitString=retURL.split('/');
         
        }
        
        if(stageWorkElementPredecessor.Id == null && splitString[1]!= '')
        {
            myEditWEP = 'Create';
                    workElements = [select Id,Name__c,Work_Element_ID__c,Work_Element_Name__c,Release_Stage_ID__r.Offering_Release_ID__c,Include__c,Release_Stage_ID__c from Stage_Work_Element__c where id=:splitString[1]];
                    //System.debug('*********'+workElements);
                    //modified by june 05/28/2014
                    workElementsList = [select Work_Element_ID__c,Id,Name__c,Work_Element_Name__c,Release_Stage_ID__r.Offering_Release_ID__c from Stage_Work_Element__c where Release_Stage_ID__r.Offering_Release_ID__c =:workElements.Release_Stage_ID__r.Offering_Release_ID__c and include__c = true and Release_Stage_ID__c=:workElements.Release_Stage_ID__c];
                    //--end--
                //    System.debug('++++++++++'+workElementsList.size());
                    wepList = [Select Id,
                                      Name,
                                      Predecessor_Stage_Work_Element_ID__c,
                                      Work_Element__c,Stage_Work_Element__c,
                                      Include__c,
                                      Predecessor_Stage_Work_Element_Name__c,
                                      Stage_Work_Element_Name__c
                                      from Stage_Work_Element_Predecessor__c where Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__c =:workElements.Release_Stage_ID__r.Offering_Release_ID__c]; 
             //add by june 05/26/2014     

             currentSWEId = stageWorkElementPredecessor.Stage_Work_Element__c;                 
             wes = CheckPWEHaveWE(stageWorkElementPredecessor);
             //--end--
        } 
        else
        {    //modified by june 05/28/2014
            stageWorkElementPredecessor = [Select Id,
                                                  Name,
                                                  Predecessor_Stage_Work_Element_ID__c,
                                                  Work_Element__c,Stage_Work_Element__c,
                                                  Include__c,
                                                  Predecessor_Stage_Work_Element_Name__c,
                                                  Stage_Work_Element_Name__c,
                                                  Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__c,
                                                  Stage_Work_Element__r.Release_Stage_ID__c
                                                  from Stage_Work_Element_Predecessor__c where Id=:stageWorkElementPredecessor.Id];
             //--end--
            //System.Debug('Test'+stageWorkElementPredecessor);
            workElementsList = new List<Stage_Work_Element__c>();
            wepList = new List<Stage_Work_Element_Predecessor__c>();
            //modified by june 05/28/2014
            workElementsList = [select Id,Name__c,Work_Element_ID__c,Work_Element_Name__c,Release_Stage_ID__r.Offering_Release_ID__c from Stage_Work_Element__c where Release_Stage_ID__r.Offering_Release_ID__c =:stageWorkElementPredecessor.Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__c AND Include__c = true and Release_Stage_ID__c=:stageWorkElementPredecessor.Stage_Work_Element__r.Release_Stage_ID__c];
            //--end--
            wepList = [Select Id,
                              Name,
                              Predecessor_Stage_Work_Element_ID__c,
                              Work_Element__c,Stage_Work_Element__c,
                              Include__c,
                              Predecessor_Stage_Work_Element_Name__c,
                              Stage_Work_Element_Name__c
                              from Stage_Work_Element_Predecessor__c where Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__c =:stageWorkElementPredecessor.Stage_Work_Element__r.Release_Stage_ID__r.Offering_Release_ID__c];
            myEditWEP = 'Update';
            //add by june 05/26/2014
            currentSWEId = stageWorkElementPredecessor.Stage_Work_Element__c;
            wes = CheckPWEHaveWE(stageWorkElementPredecessor);
            //--end--

        }

    }
    
    //add by june 05/26/2014
    public Set<ID> CheckPWEHaveWE(Stage_Work_Element_Predecessor__c stageWorkElementPredecessor){
         sweps = [select Id,Name,Stage_Work_Element__c,Predecessor_Stage_Work_Element_ID__c,Predecessor_Stage_Work_Element_Name__c from Stage_Work_Element_Predecessor__c where Stage_Work_Element__c =:stageWorkElementPredecessor.Stage_Work_Element__c];
           Set<ID> ids = new Set<ID>();
            for(Stage_Work_Element_Predecessor__c swep: sweps){
                if(swep.Stage_Work_Element__c == stageWorkElementPredecessor.Stage_Work_Element__c)
                    ids.add(swep.Predecessor_Stage_Work_Element_ID__c);
            }  
            return ids;
    }
    //--end--
    
    
    
    
    public PageReference Save(){
        try{
            system.debug('pavi'+stageWorkElementPredecessor);
            upsert stageWorkElementPredecessor;
            PageReference WEPage = new PageReference('/'+stageWorkElementPredecessor.Id);
            WEPage.setRedirect(true);
            return WEPage;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Work Element Predecessor Saving Exception, Please contact IT Administrator'));
            return null;   
        }
    }
    
    public List<SelectOption> displayWorkElementsOfCurretProject{
        get{
            List<SelectOption> options = new List<SelectOption>();
            //modify by june 05/26/2014
            if(myEditWEP=='Create')
                options.add(new SelectOption('----Select----','----Select----'));
            else
                options.add(new SelectOption(stageWorkElementPredecessor.Predecessor_Stage_Work_Element_ID__c,stageWorkElementPredecessor.Predecessor_Stage_Work_Element_Name__c));
            for(Stage_Work_Element__c workEle:workElementsList) {
                  //add by june 06/04/2014
               //   if(myEditWEP=='Create')
               //   {
               //       options.add(new SelectOption(workEle.Id,workEle.Name__c));
               //       continue;
               //   } 
                  //--end--
                  if(wes.contains(workEle.Id)||workEle.Id==currentSWEId)
                  {
                      continue;
                  }
                  options.add(new SelectOption(workEle.Id,workEle.Name__c));
            }
            //--end--
             return options;
        }
        
        
    }

}