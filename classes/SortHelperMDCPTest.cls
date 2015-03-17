/**********************************************************
* Class Name: SortHelperMDCPTest
* Author: HP
* Date: 05-OCT-2012 
* Description: This class does the test coverage for SortHelperMDCPTest class. 
***********************************************************/

@isTest(SeeAllData=true)
private class SortHelperMDCPTest{
static testMethod void myUnitTest(){
        List<Account> accList = [select Name,AccountNumber from Account limit 100];
        SortHelperMDCP obj=new SortHelperMDCP();
       obj.sortList(accList,'Name', 'ASC');
        obj.sortList(accList,'Name', 'DESC');
         String lastValue = null;
        String currentValue = null;        
        for (Account acc : accList) {
               currentValue = acc.Name;
              // System.assertEquals(currentValue.compareTo(lastValue)>=0, true);
        }
        lastValue = currentValue;
     }
     }