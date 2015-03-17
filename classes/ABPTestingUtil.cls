@isTest
public class ABPTestingUtil{
 
 public static Account createAccount(String accountName, String accountEmail,String recordType) {
    String RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account',recordType);
    Account account = new Account();
    account.Account_E_mail__c = accountEmail;
    account.Name = accountName;
    account.RecordTypeId = RecordTypeId;
    account.CurrencyIsoCode='USD';
    return account;
    }
        
public static Account_Plan__c createAbpPlan(String name,String primary,String CurrencyIsoCode) {
    
   Account_Plan__c  actPlan=new Account_Plan__c();
    
    actPlan.Primary_AccountAccount__c=primary;
    actPlan.Name=name;    
    actPlan.CurrencyIsoCode=CurrencyIsoCode;
    return actPlan;
    }
public static Strategic_Initiative__c createStategic(String stategicId,String name,String CurrencyIsoCode) {
    
    Strategic_Initiative__c stategic=new Strategic_Initiative__c();
    
    stategic.Account_Plan__c=stategicId;
    stategic.Name=name;
    stategic.CurrencyIsoCode=CurrencyIsoCode;
    return stategic;
    }
    
    public static Customer_Business_Priority__c createCBP(String cbId,String name,String CurrencyIsoCode) {
    
    Customer_Business_Priority__c cbp=new Customer_Business_Priority__c();
    cbp.Account_Plan__c=cbId;
   
    cbp.Name=name;
    cbp.CurrencyIsoCode=CurrencyIsoCode;
    return cbp;
    }
    public static Business_Unit_Plan__c createBusines(String name,String CurrencyIsoCode,String abpPlan) {
    
    Business_Unit_Plan__c business=new Business_Unit_Plan__c();
    business.Name=name;
    business.Account_Plan__c=abpPlan;
    business.CurrencyIsoCode=CurrencyIsoCode;
    return business;
    }
    public static Competitive_Landscape__c createCompetitive(String CurrencyIsoCode,String abpPlan) {
    
    Competitive_Landscape__c competitive=new Competitive_Landscape__c();
    
    competitive.Account_Plan__c=abpPlan;
    competitive.CurrencyIsoCode=CurrencyIsoCode;
    return competitive;
    }
    public static Customer_Relationship_Map__c createCrm(String CurrencyIsoCode,String abpPlan) {
     Account account = TestingSetupDataUtil.createAccount('testAccount1', 'accountEmail@email.com','Customer');
        insert account ;
    Contact con = new Contact(AccountId = account.id, LastName = 'abc', Email = 'test@test.com', Phone__c = '123456789');
        insert con;
    Customer_Relationship_Map__c crm=new Customer_Relationship_Map__c();
    crm.Account_Plan__c=abpPlan;
     crm.Contact__c = con.id;
    crm.Parent_Contact__c = 'test2';
    
    crm.CurrencyIsoCode=CurrencyIsoCode;
    return crm;
    }
    public static Opportunity createOpportunity(String opportunityAccountId, String OpportunityName, Date CloseDate) {
        Opportunity opportunity = new Opportunity();
        opportunity.Name = OpportunityName;
        opportunity.CloseDate = CloseDate;      
        opportunity.AccountId = opportunityAccountId;
        opportunity.StageName = '01 - Understand Customer';
        opportunity.CurrencyIsoCode= 'USD';
        return opportunity;
    }  
     public static Case createcase(String origin, String status,String reason,String country) {
    
    Case case1=new Case();
    case1.Origin=origin;
    case1.Reason=reason;
    case1.Status=status;
    case1.Country_of_Submitter__c=country;
    return case1;
    }
    public static Event createEvent(){
    Event event=new Event();
    //RecurringEvents
    event.StartDateTime= system.today()+ 30;
    event.OwnerId = 'TestUser';
    event.EndDateTime = system.today()+ 30;
    event.CurrencyIsoCode = 'USD';
    event.Subject = 'TestSubject';
    return event;
    }
    public static Task createTask() {  
    Task task=new Task();
    task.CurrencyIsoCode = 'USD';
    task.Status = 'Not Started';
    task.OwnerId = 'TestUser';
    task.Priority = 'TestPriority';
    task.Subject = 'TestSubject';
    return task;
    }
    
    
    }