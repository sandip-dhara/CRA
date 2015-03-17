public with sharing class CaseContractAssociationController {

public string searchCountry {get; set;}
public string searchExistingLLFL{get; set;}
public string searchExistingSAID {get;set;}
public string searchExistingAMPID {get;set;}
public string searchExistingGrpConNbr {get;set;}
public string searchExistingSalsDocNbr {get;set;}
public string searchExistingSalesOrg {get; set;}
public string searchExistingAcc {get; set;}
public string searchConAdmin {get; set;}
public string searchExistingRenewMonYr {get; set;}

List<string> splitslash;
List<string> splitzero;
public string newDate {get; set;}
public boolean masterCheckboxFlag {get; set;}
public boolean initialSearch {get; set;}
public boolean noContractList {get; set;}
public integer no_of_records{get;set;}
public String finalcheckedidstring{get;set;}

public Set<String> ConSelId {get; set;}
Transient List<Contract_Reference__c> contractList{get;set;}
public List<contacteferencewrapper> contacteferencewrapperlist{get;set;}
public String cSearch {get; set;}
public Contract_Reference__c creference {get; set;}

    public class contacteferencewrapper{
        public boolean choice {get; set;}
        public Contract_Reference__c con {get; set;}  
        
        public  contacteferencewrapper(Boolean masterCheckboxFlag, Contract_Reference__c cr, Set<String> ConSelId){
            con = cr;
            If(ConSelId.contains(con.id))
                choice = true;
            else
                choice = false;               
        } 
    }

    public CaseContractAssociationController (ApexPages.StandardSetController controller) {        
        initialSearch = true;      
        noContractList = true;
        masterCheckboxFlag = false;
        finalcheckedidstring = '';
        ConSelId = new Set<String>(); 
        creference = new Contract_Reference__c();        
        contractList = new List<Contract_Reference__c>();
        contacteferencewrapperlist = new List<contacteferencewrapper>();              
    }
   
    public pagereference ClearSearch() {
            searchCountry = '--None--';
            searchExistingLLFL = '';
            searchExistingSAID = '';
            searchExistingAMPID = '';
            searchExistingGrpConNbr = '';
            searchExistingSalsDocNbr = '';
            searchExistingSalesOrg = '';
            searchExistingAcc = '';
            searchExistingRenewMonYr = '';            
            searchConAdmin = '';
            contacteferencewrapperlist.clear();
            cr = null;
            initialSearch = true;           
            noContractList = true;
            masterCheckboxFlag = false;
            contractList = new List<Contract_Reference__c>(); 
            ConSelId = new Set<String>();
            return null;
    }
    
    
    public ApexPages.StandardSetController cr{
        get {
            if(cr == null) {                 
                cr = new ApexPages.StandardSetController(contractList);
                // sets the number of records in each page set
                cr.setPageSize(500);
            }
        return cr;
    }
    set;
    }
    
        
    public void first() {
        ContractIdSelect();
        cr.first();
        SearchWrapper();
        checkMaster();
    }
    public void last() {
        ContractIdSelect();
        cr.last();
        SearchWrapper();
        checkMaster();
    }
    public void previous() {
        ContractIdSelect();
        cr.previous();
        SearchWrapper();
        checkMaster();
    }
    public void next() {
        ContractIdSelect();
        cr.next();
        SearchWrapper();
        checkMaster();
    }
    public Boolean hasPrevious {
        get {
            return cr.getHasPrevious();
        }
        set;
    }
    public Boolean hasNext {
        get {
            return cr.getHasNext();
        }
        set;
    }
    
    public void goSearch(){ 
              
       try{
           cr = null;
           
           If(searchCountry!=null && searchCountry != '--None--'|| searchExistingLLFL!=null && searchExistingLLFL!=''|| searchExistingSAID!=null && searchExistingSAID!='' || searchExistingAMPID!=null && searchExistingAMPID!='' || searchExistingGrpConNbr!=null && searchExistingGrpConNbr!='' || searchExistingSalsDocNbr!=null && searchExistingSalsDocNbr!='' || searchExistingSalesOrg!=null && searchExistingSalesOrg!='' || searchExistingAcc!=null && searchExistingAcc!='' || searchConAdmin!=null && searchConAdmin!='' || searchExistingRenewMonYr!=null && searchExistingRenewMonYr!=''){
                
                cSearch= 'SELECT id, Name, Renewal_Month_Year__c, Renewal_Status_Description__c, AMID2__c, AMP_ID__c , Group_Contract_Nbr__c, Accounts__c, Contract_Admin_Name__c, Contract_Start_Date__c, Contract_End_date__c, Contract_Length_in_Months__c, Accounts__r.WorldRegion_Region__c, Accounts__r.ShippingCountry, Accounts__r.Name FROM Contract_Reference__c Where id != null';             
            
                if(searchCountry!=null && searchCountry != '--None--'){
                         cSearch =   cSearch +' AND Contract_Reference__c.Country__c =\''+ searchCountry+'\'' ; 
                }
                
                if(searchExistingLLFL!=null && searchExistingLLFL!=''){
                         cSearch =   cSearch + ' AND Contract_Reference__c.Functional_Location__c =\'' +searchExistingLLFL+'\'' ; 
                }
                
                if(searchExistingSAID!=null && searchExistingSAID!=''){
                         cSearch =   cSearch +' AND Contract_Reference__c.SAID__c =\''+ searchExistingSAID+'\'' ; 
                }
                
                If (searchExistingAMPID!=null && searchExistingAMPID!=''){
                         cSearch =  cSearch +' AND Contract_Reference__c.AMP_ID__c =\''+ searchExistingAMPID +'\'' ;
                }
                    
                If (searchExistingGrpConNbr!=null && searchExistingGrpConNbr!=''){
                         cSearch =  cSearch +' AND Contract_Reference__c.Group_Contract_Nbr__c =\''+ searchExistingGrpConNbr+'\'' ;
                } 
                
                If (searchExistingSalsDocNbr!=null && searchExistingSalsDocNbr!=''){
                         cSearch =  cSearch +' AND Contract_Reference__c.Sales_Doc_Nbr__c =\''+ searchExistingSalsDocNbr+'\'' ;
                }
                
                If (searchExistingSalesOrg!=null && searchExistingSalesOrg!=''){
                         cSearch =  cSearch +' AND Contract_Reference__c.Sales_Organization__c =\''+ searchExistingSalesOrg+'\'' ;
                }
                
                If (searchExistingAcc!=null && searchExistingAcc!=''){
                         cSearch =  cSearch +' AND Accounts__r.Name like \'' + '%' +searchExistingAcc+'%\'' ;
                }
              
                If(searchConAdmin!=null && searchConAdmin!=''){
                        cSearch =  cSearch +' AND Contract_Admin_Name__r.Name like \'' + '%' + searchConAdmin+'%\'' ; 
                }
                            
                If (searchExistingRenewMonYr!=null && searchExistingRenewMonYr!=''){
                       If(searchExistingRenewMonYr.contains('/')){
                           splitslash = searchExistingRenewMonYr.split('/');
                           system.debug('!!!'+splitslash);
                           string mmon = splitslash[0];
                           system.debug('!!!'+mmon );
                           string yyear = splitslash[1];
                           system.debug('!!!'+yyear );
                       
                               If(mmon.contains('0')){
                                   splitzero = mmon.split('0');
                                   system.debug('!!!'+ splitzero);
                                   string first = splitzero[0];
                                   system.debug('!!!'+ first);
                                       if(splitzero.size() > 1){
                                           string second = splitzero[1];
                                           system.debug('!!!'+ second);
                                           //if(first.contains(''))
                                               newDate =  second + '/' + yyear;
                                           //else
                                              // newDate =  mmon + '/' + yyear;                                       
                                       }  
                                       else
                                           newDate =  mmon + '/' + yyear;
                                           system.debug('!!!!'+newDate);
                               }
                               else
                                   newDate =  mmon + '/' + yyear;
                                   system.debug('!!!!'+newDate);
                       }
                   
                        cSearch =  cSearch +' AND Contract_Reference__c.Renewal_Month_Year__c =\'' + newDate+'\'' ;
                }
                cSearch = cSearch +' Limit 1200';
                system.debug('@@@'+cSearch );
                contractList=Database.Query(cSearch); 
                SearchWrapper();
            }
            else{
                contractList = new List<Contract_Reference__c>();
                contacteferencewrapperlist.clear();
                cr = null;
                noContractList = true;
            }
        
        
        }Catch(Exception e){
        }
    }   
       
       
    Public void SearchWrapper(){
           if(cr.getRecords().size()== 0)
               noContractList = true;
           else
               noContractList = false;
               
           contacteferencewrapperlist =new List<contacteferencewrapper>();
           for(Contract_Reference__c contractreferencerecord: (List<Contract_Reference__c>)cr.getRecords()){
                contacteferencewrapper wrapper=new contacteferencewrapper(masterCheckboxFlag, contractreferencerecord, ConSelId);
                contacteferencewrapperlist.add(wrapper);
           }
    }    
    
    Public void ContractIdSelect(){
        for(contacteferencewrapper contractreferncewrapper: contacteferencewrapperlist){
            if(contractreferncewrapper.choice == true){
                ConSelId.add(contractreferncewrapper.con.id);
            }
            else{
                if(ConSelId.contains(contractreferncewrapper.con.id)){
                    ConSelId.remove(contractreferncewrapper.con.id);
                }
            }
        }
        system.debug('!!!'+ConSelId);
    }
    
     public void checkMaster(){
        Boolean b = true;
        for(contacteferencewrapper contractreferncewrapper: contacteferencewrapperlist){            
            if(!ConSelId.contains(contractreferncewrapper.con.id))
                b=false;
        }        
        masterCheckboxFlag = b;    
    }


   
   public List<SelectOption> getConPickList() {
        List<SelectOption> wwConlist = new List<SelectOption>();
        wwConlist.add(new SelectOption('--None--','--None--')); 

        List<World_Region__c> wwlist = new List<World_Region__c>([Select id, Country_Name__c, Region__c From World_Region__c Limit 350]);
        Set <String> wwCountry = new Set<String>();
        for(World_Region__c ww: wwlist){
            if(ww.Country_Name__c!=Null){
                wwCountry.add(ww.Country_Name__c);
            }    
        }
        List<String> conlist = new List<String>();
        conlist.addAll(wwCountry);
        conlist.sort();
        for(String countrylist : conlist){
            wwConlist.add(new SelectOption(countrylist , countrylist));
        } 

        return wwConlist;
    }
       
    
  public pagereference CreateCase(){
  try{
    finalcheckedidstring='';
    String AccountName;
    String country;
    String wwregion;
    String region;
    
    if(contacteferencewrapperlist.size() > 0){
        wwregion =contacteferencewrapperlist[0].con.Accounts__r.WorldRegion_Region__c;
        country =contacteferencewrapperlist[0].con.Accounts__r.ShippingCountry;
        AccountName =contacteferencewrapperlist[0].con.Accounts__r.Name;
        
        if(wwregion == 'Americas')  
            region = 'AMS';
        else if(wwregion == 'Asia Pacific')
            region = 'APJ'; 
        else if(wwregion == 'EMEA')
            region = 'EMEA';                     
    }
    
    for(contacteferencewrapper contractreferncewrapper: contacteferencewrapperlist){
        if(contractreferncewrapper.choice == true){
            ConSelId.add(contractreferncewrapper.con.id);
        }
    }
    system.debug('!!!1'+ConSelId);
    for(String newConSelId : ConSelId){
        If(finalcheckedidstring!='')            
            finalcheckedidstring = finalcheckedidstring+','+String.ValueOf(newConSelId);
        else
            finalcheckedidstring = String.ValueOf(newConSelId);
    }
    
    system.debug('&&'+finalcheckedidstring);
    
    if(ConSelId.size()<1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select atleast one Contract Reference'));
            return null;
    }
         
    pagereference reference; 
    
     if(AccountName!= null && AccountName!= '')
        reference = new pagereference('/500/e?RecordType='+Label.CO_Record_Type + '&' + Label.Case_Selected_Contract +'='+finalcheckedidstring + '&' + Label.Case_Request_Type + '= Renewal Quote' + '&cas4='+ AccountName + '&' +Label.CO_Region + '=' +region + '&' + Label.CO_Country + '=' + country);
     
     else 
        reference = new pagereference('/500/e?RecordType='+Label.CO_Record_Type + '&' + Label.Case_Selected_Contract +'='+finalcheckedidstring + '&' + Label.Case_Request_Type + '= Renewal Quote');
     
    return reference;
    }catch(Exception e){
        return null;
    }
    }
    
   

}