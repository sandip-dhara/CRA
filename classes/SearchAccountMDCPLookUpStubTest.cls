/**********************************************************
* Class Name: SearchAccountMDCPLookUpStubTest
* Author: HP
* Date: 05-OCT-2012 
* Description: This class does the test coverage for SearchAccountMDCPLookUpStubTest class. 
***********************************************************/

@isTest(SeeAllData=true)
private class SearchAccountMDCPLookUpStubTest{
private static TestMethod void test1(){ 
SearchAccountMDCPLookUpStub test = new SearchAccountMDCPLookUpStub(); 
 SearchAccountMDCPLookUpStub.MDCPLookUpSearch mdcpsearch= new SearchAccountMDCPLookUpStub.MDCPLookUpSearch(); 
 try{
 mdcpsearch.MDCPLookUpSearch('',0,0,'','','','');
 }catch(Exception e){}
 SearchAccountMDCPLookUpStub.Security_element obj=new SearchAccountMDCPLookUpStub.Security_element('','','','');
SearchAccountMDCPLookUpStub.UsernameToken_element obj1=new SearchAccountMDCPLookUpStub.UsernameToken_element('','','','');
//addd to call
//test.increamentor();
} 
   
}