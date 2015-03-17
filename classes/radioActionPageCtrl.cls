public class radioActionPageCtrl {


 

   public List<SelectOption> getListOfQuarters() {
    List<SelectOption> options = new List<SelectOption>();
system.debug('selectDeb'+optSelected);
    // non-dynamic code as an example
if(optSelected == 'Option1'){
    options.add(new SelectOption('Q2 2012','Q2 2012'));
    options.add(new SelectOption('Q1 2012','Q1 2012'));
    options.add(new SelectOption('Q4 2011','Q4 2011'));
}
else {
    options.add(new SelectOption('Q2 2012','Q2 2012'));
    options.add(new SelectOption('Q1 2012','Q1 2012'));
    options.add(new SelectOption('Q4 2011','Q4 2011'));

}
    return options;
}


public Boolean renderName {
    get{
        return optSelected == 'Option1';
    }
}
public String optSelected {get;set;}
public string quarter {get;set;}
public List<SelectOption> radioValues {
    get {
        List<SelectOption> resList = new List<SelectOption>();
        resList.add(new SelectOption('Option1', 'Option1'));
        resList.add(new SelectOption('Option2', 'Option2'));
        return resList;
    }
}

public List<SelectOption> getListOfQuarters {
get {
    List<SelectOption> options = new List<SelectOption>();
if(optSelected == 'Option1'){
    // non-dynamic code as an example

    options.add(new SelectOption('Q2 2012','Q2 2012'));
    options.add(new SelectOption('Q1 2012','Q1 2012'));
    options.add(new SelectOption('Q4 2011','Q4 2011'));
}
else {
 options.add(new SelectOption('Q2 2012','Q2 2012'));
    options.add(new SelectOption('Q1 2012','Q1 2012'));
    options.add(new SelectOption('Q4 2011','Q4 2011'));

}
    return options;
}
}

public radioActionPageCtrl(ApexPages.StandardController controller) {
    optSelected  = 'Option1';
}
}