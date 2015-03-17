/*************************************************
Author: Mousumi Panda
Created Date: 26-APR-2013
Release: R5
Capability: Deal Governance
Description: ApprovalRecord Type Selection page for showing the OR and OBR record type for only Standard Opportunity and restrict it from renewal Opportunity
**************************************************/

public class DGApprovalRecordSelectionController {

    public String ApprovalRequestLabel{get;set;}
    String approvalURL1;
    Id rennewalRecordType; 
    Opportunity opp;
    public Boolean hasOptyaccess{get;set;}
    private String redirectVFPageName;
    
/*Check Oppty Access to check access on Approval*/
   public void opptyAccess()
    {
    String result=CheckOptyAccess.checkOptyEditAccess(Opptyid);
    system.debug('********checkopptyAccess*******'+result);
    If(result==Label.FAIL){
    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'You do not have permission to Create Approval.')); 
    hasOptyaccess=false;
    }
    } 
/*For Cancel Button*/
    public PageReference cancel() {
        PageReference pg = new PageReference('/'+Opptyid);
        pg.setredirect(true);
        return pg;
    }
    
    
    public static ID getRecordTypeID(String recordTypeName){
        Id recordTypeid = null;
        if(recordTypeName!=null){
          
            Schema.DescribeSObjectResult R = Approval__c.SObjectType.getDescribe();
            List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
            Map<String,Id> recordTypeNameWithID = new Map<String,Id>();
            for(Schema.RecordTypeInfo recordType: RT){
                recordTypeNameWithID.put(recordType.getName(),recordType.getRecordTypeId());
            }
        
            if(recordTypeNameWithID.containsKey(recordTypeName)){
                recordTypeid = recordTypeNameWithID.get(recordTypeName);
            }
            
        }else{
            recordTypeid = null;
        }
        return recordTypeid;
    }

/*For Next Button to route to the correct page*/
    public PageReference next() {
        Id recordtypeid = getRecordTypeID(ApprovalRequestLabel);
        system.debug('ApprovalRequestLabel****'+ApprovalRequestLabel);
        if(recordtypeid == null){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.No_RecordTypeFound));
            return null;
        }
        if(recordtypeid != null && ApprovalRecordType__c.getInstance(ApprovalRequestLabel).isVisualforce__c && ApprovalRecordType__c.getInstance(ApprovalRequestLabel).Visualforce_Page_Name__c != null){
           
            redirectVFPageName=ApprovalRecordType__c.getInstance(ApprovalRequestLabel).Visualforce_Page_Name__c;
            pagereference pgRef = new Pagereference('/apex/'+redirectVFPageName+'?id='+Opptyid+'&RecordType='+recordtypeid);
            return pgRef;
           
        }
        
        else{
            system.debug('********recordtypeid Renewal**'+recordtypeid);
            String navigationURL = '/'+Schema.SObjectType.Approval__c.getKeyPrefix()+'/e?nooverride=1&RecordType='+recordtypeid+'&CF00NG0000009G4CJ='+EncodingUtil.urlEncode(opp.Name, 'UTF-8')+'&CF00NG0000009G4CJ_lkid='+Opptyid;
            pagereference pageref = new Pagereference(navigationURL);
            return pageref;
            
        }        
    }


    public Map<String,String> mainDetails{get;set;}
    public String mainDetailHeader{get;set;}
    public boolean value{get;set;}
    public string RecordTypeName ;
    public String FinalString;
    Public String Opptyid{get;set;}
    public list<Description> DesctList{get;set;}

    public String getSelected() {

        return null;
    }


/*Record type selection Option*/
    public List<SelectOption> getSupportRequestSubTypes()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));        

        for(String sortval:finalstring.split(',') ){

            if(ApprovalRecordType__c.getInstance(sortval).value__c !=null)            
                options.add(new SelectOption(sortval,sortval));


        }

        system.debug('maindetails-----'+maindetails);
        return options;
    }

    public class Description{
        Public string name{get;set;}
        public string des{get;set;}
    }
    
    /*Record type based on the Opprtunity Record type*/
    public DGApprovalRecordSelectionController(){

        RecordTypeName = ApexPages.currentPage().getParameters().get('recordidname');
        Opptyid = ApexPages.currentPage().getParameters().get('Opportunityid');
        system.debug('g---------'+RecordTypeName);

        if(RecordTypeName == 'Renewal'){
            Finalstring =label.renewal;

        }else{
            FinalString = label.Standard;

        }
        mainDetails = new map<string,string>();

        DesctList = new list<Description>();
        system.debug('FinalString****'+FinalString);
        for(String sortval:FinalString.split(',') ){
       
         system.debug('****sortval****'+ sortval);
            if(ApprovalRecordType__c.getInstance(sortval).name !=null){                    
                mainDetails.put(ApprovalRecordType__c.getInstance(sortval).name,ApprovalRecordType__c.getInstance(sortval).Description__c);
                Description DescInstance = new Description();
                DescInstance.name = ApprovalRecordType__c.getInstance(sortval).name;
                DescInstance.des= ApprovalRecordType__c.getInstance(sortval).Description__c;
                DesctList.add(DescInstance);
                system.debug('mai---'+maindetails);
            }
        }

        rennewalRecordType=Schema.SObjectType.Approval__c.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        opp=[select id,Name from Opportunity where id=:Opptyid] ;
        hasOptyaccess=true;

    }
}