public class exportExcel {
    public string header{get;set;}
    public List<wrapper> lstwrapper {get; set;}
    public class wrapper{
        public string shipTo {get; set;}
        public string searchNumber{get; set;}
        public string accountName{get; set;}
        public string businessUnit{get; set;}
        public string dateval{get; set;}
        public string expirationDate{get; set;}
        public string expirationEndDate{get; set;}
        public string expirationStartDate{get; set;}
        public string groupval{get; set;}
        public string implantDate {get; set;}
        public string invoiceDate{get; set;}
        public string invoiceNumber{get; set;}         
    }
    public string Filetype{get;set;}
    public boolean isExcel {get;set;}
    public boolean isCsv {get;set;}   
    public exportExcel(){
            Filetype = '';
            lstwrapper = new List<wrapper>();
            header = 'Ship To,Search Number,Account Name,Business Unit,Date,Expiration Date,Expiration End Date,Expiration Start Date,Group,Implant Date ,Invoice Date,Invoice Number\r\n';                     
    }
    public void exportToExcel(){
          wrapper w = new wrapper();
          w.shipTo = 'murali';
          w.searchNumber = 'Krishna';
          w.accountName = 'Chejerla';
          lstwrapper.add(w);               
          //string queryString = 'Select c.Account_Name__c, c.Business_Unit__c, c.Date__c, c.Expiration_Date__c,c.Expiration_End_Date__c, c.Expiration_Start_Date__c, c.Group__c, c.Id, c.Implant_Date__c, c.Invoice_Date__c, c.Invoice_Number__c, c.Location__c, c.Name, c.Order_Number__c, c.OwnerId, c.Physician_ID__c, c.PO_Number__c, c.Product_Group__c, c.Product_ID__c, c.Search_ID__c, c.Serial_Number__c, c.Ship_To__c, c.Type__c, c.User_ID__c, c.User_Name__c from Consignment_Search_Data__c c where User_ID__c=\''+UserInfo.getUserId()+'\''; 
          //List<Consignment_Search_Data__c> lstConsignmentSearchData = DataBase.Query(queryString);
          //system.debug('lstConsignmentSearchData :'+lstConsignmentSearchData.size());
          //if(true){
              //for(Consignment_Search_Data__c csd :lstConsignmentSearchData){
                  
                  /*w.businessUnit = csd.Business_Unit__c ;
                  w.dateval = string.valueof(csd.Date__c);
                  w.expirationDate = string.valueOf(csd.Expiration_Date__c);
                  w.expirationEndDate = string.valueOf(csd.Expiration_End_Date__c);
                  w.expirationStartDate = string.valueOf(csd.Expiration_Start_Date__c);
                  w.groupval = csd.Group__c;
                  w.implantDate = string.valueOf(csd.Implant_Date__c);
                  w.invoiceDate = string.valueOf(csd.Invoice_Date__c) ;
                  w.invoiceNumber = string.valueOf(csd.Invoice_Number__c);*/
                  
              //}             
          //}
          system.debug('lstwrapper :'+lstwrapper.size());
    }
}