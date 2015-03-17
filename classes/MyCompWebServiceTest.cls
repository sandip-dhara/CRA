@isTest(SeeAllData=true)
//global class WebServiceMockImpl implements WebServiceMock 
global class MyCompWebServiceTest 
{
    @isTest 
    static void testEchoString() 
    { 
        MyCompWebService mws = new MyCompWebService();
        MyCompWebService.ArrayOfPerfHist aph = new MyCompWebService.ArrayOfPerfHist();
        MyCompWebService.Analytics anly = new MyCompWebService.Analytics();
        MyCompWebService.PALM_DisclaimerResponse_element pdre = new MyCompWebService.PALM_DisclaimerResponse_element();
        MyCompWebService.Help help = new MyCompWebService.Help();
        MyCompWebService.ArrayOfHelp ArrHelp = new MyCompWebService.ArrayOfHelp();
        
        MyCompWebService.MyCompServiceSoap soap = new MyCompWebService.MyCompServiceSoap();
        soap.isTest = true;
        soap.PALM_Help();
        soap.PALM_Disclaimer();
        
        MyCompWebService.Performance perf = new MyCompWebService.Performance();
        MyCompWebService.PerfHist perfHist = new MyCompWebService.PerfHist();
        MyCompWebService.PALM_HelpResponse_element phre = new MyCompWebService.PALM_HelpResponse_element();
        MyCompWebService.PALM_ViewResponse_element pvre  = new MyCompWebService.PALM_ViewResponse_element();
        //MyCompWebService.Security secur = new MyCompWebService.Security();
        MyCompWebService.PALM_HistoryResponse_element phistre  = new MyCompWebService.PALM_HistoryResponse_element();
        MyCompWebService.ArrayOfAnalytics arrAnaly = new MyCompWebService.ArrayOfAnalytics();
        MyCompWebService.Metrics met = new MyCompWebService.Metrics();
        MyCompWebService.PALM_Disclaimer_element pde = new MyCompWebService.PALM_Disclaimer_element();
        MyCompWebService.PALM_Help_element phelpEle = new MyCompWebService.PALM_Help_element();
        MyCompWebService.ArrayOfPerformance arrPerf = new MyCompWebService.ArrayOfPerformance();
        MyCompWebService.ArrayOfMetrics arrMet= new MyCompWebService.ArrayOfMetrics();
         
        myCompController mcc = new myCompController();
        mcc.isTest = true;
        mcc.start();
        mcc.showEmployeeIdSection();
        mcc.password = '78728';
        mcc.showEmployeeIdSection();
        mcc.showPasswordSection();
    }
    
    @isTest 
    static void testMyCompWebService() 
    { 
        try
        {
            MyCompWebService mws = new MyCompWebService();
            MyCompWebService.ArrayOfPerfHist aph = new MyCompWebService.ArrayOfPerfHist();
            MyCompWebService.Analytics anly = new MyCompWebService.Analytics();
            MyCompWebService.PALM_DisclaimerResponse_element pdre = new MyCompWebService.PALM_DisclaimerResponse_element();
            MyCompWebService.Help help = new MyCompWebService.Help();
            MyCompWebService.ArrayOfHelp ArrHelp = new MyCompWebService.ArrayOfHelp();
            
            MyCompWebService.Performance perf = new MyCompWebService.Performance();
            MyCompWebService.PerfHist perfHist = new MyCompWebService.PerfHist();
            MyCompWebService.PALM_HelpResponse_element phre = new MyCompWebService.PALM_HelpResponse_element();
            MyCompWebService.PALM_ViewResponse_element pvre  = new MyCompWebService.PALM_ViewResponse_element();
            //MyCompWebService.Security secur = new MyCompWebService.Security();
            MyCompWebService.PALM_HistoryResponse_element phistre  = new MyCompWebService.PALM_HistoryResponse_element();
            MyCompWebService.ArrayOfAnalytics arrAnaly = new MyCompWebService.ArrayOfAnalytics();
            MyCompWebService.Metrics met = new MyCompWebService.Metrics();
            MyCompWebService.PALM_Disclaimer_element pde = new MyCompWebService.PALM_Disclaimer_element();
            MyCompWebService.PALM_Help_element phelpEle = new MyCompWebService.PALM_Help_element();
            MyCompWebService.ArrayOfPerformance arrPerf = new MyCompWebService.ArrayOfPerformance();
            MyCompWebService.ArrayOfMetrics arrMet= new MyCompWebService.ArrayOfMetrics();
            
            String employeenumber = [Select Legacy_Employee_Ref__c from User Where id =: UserInfo.getUserId()].Legacy_Employee_Ref__c;
            String componentName = 'H2_21_SALES_MARGIN_50';
            string fiscalYear = 'FY12';
            MyCompWebService.MyCompServiceSoap soap = new MyCompWebService.MyCompServiceSoap();
            soap.isTest = true;
            try{
                soap.PALM_Help();
            }catch(Exception e){}
            
            try{
                soap.PALM_Prologue(employeenumber);
            }catch(Exception e){}
            
            try{
                soap.PALM_History(employeenumber, componentName, fiscalYear);
            }catch(Exception e){}
            
            try{
                soap.PALM_Disclaimer();
            }catch(Exception e){}
            
            try{
                soap.PALM_View(employeenumber, fiscalYear);
            }catch(Exception e){}
            
            try{
                soap.PALM_Personal(employeenumber, fiscalYear);
            }catch(Exception e){}
            
            try{
                soap.PALM_Component(employeenumber, fiscalYear);
            }catch(Exception e){}
            
        }
        catch(Exception e)
        {
        }
    }
}