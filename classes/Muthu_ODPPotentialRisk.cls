public with sharing class Muthu_ODPPotentialRisk {

    public id UserId {get;set;}
    public Id ProjectId {get;set;}
    public static  Id  StaticProjectId {get;set;}
    public Id PotentialRskId {get;set;}
    public string TeamOwnerId {get;set;}
    public static string PotentialRiskDesc {get;set;}
    public static string PotentialRiskId {get;set;}
    
    
    Public string GetAvailableBusinessImpacts
    {
        get
        {
            List<Business_Impact__c> lstAvlblBusinessImpact=[SELECT Id, Potential_Risk_ID__c, Severity__c, Description__c FROM Business_Impact__c];
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
        //list<Potential_Risk__c> lstPotentailRsk=[select Id FROM Potential_Risk__c where Project_ID__c=:ProjectId];
        system.debug('lstPotentailRsk:'+potentialRisk.Id);
    //if(lstPotentailRsk.size()>0){
        //for(Potential_Risk__c  potential :lstPotentailRsk){
            lstBusinessImpact= [SELECT Description__c, Severity__c, Potential_Risk_ID__c, Id FROM Business_Impact__c where Potential_Risk_ID__c=:PotentialRiskId];
            //}
        //}
            //system.debug('lstBusinessImpact:'+lstBusinessImpact.size());
        return lstBusinessImpact;
    }
    set;
    
    }
    
    public class BusinessImapact
    {
      public string BIID {get;set;}
      public string BIDescription {get;set;}
      public string BISeverity {get;set;}
      
    }
    
    public class RootCause{
        public String RCID {get;set;}
        public String RCDescription {get;set;}
        public String RCOccurance {get;set;}
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
    lstRoot=  [SELECT Id, Potential_Risk_ID__c, Description__c, Occurance__c FROM Root_Cause__c];
    
    Map<string,string> MapRootBI=new Map<string,string>();
    List<Business_Impact_Cause__c> lstBICause=new List<Business_Impact_Cause__c>();
    
    lstBICause=[SELECT Id, Business_Impact_ID__c, Root_Cause_ID__c FROM Business_Impact_Cause__c];
    
    for(Business_Impact_Cause__c  BICCs:lstBICause){
    MapRootBI.put(BICCs.Root_Cause_ID__c,BICCs.Business_Impact_ID__c);
    }
    
    
    List<Business_Impact__c> lstBI= [SELECT Id, Potential_Risk_ID__c, Description__c, Severity__c FROM Business_Impact__c];
    
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
    public static boolean CreateBusinessImpact(list<BusinessImapact> lstBusinessImpact,string PrjId)
    {
      List<Business_Impact__c> lstBI = new List<Business_Impact__c>();
      List<Business_Impact__c> lstUpdateBI = new List<Business_Impact__c>();
      list<Potential_Risk__c> lstPotentailRsk =new list<Potential_Risk__c>();
       
      lstPotentailRsk=[select Id FROM Potential_Risk__c where Project_ID__c=:PrjId];
      system.debug('lstPotentailRsk:'+lstPotentailRsk.size());
      if(lstPotentailRsk.size()>0){
        for(Potential_Risk__c  potential :lstPotentailRsk){
        PotentialRiskId=potential.Id;
        //PotentialRskId=potential.Id();
        }
        }
      system.debug('PotentialRiskId:'+PotentialRiskId);
      system.debug('lstBusinessImpact:'+lstBusinessImpact.size());
    
      for(BusinessImapact BusImp:lstBusinessImpact)
      {
        Business_Impact__c  BIc=new Business_Impact__c();
        
        if(BusImp.BIID =='')
        {
        BIc.Description__c= BusImp.BIDescription;
        BIc.Severity__c=BusImp.BISeverity;
        BIc.Potential_Risk_ID__c=PotentialRiskId;
        lstBI.add(BIc);
        
          
        }
        else
        {
         BIc.Description__c= BusImp.BIDescription;
           BIc.Id=BusImp.BIID;
            BIc.Severity__c=BusImp.BISeverity;
            //BIc.Potential_Risk_ID__c=PotentialRiskId;
        lstUpdateBI.add(BIc);
        }
      }
      
      insert lstBI;
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
                RCC.Description__c = RotCau.RCDescription;
                RCC.Occurance__c = RotCau.RCOccurance;
                RCC.Potential_Risk_ID__c = 'a8eZ00000004D3H';
                lstRC.add(RCC);
            }
            else{
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
    public static boolean CreateProjectRisk(string ProjId,string PotentialDescription)
    {
     Potential_Risk__c  objpotentialRisk=new  Potential_Risk__c();
     
     objpotentialRisk.Project_ID__c=ProjId;
     
     objpotentialRisk.Description__c=PotentialDescription;
     if(PotentialRiskId!='')
     {
     objpotentialRisk.Id=PotentialRiskId;
     update objpotentialRisk;
     }
     else
     {
     insert objpotentialRisk;
     }
     
     
     return true;
    }

   public string GetProject
    {
 get{

 List<Offering_Release__c> lstProjects =[SELECT  Name FROM Offering_Release__c where Id=:ProjectId];
 string ProjName ='';
 if(lstProjects.size()>0){
 for(Offering_Release__c oRc:lstProjects ){
 ProjName=oRc.Name;
 }
 }
  
 return ProjName;
 }
 set;
}   
    
public List<User> GetUsers
{
get
{

List<PermissionSetAssignment> lstPermissionSetAssignment = new List<PermissionSetAssignment>();
lstPermissionSetAssignment = [SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId IN (select id from user where isactive = true)
                                      and (PermissionSet.name='ES_Social_Learning_Producer' or PermissionSet.name='ES_Social_Learning_Moderator')  ];
        
        //List<Learning_Board__Share> listBoardShare = [SELECT UserOrGroupId FROM Learning_Board__Share where ParentId =: learningBoardId];

        //Map<string, boolean> mapBoardShareids = new Map<string, boolean>();
            
        //for(Learning_Board__Share boardItem : listBoardShare)
        //{
          //  mapBoardShareids.put(boardItem.UserOrGroupId, true);
        //}

        SET<ID> lstUserIds = new SET<ID>();

        for(PermissionSetAssignment permissionItem : lstPermissionSetAssignment)
        {
            //string value = permissionItem.AssigneeId;
            //if(!mapBoardShareids.containskey(value))
            //{
                lstUserIds.add(permissionItem.AssigneeId);
            //}
        }

        List<User> lstUser = [Select id, Name from User where id in : lstUserIds order by Name asc];

        return lstUser;

}
set;
}
    public Potential_Risk__c potentialRisk{get;set;}
    public Process_Control__c processControl{get;set;}
    public Root_Cause__c rootCause{get;set;}
    public Business_Impact__c businessImpact{get;set;}
    
    
  
    public Muthu_ODPPotentialRisk (ApexPages.StandardController controller) {
      ProjectId=ApexPages.currentPage().getParameters().get('OFID');
      StaticProjectId=ApexPages.currentPage().getParameters().get('OFID');
      system.debug('StaticProjectId:'+StaticProjectId);
        potentialRisk = (Potential_Risk__c)controller.getRecord();
        GetPotentialRiskId();
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
    
    
    }