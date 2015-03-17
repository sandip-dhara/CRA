public with sharing class IntegratedReportController {
        public String linkforIFrame{get;set;}
        public boolean isLink{get;set;}
        public boolean isReport{get;set;}
    public String pageBlockTitle{get;set;}
  
          public IntegratedReportController()
          {
            isLink = true;
            isReport = false;
            pageBlockTitle= 'Integrated Report List';
            
          }
  
          public PageReference linkClick()
          {
            isLink = false;
            isReport = true;
            pageBlockTitle= 'Sales Manager Report';
            return null;
          }

}