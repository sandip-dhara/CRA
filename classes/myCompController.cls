public with sharing class myCompController {
    
    public MyCompWebService.ArrayOfPrologue response{get;set;}
    public MyCompWebService.ArrayOfComponent componentResponse{get;set;}
    public MyCompWebService.Personal personalResponse{get;set;}
    public List<MyCompWebService.Liability> liabilityResponse{get;set;}
    public List<MyCompWebService.Payments> paymentsResponse{get;set;}
    
    public MyCompWebService.Payments estimatedNextPaymentResponse{get;set;}
    public Map<String, String> monthMap = new map<String, String>{'01' => 'NOV', '02' => 'DEC', '03' => 'JAN', '04' => 'FEB', '05' => 'MAR', '06' => 'APR', '07' => 'MAY', '08' => 'JUN', '09' => 'JUL', '10' => 'AUG', '11' => 'SEP', '12' => 'OCT'};
    
    private MyCompWebService.MyCompServiceSoap  ss;
    public boolean isTest = false;
    
    
        
    public String palmviewResponse{get;set;}
    public List<String> overallperformanceList{get;set;}

    
    public List<SelectOption> fiscalYearList{get;set;}
    public String selectedFiscalYear{get;set;}
    public List<SelectOption> componentList{get;set;}
    public List<String> componentNameList{get;set;}
    public List<String> selectedComponent{get;set;}
    public boolean showComponentList {get;set;}
    public Map<String, String> componentPALMHistoryImageMap;
    
    public String intTIA {get;set;}
    public Double drawLiability {get; set;}
    public String intdrawLiability {get; set;}
    public Double overpayLiability {get; set;}
    public String intoverpayLiability {get; set;}
    public String estimatedNextPaymentAmount {get;set;}
    public String fiscalmonth {get; set;}
    public String paymentType {get; set;}
    public String dateCalculated {get; set;}
    public Integer paymentAmount {get; set;}
    private final String NOT_APPLICABLE = 'N/A';
    private final String ZERO = '0';
    private final String WEBSERVICE_CALLOUT_ERROR_MESSAGE = 'Web service callout failed';
    private final String WEBSERVICE_CALLOUT_ERROR_MESSAGE_USER_MESSAGE = 'User data not found. Data update might be in progress, please try again later.If problem persists, please contact the MyComp support team.';
    private final String PLEASE_ENTER_EIGHT_DIGIT_NUMERIC_EMPLOYEE_NUMBER = 'Employee number should not be Empty';
    private List<Exception> exceptionList;
    public boolean componentListIsNotEmpty{get; set;}
    private final Integer MAX_NO_ALLOWED_PERFORMANCE_FRAME = 6;
    public boolean showCalloutLimitError {get; set;}
    public String calloutLimitError {get; set;}
    public String errorMessage {get; set;}
    
    public boolean showTestLink {get; set;}
    public boolean showPasswordTextBox {get; set;}
    public boolean showEmployeeIdTextBox {get; set;}
    public String password {get; set;}
    public String employeenumber {get; set;}
    public String invalidPasswordMessage {get; set;}
   //private final String PROD_ORG_ID = '00Dd0000000bUlK';
    private final String PROD_ORG_ID = Label.MYCOMP_PROD_ORGID;
    String currentUserTimeZoneSidKey;
    
    /*Start of Comments: Modified by PM on 03/14/2013 MyComp tab access based on User Region*/
    /*****Following Code  has to be retained when APJ is live with Mycomp dashboard*****/
    public boolean isStart{get;set;}
    public boolean redirect{get;set;}
    public User u = new User();
    /*End of Comments */
    
    public myCompController()
    {
        /*Start of Comments: Modified by Saranya on 05/10/2013 MyComp tab access based on User Region and Business group*/
        isStart = false;
        redirect = false;
        currentUserTimeZoneSidKey = [Select TimeZoneSidKey From User Where Id =: UserInfo.getUserId()].TimeZoneSidKey;
        u = [select Region__c, Business_Group__c from user where id=:UserInfo.getUserId()];
        
        // My Comp Dashboard page display logic based on User region and Business Group
        // If the logged in User Business Group Starts with 'ES' - display MyComp Dashboard page
        // Else the logged in User, doesn't have any Business Group Associated
        // 1. If the logged in User, belongs to AMS or EMEA region - display MyComp Dashboard page
        // 2. If the logged in User, belongs to APJ region - display MyComp mobility page
        
        if((u.Business_Group__c != null && u.Business_Group__c.substring(0,2) == 'ES') || u.Region__c == 'AMS' || u.Region__c == 'EMEA')
        {
            redirect = true;
        }
        else 
        {
            isStart = true;
            start();
        }
        /*End of Comments */
    }
/*****Until this line from the above comment, this piece of code has to be retained when APJ is live with Mycomp dashboard*****/    
    public void setDefaultValues()
    {
system.debug('Inside SetDefaultValues:Start');
        intTIA = ZERO;
        intdrawLiability = ZERO;
        intoverpayLiability = ZERO;
        estimatedNextPaymentAmount = NOT_APPLICABLE;
        estimatedNextPaymentResponse = new MyCompWebService.Payments();
        estimatedNextPaymentResponse.fiscal_month_Str = NOT_APPLICABLE;
        estimatedNextPaymentResponse.description = NOT_APPLICABLE;
        estimatedNextPaymentResponse.calculate_date_str = NOT_APPLICABLE;
        
        personalResponse = new MyCompWebService.Personal();
        exceptionList = new List<Exception>();
        errorMessage = '';
        showCalloutLimitError= false;
        calloutLimitError = '';
        showComponentList = false;
        
        personalResponse.specialty_name = NOT_APPLICABLE;
        paymentsResponse = new List<MyCompWebService.Payments>();
        MyCompWebService.Payments payment = new MyCompWebService.Payments();
        payment.fiscal_month_Str = NOT_APPLICABLE;
        payment.description = NOT_APPLICABLE;
        payment.paymentAmount_str = ZERO;
        paymentsResponse.add(payment);
        system.debug('Inside SetDefaultValues:End');
    }
    public PageReference start()
    {   
        
        setDefaultValues();
        initializeTestLinkVariables();
        
        
        boolean isValidEmployeeNumber = validateEmployeeNumber();
        if(!isValidEmployeeNumber)
        return null;
        else
        getEmployeeNumber();
        
        try
        {
            ss = new MyCompWebService.MyCompServiceSoap();
            ss.isTest = isTest;
            
            
            system.debug('employeenumber : '+employeenumber);
            if(employeenumber != null)
            {
                getFiscalYearList(employeenumber);
                
            }
            
        }
        catch(Exception e)
        {
            System.Debug('First Exception: '+e.getMessage());
            exceptionList.add(e);
        }
        try
        {
            refreshPage();
        }
        catch(Exception e)
        {
            exceptionList.add(e);
        }
        addExceptions();
        return null;
    }
    
    public boolean validateEmployeeNumber()
    {
        if(employeenumber != null && employeenumber.trim() != '')
        {
            employeenumber = employeenumber.trim();
                
            /*if(employeenumber.length() != 8)
            {
                ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, PLEASE_ENTER_EIGHT_DIGIT_NUMERIC_EMPLOYEE_NUMBER);
                ApexPages.addMessage(newMessage);
                //return false;
            }
            try
            {
                Integer employeeNumberInt = Integer.ValueOf(employeenumber);
            }
            catch(Exception e)
            {
                ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, PLEASE_ENTER_EIGHT_DIGIT_NUMERIC_EMPLOYEE_NUMBER);
                ApexPages.addMessage(newMessage);
                //return false;
            }*/
        }
        
        return true;
    }
    public void getEmployeeNumber()
    {
        if(employeenumber == null || employeenumber.trim() == '') {
            employeenumber = [Select Legacy_Employee_Ref__c from User Where id =: UserInfo.getUserId()].Legacy_Employee_Ref__c;
        
            }
    }
    
    public PageReference refreshPage()
    {
        setDefaultValues();
        componentPALMHistoryImageMap = new Map<String, String>();
        overallperformanceList = new List<String>();
        componentList = new List<SelectOption>(); 
        componentNameList = new List<String>();
        selectedComponent = new List<String>();
        
        initializeTestLinkVariables();
        boolean isValidEmployeeNumber = validateEmployeeNumber();
        if(!isValidEmployeeNumber)
        return null;
        else
        getEmployeeNumber();
                
        try
        {
            if(selectedFiscalYear == null || selectedFiscalYear == '')
            {
                DateTime dtTime = System.now();
                String currentYear = String.valueOf(dtTime.year());
                selectedFiscalYear = 'FY'+currentYear.substring(2);
            }
            
            
        }
        catch(Exception e)
        {
            exceptionList.add(e);
            
        }
                
        try
        {
                getComponentList(employeenumber, selectedFiscalYear);
        }
        catch(Exception e)
        {
            exceptionList.add(e);
            
        }
        try
        {
                getPALMImage_BlobValue(employeenumber, selectedFiscalYear);
        }
        catch(Exception e)
        {
            palmviewResponse = '';
            exceptionList.add(e);
            
        }
        try
        {
                getPALMPersonalData(employeenumber, selectedFiscalYear);
        }
        catch(Exception e)
        {
            exceptionList.add(e);
            
        }
        
        try
        {       
                showOverallPerformanceFrame();
        }
        catch(Exception e)
        {
            exceptionList.add(e);
            
        }
        
        addExceptions();
        return null;
    }
    public void initializeTestLinkVariables()
    {
        system.debug('Inside initializeTestLinkVariables:Start');
        showTestLink = false;
        showPasswordTextBox = false;
        showEmployeeIdTextBox = false;
        invalidPasswordMessage = '';
        password = '';
        if(UserInfo.getOrganizationId().substring(0,15) != PROD_ORG_ID)
        showTestLink = true;
        system.debug('Inside initializeTestLinkVariables:OrgID:'+UserInfo.getOrganizationId().substring(0,15));
    }
    public void addExceptions()
    {
        boolean calloutFailed = false;
        
        
        for(Exception e : exceptionList)
        {
            System.Debug('1. e.getMessage() : '+e.getMessage());
            if(e.getMessage().contains(WEBSERVICE_CALLOUT_ERROR_MESSAGE))
            {
                ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, WEBSERVICE_CALLOUT_ERROR_MESSAGE_USER_MESSAGE);
                ApexPages.addMessage(newMessage);
                calloutFailed = true;
                errorMessage = WEBSERVICE_CALLOUT_ERROR_MESSAGE_USER_MESSAGE;
                break;
            }
        }
        if(!calloutFailed)
        {
            for(Exception e : exceptionList)
            {
                System.Debug('2. e.getMessage() : '+e.getMessage());
                //if(e.getMessage().contains(WEBSERVICE_CALLOUT_ERROR_MESSAGE))
                //{
                    ApexPages.Message newMessage = new ApexPages.Message(ApexPages.Severity.Error, e.getMessage());
                    ApexPages.addMessage(newMessage);
               // }
            }
        }
        exceptionList.clear();
    }
    public List<SelectOption> getFiscalYearList(String employeeNumber)
    {
        try
        {
            fiscalYearList = new List<SelectOption>();
            
            response = new MyCompWebService.ArrayOfPrologue();
        
            response = ss.PALM_Prologue(employeenumber);
            system.debug('FiscalYear Response :'+response);
            selectedFiscalYear = '';
            if(response != null && response.Prologue != null)
            {
                for(MyCompWebService.Prologue fyresponse : response.Prologue)
                {
                    if(selectedFiscalYear == '')
                    selectedFiscalYear = fyresponse.FiscalYear;
                    fiscalYearList.add(new SelectOption(fyresponse.FiscalYear, fyresponse.FiscalYear));
                }
            }
        }
        catch(Exception e)
        {
            throw e;
        }       
        return fiscalYearList;
    }
    
    public List<SelectOption> getComponentList(String employeeNumber, String fiscalYear)
    {
        try
        {
            componentList = new List<SelectOption>(); 
            componentNameList = new List<String>();
            
            
            componentResponse = new MyCompWebService.ArrayOfComponent();
            componentResponse = ss.PALM_Component(employeeNumber, fiscalYear);
            system.debug('ComponentList Response :'+componentResponse);
            selectedComponent = new List<String>();
            if(componentResponse != null && componentResponse.Component != null)
            {
                List<String> componentNames = new List<String>();
                for(MyCompWebService.Component component : componentResponse.Component)
                componentNames.add(component.Name);
                
                componentNames.sort();
                
                for(String componentName : componentNames)
                {
                    if(selectedComponent.size() == 0)
                    selectedComponent.add(componentName);
                    componentList.add(new SelectOption(componentName, componentName));
                    componentNameList.add(componentName);
                }
            }
            if(componentList != null && componentList.size() > 0)
            showComponentList = true;
            else
            showComponentList = false;
        }
        catch(Exception e)
        {
            throw e;
        }
        if(componentList.size() >0) 
        componentListIsNotEmpty = true;
        else
        componentListIsNotEmpty = false;
            
        return componentList;
    }
    
    public String getPALMImage_BlobValue(String employeeNumber, String fiscalYear)
    {
        try
        {
            palmviewResponse = ss.PALM_View(employeeNumber, fiscalYear);
            system.debug('PalmView Response :'+palmviewResponse);
        }
        catch(Exception e)
        {
            throw e;
        }
        return palmviewResponse;
    }
    
    public String getPALMHistoryImage_BlobValue(String employeeNumber, String componentName, String fiscalYear)
    {
        String palmHistory; 
        try
        {
        
            palmHistory = ss.PALM_History(employeeNumber, componentName, fiscalYear);
        }
        catch(Exception e)
        {
            throw e;
        }
        return palmHistory;
    }
    
    public String formatAmount(Decimal amount, String currentValue)
    {
        if(amount != null)
        {
            if(Integer.valueOf(amount) == amount)
            return String.valueOf(Integer.valueOf(amount));
            else
            return String.valueOf(amount);
        }
        else
        return currentValue;
    }
    
    public void getPALMPersonalData(String employeeNumber, String fiscalYear)
    {
        try
        {
            Map<String, List<MyCompWebService.Payments>> paymentMonthAndPaymentListMap;
            List<String> uniquePaymentMonthList;
            Map<String, String> uniquePaymentMonthMap = new Map<String, String>();
            
            personalResponse = ss.PALM_Personal(employeeNumber, fiscalYear);
            if(personalResponse != null)
            {
                system.debug('personalResponse : '+personalResponse);
                system.debug('personalResponse.PALM_Liability : '+personalResponse.PALM_Liability);
                if(personalResponse.specialty_name == null)
                personalResponse.specialty_name = NOT_APPLICABLE;
                
                if(personalResponse.PALM_Liability != null)
                liabilityResponse = personalResponse.PALM_Liability.Liability;
                intTIA = formatAmount(personalResponse.tia, intTIA);
                
                if(liabilityResponse != null)
                {
                    for(MyCompWebService.Liability lia : liabilityResponse)
                    {
                        drawLiability = lia.draw_liability;
                        intdrawLiability = formatAmount(drawLiability, intdrawLiability);
                        overpayLiability = lia.overpay_liability;
                        intoverpayLiability = formatAmount(overpayLiability, intoverpayLiability);
                    }
                }
                
                System.Debug('personalResponse.PALM_Payments : '+personalResponse.PALM_Payments);
                System.Debug('personalResponse.PALM_Payments.Payments : '+personalResponse.PALM_Payments.Payments);
                
                if(personalResponse.PALM_Payments != null)
                {    
                    if(personalResponse.PALM_Payments.Payments != null)
                    {
                        paymentMonthAndPaymentListMap = new Map<String, List<MyCompWebService.Payments>>();
                        uniquePaymentMonthList = new List<String>();
                        
                        if(paymentsResponse == null)
                        paymentsResponse = new List<MyCompWebService.Payments>();
                        else
                        paymentsResponse.clear();
                        
                        for(MyCompWebService.Payments payment : personalResponse.PALM_Payments.Payments)
                        {  
                            system.debug('personalResponse.PALM_Payments.Payments:' +personalResponse.PALM_Payments.Payments);
                            if(payment.calculate_date != null)
                            {
                                estimatedNextPaymentResponse = payment;
                                //String strConvertedDate = (payment.calculate_date).format('EEE MMM d yyyy HH:mm:ss','CDT');
                                String strConvertedDate = (payment.calculate_date).format('EEE MMM d yyyy HH:mm:ss Z (z)', currentUserTimeZoneSidKey);
                                
                                strConvertedDate = strConvertedDate.replace('-', 'GMT-');
                                strConvertedDate = strConvertedDate.replace('+', 'GMT+');
                                estimatedNextPaymentResponse.calculate_date_str = strConvertedDate;
                               
                                estimatedNextPaymentAmount = formatAmount(estimatedNextPaymentResponse.payment, estimatedNextPaymentAmount);
                                if(payment.fiscal_month != null)
                                estimatedNextPaymentResponse.fiscal_month_Str = formatFiscalMonth(String.ValueOf(payment.fiscal_month));
                                continue;
                            }
                            
                            if(payment.fiscal_month != null)
                            {
                                payment.fiscal_month_Str = formatFiscalMonth(String.ValueOf(payment.fiscal_month));
                                //Prepare Unique Payment Months
                                if(!uniquePaymentMonthMap.containsKey(payment.fiscal_month_Str))
                                {
                                    uniquePaymentMonthMap.put(payment.fiscal_month_Str, payment.fiscal_month_Str);
                                    uniquePaymentMonthList.add(payment.fiscal_month_Str);
                                }
                            }
                            System.Debug('payment.payment : '+payment.payment);
                            if(payment.payment != null)
                            {
                               payment.paymentAmount_str = formatAmount(payment.payment, payment.paymentAmount_str);
                            }
                        
                            //paymentsResponse.add(payment);
                            
                            /*One Payment Month may have more than one payment Record
                              Group Payment Records by "Payment Month" & sub Group the payment records by "Payment Type".
                              Group Payment Records by "Payment Month".*/
                             if(payment.fiscal_month_Str != null)
                             {
                                if(paymentMonthAndPaymentListMap.containsKey(payment.fiscal_month_Str))
                                {
                                    List<MyCompWebService.Payments> paymentListTemp = paymentMonthAndPaymentListMap.get(payment.fiscal_month_Str);
                                    paymentListTemp.add(payment);
                                    paymentMonthAndPaymentListMap.put(payment.fiscal_month_Str, paymentListTemp);
                                }
                                else
                                {
                                    List<MyCompWebService.Payments> paymentListTemp = new List<MyCompWebService.Payments>();
                                    paymentListTemp.add(payment);
                                    paymentMonthAndPaymentListMap.put(payment.fiscal_month_Str, paymentListTemp);
                                }
                                
                             }
                        }
                        /*Group Payment Records by "Payment Type".*/
                        for(String fiscal_month_Str : uniquePaymentMonthList)
                        {
                            List<MyCompWebService.Payments> paymentListByMonth = paymentMonthAndPaymentListMap.get(fiscal_month_Str);
                            //If Payment Month has only one Payment Type then insert a Payment record into the List.
                            if(paymentListByMonth != null && paymentListByMonth.size() == 1)
                            {
                                paymentsResponse.add(paymentListByMonth.get(0));
                            }
                            //If Payment Month has more than one Payment Type then, Group them by Payment Type and sort the payment records by Payment Type.
                            else if(paymentListByMonth != null && paymentListByMonth.size() > 1)
                            {
                                //Create List of Payment Types and sort them.
                                List<String> paymentTypeListPerMonth = new List<String>();
                                //Group Payment Records By Payment Type using the following Logic(Map).
                                Map<String, MyCompWebService.Payments> paymentTypeAndPaymentListMap = new Map<String, MyCompWebService.Payments>();
                                for(MyCompWebService.Payments paymentTemp : paymentListByMonth)
                                {
                                    paymentTypeListPerMonth.add(paymentTemp.description);
                                    //The assumption here is, There won't be any duplicate Payment Types for a  Duplicate Payment Month.Sample Duplicate Month datas are given below.
                                    /*
                                        PaymentMonth    PaymentType         PaymentAmount 
                                        MAY 2012        COMMISSION          0 
                                        APR 2012        COMMISSION          48027.18 
                                        APR 2012        COMMISSION-M07 1H   1357.69 
                                        APR 2012        COMMISSION-M08 1H   0 
                                    */
                                    paymentTypeAndPaymentListMap.put(paymentTemp.description, paymentTemp);
                                }
                                //Sort "Payment Types" by Ascending order.
                                paymentTypeListPerMonth.sort();
                                //Iterate all payment records using "sorted' Payment types. Finally insert them into 'paymentsResponse" variable. 
                                //sort "Payment Types" by descending Order.
                                for(Integer i=paymentTypeListPerMonth.size()-1; i>=0; i--)
                                {
                                    paymentsResponse.add(paymentTypeAndPaymentListMap.get(paymentTypeListPerMonth.get(i)));
                                }
                            }
                        }
                    }
                }
            }
        }
        catch(Exception e)
        {
            System.Debug('PALM Payments Exception Message : '+e.getMessage());
            throw e;
        }
    }
    
    public PageReference showOverallPerformanceFrame()
    {
        try
        {
            if(selectedComponent != null && selectedComponent.size() <= MAX_NO_ALLOWED_PERFORMANCE_FRAME)
            {
                showCalloutLimitError = false;
                calloutLimitError = '';
                
                System.Debug('selectedComponent : '+selectedComponent);
                if(overallperformanceList == null)
            
                    overallperformanceList = new List<String>();
                else
                    overallperformanceList.clear();
                
                if(selectedComponent != null)
                {
                    for(String componentName : selectedComponent)
                    {
                        String PALMHistoryImageBlobValue = getPALMHistoryImage_BlobValue(employeenumber, componentName, selectedFiscalYear);
                        
                        if(PALMHistoryImageBlobValue != null && PALMHistoryImageBlobValue != '')
                        overallperformanceList.add(PALMHistoryImageBlobValue);
                    }
                }
                
                System.Debug('overallperformanceList : '+overallperformanceList);
            }
            else
            {
                showCalloutLimitError = true;
                calloutLimitError = 'You cannot select more than 6 components, please unselect your options';   
            }
        }
        catch(Exception e)
        {
            System.Debug('showOverallPerformanceFrame Exception : '+e.getMessage());
            throw e;
        }
        return null;
  }
  
  public String formatFiscalMonth(String fiscalMonthStr)
  {
    try
    {
        if(fiscalMonthStr != null && fiscalMonthStr != '' && fiscalMonthStr.length() == 6)
        {
                integer monthint = integer.valueOf(fiscalMonthStr.substring(4,6));
                String monthStr = monthMap.get(fiscalMonthStr.substring(4,6));
               
                String year = fiscalMonthStr.substring(0,4);
                try
                {
                integer yearint = integer.valueOf(year);
                system.debug('yearint=' +yearint);
                if(monthint < 3)
                {
                        yearint = yearint-1;
                        fiscalMonthStr = monthStr + ' ' + string.valueOf(yearint);
                        return fiscalMonthStr;
                }
                else
                return fiscalMonthStr = monthStr + ' ' + year;
                }
                catch(Exception e)
                {
                  fiscalMonthStr = monthStr + ' ' + year;
                }       
        }
    }
    catch(Exception e)
    {
        throw e;
    }
    return fiscalMonthStr;
  }
  public PageReference showPasswordSection()
  {
    showPasswordTextBox = true;
    return null;
  }
  public PageReference showEmployeeIdSection()
  {
    if(password == '78728')
    {
        showPasswordTextBox = false;
        employeenumber = '';
        showEmployeeIdTextBox = true;
        invalidPasswordMessage = '';
    }
    else
    {
        showEmployeeIdTextBox = false;
        invalidPasswordMessage = 'Password is Invalid';
        return null;
    }
    
    
    return null;
  }
 
}