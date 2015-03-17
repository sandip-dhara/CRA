public class Muthu_ODP_PotentialRisk {
  
   public Muthu_Wrapper_PotentialRisk objWrappers {get;set;}
   public static string PotentialRiskId {get;set;}
    public Muthu_ODP_PotentialRisk ()
    {
     objWrappers =new Muthu_Wrapper_PotentialRisk();
              
    }
    
    public Potential_Risk__c getPotentialRisk(){
        return objWrappers.potentialRiskObj;
    }
    
    public void addBusinessImpact(){
        objWrappers.businessImpactList.add(new Business_Impact__c());
    }
    
    public void addRootCause() {
        objWrappers.rootCauseList.add(new Root_Cause());
    }
    
     public void addProcessControl() {
        objWrappers.ProcessControlList.add(new Process_Control());
    }
    
     public static void GetPotentialRiskId()
    {
      list<Potential_Risk__c> lstPotentailRsk=[select Id FROM Potential_Risk__c where Project_ID__c=:'a6yZ0000000DFz2'];
      if(lstPotentailRsk.size()>0){
        for(Potential_Risk__c  potential :lstPotentailRsk){
            PotentialRiskId=potential.Id;
            }
        }
    }
    
     public list<Business_Impact__c> GetBusinessImpact
    {
    get{
        list<Business_Impact__c> lstBusinessImpact=new list<Business_Impact__c>();
            lstBusinessImpact= [SELECT Description__c, Severity__c, Potential_Risk_ID__c, Id FROM Business_Impact__c where Potential_Risk_ID__c=:'a8eZ00000004D82IAE'];
        return lstBusinessImpact;
    }
    set;
    
    }
    
    
     public list<Root_Cause__c> GetRootCause
    {
    get{
        list<Root_Cause__c> lstRootCause=new list<Root_Cause__c>();
            lstRootCause= [SELECT Id,Description__c,Occurance__c ,Potential_Risk_ID__c FROM Root_Cause__c where Potential_Risk_ID__c=:'a8eZ00000004D82IAE'];
        return lstRootCause;
    }
    set;
    
    }
    
    
     public list<Process_Control__c> GetProcessControl
    {
    get{
        list<Process_Control__c> lstProcessControl=new list<Process_Control__c>();
            lstProcessControl= [SELECT Id,Description__c,Detection__c,Potential_Risk_ID__c   FROM Process_Control__c where Potential_Risk_ID__c=:'a8eZ00000004D82IAE'];
        return lstProcessControl;
    }
    set;
    
    }
    
    @RemoteAction
    public static String saveRiskRecord(Muthu_Wrapper_PotentialRisk objWrapper)
    {      
   
        Root_Cause__c objRootCause1;
        Process_Control__c  objProcessControl1;
        
        objWrapper.potentialRiskObj.Description__c =objWrapper.potentialRiskObj.Description__c;
        objWrapper.potentialRiskObj.Project_ID__c=objWrapper.potentialRiskObj.Project_ID__c ;
        
        insert objWrapper.potentialRiskObj;
        
        for(Business_Impact__c objBusinessImpact : objWrapper.businessImpactList)
        {
         objWrapper.objBusinessImpact=new Business_Impact__c();
         objWrapper.objBusinessImpact.Potential_Risk_ID__c = objWrapper.potentialRiskObj.Id;
         objWrapper.objBusinessImpact.Description__c = objBusinessImpact.Description__c ;
         objWrapper.objBusinessImpact.Severity__c=objBusinessImpact.Severity__c;
         insert objWrapper.objBusinessImpact;

            for(Root_Cause objRootCause : objWrapper.rootCauseList)
            {
                if(objRootCause.BusinessImpact==objWrapper.objBusinessImpact.Description__c)
                {
                   objRootCause1= new Root_Cause__c ();
                    objRootCause1.Description__c = objRootCause.Description;
                    objRootCause1.Occurance__c =objRootCause.Occurance;
                    objRootCause1.Potential_Risk_ID__c = objWrapper.potentialRiskObj.Id;
                    insert objRootCause1;  
                     
                    objWrapper.objBusinessImpactCause=new Business_Impact_Cause__c();      
                    objWrapper.objBusinessImpactCause.Business_Impact_ID__c = objWrapper.objBusinessImpact.Id;
                    objWrapper.objBusinessImpactCause.Root_Cause_ID__c = objRootCause1.Id;
                    insert objWrapper.objBusinessImpactCause;
                 
                    for(Process_Control objProcessControl : objWrapper.ProcessControlList)
                    {
                        if(objProcessControl.RootCause ==  objRootCause1.Description__c)
                         {
                               objProcessControl1 = new Process_Control__c();
                               objProcessControl1.Description__c =objProcessControl.Description;
                               objProcessControl1.Detection__c= objProcessControl.Detection;
                               objProcessControl1.Potential_Risk_ID__c = objWrapper.potentialRiskObj.Id;
                               insert objProcessControl1;
                    
                               objWrapper.objRootCauseControl=new Root_Cause_Control__c();
                               objWrapper.objRootCauseControl.Root_Cause_ID__c = objRootCause1.Id;
                               objWrapper.objRootCauseControl.Process_Control_ID__c = objProcessControl1.Id;
                               insert objWrapper.objRootCauseControl;
                              // break;
                          }
                    }
                   // break;
                }
            }
        }
        return 'Saved Sucessfully'; 
    }
    
     @RemoteAction
    public static String saveTest(Muthu_Wrapper_PotentialRisk objWrapper)
    { 
        return 'Success'; 
    }
    
public class Muthu_Wrapper_PotentialRisk {

    public Potential_Risk__c potentialRiskObj{get;set;}
    public Business_Impact__c objBusinessImpact{get;set;}
    public Root_Cause objRootCause{get;set;}
    public Process_Control objProcessControl{get;set;}
    public Root_Cause_Control__c objRootCauseControl{get;set;}
    public Business_Impact_Cause__c objBusinessImpactCause{get;set;}
      
    Public List<Business_Impact__c> businessImpactList{get;set;}
    Public List<Root_Cause> rootCauseList{get;set;}
    Public List<Process_Control> ProcessControlList{get;set;}
    
    }
    public class Root_Cause
    {
        public String Description {get;set;}
        public String Occurance {get;set;}
        public String BusinessImpact{get;set;}
    }
     public class Process_Control
    {
        public String Description {get;set;}
        public String Detection {get;set;}
        public String RootCause{get;set;}
    }
}