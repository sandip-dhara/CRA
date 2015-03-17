/*
* NAME : ApttusAgreement
* NOTE : This class is used when user clicks on Agreement Home page Link,
		 shows the My Agreements & My Team Agreements
* Author : Apttus (Axay & Shabbir)
*/
public with sharing class ApttusAgreement {
     
     
     public ID apprReqId {get; set;}
     public String parentAgreementId {get;set;}
     public String agreementId {get;set;}
     public ID agmtId {get; set;}
     public ApexPages.StandardSetController apprRequestRecordSet;
     public List<EmployeeBean> empData{get; set;}
	 public String empID {get; set;}
	 public List<String> empids{get; set;}
	 public Boolean showTab{get;	set;}
	 
	 //private Integer totalPages = null;
     //Constants
	 public static final String QUEUE_VALUE = 'Queue';
	 public static final String NOT_YET_SELECTED_VALUE = 'Not yet selected';
	 public static final String ADVICE_ONLY_VALUE = 'Advice Only';
	 
	 public ApttusAgreement(ApexPages.StandardSetController controller) {
	 empID = [SELECT ID,Legacy_Employee_Ref__c FROM USER WHERE ID = :UserInfo.getUserID() LIMIT 1].Legacy_Employee_Ref__c;
     	//System.debug('Emp ID : '+empID);
     	empData = new List<EmployeeBean>();
     	empids = new List<String>();
     	empData = AptsTibcoWebServiceUtilClass.getEmpHierarchyData(empID);	//get Employee Hierarchy
     	showTab = FALSE;
     	if(empData.size() > 0)
     	{
     		showTab = TRUE;
     	}
	 }
	 
 	private Set<Id> getEmployeeIds(List <String> empIds) {
 		Set<Id> empIdsSet = new Set<Id>();
		if(empids.size() > 0){
	    List<User> users = [SELECT ID,NAME,Legacy_Employee_Ref__c FROM USER WHERE Legacy_Employee_Ref__c in :empids];
	    for(USER use : users){
	        EmpIdsSet.add(use.ID);
	      }	
	    }
	    return empIdsSet;
    }
	 
	 public ApexPages.StandardSetController getApprRequestRecordSet(Integer flag){
     
     if(flag == 1){ //My Agreements
            apprRequestRecordSet = new ApexPages.StandardSetController( Database.getQueryLocator(
            [select a.ID,a.Name,a.Owner.Name,a.Apttus__Account__c,a.Customer_Legal_Name__c,a.Lead_BU__c,
            a.Apttus__Total_Contract_Value__c,a.CreatedDate,Agreement_Type_String__c,LastModifiedDate,
            a.Sales_Request_Type__c,a.Customer_Location_Country__c,a.Customer_State_if_US__c,a.Public_Sector__c,
		    a.Is_Global_Account__c,a.Opportunity_Owner__c,a.Request_Date__c,a.Close_Date__c                               
            From Apttus__APTS_Agreement__c a 
            where RecordType.Name != :NOT_YET_SELECTED_VALUE AND RecordType.Name != :ADVICE_ONLY_VALUE AND OwnerID = :UserInfo.getUserID()
            order by lastmodifieddate desc]));                                                 
        }
    if(flag == 2){ //My Team Agreements
    	for(EmployeeBean emp : empData)
		{
			if(emp.employeeNumber != null || emp.employeeNumber != '')
			{
					empids.add(emp.employeeNumber);
			}
		}
	
	Set<Id> EmpIdsSet = getEmployeeIds(empIds);
	apprRequestRecordSet = new ApexPages.StandardSetController(Database.getQueryLocator(
    [SELECT a.Name,a.Owner.Name,a.Customer_Legal_Name__c,a.Aging__c,a.Apttus__Total_Contract_Value__c,
    a.Lead_BU__c,a.Apttus__Status__c,a.Apttus__Status_Category__c,a.Agreement_Type_String__c,CreatedDate,LastModifiedDate,
    a.Sales_Request_Type__c,a.Customer_Location_Country__c,a.Customer_State_if_US__c,a.Public_Sector__c,
	a.Is_Global_Account__c,a.Opportunity_Owner__c,a.Request_Date__c,a.Close_Date__c                               
    FROM Apttus__APTS_Agreement__c a 
    WHERE  RecordType.Name != :NOT_YET_SELECTED_VALUE AND RecordType.Name != :ADVICE_ONLY_VALUE AND a.OwnerID IN :empIdsSet   //Updated as per request from listGroupIds to empIdsSet 
    ORDER BY lastmodifieddate DESC]));	
    }
    	apprRequestRecordSet.setPageSize(apprRequestRecordSet.getResultSize());
        return apprRequestRecordSet;
    }
	 
	 public List<Apttus__APTS_Agreement__c> getAgmtReqPagination1(){ //My Agreement tab Pageblock data
        List<Apttus__APTS_Agreement__c> tapprRequestRecords = new List<Apttus__APTS_Agreement__c>();
        if (getApprRequestRecordSet(1) != null) {            
            tapprRequestRecords =  apprRequestRecordSet.getRecords();
        }
         return tapprRequestRecords;
    }
    
    
    public List<Apttus__APTS_Agreement__c> getAgmtReqPagination2(){ //My Team Agreement tab Pageblock data
        List<Apttus__APTS_Agreement__c> tapprRequestRecords = new List<Apttus__APTS_Agreement__c>();
        if (getApprRequestRecordSet(2) != null) {            
            tapprRequestRecords =  apprRequestRecordSet.getRecords();
        }
         return tapprRequestRecords;
    }
    
    public void doAccept() { //Click on Accept data       
        Apttus__APTS_Agreement__c apprRequest = [SELECT l.Id,l.OwnerId FROM Apttus__APTS_Agreement__c l WHERE l.Id = :apprReqId LIMIT 1];
                                            
        apprRequest.OwnerId = UserInfo.getUserId();
        update apprRequest;
        apprRequestRecordSet = null;                                    
        
    }
    
    public PageReference goAgmt(){ //go to this Agreement
        return new PageReference('/'+agreementId);        
    }
    
    
    
    //This method is not used anywhere
    public PageReference doView(){ //view specific agreeement
        return new PageReference('/'+apprReqId);        
    }

}

/* ------------------------------END OF THE CLASS -------------------------------
	public Boolean getHasApprovalRequestsAgmt() {
        // get the user set
        apprRequestRecordSet = getApprRequestRecordSet(1);
        
        return (apprRequestRecordSet != null && apprRequestRecordSet.getResultSize() > 0);
    }
    
   public void firstPage() {
        
        if (apprRequestRecordSet != null) {
            apprRequestRecordSet.first();
            
        }
    }
    
    
    public void lastPage() {

        if (apprRequestRecordSet != null) {
            apprRequestRecordSet.last();
            
        }
    }
    
    
    public Boolean getHasNextPage() {
        return (apprRequestRecordSet != null ? apprRequestRecordSet.getHasNext() : false);
    }
    
    
    public Boolean getHasPreviousPage() {
        return (apprRequestRecordSet != null ? apprRequestRecordSet.getHasPrevious() : false);
    }

    public void previousPage() {

        if (apprRequestRecordSet != null) {
            apprRequestRecordSet.previous();
            
        }
    }
        
    
    public void nextPage() {

        if (apprRequestRecordSet != null) {
            apprRequestRecordSet.next();
            
        }
    }
    
    
    public Integer getCurrentPageNumber() {
        return (apprRequestRecordSet != null ? apprRequestRecordSet.getPageNumber() : 0);
    }
    
    public Integer getTotalPages() {
        
        if (totalPages == null && apprRequestRecordSet != null) {
            totalPages = apprRequestRecordSet.getResultSize()/apprRequestRecordSet.getPageSize();
            Integer remainder = Math.mod(apprRequestRecordSet.getResultSize(), apprRequestRecordSet.getPageSize());
            if (remainder > 0) {
                totalPages++;
            }
        }       
        return (totalPages != null ? totalPages : 0);
    }*/