public class ManageContractsController {
    
    Transient List<Contract_Reference__C> contractList{get;set;}
    public Set<Id> conList{get;set;}
    public Boolean masterCheckbox{get;set;}
    public Integer count{get;set;}
    public Id oppId;
    public String stage;
    public String sortfield{get;set;}
    public String direction{get;set;}
    public String previousField;
    public String previousDirection;
    public List<ContractWrapper> contractWrapperList{get{
                                                        if(contractWrapperList == null){
                                                            contractWrapperList = new List<ContractWrapper>();
                                                            for(Contract_Reference__c c :(List<Contract_reference__C>)con.getRecords()){
                                                                 ContractWrapper cw = new ContractWrapper(masterCheckbox,c,conList);
                                                                 contractWrapperList.add(cw);
                                                             }
                                                         }
                                                             return contractWrapperList;
                                                        }
                                                    set;}
    
    public Class ContractWrapper{
        public Boolean choice{get;set;}
        public Contract_Reference__C cont{get;set;}
        
        public ContractWrapper(Boolean masterCheckbox, Contract_Reference__c con, Set<Id> conList){
            cont = con;
                if(conList.contains(cont.Id))
                    choice = true;
                else
                    choice = false;

        }
    
    }
    
    public ManageContractsController(ApexPages.StandardController controller) {
         contractList = new List<Contract_Reference__C>();
         //contractWrapperList = new List<ContractWrapper>();
         masterCheckbox = false;
         direction = 'ASC';
         oppId = ApexPages.currentPage().getParameters().get('Id');
         contractList = [Select id, Name, AMP_ID__c, Functional_Location__c, Accounts__r.Name, SAID__c, Customer_Address__c, Renewal_Status_Description__c, Total_Contract_Value__c, Original_Opportunity__r.StageName From Contract_reference__C Where Original_Opportunity__c = :oppId Limit 1200];
         if(contractList.size()>0)
             stage = contractList[0].Original_Opportunity__r.StageName;
         /*for(Contract_Reference__c c :(List<Contract_reference__C>)con.getRecords()){
                     ContractWrapper cw = new ContractWrapper(false,c);
                     contractWrapperList.add(cw);
         } */
         conList = new Set<Id>();
         count = contractList.size();
         
         
    }
    
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                
                con = new ApexPages.StandardSetController(contractList);
                // sets the number of records in each page set
                con.setPageSize(500);
                
            }
            return con;
        }
        set;
    }
    
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }
 
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
    
    public void first() {
        selectRecords();
        con.first();
        contractWrapperList = null;
        checkMaster();
    }
 
    public void last() {
        selectRecords();
        con.last();
        contractWrapperList = null;
        checkMaster();
    }
 
    public void previous() {
        selectRecords();
        con.previous();
        contractWrapperList = null;
        checkMaster();
    }
 
    public void next() {
        selectRecords();
        con.next();
        contractWrapperList = null;
        checkMaster();
    }
    
    public PageReference doSort(){
        System.debug('???????2');
        if(previousField == sortField){
            if(direction == 'DESC')
                direction = 'ASC';
            else
                direction = 'DESC';
        System.debug('???????3');
        }
        
        else{
            previousField = sortField;
            System.debug('???????4');
        }
        
        String query = 'Select id, Name, AMP_ID__c, Functional_Location__c, Accounts__r.Name, SAID__c, Customer_Address__c, Renewal_Status_Description__c, Total_Contract_Value__c, Original_Opportunity__r.StageName From Contract_reference__C Where Original_Opportunity__c = :oppId Order By ' + sortField +' ' +direction+ ' Limit 1200';  
        //contractList.clear();
        contractList = Database.query(query);
        System.debug('???????5');
        con = null;
        System.debug('???????6');
        contractWrapperList= null;
        /*for(Contract_Reference__c c :(List<Contract_reference__C>)con.getRecords()){
                     ContractWrapper cw = new ContractWrapper(false,c);
                     contractWrapperList.add(cw);
        } */
        return null;
    
    }
    
     public void selectRecords(){
        for(ContractWrapper c: contractWrapperList){
            if(c.choice == true)
                conList.add(c.cont.Id);
            else{ 
                if(conList.contains(c.cont.Id))
                    conList.remove(c.cont.Id);
                
            }
            
        }
    
    }
    
    public void checkMaster(){
        Boolean b = true;
        for(ContractWrapper c: contractWrapperList){
            
            if(!conList.contains(c.cont.Id))
                b=false;
        }
        
        masterCheckbox = b;
    
    }
    
    
    public PageReference associateToExisting(){
        selectRecords();
        
        String ids = '';
        for(Id c : conList){
            if(ids == '')
                ids += c;
            else
                ids += ',' + c;
        }
        
        if(conList.size()<1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select atleast one contract'));
            return null;
        }
        
        if(stage == '06 - Won, Deploy & Expand'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Contract can not be associated to an opportunity if the Opportunity is in Sales Stage 6'));
            return null;
        }
        
        PageReference pg = new PageReference('/apex/AssociateToExistingRenewal?selectedcontractid='+ids+'&OppId='+oppId+'&retURL=/'+oppId);
        return pg;
    
    }
    
    public PageReference associateToNew(){
        selectRecords();  
        
        String ids = '';
        for(Id c : conList){
            if(ids == '')
                ids += c;
            else
                ids += ',' + c;
        }
        
        if(conList.size()<1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select atleast one contract'));
            return null;
        }
        
        if(stage == '06 - Won, Deploy & Expand'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Contract can not be associated to an opportunity if the Opportunity is in Sales Stage 6'));
            return null;
        }
        
        PageReference pg = new PageReference('/apex/AssociateToNewRenewalOpty?selectedcontractid='+ids+'&OppId='+oppId+'&retURL=/'+oppId);
        return pg;
    
    }
    
    public PageReference Remove(){
        selectRecords();
            
        List<Id> ids = new List<Id>();
        for(Id c : conList)
            ids.add(c);
        
        if(conList.size()<1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select atleast one contract'));
            return null;
        }
        
        if(stage == '06 - Won, Deploy & Expand'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Contract can not be associated to an opportunity if the Opportunity is in Sales Stage 6'));
            return null;
        }
        
        RemoveContractAssociation.removeassociation(ids);
        
        return (new PageReference('/'+oppId));
    
    }

}