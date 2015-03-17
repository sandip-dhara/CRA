public class ODP_Extension_PotentialRisk_Hunter {
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
    public boolean IsRiskExisted{get;set;}
    //Hunter begin
    public List<BusinessImpact> BusinessImpactList{get;set;}
    public Risks__c NewRisk {get;set;}
    public String selectedBI{get;set;}
    public String selectedRC{get;set;}
    public String selectedPC{get;set;}
    public Integer SelectedRPN{get;set;}
    //Hunter end
    
    Public string GetAvailableBusinessImpacts
    {
        get
        {
            string RiskId=ApexPages.currentPage().getParameters().get('id');
            List<Business_Impact__c> lstAvlblBusinessImpact=[SELECT Id, Potential_Risk_ID__c, Severity__c, Description__c,Business_Impact_Name__c FROM Business_Impact__c where Potential_Risk_ID__c=:RiskId];
            string jsonString=JSON.serialize(lstAvlblBusinessImpact);
            return jsonString;
        }
        set;
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
        
        system.debug('lstPotentailRsk:'+potentialRisk.Id);
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
    
    public class RootCause{
        public String RCID {get;set;}
        public String RCDescription {get;set;}
        public String RCOccurance {get;set;}
        public String RCName {get;set;}
    }
    
    public class customRootCause
    {
      // public string RootCauseId {get;set;}
      // public string RootDescription {get;set;}
      // public string Occurance {get;set;}
      
       public List<BusinessImapact> lstCustBI {get;set;}
      
      public Root_Cause__c  objRootCause  {get;set;}
     // public list<Business_Impact__c> lstBImpact {get;set;}
      
    }
    
    
    public list<customRootCause> GetRootCauses
    {
    get{
    
    List<customRootCause> lstCustomRootCause=new List<customRootCause>();
    List<Root_Cause__c> lstRoot=new List<Root_Cause__c>();
    lstRoot=  [SELECT Id, Potential_Risk_ID__c, Description__c, Occurance__c,Root_Cause_Name__c FROM Root_Cause__c where Potential_Risk_ID__c = 'a8eZ00000004D9F'];
    
    Map<string,string> MapRootBI=new Map<string,string>();
    List<Business_Impact_Cause__c> lstBICause=new List<Business_Impact_Cause__c>();
    
    lstBICause=[SELECT Id, Business_Impact_ID__c, Root_Cause_ID__c FROM Business_Impact_Cause__c];
    
    for(Business_Impact_Cause__c  BICCs:lstBICause){
    MapRootBI.put(BICCs.Root_Cause_ID__c,BICCs.Business_Impact_ID__c);
    }
    
    
    List<Business_Impact__c> lstBI= [SELECT Id, Potential_Risk_ID__c, Description__c, Severity__c,Business_Impact_Name__c FROM Business_Impact__c where Potential_Risk_ID__c = 'a8eZ00000004D9F'];
    
    Map<string,string> mapBI=new Map<string,string>();
    
    for(Business_Impact__c BIC:lstBI)
    {
        mapBI.put(BIC.Id,BIC.Description__c);
    }
    
    Map<string,string> mapRoot=new Map<string,string>();
    
    for(Root_Cause__c RCC:lstRoot){
     customRootCause CRC=new customRootCause();
    Root_Cause__c objRootCau=new Root_Cause__c();
     objRootCau.Id=RCC.Id;
     objRootCau.Description__c=RCC.Description__c;
     objRootCau.Occurance__c=RCC.Occurance__c;
     objRootCau.Root_Cause_Name__c=RCC.Root_Cause_Name__c;
     CRC.objRootCause=objRootCau;
     
     // CRC.RootCauseId=RCC.Id;
     // CRC.RootDescription=RCC.Description__c;
     // CRC.Occurance=RCC.Occurance__c;
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
    }
        return lstCustomRootCause;
    }
    set;
    
    }
    
    
    @RemoteAction
    public static boolean CreateBusinessImpact(list<BusinessImapact> lstBusinessImpact,string PrjId,string RiskId)
    {
      List<Business_Impact__c> lstBI = new List<Business_Impact__c>();
      List<Business_Impact__c> lstUpdateBI = new List<Business_Impact__c>();
      list<Potential_Risk__c> lstPotentailRsk =new list<Potential_Risk__c>();
       system.debug('RiskId:'+RiskId);
       if(RiskId!='')
       {
         PotentialRiskId=RiskId;
       }
       else
       {
        lstPotentailRsk=[select Id FROM Potential_Risk__c where Project_ID__c=:PrjId];
          system.debug('lstPotentailRsk:'+lstPotentailRsk.size());
          if(lstPotentailRsk.size()>0)
          {
            for(Potential_Risk__c  potential :lstPotentailRsk)
            {
                PotentialRiskId=potential.Id;
            //PotentialRskId=potential.Id();
            }
           }
        }
      system.debug('PotentialRiskId:'+PotentialRiskId);
      system.debug('lstBusinessImpact:'+lstBusinessImpact.size());
    
      for(BusinessImapact BusImp:lstBusinessImpact)
      {
        Business_Impact__c  BIc=new Business_Impact__c();
        system.debug('BusImp.BIID:'+BusImp.BIID);
        if(BusImp.BIID !='')
        {
      BIc.Business_Impact_Name__c = BusImp.BIName;
         BIc.Description__c= BusImp.BIDescription;
           BIc.Id=BusImp.BIID;
            BIc.Severity__c=BusImp.BISeverity;
            //BIc.Potential_Risk_ID__c=PotentialRiskId;
        lstUpdateBI.add(BIc);
        
          
        }
        else
        {
        
        BIc.Business_Impact_Name__c = BusImp.BIName;
        BIc.Description__c= BusImp.BIDescription;
        BIc.Severity__c=BusImp.BISeverity;
        BIc.Potential_Risk_ID__c=  PotentialRiskId;//'a8eZ00000004D9F'; // Temp hardcoded
        lstBI.add(BIc);
        
         
        }
      }
      
      insert lstBI;
      system.debug('lstBI:'+lstBI.size());
      system.debug('lstUpdateBI:'+lstUpdateBI.size());
      update lstUpdateBI;
     // string currentUrl=ApexPages.currentPage().getHeaders().get('referer');
      return true;
    }
    
    /* Remote Action Method for RootCause */
    
    @RemoteAction
    public static boolean createRootCause(list<RootCause> lstRootCause,string PrjId){
        List<Root_Cause__c> lstRC = new List<Root_Cause__c>();
        List<Root_Cause__c> lstUpdateRC = new List<Root_Cause__c>();
        List<Potential_Risk__c> lstPotentailRsk =new List<Potential_Risk__c>();
        
        lstPotentailRsk=[select Id FROM Potential_Risk__c where Project_ID__c=:PrjId];
        system.debug('lstPotentailRsk:'+lstPotentailRsk.size());
        if(lstPotentailRsk.size()>0){
            for(Potential_Risk__c  potential :lstPotentailRsk){
                PotentialRiskId=potential.Id;           
            }
        }
        system.debug('PotentialRiskId:'+PotentialRiskId);
        system.debug('lstRootCause:'+lstRootCause.size());
        
        for(RootCause RotCau: lstRootCause){
            Root_Cause__c  RCC = new Root_Cause__c();
            if(RotCau.RCID ==''){
                RCC.Root_Cause_Name__c = RotCau.RCName;
                RCC.Description__c = RotCau.RCDescription;
                RCC.Occurance__c = RotCau.RCOccurance;
                RCC.Potential_Risk_ID__c = 'a8eZ00000004D9F'; // Temp Harcoded
                lstRC.add(RCC);
            }
            else{
                RCC.Root_Cause_Name__c = RotCau.RCName;
                RCC.Description__c = RotCau.RCDescription;
                RCC.Id= RotCau.RCID;
                RCC.Occurance__c = RotCau.RCOccurance;              
                lstUpdateRC.add(RCC);
            }
        }
        insert lstRC;
        update lstUpdateRC;
        return true;
    }
        
    @RemoteAction
    public static boolean CreateProjectRisk(string ProjId,string PotentialDescription,string potentialUserId)
    {
     Potential_Risk__c  objpotentialRisk=new  Potential_Risk__c();
     system.debug('ProjId:'+ProjId);
     system.debug('PotentialRiskDesc:'+PotentialRiskDesc);
     
     objpotentialRisk.Project_ID__c=ProjId;
     objpotentialRisk.Potential_Risk_Owner__c = potentialUserId;
     
     objpotentialRisk.Description__c=PotentialDescription;
     insert objpotentialRisk;
     
     
     return true;
    }
    
    /* To Delete Business Impact */
    
    @RemoteAction
    public static boolean deleteBusinessImpact(string businessImpactId)
    {
       List<Risks__c> lstRisk = [SELECT Id,Business_Impact_ID__c FROM Risks__c where Business_Impact_ID__c=:businessImpactId];
           if(lstRisk.size()>0){
                for(Risks__c objCurrentRisk:lstRisk){
                    Delete objCurrentRisk;
                }
           }
       List<Business_Impact_Cause__c> lstBusinessImpactCause = [SELECT Id,Business_Impact_ID__c FROM Business_Impact_Cause__c where Business_Impact_ID__c=:businessImpactId];
           if(lstBusinessImpactCause.size()>0){
                for(Business_Impact_Cause__c objCurrentBICause:lstBusinessImpactCause ){
                    Delete objCurrentBICause;
                }
           }
       List<Business_Impact__c> lstBusinessImpact = [SELECT Id,Name,Potential_Risk_ID__c,Severity__c,Description__c,Business_Impact_Name__c FROM Business_Impact__c where Id=:businessImpactId];
           if(lstBusinessImpact.size()>0){
                for(Business_Impact__c objCurretBI:lstBusinessImpact ){
                     Delete objCurretBI;
                }
           }
        
           return true;
    }


   public string GetProject
    {
 get{
 string RiskId=ApexPages.currentPage().getParameters().get('id');
 
 string R=ProjectId;
  if(RiskId!='')
 {
     list<Potential_Risk__c> lstPoten= [SELECT Id, Project_ID__c FROM Potential_Risk__c where Id=:RiskId]; 
    for(Potential_Risk__c PRC:lstPoten)
    {
     R= PRC.Project_ID__c;
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
  
public List<Core_Team_Member__c> GetTeamMembers
{
get
{
       List<Core_Team_Member__c> lstTeamMembers = [select id,Name,User__c,Role_Name__c  from Core_Team_Member__c where Release_Role__r.Offering_Release__c=:ProjectId ];
return lstTeamMembers;
} 
set;
}
    public Potential_Risk__c potentialRisk{get;set;}
    public Process_Control__c processControl{get;set;}
    public Root_Cause__c rootCause{get;set;}
    public Business_Impact__c businessImpact{get;set;}
    
    
  
    public ODP_Extension_PotentialRisk_Hunter(ApexPages.StandardController controller) {
      IsRiskExisted = false;
      ProjectId=ApexPages.currentPage().getParameters().get('OFID');
      if(ProjectId==null)
      {
      //ProjectId=ApexPages.currentPage().getParameters().get('retURL').split('/')[1];
     PRiskId=ApexPages.currentPage().getParameters().get('id');
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

    //Hunter begin
    public void LoadNewRisk()
    {
        Business_Impact__C myBI = [select Business_Impact_Name__C,Severity__c from Business_Impact__C where Id=:NewRisk.Business_Impact_ID__c limit 1];
        selectedBI = myBI.Business_Impact_Name__C;
        Root_Cause__C myRC = [select Root_Cause_Name__C,Occurance__c from Root_Cause__C where Id=:NewRisk.Root_Cause_ID__C limit 1];
        selectedRC = myRC.Root_Cause_Name__C;
        Process_Control__c myPC = [select Process_Control_Name__C,Detection__c from Process_Control__c where Id=:NewRisk.Process_Control_ID__C limit 1];
        selectedPC = myPC.Process_Control_Name__C;
        SelectedRPN = Integer.valueOf(myBI.Severity__c) * Integer.valueOf(myRC.Occurance__c) * Integer.valueOf(myPC.Detection__c);
    }
    
    public PageReference CreateRisk(){
        try{
            NewRisk.Risk_Owner__C = UserInfo.getUserId();
            insert NewRisk;
            PageReference pageRef = new PageReference('/apex/ODP_PotentialRisk_Hunter?id=' + PRiskId);
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
    
}