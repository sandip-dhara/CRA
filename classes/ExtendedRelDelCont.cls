public class ExtendedRelDelCont {
    /*public string CurServiceLine{get;set;}
    public string CurServiceLineId{get;set;}    
    public string CurOffering{get;set;}
    public string CurOfferingId{get;set;}    
    public string CurRelease{ get;set;}
    public string CurReleaseId{get;set;}
    public string CurOfferingReleaseStage{get;set;}
    public string CurOfferingReleaseStageId{get;set;}        
    public string CurReleaseDeliverable{get;set; }
    public string CurReleaseDeliverableId{get;set;} 
    public string SelectTeamMember{get;set;}       
    public boolean DisableRelease{get;set;}
    public class Rdc_User{
        public List<Release_Deliverable_Contributor__c> rdc{get;set;}
        public String username{get;set;}
        public string userImgUrl{get;set;} 
        public string userLink{get;set;}       
    }
    public class Rdcname_User{
        public List<Release_Deliverable_Contributor__c> rdc_relname{get;set;}
        public String rd_name {get;set;}
    }

    public Release_Deliverable_Contributor__c reldelcont;
    public string   rdName{get;set;} 
      ///////////////


    public List<SelectOption> teammember{get;set;} */    
     
    public ExtendedRelDelCont(ApexPages.StandardController controller) {
        /*this.reldelcont = (Release_Deliverable_Contributor__c)controller.getRecord();
        string upId = ApexPages.currentPage().getParameters().get('id');
        if(string.isNotEmpty(upId)) //update Release_Deliverable_Contributor
        {
            Release_Deliverable_Contributor__c c = [select Contributor__c,Team_Member_ID__c,Team_Member_Name__c, Release_Deliverable_Name__c, Release_Deliverable_ID__c, Deliverable_Name__c, Stage_Name__c from Release_Deliverable_Contributor__c where id=:upId];
            SelectTeamMember = c.Team_Member_ID__c;
            CurReleaseDeliverable = c.Release_Deliverable_Name__c;
            rdName =   c.Release_Deliverable_Name__c;          
            CurReleaseDeliverableId = c.Release_Deliverable_ID__c; 
            Release_Deliverable__c rd =  [select Offering_Release_Stage_ID__c, Stage_Name__c from Release_Deliverable__c where id=:CurReleaseDeliverableId];
            CurOfferingReleaseStage = rd.Stage_Name__c;
            CurOfferingReleaseStageId= rd.Offering_Release_Stage_ID__c;
            Offering_Release_Stage__c ors = [select Offering_Release_ID__c, Offering_Release_Name__c from Offering_Release_Stage__c where id=:CurOfferingReleaseStageId];
            CurRelease = ors.Offering_Release_Name__c;
            CurReleaseId =  ors.Offering_Release_ID__c;
            Offering_Release__c orc = [select Offering_ID__c, Offering_Name__c from Offering_Release__c where id=:CurReleaseId ];
            CurOffering = orc .Offering_Name__c;
            CurOfferingId = orc .Offering_ID__c; 
            Offering__c offering = [select Service_Line__c, Service_Line_Name__c from Offering__c where id=:CurOfferingId ];
            CurServiceLine = offering .Service_Line__c;
            CurServiceLineId = offering .Service_Line_Name__c;            
            DisableRule = true;            
            ShowByID();
            myEditStates = 'Update';
        }
        else      //save a new Release_Deliverable_Contributor
        {
            string rdId = reldelcont.Release_Deliverable_ID__c;
            if(string.isNotEmpty(rdId)){
                CurReleaseDeliverableId = rdId;
                Release_Deliverable__c rd =  [select Offering_Release_Stage_ID__c, Stage_Name__c,Release_Deliverable_Name__c from Release_Deliverable__c where id=:CurReleaseDeliverableId];
                CurOfferingReleaseStage = rd.Stage_Name__c;
                CurOfferingReleaseStageId= rd.Offering_Release_Stage_ID__c;
                CurReleaseDeliverable = rd.Release_Deliverable_Name__c;
                rdName =  rd.Release_Deliverable_Name__c;             
                Offering_Release_Stage__c ors = [select Offering_Release_ID__c, Offering_Release_Name__c from Offering_Release_Stage__c where id=:CurOfferingReleaseStageId];
                CurRelease = ors.Offering_Release_Name__c;
                CurReleaseId =  ors.Offering_Release_ID__c;
                Offering_Release__c orc = [select Offering_ID__c, Offering_Name__c from Offering_Release__c where id=:CurReleaseId ];
                CurOffering = orc .Offering_Name__c;
                CurOfferingId = orc .Offering_ID__c; 
                Offering__c offering = [select Service_Line__c, Service_Line_Name__c from Offering__c where id=:CurOfferingId ];
                CurServiceLine = offering .Service_Line__c;
                CurServiceLineId = offering .Service_Line_Name__c; 
            }
            DisableRule = false;        
            ShowByID();
            myEditStates = 'New';
        } 
        if(string.isNotEmpty(CurReleaseDeliverableId))
        {
            Offering_Release__c orc = [select Offering_ID__c,Offering_Name__c from Offering_Release__c where id=:CurReleaseId];
            CurOffering = orc.Offering_Name__c;
            CurOfferingId = orc.Offering_ID__c;
            Offering__c oc = [select Service_Line_Name__c,Service_Line__c from Offering__c where id =:CurOfferingId];
            CurServiceLine = oc.Service_Line__c;
            CurServiceLineId = oc.Service_Line_Name__c;
            DisableRelease = true;
            teammember = new List<SelectOption>();  
            List<Core_Team_Member__c> ctmList = [select id,User__r.Name from Core_Team_Member__c where Offering_Release_Id__c=:CurReleaseId order by User__r.Name];
            for(Core_Team_Member__c ctmTemp : ctmList )
            {
                teammember.add(new SelectOption(ctmTemp.id,ctmTemp.User__r.Name));
            }          
                        
        }
        else
        {
            DisableRelease = false;
            teammember = new List<SelectOption>();            
        }*/
    }
   /* public String RDCSearchText{get;set;}    
    public String st;    
    //public List<Release_Deliverable__c> rd = [select Name, Release_Deliverable_Name__c from Release_Deliverable__c where Name =: Apexpages.currentPage().getParameters().get('CF00NZ000000135Yh')]; 
    public List<Release_Deliverable__c> rd{get;set;}
    
    public string myEditStates{get;set;}    
    public boolean DisableRule {get;set;}

    public List<Release_Deliverable_Contributor__c> RelDelContList{get;set;}
   
    private String sortDirection = 'ASC';
    public String getSortDirection()
    {
        
         return (sortDirection == 'ASC')? 'DESC' : 'ASC';
    }

    public void setSortDirection(String value)
    {  
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
    }
    public List<Rdc_User> rdc_u_list {get;set;}
    public Map<String,List<Release_Deliverable_Contributor__c>> DeConMap {get;set;}
    
    public List<String> namelist{get;set;}   

    public void RDCSearch(){  
        if(string.isEmpty(RDCSearchText) || RDCSearchText.isWhitespace() )
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'the search string can not be null or whitespace.'));
        }
        else
        {
            st = '%' + RDCSearchText+ '%';
            if( sortDirection == 'DESC'){
                RelDelContList = [select Contributor__c,Contributor__r.Name, Release_Deliverable_Name__c, Release_Deliverable_ID__c, Deliverable_Name__c, Stage_Name__c  from Release_Deliverable_Contributor__c  where Release_Deliverable_Name__c like :st order by Contributor__r.Name desc]; 
            }else{
                RelDelContList = [select Contributor__c,Contributor__r.Name, Release_Deliverable_Name__c, Release_Deliverable_ID__c, Deliverable_Name__c, Stage_Name__c  from Release_Deliverable_Contributor__c  where Release_Deliverable_Name__c like :st order by Contributor__r.Name ];
            }
            rdc_u_list = new List<Rdc_User>();
            DeConMap = new Map<String,List<Release_Deliverable_Contributor__c>>();
            namelist= new List<String>(); 
            for(Release_Deliverable_Contributor__c a: RelDelContList) {
              if(DeConMap.containsKey(a.Contributor__r.Name)) {
                DeConMap.get(a.Contributor__r.Name).add(a);
              } else {
                namelist.add(a.Contributor__r.Name);
                DeConMap.put(a.Contributor__r.Name,new List<Release_Deliverable_Contributor__c>{a});
              }              
            }
            for(String name : namelist)
            { 
              Rdc_User temp  = new Rdc_User();      
              temp.username = name;             
              temp.rdc = DeConMap.get(name);
              rdc_u_list.add(temp);
            }           
        }
    }
    public List<Rdcname_User> rn_Rdc_list {get;set;}    
    public Map<String,List<Release_Deliverable_Contributor__c>> DeConMapOrderByRname {get;set;}
    public List<String> rnList {get;set;}
    public void RDCSearchOrderByRname(){  
        if(string.isEmpty(RDCSearchText) || RDCSearchText.isWhitespace() )
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'the search string can not be null or whitespace.'));
        }
        else
        {
            st = '%' + RDCSearchText+ '%';
            if( sortDirection == 'DESC'){
                RelDelContList = [select Contributor__c,Contributor__r.Name, Release_Deliverable_Name__c, Release_Deliverable_ID__c, Deliverable_Name__c, Stage_Name__c  from Release_Deliverable_Contributor__c  where Release_Deliverable_Name__c like :st order by Release_Deliverable_Name__c desc]; 
            }else{
                RelDelContList = [select Contributor__c,Contributor__r.Name, Release_Deliverable_Name__c, Release_Deliverable_ID__c, Deliverable_Name__c, Stage_Name__c  from Release_Deliverable_Contributor__c  where Release_Deliverable_Name__c like :st order by Release_Deliverable_Name__c ]; 
            }
            rn_Rdc_list = new List<Rdcname_User>();
            DeConMapOrderByRname = new Map<String,List<Release_Deliverable_Contributor__c>>();
            rnList = new List<String>();           
            for(Release_Deliverable_Contributor__c a: RelDelContList) {
              List<User> userlist = [SELECT Email,Name FROM User WHERE Id=: a.Contributor__c];
              if(DeConMapOrderByRname.containsKey(a.Release_Deliverable_Name__c)) {
                DeConMapOrderByRname.get(a.Release_Deliverable_Name__c).add(a);
              } else {
                rnList.add(a.Release_Deliverable_Name__c);
                DeConMapOrderByRname.put(a.Release_Deliverable_Name__c,new List<Release_Deliverable_Contributor__c>{a});
              }
            }
            for(String name : rnList)
            { 
              Rdcname_User temp  = new Rdcname_User();      
              temp.rd_name= name;
              temp.rdc_relname = DeConMapOrderByRname.get(name);
              rn_Rdc_list.add(temp);
            }               
        }
    }  
    public void ShowByID(){
        
            String rdId = reldelcont.Release_Deliverable_ID__c;        
            if( sortDirection == 'DESC'){
                RelDelContList = [select Team_Member_ID__c,Team_Member_Name__c,Release_Deliverable_Name__c, Release_Deliverable_ID__c, Deliverable_Name__c, Stage_Name__c  from Release_Deliverable_Contributor__c  where Release_Deliverable_ID__c = :rdId order by Team_Member_Name__c desc]; 
            }else{
                RelDelContList = [select Team_Member_ID__c,Team_Member_Name__c, Release_Deliverable_Name__c, Release_Deliverable_ID__c, Deliverable_Name__c, Stage_Name__c  from Release_Deliverable_Contributor__c  where Release_Deliverable_ID__c = :rdId order by Team_Member_Name__c ];
            }   
            rdc_u_list = new List<Rdc_User>();
            DeConMap = new Map<String,List<Release_Deliverable_Contributor__c>>();
            namelist= new List<String>(); 
            Map<string,string> photoMap = new Map<string,string>();
            Map<string,string> linkMap = new Map<string,string>();            
            for(Release_Deliverable_Contributor__c a: RelDelContList) {
              Core_Team_Member__c ctm = [select User__r.SmallPhotoUrl from Core_Team_Member__c where id =: a.Team_Member_ID__c];            
              //User userTemp = [select SmallPhotoUrl from User where id =: a.Team_Member_ID__r.User__c];            
              if(DeConMap.containsKey(a.Team_Member_Name__c)) {
                DeConMap.get(a.Team_Member_Name__c).add(a);                 
              } else {
                namelist.add(a.Team_Member_Name__c);
                DeConMap.put(a.Team_Member_Name__c,new List<Release_Deliverable_Contributor__c>{a});
                photoMap.put(a.Team_Member_Name__c,ctm.User__r.SmallPhotoUrl);
                linkMap.put(a.Team_Member_Name__c,ctm.User__c);                
              }              
            }
            for(String name : namelist)
            { 
              Rdc_User temp  = new Rdc_User();      
              temp.username = name;
              temp.userImgUrl =  photoMap.get(name);              
              temp.rdc = DeConMap.get(name);
              temp.userLink = '/_ui/core/userprofile/UserProfilePage?u=' + linkMap.get(name);
              rdc_u_list.add(temp);
            }
            //Show Sorted by release deliveralbe name
            if( sortDirection == 'DESC'){
                RelDelContList = [select Team_Member_ID__c,Team_Member_Name__c, Release_Deliverable_Name__c, Release_Deliverable_ID__c, Deliverable_Name__c, Stage_Name__c  from Release_Deliverable_Contributor__c  where Release_Deliverable_ID__c =:rdId order by Release_Deliverable_Name__c desc]; 
            }else{
                RelDelContList = [select Team_Member_ID__c,Team_Member_Name__c, Release_Deliverable_Name__c, Release_Deliverable_ID__c, Deliverable_Name__c, Stage_Name__c  from Release_Deliverable_Contributor__c  where Release_Deliverable_ID__c =:rdId order by Release_Deliverable_Name__c ]; 
            }
            rn_Rdc_list = new List<Rdcname_User>();
            DeConMapOrderByRname = new Map<String,List<Release_Deliverable_Contributor__c>>();
            rnList = new List<String>();           
            for(Release_Deliverable_Contributor__c a: RelDelContList) {
              //List<User> userlist = [SELECT Email,Name FROM User WHERE Id=: a.Contributor__c];
              if(DeConMapOrderByRname.containsKey(a.Release_Deliverable_Name__c)) {
                DeConMapOrderByRname.get(a.Release_Deliverable_Name__c).add(a);
              } else {
                rnList.add(a.Release_Deliverable_Name__c);
                DeConMapOrderByRname.put(a.Release_Deliverable_Name__c,new List<Release_Deliverable_Contributor__c>{a});
              }
            }
            for(String name : rnList)
            { 
              Rdcname_User temp  = new Rdcname_User();      
              temp.rd_name= name;
              temp.rdc_relname = DeConMapOrderByRname.get(name);
              rn_Rdc_list.add(temp);
            }
        
    
    }    
    public PageReference save(){
        try{
            reldelcont.Team_Member_ID__c = SelectTeamMember; 
            string validateStr = ValidateRelDelCont(reldelcont); 
            if(validateStr == 'success'){
                reldelcont.Team_Member_ID__c = SelectTeamMember;
                upsert reldelcont;
                PageReference RDCPage = new ApexPages.StandardController(reldelcont).view();
                RDCPage.setRedirect(true);
                //return RDCPage; 
                string s = '/' + reldelcont.Release_Deliverable_ID__c;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, s));

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
     
    public string ValidateRelDelCont(Release_Deliverable_Contributor__c rdc)
    {
        string result = 'success';
        try{
            Release_Deliverable_Contributor__c[] seaRdc = [select name,Team_Member_Name__c from Release_Deliverable_Contributor__c where Release_Deliverable_ID__c=:reldelcont.Release_Deliverable_ID__c and Team_Member_ID__c=:reldelcont.Team_Member_ID__c];
            if(seaRdc.size() > 0 )
            {
                result = 'The same Release Deliverable Contribtor alredy exist, Please confirm your input';               
            } 
        }
        catch(exception e){
            result = 'Validate data occur Exception:' + e.getMessage();
        }
        return result;
    }
     
      public Pagereference doSaveAndNew()
      {
        try{
            reldelcont.Team_Member_ID__c = SelectTeamMember;         
            string validateStr = ValidateRelDelCont(reldelcont); 
            if(validateStr == 'success'){                         
                upsert reldelcont;
                string s = '/' + ('' + reldelcont.get('Id')).subString(0, 3) + '/e?';
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

      }*/
}