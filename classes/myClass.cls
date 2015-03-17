public class myClass {
public String myString {get; set;}
public string myHiddenValue {get;set;}
    public myClass(){
        myString = '';
        myHiddenValue ='';
    }

    // Method for testing a hidden field functionality 
    public PageReference myMethod(){
        System.debug('myString: ' + myString);
        return null;
    }
    
    public void Test()
    {
        System.debug('myHiddenValue: ' + myHiddenValue );    
    }
}