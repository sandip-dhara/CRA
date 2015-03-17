/**********************************************************
* Class Name: DealReg_AccountSearchUtilTest
* Author: HP
* Date: 02-OCT-2012 
* Description: This class does the test coverage for DealReg_AccountSearchUtil class. 
***********************************************************/
    
    /*
     * @Description: Test Method to test search method of DealReg_AccountSearchUtil class.
     * 
     */
@isTest
private class DealReg_AccountSearchUtilTest{
    
    //Test method to test code coverage of the DealReg_AccountSearchUtil class
    public static testMethod void testRunSearch() {
      
      List<Account> results;
      
      //Testing with only Customer Name
      DealReg_AccountSearchUtil.runSearch('test','','',results,20,20);
      
      //Testing with Customer Name and Country
      DealReg_AccountSearchUtil.runSearch('test','test','',results,20,20);
      
      //Testing with Customer Name and City
      DealReg_AccountSearchUtil.runSearch('test','','test',results,20,20);
      
      //Testing with Customer Name, Country and City
      DealReg_AccountSearchUtil.runSearch('test','test','test',results,20,20);
      
    }
}