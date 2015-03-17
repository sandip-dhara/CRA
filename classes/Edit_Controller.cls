public with sharing class Edit_Controller {

    public PageReference cancel() {
        return null;
    }


    public String showEditBlock { get; set; }
public SObject record{
    get; 
    set{
        System.debug('record: ' + value);
        if(value != null){
            record = value;
        }
    }
}

public Edit_Controller(){
}

public PageReference save(){
    ApexPages.StandardController sc = new ApexPages.StandardController(record);
    return sc.save();
}
}