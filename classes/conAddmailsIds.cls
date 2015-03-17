/*
* This class queries the ED for contact
*/
global class conAddmailsIds{
    public static String testResponse = 'message';
    
    public String  emailToAdd{get;set;}
    public String toMailIds{get;set;}
    public String ccMailIds{get;set;}
    public String bccMailIds{get;set;}
    public List<EmployeeBean> searchResults {get;set;}
    public string searchText {get;set;}
    public List<SelectOption> Items{get;set;}
    public String selectId{ get;set; }
    public string searchCountry {get;set;}
    public string searchBG {get;set;}
    public string selectCountry {get;set;}
    public string selectBG {get;set;}
    public Boolean displayPopup {get;set;}
    public Account_Plan__c RelSuite;
    public String retURL {get;set;}
    public String errorMessage{get;set;}    
    public Integer PageNext {get; set;}
    public Integer PageUntil {get; set;}
    public Integer pageNumber {get;set;}
    public  Decimal pgNO{get;set;}
    public Integer NoPage{get;set;}    
    public EmployeeBean empDetails{get;set;} 
    public String action {get;  set;}    
    public ID AccId; 
    //List of attributes which is displayed
    public class EmployeeBean{
    public String fullName{get;set;}
    public String cn{get;set;}
    public String sn{get;set;}
    public String lastName{get;set;}
    public String givenName{get;set;}
    public String ntUserDomainId{get;set;}
    public String employeeNumber{get;set;}
    public String telephoneNumber{get;set;}
    public String mail{get;set;}
    public String hpPayrollCountryCode{get;set;}
    public String hpLegalName{get;set;}
    public String city{get;set;}
    public String state{get;set;}
    public String postalCode{get;set;}
    public String country{get;set;}
    public String hpSourceCompany{get;set;}
    public String street{get;set;}
    public String manager{get;set;}
    public String hpBusinessGroup{get;set;}
    public String hpBusinessRegion{get;set;}
    public String organisation{get;set;}
    public String hpBusinessUnit{get;set;}
    public String facsimileTelephoneNumber{get;set;}
    public String mobile{get;set;}
    public String hpAdmin{get;set;}
    public String postalAddress{get;set;}
    public String managerEmployeeNumber{get;set;}
    public boolean selected{get;set;}
    public String o{get;set;}  
    public String l{get;set;}         
    public String hpLocationCode{get;set;}
    }
    public conAddmailsIds(){
        action = ApexPages.currentPage().getParameters().get('action');        
    }
   public void conAddmailsIds(){
        listEmp.clear();
        numberList.clear();
        searchResults.clear();
    }    
     
    public conAddmailsIds(ApexPages.StandardController controller) {
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        this.RelSuite = (Account_Plan__c)controller.getRecord(); 
    }
        
    public String getReqURL(){
        return ApexPages.currentPage().getParameters().get('reqURL');
    }
     //closes the popup
    public void closePopup() {
        displayPopup = false;    
    }
    //selection list displyed
    public List<SelectOption> getautoRun(){
        Items = new List<SelectOption>();
        Items.add(new selectOption('givenName', 'First Name'));
        Items.add(new selectOption('sn', 'Last Name'));
        Items.add(new selectOption('cn', 'First Name Last Name'));
        return items;
    }
    //add the selected email ids to the URL
    public Pagereference conAddEmailsIds(){
        String urlToEmail=getReqURL();
        if(action != '' && action != null){
            urlToEmail = urlToEmail + '&action='+action;
        }
        if(toMailIds != null){
            urlToEmail=urlToEmail+'&p24='+toMailIds;
        }
        if(ccMailIds != null){
            urlToEmail=urlToEmail+'&p4='+ccMailIds;
        }
        if(bccMailIds != null){
            urlToEmail=urlToEmail+'&p5='+bccMailIds;
        }       
        PageReference p = new PageReference(urlToEmail);
        p.setRedirect(true);
        return p;      
    }
    //collects the additional to email ids
    public Pagereference addToList(){
        for(EmployeeBean empB: searchResults){
            if(empB.selected == true){
                if(toMailIds== null){
                    toMailIds = empB.mail;
                }
                else{
                    toMailIds=toMailIds+';'+empB.mail;
                }
                empB.selected = false;
            }
        }
        return null;
    }  
    //collects the cc email ids  
    public Pagereference addCCList(){
        for(EmployeeBean empB: searchResults){
            if(empB.selected == true){
                if(ccMailIds== null){
                    ccMailIds = empB.mail;
                }
                else{
                    ccMailIds=ccMailIds+';'+empB.mail;
                }
                empB.selected = false;
            }
        }
        return null;
    }
    //collects the bcc email ids
    public Pagereference addBCCList(){
        for(EmployeeBean empB: searchResults){
            if(empB.selected == true){
                if(bccMailIds== null){
                    bccMailIds = empB.mail;
                }
                else{
                    bccMailIds=bccMailIds+';'+empB.mail;
                }
                empB.selected = false;
            }
        }
        return null;
    }
   
    //queryies for hierarchy details from ED
    public List<EmployeeBean> getEmpHierarchyData(){
        String userId = UserInfo.getUserId();
        List<User> empId = [SELECT Legacy_Employee_Ref__c, id FROM User where id = :userId];
        // creating soap request    
        String empNo = empId[0].Legacy_Employee_Ref__c;
        System.debug('Emp Id............'+empNo);
        // Fetch userName and password for Exstream from TibcoSecurity__c - START
        String xml = tibcoCallout(empNo,'hierarchy');
            
        // reading response    
        conAddmailsIds demo = new conAddmailsIds();   
        String resultString = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'+
                                '<SOAP-ENV:Body>'+
                                    '<ns0:EDResponse xmlns:ns0="http://www.tibco.com/schemas/EDInterface/BusinessUseCases/SharedResources/Schemas/EDOutPut">'+
                                        '<ns0:Message>{ravi.raju@dec.com, ravi, sekhar, 33825245, 21794877, +917406077775}</ns0:Message>'+
                                        '<ns0:Message>{prakash.raju@dec.com, Somalraju, Prakash, 33825116, 21794811, +917406092055}</ns0:Message>'+
                         
                                    '</ns0:EDResponse>'+
                                '</SOAP-ENV:Body>'+
                            '</SOAP-ENV:Envelope>';
                
        XMLDom dom = new XMLDom(xml);
        List<XMLDom.Element> emList = dom.getElementsByTagName('Message');
        List<EmployeeBean> listEmp=new List<EmployeeBean>();
        for ( Integer iter=0; ( iter<emList.size() && iter<50 ) ; iter++){
            EmployeeBean empData = new EmployeeBean();     
            Map<String, String> kv = new Map<String, String>();
            XMLDom.Element em = emList.get(iter);
            String values = em.nodeValue;
            String strValues = values.substring(0,values.length());
            String[] namevalues=strValues.split('\\|\\|');
            if(!namevalues[0].equalsIgnoreCase('#null')){
                kv.put('cn',namevalues[0]);
            }else{
                kv.put('cn','');
            }
            if(!namevalues[2].equalsIgnoreCase('#null')){
                kv.put('mail',namevalues[2]);
            }else{
                kv.put('mail','');
            }
            if(!namevalues[1].equalsIgnoreCase('#null')){
                kv.put('employeeNumber',namevalues[1]);
            }else{
                kv.put('employeeNumber','');
            }
            if(!namevalues[3].equalsIgnoreCase('#null')){
                kv.put('managerEmployeeNumber',namevalues[3]);
            }else{
                kv.put('managerEmployeeNumber','');
            }
            empData.mail =  kv.get('mail');
            empData.cn=  kv.get('cn');
            empData.employeeNumber =  kv.get('employeeNumber');
            empData.managerEmployeeNumber = kv.get('managerEmployeeNumber');
            listEmp.add(empData);
        }
        searchResults = listEmp;  
        return listEmp;   
    }
    //creates a http request to send to TIBCO
    public static DOM.Document createRequest(String empNo, String reqType, String tibcoUsername, String tibcoPassword){    
        DOM.Document docRequest = new DOM.Document();        
        String soapNS = Label.SOAP_HEADER_NS;   //'http://schemas.xmlsoap.org/soap/envelope/';
        String xsd = Label.XML_SCHEMA_NS; //'http://www.w3.org/2001/XMLSchema';
        String wsse = Label.WSSE_SECURITY_NS ; //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
        String wsu = Label.WSSE_UTILITY_NS; //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';
        String type = Label.WSSE_PASSWORD_TYPE;   //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest';
        String encodingType = Label.WSSE_ENCODING_TYPE; //'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soapmessage-security-1.0#Base64Binary';
        String sfdc = Label.Exstream_TibcoSchema ; 
        String ed = Label.ApttusToEdSchema; //'http://www.tibco.com/schemas/EDInterface/BusinessUseCases/SharedResources/Schemas/ED';       
        dom.XmlNode envelope= docRequest.createRootElement('Envelope', soapNS, 'soapenv');
        envelope.setNamespace('ed',ed);    
        dom.XmlNode header= envelope.addChildElement('Header', soapNS, null);
        dom.XmlNode security = header.addChildElement('Security', wsse, 'wsse');
        security.setAttributeNs('soapenv:mustUnderstand','1',null,null);                   
        security.setNamespace('wsu',wsu);                    
        dom.XmlNode usernameToken = security.addChildElement('UsernameToken', wsse, 'wsse');  
        usernameToken.setAttributeNs('wsu:Id','UsernameToken-5',null,null);                
        DateTime d = System.now();
        String createdStr = d.formatGmt('yyyy-MM-dd HH:mm:ss.SSSSSS');
        String nonceStr = String.valueOf(Crypto.getRandomInteger());                           
        Blob passBlob= Blob.valueOf(nonceStr+ createdStr+ tibcoPassword);
        String passwordStr = EncodingUtil.base64Encode(Crypto.generateDigest('SHA1',passBlob));
        Blob nonceBlob = Blob.valueOf(nonceStr);
        nonceStr=EncodingUtil.base64Encode(nonceBlob);                
        dom.XmlNode userName = usernameToken.addChildElement('Username', wsse, 'wsse');
        userName.addTextNode(tibcoUsername);
        dom.XmlNode password= usernameToken.addChildElement('Password', wsse, 'wsse');
        password.setAttribute('Type',type);
        password.addTextNode(passwordStr);
        dom.XmlNode nonce= usernameToken.addChildElement('Nonce', wsse, 'wsse');
        nonce.setAttribute('EncodingType', encodingType);
        nonce.addTextNode(nonceStr);
        dom.XmlNode created = usernameToken.addChildElement('Created', wsu, 'wsu');
        created.addTextNode(createdStr);
        dom.XmlNode body= envelope.addChildElement('Body', soapNS, null);            
        dom.XmlNode eleInput= body.addChildElement('ED', ed, null);                                      
        if(reqType.equals('Search')){
            dom.XmlNode Salesforce_id
                = eleInput.addChildElement('EMPID', ed, null);
            Salesforce_id.addTextNode(empNo);
            dom.XmlNode request_Type = eleInput.addChildElement('RequestType',ed, null);
            request_Type.addTextNode('Search');
        }else{
            dom.XmlNode Salesforce_id
                = eleInput.addChildElement('EMPID', ed, null);
            Salesforce_id.addTextNode('20131966');//00647066 
            
            dom.XmlNode request_Type = eleInput.addChildElement('RequestType',ed, null);
            request_Type.addTextNode('Hierarchy');
        }                              
        return docRequest;  
    }
    //Number of pages    
    List<Integer> numberList=new List<Integer>();
    public List<Integer> getnumberList(){
        return numberList;
    }
    
    Integer next = 200;
    Decimal countint = 200;
    public boolean shownext, showprev = false;
    Integer copydownlimit;
    public List<EmployeeBean> listEmp=new List<EmployeeBean>();
    //queryies for employee record from ED
    public PageReference getAllEmployees(){  
            try{ 
            numberList.clear();   
            if((searchText== null || searchText == '')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter search criteria'));              
            }else if((searchText != null || searchText != '') && (searchText.trim().isNumeric() == true || searchText.trim().isAlphaSpace() == false)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Enter valid Name.'));              
            }else if((searchText != null || searchText != '') && searchText.isAlphaSpace()){ 
            String[] compositeKey = selectId.split(',');
            String[] compositeValue = searchText.split(',');   
            String compo = null;               
            compo = selectId+'||'+searchText;                
            if(compo <> null){
                                
                String xml = tibcoCallout(compo,'Search');                
                XMLDom dom = new XMLDom(xml);
                XMLDom.Element emStatus = dom.getElementByTagName('status');
                String statusvalues = emStatus.nodeValue;
                if(statusvalues.equalsIgnoreCase('false')){
                    // if status is false then appropriate error message in displayed
                    if(dom.getElementByTagName('LogMessage')<> null){
                        // display error mesg when TIBCO throws an exception. It is assumed that list is too high from ED
                        XMLDom.Element emLogMsg = dom.getElementByTagName('LogMessage');
                        String lgmsg = emLogMsg.nodeValue;
                        if(lgmsg <> null){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please refine your search and try again to get the filtered results.'));
                        }
                    }else{
                        //when ED is down
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please retry after sometime, could not connect to Enterprise Directory.'));
                    }
                }else if(statusvalues.equalsIgnoreCase('true')){                    
                    List<XMLDom.Element> emList = dom.getElementsByTagName('Message');
                    listEmp = new List<EmployeeBean>();
                    if(emlist.size() == 0 ||emlist == null){
                        // when no value is returned from ED
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No Record Found.'));
                    }else if(emlist.size()<1000){
                        for ( Integer iter=0; ( iter<emList.size()) ; iter++){                     
                            EmployeeBean empData = new EmployeeBean();     
                            Map<String, String> kv = new Map<String, String>();
                            XMLDom.Element em = emList.get(iter);
                            String values = em.nodeValue;
                            String strValues = values.substring(0,values.length());
                            //break the response based on ||
                            String[] namevalues=strValues.split('\\|\\|'); 
                            //assign the values to respective attributes
                            if(!namevalues[0].equalsIgnoreCase('#null')){
                                kv.put('fullName',namevalues[0]);
                            }else{
                                kv.put('fullName','');
                            }
                            if(!namevalues[10].equalsIgnoreCase('#null')){
                                kv.put('city',namevalues[10]);
                            }else{
                                kv.put('city','');
                            }
                            if(!namevalues[21].equalsIgnoreCase('#null')){
                                kv.put('telephoneNumber',namevalues[21]);
                            }else{
                                kv.put('telephoneNumber','');
                            }
                            if(!namevalues[5].equalsIgnoreCase('#null')){
                                kv.put('mail',namevalues[5]);
                            }else{
                                kv.put('mail','');
                            }
                            if(!namevalues[19].equalsIgnoreCase('#null')){
                                kv.put('organisation',namevalues[19]);
                            }else{
                                kv.put('organisation','');
                            }
                            if(!namevalues[16].equalsIgnoreCase('#null')){
                                String [] managerAr = namevalues[16].split(',');
                                String managerEID = managerAr[0].substringAfterLast('=');
                                kv.put('manager',managerEID);
                            }else{
                                kv.put('manager','');
                            }
                            if(!namevalues[6].equalsIgnoreCase('#null')){
                                kv.put('hpPayrollCountryCode',namevalues[6]);
                            }else{
                                kv.put('hpPayrollCountryCode','');
                            }
                            
                            empData.fullName =  kv.get('fullName'); 
                            empData.city =  kv.get('city'); 
                            empData.hpPayrollCountryCode =  kv.get('hpPayrollCountryCode'); 
                            empData.telephoneNumber =  kv.get('telephoneNumber');
                            empData.mail =  kv.get('mail');
                            empData.organisation =  kv.get('organisation'); 
                            empData.manager =  kv.get('manager');
                            
                            listEmp.add(empData);
                        }
                    }else{
                        //when the list from ED is larger then 1000
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Please refine your search and try again to get the filtered results'));
                    }
                    searchResults = new List<EmployeeBean>();
                    if(listEmp != null && listEmp.size()>countint){
                        //add first 200 records for 1st page
                        for(Integer i=0; i<countint; i++){
                            searchResults.add(listEmp.get(i));
                        }
                        pgNO = Math.ceil(listEmp.size()/countint);
                        for(Integer i=0; i<pgNO; i++){
                            numberList.add(i+1);
                        }
                        shownext = true;
                        pageNumber = 1;
                        PageUntil = (Integer)countint;
                        NoPage = numberList.size();
                    }else{
                        //if list is less then 200 add to disply list
                        integer ii=listEmp.size();
                        for(integer i=0;i<listEmp.size();i++) {                 
                            numberList.add(ii+i);
                            searchResults.add(listEmp.get(i));                  
                        }
                        pageNumber = 1;
                        NoPage = 1;
                        shownext = false;
                        showprev = false;
                        PageUntil = listEmp.size();
                    }
                    //set the page number
                    if(listEmp.size() >0){
                        PageNext = 1;
                    }else{
                        PageNext = 0;
                    }
                    copydownlimit = 0;  
                }
            }
        }
            return null;
        }catch(System.XmlException xe){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please retry after sometime, could not connect to Enterprise Directory.'));   
            return null;
        }catch(CalloutException ce){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please retry after sometime, could not connect to Enterprise Directory.'));   
            return null;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please retry after sometime, could not connect to Enterprise Directory.'));   
            return null;           
        }  
    }
   
    //Paging methods Next() and Prev()
    public void nextpg(){
        try{
            copydownlimit += (Integer)countint;
            showprev = true;
            searchResults.clear();
            Integer limit1 = 0;
            if(next+countint < listEmp.size()){
                limit1 = next+(Integer)countint;
            }
            else{
                limit1 = listEmp.size();
                shownext = false;
            }
            PageNext = next;
            PageUntil = limit1;
            if (pageNumber <5 ){
                pageNumber = pageNumber+1;
            }
            for(Integer i=next; i<limit1; i++){
                searchResults.add(listEmp[i]);
            }           
            Next+=(Integer)countint;
        }catch(Exception e){
            system.debug('Exception :'+e);}
    }
    
    public void Prevpg(){
        try{
            shownext = true;
            copydownlimit -=(Integer)countint;
            searchResults.clear();
            Integer limit1 = 0;
            if(next-((Integer)countint+(Integer)countint) > 0)
                limit1 = next-(Integer)countint;
            else{
                limit1 = next-(Integer)countint;
                showprev = false;
            }
            PageNext = next-((Integer)countint+(Integer)countint);
            if (PageNext == 0){PageNext = 1;}
            PageUntil = limit1;
            for(Integer i=next-((Integer)countint+(Integer)countint); i<limit1; i++){ 
                searchResults.add(listEmp.get(i));
            }
            Next-=(Integer)countint;
            if(pageNumber > 1){
                pageNumber = pageNumber - 1 ;
            }
        }catch(Exception e){
            system.debug('Exception :'+e);}
    }
    
    public boolean getshownext(){return shownext;}
    public boolean getshowprev(){return showprev;}
    //display all the details of a particular employee
    public PageReference getEmployeesDetails(){  
        try{      
            String[] compositeKey = selectId.split(',');
            String[] compositeValue = searchText.split(','); 
            displayPopup = true;
            String detName = ApexPages.currentPage().getParameters().get('detName');
            System.debug('Param value passed is @@@@@ '+detName);  
            String compo = 'mail||'+detName;
            // DOM.Document doc = createSearchRequest(selectId,searchText) ; 
            // Fetch userName and password for Exstream from TibcoSecurity__c - START
            String xml = tibcoCallout(compo,'Search');
            XMLDom dom = new XMLDom(xml);
            List<XMLDom.Element> emList = dom.getElementsByTagName('Message');
            for ( Integer iter=0; ( iter<emList.size() && iter<10 ) ; iter++){ 
                empDetails = new EmployeeBean();     
                Map<String, String> kv = new Map<String, String>();
                XMLDom.Element em = emList.get(iter);
                String values = em.nodeValue;
                String strValues = values.substring(0,values.length());             
                String[] namevalues=strValues.split('\\|\\|'); 
                if(!namevalues[0].equalsIgnoreCase('#null')){
                    kv.put('fullName',namevalues[0]);
                }else{
                    kv.put('fullName','');
                }
                if(!namevalues[1].equalsIgnoreCase('#null')){
                    kv.put('lastName',namevalues[1]);
                }else{
                    kv.put('lastName','');
                }
                if(!namevalues[2].equalsIgnoreCase('#null')){
                    kv.put('givenName',namevalues[2]);
                }else{
                    kv.put('givenName','');
                }
                if(!namevalues[3].equalsIgnoreCase('#null')){
                    kv.put('ntUserDomainId',namevalues[3]);
                }else{
                    kv.put('ntUserDomainId','');
                }
                if(!namevalues[4].equalsIgnoreCase('#null')){
                    kv.put('employeeNumber',namevalues[4]);
                }else{
                    kv.put('employeeNumber','');
                }
                if(!namevalues[5].equalsIgnoreCase('#null')){
                    kv.put('mail',namevalues[5]);
                }else{
                    kv.put('mail','');
                }
                if(!namevalues[6].equalsIgnoreCase('#null')){
                    kv.put('hpPayrollCountryCode',namevalues[6]);
                }else{
                    kv.put('hpPayrollCountryCode','');
                }
                if(!namevalues[7].equalsIgnoreCase('#null')){
                    kv.put('hpLegalName',namevalues[7]);
                }else{
                    kv.put('hpLegalName','');
                }
                if(!namevalues[8].equalsIgnoreCase('#null')){
                    kv.put('hpLocationCode',namevalues[8]);
                }else{
                    kv.put('hpLocationCode','');
                }
                if(!namevalues[9].equalsIgnoreCase('#null')){
                    kv.put('managerEmployeeNumber',namevalues[9]);
                }else{
                    kv.put('managerEmployeeNumber','');
                }
                if(!namevalues[10].equalsIgnoreCase('#null')){
                    kv.put('city',namevalues[10]);
                }else{
                    kv.put('city','');
                }
                if(!namevalues[11].equalsIgnoreCase('#null')){
                    kv.put('state',namevalues[11]);
                }else{
                    kv.put('state','');
                }
                if(!namevalues[12].equalsIgnoreCase('#null')){
                    kv.put('postalCode',namevalues[12]);
                }else{
                kv.put('postalCode','');
                }
                if(!namevalues[13].equalsIgnoreCase('#null')){
                kv.put('country',namevalues[13]);
                }else{
                    kv.put('country','');
                }
                if(!namevalues[14].equalsIgnoreCase('#null')){
                    kv.put('hpSourceCompany',namevalues[14]);
                }else{
                    kv.put('hpSourceCompany','');
                }
                if(!namevalues[15].equalsIgnoreCase('#null')){
                    kv.put('street',namevalues[15]);
                }else{
                    kv.put('street','');
                }
                if(!namevalues[16].equalsIgnoreCase('#null')){
                    String [] managerAr = namevalues[16].split(',');
                    String managerEID = managerAr[0].substringAfterLast('=');
                    kv.put('manager',managerEID);
                }else{
                    kv.put('manager','');
                }
                if(!namevalues[17].equalsIgnoreCase('#null')){
                    kv.put('hpBusinessGroup',namevalues[17]);
                }else{
                    kv.put('hpBusinessGroup','');
                }
                if(!namevalues[18].equalsIgnoreCase('#null')){
                    kv.put('hpBusinessRegion',namevalues[18]);
                }else{
                    kv.put('hpBusinessRegion','');
                }
                if(!namevalues[19].equalsIgnoreCase('#null')){
                    kv.put('organisation',namevalues[19]);
                }else{
                    kv.put('organisation','');
                }
                if(!namevalues[20].equalsIgnoreCase('#null')){
                    kv.put('hpBusinessUnit',namevalues[20]);
                }else{
                    kv.put('hpBusinessUnit','');
                }
                if(!namevalues[21].equalsIgnoreCase('#null')){
                    kv.put('telephoneNumber',namevalues[21]);
                }else{
                    kv.put('telephoneNumber','');
                }
                if(!namevalues[22].equalsIgnoreCase('#null')){
                    kv.put('facsimileTelephoneNumber',namevalues[22]);
                }else{
                    kv.put('facsimileTelephoneNumber','');
                }
                if(!namevalues[23].equalsIgnoreCase('#null')){
                    kv.put('mobile',namevalues[23]);
                }else{
                    kv.put('mobile','');
                }
                if(!namevalues[24].equalsIgnoreCase('#null')){
                    kv.put('hpAdmin',namevalues[24]);
                }else{
                    kv.put('hpAdmin','');
                }
                if(!namevalues[25].equalsIgnoreCase('#null')){
                    kv.put('postalAddress',namevalues[25].replace('$',','));
                }else{
                    kv.put('postalAddress','');
                }            
                empDetails.fullName =  kv.get('fullName'); 
                empDetails.lastName =  kv.get('lastName'); 
                empDetails.givenName =  kv.get('givenName'); 
                empDetails.ntUserDomainId =  kv.get('ntUserDomainId'); 
                empDetails.employeeNumber =  kv.get('employeeNumber'); 
                empDetails.mail =  kv.get('mail'); 
                empDetails.hpPayrollCountryCode =  kv.get('hpPayrollCountryCode'); 
                empDetails.hpLegalName =  kv.get('hpLegalName'); 
                empDetails.hpLocationCode=  kv.get('hpLocationCode'); 
                empDetails.city =  kv.get('city');  
                empDetails.state =  kv.get('state'); 
                empDetails.postalcode=  kv.get('postalCode'); 
                empDetails.country =  kv.get('country'); 
                empDetails.hpSourceCompany =  kv.get('hpSourceCompany'); 
                empDetails.street =  kv.get('street'); 
                empDetails.manager =  kv.get('manager'); 
                empDetails.hpBusinessGroup =  kv.get('hpBusinessGroup'); 
                empDetails.hpBusinessRegion =  kv.get('hpBusinessRegion'); 
                empDetails.organisation =  kv.get('organisation'); 
                empDetails.hpBusinessUnit=  kv.get('hpBusinessUnit'); 
                empDetails.telephoneNumber =  kv.get('telephoneNumber'); 
                empDetails.facsimileTelephoneNumber =  kv.get('facsimileTelephoneNumber'); 
                empDetails.mobile =  kv.get('mobile'); 
                empDetails.hpAdmin =  kv.get('hpAdmin'); 
                empDetails.postalAddress =  kv.get('postalAddress'); 
                return null;
            }
        }catch(Exception e){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error on the page. Please try again.  '+e));   
        return null;           
        }  
        return null;
    }
    
    webservice static string tibcoCallout(String comp, String reqType){
        List<TibcoSecurity__c> lstPwd = [Select t.Name, t.TibcoPassword__c From TibcoSecurity__c t where t.TargetSystemName__c ='ApttusToEd' ];
        String passwordText = '';
        String usernameText = '';
        if(lstPwd.size()==1){
            passwordText = lstPwd[0].TibcoPassword__c;
            usernameText = lstPwd[0].Name;
        }        
             
        DOM.Document doc = createRequest(comp,reqType,usernameText, passwordText) ; 
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        String serviceEndPoint = Label.ED_EndPoint; 
        req.setEndpoint(serviceEndPoint);
        req.setBodyDocument(doc);
        req.setHeader('SOAPAction','/BusinessUseCases/Services/ED');
        req.setTimeout(60000);
        req.setClientCertificateName('SFDC_Certificate');
        Http http = new Http();
        HttpResponse res = new HttpResponse();
        DOM.Document doc1 = new DOM.Document();
        //get the response
        String xml='';
        if(Test.isRunningTest()){
        if(testResponse.equals('message')){
               xml = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'+
                       '<SOAP-ENV:Header/>'+
                        '<SOAP-ENV:Body>'+
                          '<ns0:EDResponse xmlns:ns0="http://www.tibco.com/schemas/EDInterface/BusinessUseCases/SharedResources/Schemas/EDOutPut">'+
                             '<ns0:Message>Prakash Raju Somalraju||Somalraju||Prakash Raju||ASIAPACIFIC:somalrap||21794811||prakash-raju.somalraju@hp.com||IN||#Null||LB007000GV000000||20094479||Bangalore||Karnataka||560100||India||HP||Surya Wave, Sy. No.61(P), Doddathogur Village $ Begur Hobli, Bangalore South Taluk $ Electronic City Phase-II Industrial Area||uid=krishna-mohan.thai@hp.com,ou=People,o=hp.com||Technology and Operations||Worldwide||Development Services||Development Services||#Null||#Null||#Null||#Null||Surya Wave, Sy. No.61(P), Doddathogur Village $ Begur Hobli, Bangalore South Taluk $ Electronic City Phase-II Industrial Area $ Bangalore $ Karnataka $ India $ 560100</ns0:Message>'+
                              '<ns0:Status>True</ns0:Status>'+
                               '<ns0:LogMessage/>'+
                                '</ns0:EDResponse>'+
                                   '</SOAP-ENV:Body>'+
                                    '</SOAP-ENV:Envelope>';
    
        }
        }
        else{
        res = http.send(req);            
        doc1 = res.getBodyDocument();
        String resultBody = res.getBody();
        xml= doc1.toXmlString();
        System.debug('output response :::::::::::::::: '+xml);
        }
        return xml;
    }
    
}