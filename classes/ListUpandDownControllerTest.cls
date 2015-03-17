@isTest
public class ListUpandDownControllerTest{
    public static testMethod void ListUpandDownControllerTest(){
        ListUpandDownController LPDC = new ListUpandDownController(); 
        LPDC.rightOptions = new List<SelectOption>();
        LPDC.rightOptionsHidden = 'A&a&b&b&C&c';
        System.assertEquals(LPDC.rightOptions.size(), 3);
        /*SelectOption[] options = new SelectOption[]{};  
        String str = LPDC.rightOptionsHidden;
        string str1;*/
    }
}