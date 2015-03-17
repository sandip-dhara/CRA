public class ODP_Extention_ExtendedReview {
    public String myEditStates{get;set;}
    public String SelectTeamMember{get;set;}
    public String CurSwe{get;set;}
    public String waringMessage{get;set;} 
    public boolean disableCom{get;set;} 
    public string waringMessageShow{get;set;}   
    public List <SelectOption> items{
        get{           
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('norole',''));                    
            for(Role__c rc: [select Role_Name__c, Name from Role__c]){
                options.add(new SelectOption(rc.Id,rc.Role_Name__c));        
            }        
            return options;        
         }        
    }
    public String SelectRole{get;set;}     
    public List <SelectOption> teammenbers{get;set;} 
    public Review__c cc{get;set;}
    
       //add by june 5/21/2014
    public boolean deliverableIncludeFlag{get;set;}
    public Release_Deliverable__c RDObj {get;set;}
    public Stage_Work_Element__c sweC{get;set;}
    //--end--
    
    
    public ODP_Extention_ExtendedReview(ApexPages.StandardController controller) {
        cc = (Review__c)controller.getRecord();
        String upId = ApexPages.currentPage().getParameters().get('id');
        CurSwe = Apexpages.currentPage().getParameters().get('retURL'); 
        
        if(string.isNotEmpty(upId)) //update Review
        {
            Review__c c = [select Role__c,Role_Name__c,Complete__c,Team_Member_Name__c,Team_Member__c,Stage_Work_Element__c,Rating__c,Comment__c from Review__c where id=:upId];
            SelectRole = c.Role__c;
            SelectTeamMember =  c.Team_Member__c;
            CurSwe = c.Stage_Work_Element__c;
            myEditStates = 'Update';
            disableCom = true;
        }
        else if(string.isNotEmpty(CurSwe)) //new Review
        {
            myEditStates = 'New';
            CurSwe = CurSwe.substring(1); 
            SelectRole = 'norole';
            SelectTeamMember = 'noctm';
            disableCom = false;        
        }
        
        //Modify by june 05/21/2014
        sweC = [select Release_Stage_ID__r.Offering_Release_ID__c,Release_Deliverable_ID__c from Stage_Work_Element__c where id =: CurSwe limit 1];
        RDObj = [select id,Include__c from release_deliverable__c where id =:sweC.Release_Deliverable_ID__c];
        deliverableIncludeFlag = RDObj.Include__c;
        //--end--
        
        
        List<Core_Team_Member__c> ctmList = [select User__r.id,User__r.Name, Release_Role__r.Role_Name__c 
            from Core_Team_Member__c where Release_Role__r.Offering_Release__c =: sweC.Release_Stage_ID__r.Offering_Release_ID__c order by User__r.Name]; 
        teammenbers =  new List<SelectOption>();
        teammenbers.add(new SelectOption('noctm','')); 
        for(Core_Team_Member__c ctm: ctmList ){
             teammenbers.add(new SelectOption(ctm.id,ctm.User__r.Name + ' [' + ctm.Release_Role__r.Role_Name__c + ']'));        
        }
        waringMessageShow = 'none';
        //waringMessage = 'The Team Member must belongs to the  Role!';           
    }
    public string ValidateReview(){   
        string result = 'success';
        try{
            Review__c[] conList= [select id,Name 
                from Review__c where Role__c =:cc.Role__c and Team_Member__c =: cc.Team_Member__c and Stage_Work_Element__c = : cc.Stage_Work_Element__c ];
            string upId = ApexPages.currentPage().getParameters().get('id');            
            if(!string.isNotEmpty(upId))             
            {    //save new         
                if(conList.size() > 0)
                {
                    if( cc.Team_Member__c == null){
                        result = 'The selected role already exist for this work element. Please assign the team member to the existed role';    
                    }else{
                        result = 'The same role and same team member for this work element already exist, Please confirm your input';
                    }
                }
            }else 
            {   //update
                if(conList.size() > 0)
                {                
                    if(conList[0].id != cc.id ){                                    
                        if(cc.Team_Member__c == null){
                            result = 'The selected role already exist for this work element. Please assign the team member to the existed role';    
                        }else{
                            result = 'The same role and same team member for this work element already exist, Please confirm your input';
                        }
                    }               
                }
            }         
        }
        catch(exception e){
            //result = 'Validate data occur Exception, Please contact IT Administrator';
            result = 'Operation Failed: review saving, Please try again later or contact IT Administrator';
        }
        return result;    
    }
    public PageReference Save(){
        try{
            if(SelectRole.equals('norole')){
                //SelectRole = ''; 
                cc.Role__c =  null;   
            }else{
                cc.Role__c = SelectRole;
            }
            if(SelectTeamMember.equals('noctm')){
                system.debug('');
                //SelectTeamMember = ''; 
                cc.Team_Member__c = null;      
            }else{
                cc.Team_Member__c = SelectTeamMember; 
            }  
            string saveflag = ValidateReview();   
            if(saveflag == 'success'){
                upsert cc;        
                PageReference OFPage = new PageReference('/'+cc.Stage_Work_Element__c);
                OFPage.setRedirect(true);
                return OFPage;
            }
             else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, saveflag ));       
                return null;
            }                       
        }
        catch(exception e){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getMessage()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Operation Failed: save exception, Please contact IT Administrator if needed'));        
            return null;        
        }     
    }
    public void changeRole(){
        Stage_Work_Element__c sweC = [select Release_Stage_ID__r.Offering_Release_ID__c from Stage_Work_Element__c where id =: CurSwe limit 1]; 
        if(SelectRole == 'norole'){
            List<Core_Team_Member__c> ctmList = [select User__r.id,User__r.Name, Release_Role__r.Role_Name__c 
                from Core_Team_Member__c where Release_Role__r.Offering_Release__c =: sweC.Release_Stage_ID__r.Offering_Release_ID__c order by User__r.Name]; 
            teammenbers =  new List<SelectOption>();
            teammenbers.add(new SelectOption('noctm','')); 
            for(Core_Team_Member__c ctm: ctmList ){
                 teammenbers.add(new SelectOption(ctm.id,ctm.User__r.Name + ' [' + ctm.Release_Role__r.Role_Name__c + ']'));        
            }   
        }else{   
            List<Core_Team_Member__c> ctmList = [select User__r.id,User__r.Name, Release_Role__r.Role_Name__c 
                from Core_Team_Member__c where Release_Role__r.Offering_Release__c =: sweC.Release_Stage_ID__r.Offering_Release_ID__c 
                and Release_Role__r.Role_ID__r.Id =: SelectRole order by User__r.Name];
            Role__c roleTemp = [select Role_Name__c, Name from Role__c where id = : SelectRole];        
            teammenbers =  new List<SelectOption>();
            teammenbers.add(new SelectOption('noctm',''));  
            if(ctmList.size() > 0){            
                for(Core_Team_Member__c ctm: ctmList ){
                     teammenbers.add(new SelectOption(ctm.id,ctm.User__r.Name + ' ['+ ctm.Release_Role__r.Role_Name__c  +']'));        
                }
                //waringMessage = 'The Team Member must belongs to the  Role!'; 
                waringMessage = '';  
                waringMessageShow = 'none';                           
            }else{
                waringMessage =  'No resource allocated to this project role -- ' + roleTemp.Role_Name__c  +'. Please select another role!';
                waringMessageShow = 'block';       
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'There is no Team Member belongs to this Role, please add the Team Member to this Role before add Team Member to the Stage Work Element!'));
            }
        }    
    }    
    
        //add by june 05/22/2014
    public PageReference DeleteWE(){
        try{
            delete cc;
            PageReference WEPage = new PageReference('/'+sweC.id);
            WEPage.setRedirect(true);
            return WEPage;
        }
         catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: Review Delete Exception. Please contact IT administrators if any assistance needed.'));
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Operation Failed: ' + e.getMessage()));
            return null;   
        } 
    }
    //--end--
    
    
    public void changeTeamMember(){
        Stage_Work_Element__c sweC = [select Release_Stage_ID__r.Offering_Release_ID__c from Stage_Work_Element__c where id =: CurSwe limit 1];  
        if(SelectTeamMember != 'noctm'){  
            Core_Team_Member__c ctm = [select Release_Role__r.Role_ID__r.Id 
                from Core_Team_Member__c where  id =: SelectTeamMember ];                
            SelectRole =  ctm.Release_Role__r.Role_ID__r.Id; 
        }else{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('norole',''));                    
            for(Role__c rc: [select Role_Name__c, Name from Role__c]){
                options.add(new SelectOption(rc.Id,rc.Role_Name__c));        
            }  
        } 
    } 
}