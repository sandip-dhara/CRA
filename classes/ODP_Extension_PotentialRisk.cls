public class ODP_Extension_PotentialRisk {

        //Hunter begin
        public List<BusinessImpact> BusinessImpactList{get;set;}
        public Risks__c NewRisk {get;set;}
        public String selectedBI{get;set;}
        public String selectedRC{get;set;}
        public String selectedPC{get;set;}
        public Integer SelectedRPN{get;set;}
        //Hunter end
        
        public string errorMessage{get;set;}
        public id UserId {get;set;}
        public Id ProjectId {get;set;}
        public string projectName {get;set;}
        public string projectStatus {get;set;}
        public Id teamMemberId {get;set;}
        public static  Id  StaticProjectId {get;set;}
        public Id PotentialRskId {get;set;}
        public string TeamOwnerId {get;set;}
        public static string PotentialRiskDesc {get;set;}
        public static string PotentialRiskId {get;set;}
        public string PRiskId {get;set;}
        public static string hdnPotentailRisk {get;set;}
        
        set<id> bicdff=new set<id>();
        set<id> bdff=new set<id>();
        Map<id,string> bimap=new Map<id,string>();
        Map<id,string> rcmap=new Map<id,string>();
        Map<id,string> prmap=new Map<id,string>();
        public map<id, list<Business_Impact_Cause__c>> tempBusMap {get;set;}
        
        public static string HiddenRiskId {get;set;}
        
        
         public String redirectToProject
        {
        get{
                return ConstructProjectURL();
        }
        set;
        }
        
        
        public boolean IsBusinessExistRootTab 
        {
        get{
           
            list<Business_Impact__c> lstBICount=new list<Business_Impact__c>();
                string RiskId=ApexPages.currentPage().getParameters().get('id');
                if(RiskId=='')
                {
                  RiskId=HiddenRiskId;
                }
            lstBICount= [select Id FROM Business_Impact__c where Potential_Risk_ID__c=:RiskId];
            
            if(lstBICount.size()>0)
            {
              return true;
            }
            else
            {
                return false;
            }
            
        
        }
        set;
        }
        
        public boolean IsRootExistProcessTab 
        {
        get{
           
                List<Root_Cause__c> lstRoot = new List<Root_Cause__c>();
                string RiskId=ApexPages.currentPage().getParameters().get('id');
                if(RiskId=='')
                {
                  RiskId=HiddenRiskId;
                }
                lstRoot=[select Id FROM Root_Cause__c where Potential_Risk_ID__c=:RiskId];
                
                if(lstRoot.size()>0)
                {
                  return true;
                }
                else
                {
                    return false;
                }
            
        }
        set;
        }
        
        public boolean IsProcessExistRiskTab 
        {
        get{
           
                List<Process_Control__c> lstPC = new List<Process_Control__c>();
                string RiskId=ApexPages.currentPage().getParameters().get('id');
                if(RiskId==null || (RiskId==''))
                {
                  RiskId=HiddenRiskId;
                }
                lstPC=[select Id FROM Process_Control__c where Potential_Risk_ID__c=:RiskId];
                
                if(lstPC.size()>0)
                {
                  return true;
                }
                else
                {
                    return false;
                }
            
        }
        set;
        }
        
        public boolean IsRCExistProcessCntrlTab {get;set;}
        
        
        Public string GetAvailableBusinessImpacts
        {
            get
            {
                string RiskId=ApexPages.currentPage().getParameters().get('id');
                List<Business_Impact__c> lstAvlblBusinessImpact=[SELECT Id,Business_Impact_Name__c FROM Business_Impact__c where Potential_Risk_ID__c=:RiskId];
                string jsonString=JSON.serialize(lstAvlblBusinessImpact);
                return jsonString;
            }
            set;
        }
        
        @RemoteAction
        public static List<Business_Impact__c> ReturnLatestBIs(string RiskId)
        {
                string jsonString='';
                List<Business_Impact__c> lstAvlblBusinessImpact=new  List<Business_Impact__c> ();
                lstAvlblBusinessImpact=[SELECT Id, Potential_Risk_ID__c, Severity__c, Description__c,Business_Impact_Name__c FROM Business_Impact__c where Potential_Risk_ID__c=:RiskId];
               // jsonString=JSON.serialize(lstAvlblBusinessImpact);
                return lstAvlblBusinessImpact;
        }
        
        
     public PageReference cancelButton(){

         
         System.Debug('projectId$$$$$$$'+projectId);
         
              PageReference cancelPage = new PageReference(ConstructProjectURL());
          cancelPage.setRedirect(true);
       
        return cancelPage;
   }
public string ConstructProjectURL()
{
 if(projectId == null)
      {
          string RiskId=ApexPages.currentPage().getParameters().get('id');
          System.Debug('RiskId$$$$$$$'+RiskId);
          List<Potential_Risk__c> lstPotentialrisk=[select Project_ID__c FROM Potential_Risk__c where id=:RiskId];
          if(lstPotentialrisk.size()>0){
              for(Potential_Risk__c  curntPotential :lstPotentialrisk){
                 projectId=curntPotential.Project_ID__c;
                 system.debug('projectId$$$$'+projectId);
              }
          }        
      
        }
          String hostName = 'https://' + ApexPages.CurrentPage().getHeaders().get('Host').remove('--c').replace('visual.force','my.salesforce')+ '/' + projectId;
 return hostName;
}
        public static void GetPotentialRiskId()
        {
        system.debug('StaticProjectId:'+StaticProjectId);
          list<Potential_Risk__c> lstPotentailRsk=[select Id FROM Potential_Risk__c where Project_ID__c=:StaticProjectId];
          system.debug('lstPotentailRsk:'+lstPotentailRsk.size());
          if(lstPotentailRsk.size()>0){
            for(Potential_Risk__c  potential :lstPotentailRsk){
            PotentialRiskId=potential.Id;
            //PotentialRskId=potential.Id();
            }
            }
            system.debug('PotentialRiskId:'+PotentialRiskId);
        }
        
        public list<Business_Impact__c> GetBusinessImpact
        {
        get{
            list<Business_Impact__c> lstBusinessImpact=new list<Business_Impact__c>();
            system.debug('ProjectId:'+ProjectId);
            string RiskId=ApexPages.currentPage().getParameters().get('id');
            list<Potential_Risk__c> lstPotentailRsk=new list<Potential_Risk__c>();
            
            if(RiskId!=null && RiskId!='')
            {
             lstPotentailRsk=[select Id FROM Potential_Risk__c where Id=:RiskId];
            }
            
           
            set<ID> setPotentialRisk=new set<ID>();
            for(Potential_Risk__c pRC:lstPotentailRsk)
            {
              setPotentialRisk.add(pRC.Id);
            }
            
            
        lstBusinessImpact= [SELECT Description__c, Severity__c, Potential_Risk_ID__c, Id,Business_Impact_Name__c FROM Business_Impact__c where Potential_Risk_ID__c in:setPotentialRisk];

                system.debug('lstBusinessImpact:'+lstBusinessImpact.size());
            return lstBusinessImpact;
        }
        set;
        
        }
        
        public class BusinessImapact
        {
          public string BIID {get;set;}
          public String BIName {get;set;}
          public string BIDescription {get;set;}
          public string BISeverity {get;set;}
          
        }
        
         public class RootCause
        {
            public String RCID {get;set;}
            public String RCDescription {get;set;}
            public String RCOccurance {get;set;}
            public String RCName {get;set;}
            public list<BusinessImapact> BIIds {get;set;}
            public List<string> lstBIIds {get;set;}
        }
        
        public class customRootCause
        {
          // public string RootCauseId {get;set;}
          // public string RootDescription {get;set;}
          // public string Occurance {get;set;}
          public integer iRowCount {get;set;}
           public List<BusinessImapact> lstCustBI {get;set;}
          
          public Root_Cause__c  objRootCause  {get;set;}
         // public list<Business_Impact__c> lstBImpact {get;set;}
          
        }
        
        
        
        public list<customRootCause> GetRootCauses
        {
        get{
        
        List<customRootCause> lstCustomRootCause=new List<customRootCause>();
        List<Root_Cause__c> lstRoot=new List<Root_Cause__c>();
        string PRiskId=ApexPages.currentPage().getParameters().get('id');
        lstRoot=  [SELECT Id, Potential_Risk_ID__c, Description__c, Occurance__c,Root_Cause_Name__c FROM Root_Cause__c where Potential_Risk_ID__c =:PRiskId ];
        
        Map<string,string> MapRootBI=new Map<string,string>();
        List<Business_Impact_Cause__c> lstBICause=new List<Business_Impact_Cause__c>();
        
        lstBICause=[SELECT Id, Business_Impact_ID__c, Root_Cause_ID__c FROM Business_Impact_Cause__c];
        
        for(Business_Impact_Cause__c  BICCs:lstBICause){
        MapRootBI.put(BICCs.Root_Cause_ID__c,BICCs.Business_Impact_ID__c);
        }
        
        List<Business_Impact__c> lstBI= [SELECT Id, Potential_Risk_ID__c, Description__c, Severity__c,Business_Impact_Name__c FROM Business_Impact__c ];
        //List<Business_Impact__c> lstBI= [SELECT Id, Potential_Risk_ID__c, Description__c, Severity__c,Business_Impact_Name__c FROM Business_Impact__c where Potential_Risk_ID__c = 'a8eZ00000004D9F'];
        
        Map<string,string> mapBI=new Map<string,string>();
        
        for(Business_Impact__c BIC:lstBI)
        {
            mapBI.put(BIC.Id,BIC.Business_Impact_Name__c);
        }
        
        Map<string,string> mapRoot=new Map<string,string>();
        Integer iCountL=0;
        for(Root_Cause__c RCC:lstRoot)
        {
         customRootCause CRC=new customRootCause();
        Root_Cause__c objRootCau=new Root_Cause__c();
         objRootCau.Id=RCC.Id;
         objRootCau.Description__c=RCC.Description__c;
         objRootCau.Occurance__c=RCC.Occurance__c;
         objRootCau.Root_Cause_Name__c=RCC.Root_Cause_Name__c;
         CRC.objRootCause=objRootCau;
         CRC.iRowCount=iCountL;
         CRC.lstCustBI=new List<BusinessImapact>();
         
        for(Business_Impact_Cause__c BusinessICC:lstBICause)
        {
        
            if(BusinessICC.Root_Cause_ID__c==RCC.Id)
            {
                BusinessImapact BIS=new BusinessImapact();
                BIS.BIID=BusinessICC.Business_Impact_ID__c;
                BIS.BIDescription=mapBI.get(BusinessICC.Business_Impact_ID__c);
                CRC.lstCustBI.add(BIS);
            
            }
        }
        
        lstCustomRootCause.add(CRC);
         iCountL++;
        }
       
            return lstCustomRootCause;
        }
        set;
        
        }
        
        
        @RemoteAction
        public static ReturnObj CreateBusinessImpact(list<BusinessImapact> lstBusinessImpact,string PrjId,string RiskId)
        {
          ReturnObj obj=new ReturnObj();
          obj.warningMessage='';
          List<Business_Impact__c> lstBI = new List<Business_Impact__c>();
          List<Business_Impact__c> lstUpdateBI = new List<Business_Impact__c>();
          list<Potential_Risk__c> lstPotentailRsk =new list<Potential_Risk__c>();
           system.debug('RiskId:'+RiskId);
           if(RiskId!='')
           {
             PotentialRiskId=RiskId;
           }
           
          system.debug('PotentialRiskId:'+PotentialRiskId);
          system.debug('lstBusinessImpact:'+lstBusinessImpact.size());
        Business_Impact__c  BIc;
          for(BusinessImapact BusImp:lstBusinessImpact)
          {
            BIc=new Business_Impact__c();
            system.debug('BusImp.BIID:'+BusImp.BIID);
            
            if(BusImp.BIID !='')
            {
               BIc.Business_Impact_Name__c = BusImp.BIName;
               BIc.Description__c= BusImp.BIDescription;
               BIc.Id=BusImp.BIID;
               BIc.Severity__c=BusImp.BISeverity;
               lstUpdateBI.add(BIc);
            }
            else
            { 
            boolean isFound= VerifyBusinessImpactName(BusImp.BIName,PotentialRiskId) ;
            if(!isFound)
            {      
            BIc.Business_Impact_Name__c = BusImp.BIName;
            BIc.Description__c= BusImp.BIDescription;
            BIc.Severity__c=BusImp.BISeverity;
            BIc.Potential_Risk_ID__c=  PotentialRiskId;//'a8eZ00000004D9F'; // Temp hardcoded
            lstBI.add(BIc);
            }
            else
            {
                if(BusImp.BIName!=null)
                {
                obj.warningMessage+= BusImp.BIName +' Duplicate Business Impact';
                }
            }
     
            }
          }
          
          insert lstBI;
          system.debug('lstBI:'+lstBI.size());
          system.debug('lstUpdateBI:'+lstUpdateBI.size());
          update lstUpdateBI;
          obj.id='';
          obj.Status=true;
          obj.errorMessage='';
          obj.lstBusinessImpacts=new List<Business_Impact__c>();
          obj.lstBusinessImpacts=lstBI;
          return obj;
        }
        
        /* Remote Action Method for RootCause */
        
       @RemoteAction
        public static ReturnObj createRootCause(list<RootCause> lstRootCause,string PrjId,string RiskId)
        {
            boolean foundDuplicate=false;
             ReturnObj obj=new ReturnObj();
             obj.warningMessage='';
            List<Root_Cause__c> lstRC = new List<Root_Cause__c>();
            List<Root_Cause__c> lstUpdateRC = new List<Root_Cause__c>();
            List<Potential_Risk__c> lstPotentailRsk =new List<Potential_Risk__c>();
             PotentialRiskId=RiskId;

            List<Business_Impact_Cause__c> lstBICCExisting=new List<Business_Impact_Cause__c>();
            lstBICCExisting=[SELECT Id, Root_Cause_ID__c, Business_Impact_ID__c FROM Business_Impact_Cause__c ];
            
            for(RootCause RotCau: lstRootCause)
            {
                foundDuplicate=false;
                if(rotcau.lstBIIds.size()>0)
                {
                Root_Cause__c  RCC = new Root_Cause__c();
                
                 //Select inserted Business Impact
            if(RotCau.RCID =='')
            {
                 List<Root_Cause__c> lstRootCauseIds= [SELECT Id FROM Root_Cause__c where Root_Cause_Name__c =: RotCau.RCName and Potential_Risk_ID__c=:PotentialRiskId];
                 
                  for(Root_Cause__c currentRC:lstRootCauseIds)
                {
                    RotCau.RCID =currentRC.Id;
                }
             }
             
                if(RotCau.RCID =='')
                {
                  // boolean isFound= VerifyRootCauseName(RotCau.RCName,PotentialRiskId) ;
                  // if(!isFound)
                  // {  
                    RCC.Root_Cause_Name__c = RotCau.RCName;
                    RCC.Description__c = RotCau.RCDescription;
                    RCC.Occurance__c = RotCau.RCOccurance;
                    RCC.Potential_Risk_ID__c = PotentialRiskId; 
                    insert RCC;
                   //}
                  /* else
                   {
                     if(RotCau.RCName!=null)
                     {
                           foundDuplicate=true;
                           obj.warningMessage+= RotCau.RCName +' Duplicate Root Cause';
                     }
                   }*/
                }
                else{
                    RCC.Root_Cause_Name__c = RotCau.RCName;
                    RCC.Description__c = RotCau.RCDescription;
                    RCC.Id= RotCau.RCID;
                    RCC.Occurance__c = RotCau.RCOccurance;              
                    lstUpdateRC.add(RCC);
                }
               // if(!foundDuplicate)
               // {
                
                List<Business_Impact_Cause__c> lstBICC=new List<Business_Impact_Cause__c>();
                
               for(Business_Impact_Cause__c BICCC:lstBICCExisting)
                {
                   if(BICCC.root_cause_id__c==RCC.Id)
                    {
                       Delete BICCC;
                     }
                }

                                
                Business_Impact_Cause__c bicc;
                for(string strBIID :rotcau.lstBIIds)
                {
                      bicc=new Business_Impact_Cause__c();
                      bicc.business_impact_id__c=strBIID;
                      bicc.root_cause_id__c =RCC.Id;
                      lstBICC.add(bicc);                  
                }
                insert lstBICC;
                }
               // }
            }
            //insert lstRC;
            update lstUpdateRC;
            obj.id='';
            obj.Status=true;
            obj.errorMessage='';
            return obj;
        }
        
        
        public PageReference SavePotentialRisk()
        {
           Potential_Risk__c  objpotentialRisk=new  Potential_Risk__c();
         List<Potential_Risk__c> lstPotentailRsk =new List<Potential_Risk__c>();
         
         objpotentialRisk.Potential_Risk_Owner__c = potentialRisk.Potential_Risk_Owner__c;
         objpotentialRisk.Description__c=potentialRisk.Description__c;
         
         
          string RiskId=ApexPages.currentPage().getParameters().get('id');
          system.debug('MuRiskId:'+RiskId);
            if(RiskId!='' &&  RiskId!=null)
            {
               objpotentialRisk.Id=RiskId;
               update objpotentialRisk;
            }
            else
            {
               objpotentialRisk.Project_ID__c=ProjectId;
            try{ 
               insert objpotentialRisk;
               RiskId=objpotentialRisk.Id;
               }               
              catch(DmlException e) {
                 errorMessage=e.getMessage();
                  return null;
                }
            }
            PageReference pRef = new PageReference('/apex/ODP_PotentialRisk');
                pRef.getParameters().put('id',RiskId );
                pRef.setRedirect(true);
                return pRef;
        }
          @RemoteAction
        public static ReturnObj CreateProjectRisk(string ProjId,string PotentialDescription,string potentialUserId,string RiskId)
        {
          ReturnObj obj=new ReturnObj();
          obj.id='';
          obj.Status=false;
          obj.errorMessage='';
          
         Potential_Risk__c  objpotentialRisk=new  Potential_Risk__c();
         List<Potential_Risk__c> lstPotentailRsk =new List<Potential_Risk__c>();
         objpotentialRisk.Potential_Risk_Owner__c = potentialUserId;
         
         objpotentialRisk.Description__c=PotentialDescription;
          
            if(RiskId!='')
            {
               objpotentialRisk.Id=RiskId;
               update objpotentialRisk;
            }
            else
            {
               objpotentialRisk.Project_ID__c=ProjId;
               insert objpotentialRisk;
               obj.id=objpotentialRisk.Id;
            }
         obj.Status=true;
         
         return obj;
        }
        
        /* To Delete Business Impact */
        
        @RemoteAction
        public static ReturnObj deleteBusinessImpact(string businessImpactId)
        {
            boolean foundRisks=false;
            ReturnObj obj=new ReturnObj();
            obj.errorMessage='';

           List<Risks__c> lstRiskBI = [SELECT Id,Business_Impact_ID__c FROM Risks__c where Business_Impact_ID__c=:businessImpactId];
               if(lstRiskBI.size()>0){
                   foundRisks=true;
               }
               if(!foundRisks)
               {
                   List<Business_Impact_Cause__c> lstBusinessImpactCauseBI = [SELECT Id,Business_Impact_ID__c FROM Business_Impact_Cause__c where Business_Impact_ID__c=:businessImpactId];
                   if(lstBusinessImpactCauseBI.size()>0){
                        for(Business_Impact_Cause__c objCurrentBICause:lstBusinessImpactCauseBI ){
                            Delete objCurrentBICause;
                        }
                   }
                   List<Business_Impact__c> lstBusinessImpact = [SELECT Id,Name,Potential_Risk_ID__c,Severity__c,Description__c,Business_Impact_Name__c FROM Business_Impact__c where Id=:businessImpactId];
                   if(lstBusinessImpact.size()>0){
                        for(Business_Impact__c objCurretBI:lstBusinessImpact ){
                             Delete objCurretBI;
                        }
                   }
                   obj.id=businessImpactId;
               }
               else
               {
                    obj.errorMessage='Cannot delete business Imapct since it has been associated with a risk';
               }
            return obj;
        }

       /* To Delete Root Cause */
        
        @RemoteAction
        public static ReturnObj deleteRootCause(string rootCauseId)
        {
            boolean foundRisks=false;
            ReturnObj obj=new ReturnObj();
            obj.errorMessage='';
            List<Risks__c> lstRiskBI = [SELECT Id,Root_Cause_ID__c FROM Risks__c where Root_Cause_ID__c=:rootCauseId];
               if(lstRiskBI.size()>0){
                   foundRisks=true;
               }
               if(!foundRisks)
               {
                   List<Root_Cause_Control__c> lstRootCauseControl = [SELECT Id,Root_Cause_ID__c FROM Root_Cause_Control__c where Root_Cause_ID__c=:rootCauseId];
                   if(lstRootCauseControl.size()>0){
                        for(Root_Cause_Control__c objCurrentRCControl:lstRootCauseControl ){
                            Delete objCurrentRCControl;
                        }
                   }
                   List<Business_Impact_Cause__c> lstBusinessImpactCause = [SELECT Id,Root_Cause_ID__c FROM Business_Impact_Cause__c where Root_Cause_ID__c=:rootCauseId];
                   if(lstBusinessImpactCause.size()>0){
                        for(Business_Impact_Cause__c objBusinessImpactCause:lstBusinessImpactCause ){
                             Delete objBusinessImpactCause;
                        }
                   }
                   List<Root_Cause__c> lstRootCause = [SELECT Id,Description__c,Potential_Risk_ID__c,Root_Cause_Name__c, Occurance__c FROM Root_Cause__c where Id=:rootCauseId];
                   if(lstRootCause.size()>0){
                        for(Root_Cause__c objCurrentRootCause:lstRootCause ){
                             Delete objCurrentRootCause;
                        }
                   }
                   obj.id=rootCauseId;
               }
               else
               {
                    obj.errorMessage='Cannot delete Root Cause since it has been associated with a risk';
               }
            return obj;
        }       
       /* To Delete Process Conrol  */
        @RemoteAction
        public static ReturnObj deleteProcessControl(string processControlId)
        {
            boolean foundRisks=false;
            ReturnObj obj=new ReturnObj();
            obj.errorMessage='';
            List<Risks__c> lstRiskPC = [SELECT Id,Process_Control_ID__c FROM Risks__c where Process_Control_ID__c=:processControlId];
               if(lstRiskPC.size()>0){
                    foundRisks=true;
               }
            if(!foundRisks)
            {
                List<Root_Cause_Control__c> lstRootCauseControlPC = [SELECT Id,Process_Control_ID__c FROM Root_Cause_Control__c where Process_Control_ID__c=:processControlId];
                   if(lstRootCauseControlPC.size()>0){
                        for(Root_Cause_Control__c objRootCauseControlPC:lstRootCauseControlPC ){
                            Delete objRootCauseControlPC;
                        }
                   }
                List<Process_Control__c> lstProcessControl = [SELECT Id FROM Process_Control__c where Id=:processControlId];
                   if(lstProcessControl.size()>0){
                        for(Process_Control__c objProcessControl:lstProcessControl ){
                            Delete objProcessControl;
                        }
                   }
                 obj.id=processControlId;
             }
             else
               {
                    obj.errorMessage='Cannot delete Process Control since it has been associated with a risk';
               }
            return obj;
        }
        
       public string GetProject
        {
         get{
             string RiskId=ApexPages.currentPage().getParameters().get('id');
             
             string R=ProjectId;
              if(RiskId!='')
             {
                 list<Potential_Risk__c> lstPoten= [SELECT Id, Project_ID__c,Project_ID__r.Name__C FROM Potential_Risk__c where Id=:RiskId]; 
                for(Potential_Risk__c PRC:lstPoten)
                {
                 R= PRC.Project_ID__c;
                     ProjectId = PRC.Project_ID__c;
                } 
             }
        
             List<Offering_Release__c> lstProjects =[SELECT  Name,Name__c,Status__c FROM Offering_Release__c where Id =:R];
             string ProjName ='';
             if(lstProjects.size()>0){
             for(Offering_Release__c oRc:lstProjects ){
             ProjName=oRc.Name;
             projectName = oRc.Name__c;
             projectStatus = oRc.Status__c;
         }
         }
          
         return ProjName;
         }
     
     set;
    }
    
    public PageReference redirectToProject(){
        if(projectId == '' && projectId == null)
      {
          string RiskId=ApexPages.currentPage().getParameters().get('id');
          System.Debug('RiskId$$$$$$$'+RiskId);
          List<Potential_Risk__c> lstPotentialrisk=[select Project_ID__c FROM Potential_Risk__c where id=:RiskId];
          if(lstPotentialrisk.size()>0){
              for(Potential_Risk__c  curntPotential :lstPotentialrisk){
                 projectId=curntPotential.Project_ID__c;
                 system.debug('projectId$$$$'+projectId);
              }
          }        
      
        }
          String hostName = 'https://' + ApexPages.CurrentPage().getHeaders().get('Host').remove('--c').replace('visual.force','my.salesforce')+ '/' + projectId;
          PageReference cancelPage = new PageReference(hostName);
          cancelPage.setRedirect(true);
       
        return cancelPage;
    }

        public Potential_Risk__c potentialRisk{get;set;}
        public Process_Control__c processControl{get;set;}
        public Root_Cause__c rootCause{get;set;}
        public Business_Impact__c businessImpact{get;set;}
     
    public ODP_Extension_PotentialRisk (ApexPages.StandardController controller) {
          ProjectId=ApexPages.currentPage().getParameters().get('OFID');
          if(!String.IsEmpty(ProjectId)){
              offering_release__c  project = [select id,Name,name__c from offering_release__c where id=: ProjectId];
              ProjectName = project.name__c;
          }
          if(ProjectId==null)
          {
          //ProjectId=ApexPages.currentPage().getParameters().get('retURL').split('/')[1];
             PRiskId=ApexPages.currentPage().getParameters().get('id');
             ProjectName =  GetProject;
          }
          
          system.debug('PRiskId:'+PRiskId);
          system.debug('ProjectId:'+ProjectId);
         // system.debug('retURL:'+ApexPages.currentPage().getParameters().get('retURL').split('/')[1]);
          StaticProjectId=ApexPages.currentPage().getParameters().get('OFID');
          system.debug('StaticProjectId:'+StaticProjectId);
            potentialRisk = (Potential_Risk__c)controller.getRecord();
            GetPotentialRiskId();
            
            
          
               
         //Hunter begin
         NewRisk = new Risks__c();
         BusinessImpactList = new List<BusinessImpact>();
         List<Business_Impact__c> listBIC = [select Id,Business_Impact_Name__c,Severity__c from Business_Impact__c where Potential_Risk_ID__c=:potentialRisk.Id];
         for(Business_Impact__c bic:listBIC){
            integer pointI = 0;
            integer biSize = 0;
            BusinessImpact BI = New BusinessImpact();
            BI.ThisBusinessImpact = bic;
            BI.RootCouseList = new List<RootCouse>();
            List<Business_Impact_Cause__c> listBICC = [select Root_Cause_ID__r.Id,Root_Cause_ID__r.Root_Cause_Name__c,Root_Cause_ID__r.Occurance__c
                from Business_Impact_Cause__c where Business_Impact_ID__c=:bic.Id];
            List<Risks__c> BIRisks = [select Id,Name__c,Process_Control_ID__c,Root_Cause_ID__c from Risks__c where Business_Impact_ID__c=:bic.Id];
            Map<String,Risks__c> MapBIRisks = new Map<String,Risks__c>();
            for(Risks__c r:BIRisks){
                MapBIRisks.put(String.ValueOf(r.Root_Cause_ID__c) + '-' + String.ValueOf(r.Process_Control_ID__c),
                    r);
            }
            for(Business_Impact_Cause__c bicc:listBICC){
                pointI += 1;
                integer pointj = 0;
                RootCouse RC = new RootCouse();
                RC.ThisRootCause = bicc.Root_Cause_ID__r;
                RC.ProcessControlList = new List<ProcessControl>();
                List<Root_Cause_Control__c> listRCCC = [select Process_Control_ID__r.Id,Process_Control_ID__r.Process_Control_Name__c,Process_Control_ID__r.Detection__c
                    from Root_Cause_Control__c where Root_Cause_ID__c=:bicc.Root_Cause_ID__r.Id];
                for(Root_Cause_Control__c rccc:listRCCC){
                    pointj += 1;
                    biSize += 1;
                    ProcessControl BC = new ProcessControl();
                    BC.ShowRootCouse = pointj == 1;
                    BC.ShowBusinessImpact = pointj == 1 && pointi == 1;
                    BC.ThisProcessControl = rccc.Process_Control_ID__r;
                    String riskKey = bicc.Root_Cause_ID__r.Id + '-' + rccc.Process_Control_ID__r.Id;
                    if(MapBIRisks.ContainsKey(riskKey)){
                        BC.RiskIsExists = true;
                        BC.ThisRisk = MapBIRisks.get(riskKey);
                    }
                    else{
                        BC.RiskIsExists = false;
                    }
                    RC.ProcessControlList.add(BC);
                }
                RC.size = pointj;
                BI.RootCouseList.add(RC);
            }
            BI.Size = biSize;
            BusinessImpactList.add(BI);
         }
         //Hunter end
         
         
           
        }
        public PageReference save()
        {
        insert potentialRisk;
        return ApexPages.currentPage();
        
        }
        
    public static String getReferer()
    {
        return ApexPages.currentPage().getHeaders().get('referer');
    }
        
      public class ReturnObj
      {
         public string id{get;set;}
         public boolean Status{get;set;}
         public string errorMessage{get;set;} 
         public string warningMessage{get;set;} 
         List<Business_Impact__c> lstBusinessImpacts{get;set;}
      }
       public static boolean VerifyBusinessImpactName(string BusinessName,string PotentialId )
       {
          boolean found=false;
          list<Business_Impact__c> lstbusiname =[SELECT Id FROM Business_Impact__c where Business_Impact_Name__c=:BusinessName AND Potential_Risk_ID__c=:PotentialId];
          if(lstbusiname.size()>0)
          {
              found=true;
          }  
          return found;
       }
       public static boolean VerifyRootCauseName(string RootCauseName,string PotentialId )
       {
          boolean found=false;
          list<Root_Cause__c> lstrcname =[SELECT Id FROM Root_Cause__c where Root_Cause_Name__c=:RootCauseName AND Potential_Risk_ID__c=:PotentialId];
          if(lstrcname.size()>0)
          {
              found=true;
          }  
          return found;
       }
       public static boolean VerifyprocesscontrolName(string processcontrolName,string PotentialId )
       {
          boolean found=false;
          list<Process_Control__c> lstproconname =[SELECT Id FROM Process_Control__c where  Process_Control_Name__c=:processcontrolName AND Potential_Risk_ID__c=:PotentialId];
          if(lstproconname.size()>0)
          {
              found=true;
          }  
          return found;
       }
      
      

    public Map<Id,List<Business_Impact_Cause__c>> lstBIRoot {get;set;} 
        public boolean BIExists {get;set;}
        
        public Map<Id,List<Business_Impact_Cause__c>> getBIsRoot
        {
         get
         {
         set<Id> setPoten=new set<Id>();
         lstBIRoot=new Map<Id,List<Business_Impact_Cause__c>>();
          List<Business_Impact_Cause__c> bic=new  List<Business_Impact_Cause__c>();
         List<Root_Cause__c> lstPoten=new List<Root_Cause__c>();
         list<Potential_Risk__c> lstPotentailRsk=new list<Potential_Risk__c>();
        string PRiskId=ApexPages.currentPage().getParameters().get('id');
        if(PRiskId !='')
            {
        
            lstPoten = [select id,name from Root_Cause__c where Potential_Risk_ID__c=:PRiskId];
            for(Root_Cause__c biite : lstPoten)
            {
                setPoten.add(biite.id);
            }
            
            
            bic=[SELECT Id, Root_Cause_ID__c,Root_Cause_ID__r.name, Business_Impact_ID__c,Business_Impact_ID__r.Business_Impact_Name__c,Root_Cause_ID__r.Description__c,Root_Cause_ID__r.Occurance__c,Business_Impact_ID__r.description__c FROM Business_Impact_Cause__c where Root_Cause_ID__c In :setPoten];
            
            for(Business_Impact_Cause__c bff : bic)
            {
                
                bicdff.add(bff.Root_Cause_ID__c);
                if(lstBIRoot.containsKey(bff.Root_Cause_ID__c)){
                    list<Business_Impact_Cause__c> tempList = lstBIRoot.get(bff.Root_Cause_ID__c);
                    tempList.add(bff);
                    lstBIRoot.put(bff.Root_Cause_ID__c, tempList);
                }else{
                    list<Business_Impact_Cause__c> tempList = new list<Business_Impact_Cause__c>();
                    tempList.add(bff);
                    lstBIRoot.put(bff.Root_Cause_ID__c, tempList);
                }
            }
            system.debug('Root values' + lstBIRoot);
            system.debug('size'+lstBIRoot.size());
            if(lstBIRoot.size()>0)
            {
            BIExists=true;
            }
            
            
            
            
         }
         return lstBIRoot;
         }
         set;
        }
        
        
         //Hunter begin
        public void LoadNewRisk()
        {
            Business_Impact__C myBI = [select Business_Impact_Name__C,Severity__c from Business_Impact__C where Id=:NewRisk.Business_Impact_ID__c limit 1];
            selectedBI = myBI.Business_Impact_Name__C;
            Root_Cause__C myRC = [select Root_Cause_Name__C,Occurance__c from Root_Cause__C where Id=:NewRisk.Root_Cause_ID__C limit 1];
            selectedRC = myRC.Root_Cause_Name__C;
            Process_Control__c myPC = [select Process_Control_Name__C,Detection__c from Process_Control__c where Id=:NewRisk.Process_Control_ID__C limit 1];
            selectedPC = myPC.Process_Control_Name__C;
            //Ning Bug Fixing Start
            if(myBI.Severity__c == null){
                myBI.Severity__c = String.Valueof(0);
            }
            if(myRC.Occurance__c == null){
                myRC.Occurance__c = String.Valueof(0);
            }
            if(myPC.Detection__c == null){
                myPC.Detection__c = String.Valueof(0);
            }
            //Ning Bug Fixing End
            SelectedRPN = Integer.valueOf(myBI.Severity__c) * Integer.valueOf(myRC.Occurance__c) * Integer.valueOf(myPC.Detection__c);
        }
        
        public PageReference CreateRisk(){
            try{
                NewRisk.Risk_Owner__C = UserInfo.getUserId();
                insert NewRisk;
                PageReference pageRef = new PageReference('/apex/ODP_PotentialRisk?id=' + PRiskId);
                pageRef.setRedirect(true);
                return pageRef;
            }
            catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.InFO,'Create Risk Failed, Please Contact IT Administrator.'));
                return null;
            }
        }
        
        public class ProcessControl
        {
            public Process_Control__c ThisProcessControl{get;set;}
            public Risks__c ThisRisk{get;set;}
            public boolean ShowRootCouse{get;set;}
            public boolean ShowBusinessImpact{get;set;}
            public boolean RiskIsExists{get;set;}
              public String PCID {get;set;}
            public String PCName {get;set;}
            public String PCDescription {get;set;}
            public String PCDetection {get;set;}
            public List<string> lstRCIds {get;set;}
        }
        
        public class RootCouse
        {
            public Root_Cause__c ThisRootCause{get;set;}
            public integer size{get;set;}
            public List<ProcessControl> ProcessControlList{get;set;}
        }    
        
        public class BusinessImpact
        {
            public Business_Impact__c ThisBusinessImpact{get;set;}
            public integer size{get;set;}
            public List<RootCouse> RootCouseList{get;set;}
        }
        //Hunter end
        
         public list<customProcessControl> GetProcessControl
            {       
            get{
                List<customProcessControl> lstProcessControl = new List<customProcessControl>();
                List<Process_Control__c> lstProcess = new List<Process_Control__c>();
                string PRiskId =ApexPages.currentPage().getParameters().get('id');
                list<Potential_Risk__c> lstPotentailRsk=new list<Potential_Risk__c>();
                lstProcess =  [SELECT Id, Potential_Risk_ID__c, Description__c, Detection__c, Process_Control_Name__c FROM Process_Control__c where Potential_Risk_ID__c = :PRiskId];
                Map<string,string> MapPCRoot = new Map<string,string>();
                List<Root_Cause_Control__c> lstRTCause = new List<Root_Cause_Control__c>();   
                lstRTCause = [SELECT Id, Root_Cause_ID__c, Process_Control_ID__c FROM Root_Cause_Control__c];
                for(Root_Cause_Control__c  RTCCs: lstRTCause){
                    MapPCRoot.put(RTCCs.Process_Control_ID__c,RTCCs.Root_Cause_ID__c);
                }
                List<Root_Cause__c> lstRC = [SELECT Id, Potential_Risk_ID__c, Description__c, Occurance__c,Root_Cause_Name__c FROM Root_Cause__c where Potential_Risk_ID__c =:PRiskId];    
                
                Map<string,string> mapPC = new Map<string,string>();
                for(Root_Cause__c RCC: lstRC){
                    mapPC.put(RCC.Id,RCC.Root_Cause_Name__c);
                }
               
                Integer iCountL=0;
                for(Process_Control__c PCC: lstProcess){
                    customProcessControl CRC = new customProcessControl();
                    Process_Control__c objProcessCau = new Process_Control__c();
                    objProcessCau.Id = PCC.Id;
                    objProcessCau.Description__c = PCC.Description__c;
                    objProcessCau.Detection__c = PCC.Detection__c;
                    objProcessCau.Process_Control_Name__c = PCC.Process_Control_Name__c;
                    CRC.objProcessControl = objProcessCau;
                    CRC.iRowCount=iCountL;    
                    CRC.lstCustRC = new List<RootCause>();
                    for(Root_Cause_Control__c BusinessICC: lstRTCause){                 
                        if(BusinessICC.Process_Control_ID__c == PCC.Id){
                            RootCause BIS = new RootCause();
                            BIS.RCID = BusinessICC.Root_Cause_ID__c;
                            BIS.RCDescription=mapPC.get(BusinessICC.Root_Cause_ID__c);
                            CRC.lstCustRC.add(BIS);                     
                        }
                    }
                    lstProcessControl.add(CRC);
                    iCountL++;
                }
                 return lstProcessControl;
            }
            set;
        }

        public class customProcessControl
        {            
            public List<RootCause> lstCustRC {get;set;}  
            public integer iRowCount {get;set;}
            public Process_Control__c  objProcessControl  {get;set;}          
        }
       Public string GetAvailableRootCause
        {
            get
            {
                string RiskId=ApexPages.currentPage().getParameters().get('id');
                List<Root_Cause__c> lstAvlblRootCause =[SELECT Id, Potential_Risk_ID__c, Occurance__c, Description__c,Root_Cause_Name__c FROM Root_Cause__c where Potential_Risk_ID__c=:RiskId];
                string jsonString = JSON.serialize(lstAvlblRootCause);
                system.debug('lstAvlblRootCause---------'+lstAvlblRootCause);
                return jsonString;
            }
            set;
        }
        
        
        @RemoteAction
       public static boolean CreateProcessControl(list<ProcessControl> lstProcessControl,string PrjId,string RiskId)
       {
            ReturnObj obj=new ReturnObj();
            obj.warningMessage='';
            List<Process_Control__c> lstPC = new List<Process_Control__c>();
            List<Process_Control__c> lstUpdatePC = new List<Process_Control__c>();
            List<Potential_Risk__c> lstPotentailRsk =new List<Potential_Risk__c>();
            system.debug('RiskId:'+RiskId);
            
            List<Root_Cause_Control__c> lstBICCExisting = new List<Root_Cause_Control__c>();
            lstBICCExisting=[SELECT Id, Root_Cause_ID__c, Process_Control_ID__c FROM Root_Cause_Control__c ];

            for(ProcessControl ProCess: lstProcessControl){
                if(ProCess.lstRCIds.size()>0){
                    Process_Control__c  PCc = new Process_Control__c();                
                    if(ProCess.PCID == '')
                    {
                     //boolean isFound= VerifyprocesscontrolName(ProCess.PCName,RiskId) ;
                    // if(!isFound)
                     //{ 
                        system.debug('-------------insert---------------');
                        PCc.Process_Control_Name__c =  ProCess.PCName;
                        PCc.Description__c = ProCess.PCDescription;
                        PCc.Potential_Risk_ID__c=  RiskId;
                        PCc.Detection__c = ProCess.PCDetection;             
                        insert PCc;  
                    /* }
                     else
                     {
                        if(ProCess.PCName!=null)
                        {
                            obj.warningMessage+=ProCess.PCName +' Duplicate Process Control';
                        }
                    }*/
                    }
                    else{
                        system.debug('-------------Update---------------');
                        PCc.Process_Control_Name__c = ProCess.PCName;
                        PCc.Description__c = ProCess.PCDescription;
                        PCc.Detection__c = ProCess.PCDetection;
                        PCc.Id = ProCess.PCID;
                        lstUpdatePC.add(PCc);                
                    }
                    List<Root_Cause_Control__c> lstBICC = new List<Root_Cause_Control__c>();
                   for(Root_Cause_Control__c RCCCC:lstBICCExisting){
                            if(RCCCC.Process_Control_ID__c == PCc.Id){
                                Delete RCCCC;
                            }
                        }
                    for(string strBIID :ProCess.lstRCIds){
                            Root_Cause_Control__c bicc = new Root_Cause_Control__c();
                            bicc.Root_Cause_ID__c = strBIID;
                            bicc.Process_Control_ID__c = PCc.Id;
                            lstBICC.add(bicc);
                    }
                    insert lstBICC;
                }           
            }
            //insert lstPC;      
            update lstUpdatePC;    
            return true;
        }
        
         

         
    }