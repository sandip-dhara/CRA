public class SalesManagerReportCtrller {
    public String reportName {get; set;}
    public boolean isExportable {get; set;}
    
    public SalesManagerReportCtrller(ApexPages.StandardController controller) {
        reportName = 'Report1';
    }
    
    public List<SelectOption> getReportNames() {
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('Select','Select Value'));
        options.add(new SelectOption('Report1','Summary by Reporting Person'));
        options.add(new SelectOption('Report3','Summary by Reporting Person by Product by Book Ship Date'));
        options.add(new SelectOption('Report4','Summary by Sales Representative by Product by Book Ship Date'));
        return options;
   }
}