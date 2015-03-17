//When adding a new work element, do not show Process Work Element ID, status, text, accountable team member
//
public class ODP_Extension_WorkElement {
    public Stage_Work_Element__c stgwe{get;set;}
    public String myEditStates{get;set;}
    public Boolean IsFromFlightPlan{get;set;}
    public string UserID{get;set;}
    public string retURL{get;set;}
    
    public Role__c RelRolObj{get;set;} 
    
    public Release_Stage__c RSobj{get;set;}
    public Release_Deliverable__c RDObj {get;set;}
    
    public List<Release_Stage__c> stgs{get;set;}
    public List<Release_Deliverable__c> deliverables{get;set;}
    
    public List<Stage_Work_Element__c> stgwes{get;set;}
    
    //add by june 5/20/2014
    public List<Core_Team_Member__c> ctms{get;set;}
    public List<SelectOption> curTeamMembers{get;set;}
    //--end--
    //add by june 5/21/2014
    public boolean deliverableIncludeFlag{get;set;}
    //--end--
    
    public string test{get;set;}
    public string stgID{get;set;}
    
    public ODP_Extension_WorkElement(ApexPages.StandardController controller) {
        stgwe = (Stage_Work_Element__c )controller.getRecord();
        IsFromFlightPlan = false;
        UserID = UserInfo.getUserId();
        retURL =  ApexPages.currentPage().getParameters().get('retURL');
        stgID =  ApexPages.currentPage().getParameters().get('STGID');
        if(string.isNotEmpty(retURL)){
            retURL =  ApexPages.currentPage().getParameters().get('retURL').substring(1);    
        }
      //  System.debug('Ning Kang Debug: ' + retURL);
        if(stgwe.Id==null && retURL != '' )
        {
            myEditStates = 'Create';
            //stgwe.Release_Stage_ID__r.Offering_Release_ID__c = 'a6yZ0000000DJOeIAO';
            try{
                //From Stage to Work Element    //note: process had been changed, we can not create work element in Stage step. need to discuss.
                 RSobj = [select id,Name,Stage_Name__c,Offering_Release_ID__c,Release_Name__c from release_stage__c where id=: retURL]; 
                 stgs = [select id,Name,stage_name__c,Offering_Release_ID__c from Release_stage__c where Offering_Release_ID__c =: RSobj.Offering_Release_ID__c];
                 //All of Work Element in project
                 stgwes = [select id,Name__c,Name,Release_Name__c,Deliverable_Name__c,Stage_Name__c,Include__c,Status__c,Review_Required__c,Optional__c from Stage_Work_Element__c where Release_Stage_ID__r.Offering_Release_ID__c =: RSobj.Offering_Release_ID__c and Include__c =true];
          
                 RDObj = [select id, Offering_Release__c,Release_Deliverable_Name__c from release_deliverable__c where Offering_Release__c =: RSobj.Offering_Release_ID__c limit 1]; 
                 deliverables = [select id , Release_Deliverable_Name__c from Release_Deliverable__c where Offering_Release__c =:RSobj.Offering_Release_ID__c];
            
                 Selecteditem = RSObj.Stage_Name__c;
            }
            catch(exception e){
                //From Deliverable to WorkElement  //add include__c by june 5/21/2014
                RDObj = [select id, Offering_Release__c,Release_Deliverable_Name__c,Include__c from release_deliverable__c where id =: retURL];
                //All of Work Element in project
                stgwes = [select id,Name__c,Name,Release_Name__c,Deliverable_Name__c,Stage_Name__c,Include__c,Status__c,Review_Required__c,Optional__c  from Stage_Work_Element__c where Release_Stage_ID__r.Offering_Release_ID__c =: RDObj.Offering_Release__c and Include__c =true ];
                
                deliverables = [select id , Release_Deliverable_Name__c from Release_Deliverable__c where Offering_Release__c =:RDObj.Offering_Release__c];
                RSobj = [select id,Name,Stage_Name__c,Offering_Release_ID__c,Release_Name__c from release_stage__c where Offering_Release_ID__c =: RDObj.Offering_Release__c limit 1]; 
                 stgs = [select id,Name,stage_name__c,Offering_Release_ID__c from Release_stage__c where Offering_Release_ID__c =: RDObj.Offering_Release__c];
                 
                //add by june 5/20/2014 show Accountable team member
                ctms= [select User__r.Name,Role_Name__c,User__c from Core_Team_Member__c where Release_Name__c =: RSobj.Release_Name__c ];
                curTeamMembers = new List<SelectOption>();
                for(Core_Team_Member__c c :ctms){
                    curTeamMembers.add(new SelectOption(c.id,c.User__r.Name+' | '+c.Role_Name__c));
                }
                //--end--
                
                //add by june 5/21/2014 if deliverable include indicator is uncheck,can not create w.e.
                deliverableIncludeFlag = RDObj.Include__c;
                //--end--
            }

            
        }
        else
        {
            stgwe = [select id,
                     Accountable_Role__c,
                     Accountable_Process_Role_Name__c,
                     Accountable_Team_Member__c,
                     Accountable_User__c,
                     Contribute_Due_Date__c,
                     Days_To_Review__c,
                     Release_Deliverable_ID__c,
                     Deliverable_Name__c,
                     Description_Text_Area__c,
                     Help_Description__c,
                     Include__c,
                     Name__c,
                     Work_Element_ID__c,
                     Work_Element_Name__c,
                     Release_Name__c,
                     review_due_date__c,
                     Review_Required__c,
                     Release_Stage_ID__c,
                     Stage_Name__c,
                     Status__c,
                     Text__c,
                     Work_Instructions__c,
                     Release_Deliverable_ID__r.Deliverable_Name__c,
                     Release_Stage_ID__r.Offering_Release_ID__c,
                     Optional__c 
                     //Successor_Work_Element__c
                     from Stage_Work_Element__c
                     Where Id=:stgwe.Id];

            //add by june 5/20/2014 show Accountable team member
            ctms= [select User__r.Name,Role_Name__c,User__c from Core_Team_Member__c where Release_Name__c =: stgwe.Release_Name__c ];
            curTeamMembers = new List<SelectOption>();
            for(Core_Team_Member__c c :ctms){
                curTeamMembers.add(new SelectOption(c.id,c.User__r.Name+' | '+c.Role_Name__c));
            }
            //--end--
                
             stgs = [SELECT Id,Name,Offering_Release_ID__c,Release_Name__c,Stage_Name__c FROM Release_Stage__c WHERE Offering_Release_ID__c =: stgwe.Release_Stage_ID__r.Offering_Release_ID__c];
           
             deliverables = [select id , Release_Deliverable_Name__c from Release_Deliverable__c where Offering_Release__c =:stgwe.Release_Stage_ID__r.Offering_Release_ID__c   ];      
                     
             stgwes = [select id,Name__c,Name,Release_Name__c,Deliverable_Name__c,Stage_Name__c,Include__c,Status__c,Review_Required__c from Stage_Work_Element__c where Release_Stage_ID__r.Offering_Release_ID__c =: stgwe.Release_Stage_ID__r.Offering_Release_ID__c and Include__c =true]; 
             
             RDObj = [select id, Offering_Release__c,Release_Deliverable_Name__c,Include__c from release_deliverable__c where id =:stgwe.Release_Deliverable_ID__c];
             deliverableIncludeFlag = RDObj.Include__c;
                 
            if(stgwe.Work_Element_ID__c != null){
                IsFromFlightPlan = true;
            }
            myEditStates = 'Update';
            
            Selecteditem = stgwe.Stage_Name__c;            
        }
    }
    public PageReference Save(){
        try{
            upsert stgwe;
            // Ning Kang: Apr 24 2014
            // When adding a new WE and providing the Accountable Process Role, need to create a new role in the system if the target role is not in the ststem
/*            
            List <Release_Role__c> RRObjList = [select id, Role_Name__c, Role_ID__c, Offering_Release__c from release_role__c where Offering_Release__c =: RSobj.Offering_Release_ID__c];

            for(Release_Role__c rrobj : RRObjList ){
                if(stgwe.Accountable_Role__c != rrobj.Role_ID__c){
                    RelRolObj = new Release_Role__c(Accountable__c = true, Contributor__c = false, Independent_Reviewer__c = false, Role_ID__c = stgwe.Accountable_Role__c, Offering_Release__c = rrobj.Offering_Release__c, Reviewer__c = false);
                }                
            }
            upsert RelRolObj;

*/            
            PageReference WEPage = new PageReference('/'+retURL);
            WEPage.setRedirect(true);
            return WEPage;
        }
        catch(exception e){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: Work Element Saving Exception. Please contact IT administrators if any assistance needed.'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: ' + e.getMessage()));
            return null;   
        } 
    }
    //add by june 05/22/2014
    public PageReference DeleteWE(){
        try{
            delete stgwe;
            PageReference WEPage = new PageReference('/'+stgwe.Release_Deliverable_ID__c);
            WEPage.setRedirect(true);
            return WEPage;
        }
         catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: Work Element Delete Exception. Please contact IT administrators if any assistance needed.'));
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: ' + e.getMessage()));
            return null;   
        } 
    }
    //--end--
    
     public List<SelectOption> StageItems{
      get{           
            List<SelectOption> options = new List<SelectOption>();
            if(stgwe.Id!=null){
                options.add(new SelectOption(stgwe.Release_Stage_ID__c,stgwe.Stage_Name__c));
            }else{
                options.add(new SelectOption(RSobj.id,RSobj.Stage_Name__c));
            }           
            for(Release_Stage__c stg:stgs){
               if(stgwe.Id!=null){
                    if(stg.id == stgwe.Release_Stage_ID__c)
                        continue;
               }else{
                   if(stg.Id ==RSobj.Id )
                        continue;
               } 
              options.add(new SelectOption(stg.id,stg.stage_name__c ));                           
            } 
            return options;        
         }
    }


    
    
 
   public List<SelectOption> DeliverableItems{
      get{
          List<SelectOption> options = new List<SelectOption>();
          if(stgwe.Id!=null){
                options.add(new SelectOption(stgwe.Release_Deliverable_ID__c,stgwe.Release_Deliverable_ID__r.Deliverable_Name__c));
           }else{
               if(RDObj.Release_Deliverable_Name__c ==null){
                   options.add(new SelectOption(RDObj.id,''));
                  
               }else{
                    options.add(new SelectOption(RDObj.id,RDObj.Release_Deliverable_Name__c ));
               }
                
           } 
          for(Release_Deliverable__c dc:deliverables){
              if(stgwe.Id!=null){
                    if(dc.id == stgwe.Release_Deliverable_ID__c)
                        continue;
               }else{
                   if(dc.Id ==RDObj.Id )
                        continue;
               } 
               
               if(dc.Release_Deliverable_Name__c ==null){
                   options.add(new SelectOption(dc.id,''));  
               }else{
                options.add(new SelectOption(dc.id,dc.Release_Deliverable_Name__c ));  
               }
                
          } 
          return options;        
      }
    }
    
    public String Selecteditem {get;set;}
    public List<SelectOption> SuccessorWEItems{
      get{
          List<SelectOption> options = new List<SelectOption>();
          for(Stage_Work_Element__c swe: stgwes ){
              if(stgwe.Id!=null){
                   if(swe.id == stgwe.id)
                        continue;
              }else{
                   if(swe.Id ==RSObj.Id )
                        continue;
              }
             if(swe.Stage_Name__c == Selecteditem ){  
                 options.add(new SelectOption(swe.id,swe.Name__c ));  
             }
          } 
          return options;        
      }
    }
    
    public PageReference reloadWETable(){
        system.debug('----------------------------------' + Selecteditem);
        if(stgwe.Id==null && retURL != '' )
        {
            stgwes = [select id,Name__c,Name,Release_Name__c,Deliverable_Name__c,Stage_Name__c,Include__c,Status__c,Review_Required__c from Stage_Work_Element__c where Release_Stage_ID__r.Offering_Release_ID__c =: RSobj.Offering_Release_ID__c and Include__c =true and Release_Stage_ID__c =:Selecteditem];
            system.debug('------------Create-----------------' + stgwe.Id);
        }
        else{
            stgwes = [select id,Name__c,Name,Release_Name__c,Deliverable_Name__c,Stage_Name__c,Include__c,Status__c,Review_Required__c from Stage_Work_Element__c where Release_Stage_ID__r.Offering_Release_ID__c =: stgwe.Release_Stage_ID__r.Offering_Release_ID__c and Include__c =true and Release_Stage_ID__c =:Selecteditem];  
            system.debug('------------Update-----------------' + stgwe.Id);
        }
        return null;
    }  
}