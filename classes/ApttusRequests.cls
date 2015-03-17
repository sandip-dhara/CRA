/*
* NAME : ApttusRequests
* NOTE: class will used when user clicks on "Request" Home Page Link,it shows My Assigned/Unassigned,My Team Assigned/UnAssigned Requests
* Author : Apttus(Axay Varu & Shabbir Lahori)
*/
public with sharing class ApttusRequests {
  
     public Id apprReqId {get; set;}
     public String parentAgreementId {get;set;}
     public String agreementId {get;set;}
     public Id agmtId {get; set;}
     public ApexPages.StandardSetController apprRequestRecordSet;
     public List<EmployeeBean> empData{get; set;}
	 public String empID {get; set;}
	 public List<String> empids{get; set;}
	 public Boolean showTab{get;	set;}
	 
	 //Constants
	 public static final String QUEUE_VALUE = 'Queue';
	 public static final String NOT_YET_SELECTED_VALUE = 'Not yet selected';
	 public static final String REQUEST_VALUE = 'Request';
	 public static final String ASSIGNED_VALUE = 'Assigned';
	 public static final String PENDING_ASSIGNMENT_VALUE = 'Pending Assignment';
	 
     public ApttusRequests(ApexPages.StandardSetController controller) {
     	empID = [SELECT ID,Legacy_Employee_Ref__c FROM USER WHERE ID = :UserInfo.getUserID() LIMIT 1].Legacy_Employee_Ref__c;
     	empData = new List<EmployeeBean>();
     	empids = new List<String>();
     	empData = AptsTibcoWebServiceUtilClass.getEmpHierarchyData(empID); //for testing empID = '20131966' -> Arne Byberg
     	showTab = FALSE;
     	if(empData.size() > 0)
     	{
     		showTab = TRUE;
     	}
     }    
     
     public List<ID> getAllQueueMembers(List<ID> userid)
     {
     	List<GroupMember> lstGroupMember = new List<GroupMember>();
     	List<ID> lstAllQueueMembers = new List<ID>();
     	lstGroupMember = [SELECT g.GroupID FROM GroupMember g WHERE g.Group.Type= :QUEUE_VALUE AND g.UserOrGroupId IN :userid];
     	if(lstGroupMember.size() > 0)
     	{
     		for (GroupMember gm : lstGroupMember) 
     		{
        		lstAllQueueMembers.add(gm.GroupId);
            }	
     	}
       return lstAllQueueMembers;	
     }
     
     public List<ID> getEmployeeIds(List<String> extrnlids)
     {
     	List<ID> idsext = new List<ID>();
     	List<USER> users = new List<USER>();
     	if(extrnlids.size() > 0)
        {
        	users = [SELECT ID,NAME,Legacy_Employee_Ref__c FROM USER WHERE Legacy_Employee_Ref__c IN :extrnlids];
        	for(USER use : users)
        	{
        		idsext.add(use.ID);
        		}	
        	}
        return idsext;
     }
     
    public ApexPages.StandardSetController getApprRequestRecordSet(Integer flag){
    	if(flag == 1){ 
        //My Assigned Requests
        
		apprRequestRecordSet = new ApexPages.StandardSetController( Database.getQueryLocator(
		[SELECT a.ID,a.Name,a.Owner.Name,a.Apttus__Account__c,a.Customer_Legal_Name__c,a.Lead_BU__c,
		a.Apttus__Total_Contract_Value__c,a.CreatedDate,Agreement_Type_String__c,a.LastModifiedDate,
		a.Sales_Request_Type__c,a.Customer_Location_Country__c,a.Customer_State_if_US__c,a.Public_Sector__c,
		a.Is_Global_Account__c,a.Opportunity_Owner__c,a.Request_Date__c,a.Close_Date__c                               
        FROM Apttus__APTS_Agreement__c a 
        WHERE  RecordType.Name = :NOT_YET_SELECTED_VALUE 
        AND Apttus__Status__c = :ASSIGNED_VALUE AND Apttus__Status_Category__c = :REQUEST_VALUE AND OwnerID = :UserInfo.getUserID()
        ORDER BY lastmodifieddate DESC]));
        
        }
        
        if(flag == 2){ 
        // My UnAssigned Requests
        
        List<ID> myid = new List<ID>();
        myid.add(UserInfo.getUserID());
       	List<Id> listGroupIds = getAllQueueMembers(myid);
		apprRequestRecordSet = new ApexPages.StandardSetController(Database.getQueryLocator(
        [SELECT a.Name,a.Owner.Name,Agreement_Type_String__c,a.Customer_Legal_Name__c,a.Aging__c,a.Lead_BU__c,
        a.Apttus__Total_Contract_Value__c,a.CreatedDate,a.LastModifiedDate,
        a.Sales_Request_Type__c,a.Customer_Location_Country__c,a.Customer_State_if_US__c,a.Public_Sector__c,
		a.Is_Global_Account__c,a.Opportunity_Owner__c,a.Request_Date__c,a.Close_Date__c
        FROM Apttus__APTS_Agreement__c a 
        WHERE  RecordType.Name = :NOT_YET_SELECTED_VALUE AND Apttus__Status__c = :PENDING_ASSIGNMENT_VALUE AND Apttus__Status_Category__c = :REQUEST_VALUE AND OwnerID IN :listGroupIds ORDER BY lastmodifieddate DESC]));
        
        }
        
        if(flag == 3){
       // My Team Assigned Requests
       
		for(EmployeeBean emp : empData)
		{
			if(emp.employeeNumber != null || emp.employeeNumber != '')
			{
					empids.add(emp.employeeNumber);
			}
		}
        
              List<Id> listGroupIds = getEmployeeIds(empids);

              apprRequestRecordSet = new ApexPages.StandardSetController(
              Database.getQueryLocator(
              [SELECT a.Name,a.Owner.Name,a.Agreement_Type_String__c,a.Customer_Legal_Name__c,a.Aging__c,a.Apttus__Total_Contract_Value__c,a.Lead_BU__c,a.Apttus__Status__c,a.Apttus__Status_Category__c,CreatedDate,LastModifiedDate,
              a.Sales_Request_Type__c,a.Customer_Location_Country__c,a.Customer_State_if_US__c,a.Public_Sector__c,
			  a.Is_Global_Account__c,a.Opportunity_Owner__c,a.Request_Date__c,a.Close_Date__c                               
              FROM Apttus__APTS_Agreement__c a 
              WHERE  RecordType.Name = :NOT_YET_SELECTED_VALUE AND Apttus__Status__c = :ASSIGNED_VALUE AND Apttus__Status_Category__c = :REQUEST_VALUE AND a.OwnerID IN :listGroupIds
              ORDER BY lastmodifieddate DESC]));
              
        }
        
        if(flag == 4){
        //My Team Unassigned Requests
        
		for(EmployeeBean emp : empData)
		{
			if(emp.employeeNumber != null || emp.employeeNumber != '')
			{
					empids.add(emp.employeeNumber);
			}
		}
            
                 List<ID> lstMyEmpIDs = getEmployeeIds(empids);
                 Set<ID> removeDuplicates = new Set<ID>();
                 List<ID> myEmpQueue = new List<ID>();
                 
                 removeDuplicates.addAll(lstMyEmpIDs);
                 lstMyEmpIDs.clear();
                 lstMyEmpIDs.addAll(removeDuplicates);
                 removeDuplicates.clear();
                 
                 myEmpQueue = getAllQueueMembers(lstMyEmpIDs);
                 removeDuplicates.addAll(myEmpQueue);
                 myEmpQueue.clear();
                 myEmpQueue.addAll(removeDuplicates);
                 
                 apprRequestRecordSet = new ApexPages.StandardSetController( Database.getQueryLocator(
                 [SELECT a.Name,a.Owner.Name,Agreement_Type_String__c,a.Customer_Legal_Name__c,a.Aging__c,a.Apttus__Total_Contract_Value__c,a.Lead_BU__c,a.Apttus__Status__c,CreatedDate,LastModifiedDate,
                  a.Sales_Request_Type__c,a.Customer_Location_Country__c,a.Customer_State_if_US__c,a.Public_Sector__c,
				  a.Is_Global_Account__c,a.Opportunity_Owner__c,a.Request_Date__c,a.Close_Date__c                               
                  FROM Apttus__APTS_Agreement__c a WHERE  RecordType.Name = :NOT_YET_SELECTED_VALUE 
                  AND Apttus__Status__c = :PENDING_ASSIGNMENT_VALUE AND Apttus__Status_Category__c = :REQUEST_VALUE AND OwnerID IN :myEmpQueue ORDER BY lastmodifieddate DESC]));
                  
       }
        apprRequestRecordSet.setPageSize(apprRequestRecordSet.getResultSize());
        
        return apprRequestRecordSet;
    }
    
   
    // Requests Tab 1 My  Requests
    public List<Apttus__APTS_Agreement__c> getApprReqPagination1(){
        List<Apttus__APTS_Agreement__c> tapprRequestRecords = new List<Apttus__APTS_Agreement__c>();
        if (getApprRequestRecordSet(1) != null) {            
            tapprRequestRecords =  apprRequestRecordSet.getRecords();
        }
         return tapprRequestRecords;
    } 
    // Requests Tab 2 My Unassigned Request
    public List<Apttus__APTS_Agreement__c> getApprReqPagination2(){
        List<Apttus__APTS_Agreement__c> tapprRequestRecords = new List<Apttus__APTS_Agreement__c>();
        if (getApprRequestRecordSet(2) != null) {            
            tapprRequestRecords =  apprRequestRecordSet.getRecords();
        }
         return tapprRequestRecords;
    }
	// Requests Tab 3 My Team assigned Request
	public List<Apttus__APTS_Agreement__c> getApprReqPagination3(){
        List<Apttus__APTS_Agreement__c> tapprRequestRecords = new List<Apttus__APTS_Agreement__c>();
        if (getApprRequestRecordSet(3) != null) {            
            tapprRequestRecords =  apprRequestRecordSet.getRecords();
        }
         return tapprRequestRecords;
    }
    // Requests Tab 4 My Team Unassigned Request
	public List<Apttus__APTS_Agreement__c> getApprReqPagination4(){
        List<Apttus__APTS_Agreement__c> tapprRequestRecords = new List<Apttus__APTS_Agreement__c>();
        if (getApprRequestRecordSet(4) != null) {            
            tapprRequestRecords =  apprRequestRecordSet.getRecords();
        }
         return tapprRequestRecords;
    }
    
    public void doAccept() {        
        Apttus__APTS_Agreement__c apprRequest = [select l.Id,l.OwnerId  
                                            from Apttus__APTS_Agreement__c l where l.Id=:apprReqId limit 1];
                                            
        apprRequest.OwnerId = UserInfo.getUserId();
        update apprRequest;
        apprRequestRecordSet = null;                                    
        
    }
    
    public PageReference goAgmt(){
        return new PageReference('/'+agreementId);        
    }
    
    
    
    // This method is not used anywhere
    public PageReference doView(){
        return new PageReference('/'+apprReqId);        
    }

}
	
/* -------------------END OF CLASS-------------------------------
    public Boolean getHasApprovalRequests1() {
        // get the user set
        apprRequestRecordSet = getApprRequestRecordSet(1);
        
        return (apprRequestRecordSet != null && apprRequestRecordSet.getResultSize() > 0);
    }
    public Boolean getHasApprovalRequests2() {
        // get the user set
        apprRequestRecordSet = getApprRequestRecordSet(2);
        
        return (apprRequestRecordSet != null && apprRequestRecordSet.getResultSize() > 0);
    }
    public Boolean getHasApprovalRequests3() {
        // get the user set
        apprRequestRecordSet = getApprRequestRecordSet(3);
        
        return (apprRequestRecordSet != null && apprRequestRecordSet.getResultSize() > 0);
    }
    public Boolean getHasApprovalRequests4() {
        // get the user set
        apprRequestRecordSet = getApprRequestRecordSet(4);
        
        return (apprRequestRecordSet != null && apprRequestRecordSet.getResultSize() > 0);
    } 
    
    public void firstPage() {
        
        if (apprRequestRecordSet != null) {
            apprRequestRecordSet.first();
            // reset current page
            //userList = null;
        }
    }
    
    
    public void lastPage() {

        if (apprRequestRecordSet != null) {
            apprRequestRecordSet.last();
            // reset current page
            //userList = null;
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
        	pageNumber--;
        	System.debug('IN PREVIOUS');
            //apprRequestRecordSet.previous();
            // reset current page
            //userList = null;
        }
    }
        
    
    public void nextPage() {
		
        if (apprRequestRecordSet != null) {
        	//apprRequestRecordSet.next();
        	System.debug('IN NEXT');
        	//apprRequestRecordSet.setPageNumber(++pageNumber);
        	pageNumber++;
            
        }
    }
    
    
    public Integer getCurrentPageNumber() {
        return (apprRequestRecordSet != null ? apprRequestRecordSet.getPageNumber() : 0);
    }
    
    public Integer getTotalPages() {
        
        if (apprRequestRecordSet != null) {
        	
            totalPages = apprRequestRecordSet.getResultSize()/apprRequestRecordSet.getPageSize();
            
            
            Integer remainder = Math.mod(apprRequestRecordSet.getResultSize(), apprRequestRecordSet.getPageSize());
            if (remainder > 0) {
                totalPages++;
            }
        }       
        return (totalPages != null ? totalPages : 0);
    }
    
    public Integer getCorrespondingTotalPages(ApexPages.StandardSetController recordSetVariable) {
        
        if (recordSetVariable != null) {
        	
            totalPages = recordSetVariable.getResultSize()/recordSetVariable.getPageSize();
            Integer remainder = Math.mod(recordSetVariable.getResultSize(), recordSetVariable.getPageSize());
            if (remainder > 0) {
                totalPages++;
            }
        }       
        return (totalPages != null ? totalPages : 0);
    }
    
   public PageReference rerenderPaginationPanel()
   {
   		pageNumber = 1;
   		return null;
   } */