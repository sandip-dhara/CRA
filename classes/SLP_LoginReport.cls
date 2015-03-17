global class SLP_LoginReport {
public string header{get;set;}
public  string UserId {get;set;}
public  date FromDate {get;set;}
public  date ToDate {get;set;}
public  boolean IsShowReport {get;set;}

//Export 

   public string Filetype{get;set;}
    public boolean isExcel {get;set;}
    public boolean isCsv {get;set;} 
    
    public List<LoginReport> lstLoginReport {get; set;}
    
public SLP_LoginReport(){
Filetype='';
lstLoginReport=new List<LoginReport>();
header ='User Name, Login Date,Email';
}



global class LoginReport
{
  public string UserName {get;set;}
  public DateTime UserDateTime {get;set;}
  public string Email {get;set;}
  public string UserCreateDate {get;set;}
}

Public User GetLoggedinUserDtls()
       {
            User u = [Select Name,FullPhotoUrl,AboutMe, Email From User where User.id= :UserInfo.getUserId()];
            return U;
       }
       Public String getSfInstance{
get{
return ApexPages.currentPage().getHeaders().get('Host');
}
}
 Public boolean IsLearningBoardCreator
        { 
            get
           { 
                AthenaUserAccess usrAccs=new AthenaUserAccess(); 
                if(usrAccs.IsModerator(UserInfo.getUserId()) || usrAccs.IsProducer(UserInfo.getUserId()) )
                    return true; 
                else
                    return false;
           } 
        } 
        
    public List<SelectOption> GetListOfUsers()
    {
      List<SelectOption> Users= new List<SelectOption>();
        Users.add(new SelectOption('','--Select User--'));
    
    List<permissionsetassignment> lstUsers=[select assignee.id,assignee.name from permissionsetassignment where permissionset.name in ('ES_Social_Learning_Consumer','ES_Social_Learning_Producer','ES_Social_Learning_Moderator') ];
    
    for(permissionsetassignment aR:lstUsers){
    Users.add(new SelectOption(aR.assignee.id,aR.assignee.name)); 
    }
    list<user> EsitAdmin= [select id,name from user where profile.name = 'ES IT Administrator'];
    for(user aRu:EsitAdmin){
    Users.add(new SelectOption(aRu.id,aRu.name)); 
    }
    return Users;
    }
    
    public void ShowGenerateReport()
    {
    IsShowReport=true;
    
    
    }
    
    public list<LoginReport> getGenerateReport()
    {
    IsShowReport=true;
    system.debug('ToDate:'+ToDate);
    system.debug('FromDate:'+FromDate);
    system.debug('UserId:'+UserId);
    
    list<SLP_UserSession__c> lstUserSession= [SELECT  User_Id__r.name, CreatedDate FROM SLP_UserSession__c];
    list<LoginReport> lstLoginRpt=new list<LoginReport>();
    LoginReport lR;
    for(SLP_UserSession__c USession:lstUserSession){
        lR=new LoginReport();
        lR.UserName =USession.User_Id__r.name;
        lR.UserDateTime =USession.CreatedDate;
    lstLoginRpt.add(lR);
    }
    return lstLoginRpt;
    
    }
    
    @RemoteAction
    global static list<LoginReport> getGenerateReports()
    {
    
    
    list<SLP_UserSession__c> lstUserSession= [SELECT  User_Id__r.name, CreatedDate,User_Id__r.Email FROM SLP_UserSession__c];
    list<LoginReport> lstLoginRpt=new list<LoginReport>();
    LoginReport lR;
    for(SLP_UserSession__c USession:lstUserSession){
        lR=new LoginReport();
        lR.UserName =USession.User_Id__r.name;
        lR.UserDateTime =USession.CreatedDate;
        lR.Email =USession.User_Id__r.Email;
        lR.UserCreateDate=USession.CreatedDate.format('dd-MMM-yyyy');
    lstLoginRpt.add(lR);
    }
    return lstLoginRpt;
    
    }
    
    public void ExportToExcel()
    {
      list<SLP_UserSession__c> lstUserSession= [SELECT  User_Id__r.name, CreatedDate,User_Id__r.Email FROM SLP_UserSession__c];
    list<LoginReport> lstLoginRpt=new list<LoginReport>();
    LoginReport lR;
    for(SLP_UserSession__c USession:lstUserSession){
        lR=new LoginReport();
        lR.UserName =USession.User_Id__r.name;
        lR.UserDateTime =USession.CreatedDate;
        lR.Email =USession.User_Id__r.Email;
        lR.UserCreateDate=USession.CreatedDate.format('dd-MMM-yyyy');
    lstLoginRpt.add(lR);
    }
    }
    
    
}