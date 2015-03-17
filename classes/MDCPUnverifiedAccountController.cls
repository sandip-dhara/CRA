/**********************************************************
* Class Name: MDCPUnverifiedAccountController
* Author: Vijay Ranjan
* Date: 28-July-2013 
* Description: Controller class to Create Unverified Accounts in SFDC
*
***********************************************************/
public class MDCPUnverifiedAccountController{
public String Name{get;set;}
public String PhysicalStreet{get;set;}
public String PhysicalState {get;set;}
public String PhysicalCity{get;set;}
public String PostalCode{get;set;}
public List<SelectOption> PhysicalCountrylist {get;set;}
public String selectedCountry {get;set;}
public Boolean IsNewAccountCreated{get;set;}
public Boolean getIsNewAccountCreated(){
return IsNewAccountCreated;
}
public String newUnverifiedAccountID{get;set;}
public String getnewUnverifiedAccountID(){
return newUnverifiedAccountID;
}
public String newCaseID{get;set;}
public String getnewCaseID(){
return newCaseID;
}
public Boolean isCaseCreated{get;set;}
public Boolean getisCaseCreated(){
return isCaseCreated;
}
public Boolean isCaseCreationFailed {get;set;}
public Boolean getisCaseCreationFailed(){
return isCaseCreationFailed ;
}
/**************Constructor for MDCPUnverifiedAccountController***********************/
public MDCPUnverifiedAccountController(){
loadCountrylist();
isCaseCreated=false;
}
public void save(){
    IsNewAccountCreated=false; 
    newUnverifiedAccountID=null;
    try{
        Account var=new Account();
        ID CustomerRecordTypeId=[SELECT Id FROM RecordType where name='Customer' limit 1].id;
        var.recordTypeID=CustomerRecordTypeId;
        var.OwnerId =[Select Id,Country,Region__c,Business_Group__c,Name from User where Alias=:Label.MDCPUnverifiedAccountOwner limit 1].id;
        var.Name=Name; 
        var.ShippingStreet=PhysicalStreet; 
        var.ShippingPostalCode=PostalCode; 
        var.ShippingCity=PhysicalCity; 
        var.ShippingState=PhysicalState ; 
        var.ShippingCountry=selectedCountry ; 
        var.MDCP_Subscribed_Flag__c='false'; 
        insert var;     
               if(var.id != null){
                    IsNewAccountCreated=true;
                    newUnverifiedAccountID=var.id;
                }
        system.debug('Inserted accout ID============'+var.id);            
    }catch(Exception e){system.debug('Exception occured in Account Creation:::::: '+e.getmessage());}
  if(IsNewAccountCreated){
    createNewCase();
  }  
}
public pagereference back(){
    PageReference pageRef = new PageReference('/apex/MDCPDynamicSearchPage?entity=Customer');
    pageRef.setRedirect(true);
return pageRef;
}
public void loadCountrylist(){

    List<World_Region__c>Countrylist=[SELECT Country_Name__c from World_Region__c where Country_Name__c !=null OR Country_Name__c!= ''];
    Countrylist.sort();
    PhysicalCountrylist = new List<SelectOption>();   
     PhysicalCountrylist.add(new SelectOption('--None-- ','--None-- ')); 
    for(World_Region__c val:Countrylist){
     PhysicalCountrylist.add(new SelectOption(val.Country_Name__c,val.Country_Name__c));
    }
}
       
/********@Method to Create New Case if Account does not exist in SFDC******/
public void createNewCase() { 
isCaseCreated =false; 
Map<String,Schema.RecordTypeInfo> rtMapByName;
Id caseRecordordTypeId;
String caseId;
  case  caseRecord=new case();
    User usr = [Select Id,Country,Region__c,Business_Group__c,Name from User where Id =: UserInfo.getUserId()];
    rtMapByName = Case.SObjectType.getDescribe().getRecordTypeInfosByName();
    caseRecordordTypeId = rtMapByName.get(Label.Account_Request).getRecordTypeId();
    caseRecord.RecordTypeId = caseRecordordTypeId;
    caseRecord.AccountId= newUnverifiedAccountID;    
    caseRecord.Origin = 'SFDC';
    caseRecord.IsSelfServiceClosed = False ;
    caseRecord.IsEscalated = False;
    caseRecord.Priority = 'Medium';
    caseRecord.Region__c =usr.Region__c ;    
    caseRecord.Status = 'New';
    caseRecord.BG__c=usr.Business_Group__c;
    caseRecord.Request_Type__c = 'Single Record';
    caseRecord.New_Account_Name__c = Name;
    caseRecord.Country_of_Submitter__c = usr.Country;
    caseRecord.City__c = PhysicalCity;
    caseRecord.Country__c =selectedCountry  ;
    caseRecord.Street__c = PhysicalStreet;
    caseRecord.State_Province__c = PhysicalState ;
    caseRecord.Zip_Postal_Code__c = PostalCode;
    caseRecord.IsVisibleInSelfService = False;
    caseRecord.Country_of_Submitter__c =usr.Country ;
    //checking to create for competitor or customer
    caseRecord.OwnerId = Label.Master_Data_Back_Office_SFDC;
    caseRecord.Reason = 'Customer - Create a new account';
    caseRecord.Subject = 'account.Created By '+usr.name+ ' New Unverified account submission request';
    caseRecord.Description = 'This Record has been created in SFDC manually via Unverified Account Creation Process by  '+usr.name ;
    caseRecord.Scenario__c = 'UVA created & MDCP Org ID not found';

     try{
        insert caseRecord;
        isCaseCreated = True;
        newCaseID= [Select Id,CaseNumber from Case where id =:caseRecord.Id].CaseNumber;        
        }catch (Exception e) { isCaseCreationFailed = True;
        }
   
}
/**********************@method to hide case created link*********************************/
public void hidecaselink() {
    isCaseCreated =false;
}
/**********************@method to hide Account created link*********************************/
public void hideAccountlink() {
    IsNewAccountCreated=false;
}   
}