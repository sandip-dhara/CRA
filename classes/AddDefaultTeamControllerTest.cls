/**********************************************************
* Class Name: AddDefaultTeamControllerTest
* Author: Accenture
* Date: 9-MAY-2012 
* Description: This class does the test coverage
*              for AddDefaultTeamController class. 
***********************************************************/
@isTest
private class AddDefaultTeamControllerTest{
	static AddDefaultTeamController addDefaultTeamController;
    static AccountTeamMember accountTeamMember, accMem;
    static UserAccountTeamMember userAccountTeamMembers;
    static Opportunity opty;
    static Account newAccount ;
    static String returnString;
    static UserAccountTeamMember userAccTeamMember;
    static UserTeamMember userTeamMember;
    public static void setupData() {
    	String RecordTypeId ='';
    	returnString = 'test';
    	addDefaultTeamController  = new AddDefaultTeamController();
	    try {
	        RecordTypeId = RecordTypeIdHelper.getRecordTypeId('Account','Customer');
	    } catch(Exception e) {
	        System.debug('>>> Exception: '+e.getMessage());
	    }
    	//Create a test account
	    newAccount = new Account(); 
	    newAccount = TestingSetupDataUtil.createAccount('testAccount', 'test@accenture.com', 'Customer');
	    insert newAccount;
	    
	    //Insert AccountTeamMember
	    accMem = new AccountTeamMember();
		accMem = TestingSetupDataUtil.createAccTeamMembers(Userinfo.getUserId(), 'Sales Rep', newAccount.Id);
		insert accMem;
		system.assertEquals(accMem.Id != null, true);
		
				

		//Create Opty
	   	opty  = new Opportunity(); 
	    opty = TestingSetupDataUtil.createOpportunity(newAccount.Id, 'Default Opty_5_7', System.today().addMonths(1));
	    insert opty;
	    
    }
    static testMethod void addDefaultTeamControllerTest(){
    	setupData();

    	Test.startTest();
   	
		/* Testing to add default team for Account Team */
		try {	  	
	  		returnString = addDefaultTeamController.addDefaultTeamforAM(newAccount.Id);
		} catch(Exception ex) {
			CreateApexErrorLog.insertHandledExceptions(ex, null, 'AccountTeam', 'AddDefaultTeamControllerTest', 'Class');
		}
	  	/* Testing to add default team for Opportunity Sales Team */
	  	try {
		  	returnString = addDefaultTeamController.addDefaultTeamforSalesTeam(opty.Id);
	  	} catch(Exception ex) {
			CreateApexErrorLog.insertHandledExceptions(ex, null, 'SalesTeam', 'AddDefaultTeamControllerTest', 'Class');
		}
	  	Test.stopTest();
    }
}