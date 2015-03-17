public class OpportunityRepLinkCtrller {
    public String reportName {get; set;}
    public String accName {get; set;}
    public String accId {get; set;}

    // Constructor
    public OpportunityRepLinkCtrller(ApexPages.StandardController controller) {
        reportName = 'Report1';
        accId = ApexPages.currentPage().getParameters().get('AccountID');
        List<Account> lst = [SELECT Id, Name FROM Account WHERE id = :accId];
        //accName = ApexPages.currentPage().getParameters().get('AccountName');
        accName = lst.get(0).name;
    }

    // Report names to be displayed in Drop down
    public List<SelectOption> getReportNames() {
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('Select','Select Value'));
        options.add(new SelectOption('Report1','Opportunity Summary for Account (AMID 2)'));
        options.add(new SelectOption('Report2','Opportunity Summary for Account (AMID 2)-HPFS'));
        return options;
    }
}