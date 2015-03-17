/**
* Class Name: HPQuoteController 
* Author: HP - Mohit
* Date: 07-Nov-2012 
* Description: Display HP quotes in oppty custom related list 
*/
public without sharing class HPQuoteController {
    
    public class QuoteWrapperClass
    {
      public Boolean isSelected {get;set;}
      public HP_Quote__c oQuoteObj{get;set;}
      public QuoteWrapperClass(HP_Quote__c oQuoteObj, Boolean isSelect)
      {
         this.isSelected=isSelect;
         this.oQuoteObj=oQuoteObj;
        }
    }
    public String sOptyId {get;set;}
    public String viewMode {get;set;}
    public String clickedFrom{get;set;}
    public String selectedIdsForPreviousVersion;
    public Integer sPageSize =5;
    public Boolean isShowAll= false;
    public Boolean isShowMore= false;
    public Boolean isHideClicked = false;
    public Boolean isPreviousVersionClicked {get;set;}
    public Boolean isAlphaSorting = false;
    public String sQueryString='';
    public String sFieldList='Id,Name,Originating_System_Quote_ID__c,AMPID_TS__c,Group_Contract_SW__c,Service_Agreement_Id__c,Originating_System_Quote_Version__c,Quote_Start_Date__c,Quote_End_Date__c,Quote_Status__c,Grand_Total__c,Synced_To_Opportunity__c,Last_Synced_to_Opportunity__c,LastModifiedDate,Quote_IDS_ID__c,Total__c,Total_Cost__c,Contract_Start_Date__c,Term_in_Months__c,Quote_Owner__c,Quote_Detail_URL__c,Originating_System_Quote_Creation_Date__c';
    public String sWhereClause='' ;
    public List<String> listQuoteIDSId;
    public boolean hasPrevious {get{return oQuoteList.getHasPrevious();}set;}
    public boolean hasNext {get{return oQuoteList.getHasNext();}set;}   
    public ApexPages.StandardSetController oQuoteList{get;set;}
    public List<QuoteWrapperClass> oQuoteWrapperList{get;set;}
    public string Alpha{get;set;}
    public User objUser{get;set;}
    public Boolean showSyncButton{get;set;}
    public Boolean showNewQuoteButton{get;set;}
    public String redirectURL{get;set;}
    public opportunity objOpportunity;
    private String sortDirection = 'ASC';
    private String sortExp = 'Id';
    private Map<String,Support_Request_FS_CS__c> sRequestFieldSetCSMap = null;
    public Boolean isCustomSort = false;
    public Boolean isCustomSearch = false;
    public string allowedAMPBGs = System.Label.AMP_AllowedBGs;
    public string allowedGCBGs = System.Label.GC_AllowedBGs;
    public Boolean showBMIQuoteButton{get;set;}
    // Shaijan Thomas 5th March 13 for R5
    public boolean displayPopup {get; set;}
    public boolean isPopup = false;
    public List<QuoteAoGwrapper> AGQuoteList = new List<QuoteAoGwrapper>();
    public List<HP_Quote__c> oSearchList = new List<HP_Quote__c>();
    public Map<string, HP_Quote__c> oSearchListMap = new Map<string,HP_Quote__c>();
    public integer ampsPageSize = 5;
    public string Searchorder{get; set;}
    public string[] CheckedAGIds = new String[]{};
    public string[] SearchQNValue = new String[]{};
    public string[] SearchGCValue = new String[]{};
    public string[] SearchAMValue = new String[]{};
    public Boolean isQuoteName{get;set;}
    public Boolean isAMPID{get;set;}
    public Boolean isGroupContract{get;set;}
    public Boolean isClearAll{get;set;}
    public string retAmp{get; set;}
    public string retGC{get; set;}
    public string retQN{get; set;}
    public string retAMPLabel{get; set;}
    public string retQNLabel{get; set;}
    public string retGCPLabel{get; set;}
    public string SearchRetSring{get; set;}
    public string AMSearchRetSring{get; set;}
    public string QNSearchRetSring{get; set;}
    public string GCSearchRetSring{get; set;}
    String typeOfQuote = '';
    public Boolean isQuoteCheckAll{get;set;}
    private integer counter=0;
    public integer total_size;
    public Boolean isPagination {get; set;}   
    
    public PageReference Beginning() {
        counter = 0;
        total_size= 5;
        IntiateQuoteList();
        return null;
    }
    public PageReference Previous() {
        counter -= sPageSize;
        IntiateQuoteList();
        return null;
    }
    public PageReference End() {
        counter = total_size - math.mod(total_size, sPageSize);
        IntiateQuoteList();
        return null;
    }
    public PageReference Next() {
        counter += sPageSize;
        IntiateQuoteList();
       return null;
    }
    public Boolean getDisablePrevious() { 
      if (counter>0) return false; 
      else 
      return true;
    }
    public Boolean getDisableNext() { 
      if (counter + sPageSize < total_size) 
      return false; 
      else return true;
    }
    public Integer getTotal_size() {
      return total_size;
    }
    public Integer getPageNumber() {
      return counter/sPageSize + 1;
    }
    public Integer getTotalPages() {
      if (math.mod(total_size, sPageSize) > 0) 
          {
             return total_size/sPageSize + 1;
          } 
      else 
          {
             return (total_size/sPageSize);
          }
       }
    public String gettypeOfQuote() {
        return typeOfQuote;
    }   
    public void settypeOfQuote(String typeOfQuote) {
        this.typeOfQuote = typeOfQuote;
    }
    public void ClearAllFilters()
    {
        isClearAll = true;
        retAMPLabel = 'AMP ID';
        retGCPLabel='Group Contract';
        retQNLabel='Functional Location';
        Searchorder ='b';
        CheckedAGIds.clear();
        SearchQNValue.clear();
        SearchGCValue.clear();
        SearchAMValue.clear();
        retAmp=null;
        retGC=null;
        retQN=null;
        isQuoteCheckAll = false;
        SearchRetSring = null;
        IntiateQuoteList();
    }
    public void showQN() 
    {
        ampsPageSize = 5;
        isQuoteName = true;
        isAMPID = false; 
        isGroupContract=false;
        displayPopUp = true;
        //getAmpORGroupValues();
    }  
    public void showAMPID() 
    {
        ampsPageSize = 5;
        isQuoteName = false;
        isAMPID = true; 
        isGroupContract=false; 
        displayPopUp = true;
        //getAmpORGroupValues();
    } 
    public void showGC() 
    { 
        ampsPageSize = 5;
        displayPopUp = true;
        isQuoteName = false;
        isAMPID = false; 
        isGroupContract=true;
        //getAmpORGroupValues();
    }  
    public void closePopup() 
    { 
                try
                {
                    integer i = 0; 
                    string tempStr; 
                    boolean selectedFlag = false;
                    isQuoteCheckAll = true; 
                    displayPopup = false;
                    SearchRetSring = null; 
                    AMSearchRetSring = null; 
                    QNSearchRetSring = null; 
                    GCSearchRetSring = null;
                    Set <string> setOfAmporGroupId = new set <string>();
                    if(!CheckedAGIds.isEmpty()) 
                        isPopup = true;   
                    if (isAMPID && !SearchAMValue.isEmpty()) 
                        SearchAMValue.Clear();
                    if (isGroupContract && !SearchGCValue.isEmpty()) 
                        SearchGCValue.Clear();
                    if (isQuoteName && !SearchQNValue.isEmpty()) 
                        SearchQNValue.Clear();
                    if (isAMPID && retAmp!=null) 
                        retAmp = null;
                    if (isGroupContract && retGC!=null) 
                        retGC = null;
                    if (isQuoteName && retQN!=null) 
                        retQN = null;   
                if(isShowMore != true && isCustomSort != true)
                {
                    isPopup = true;
                    for(integer j = CheckedAGIds.size()-1;j>=0;j=j-1)
                        if ((isAMPID && CheckedAGIds[j].substring(0, 3)=='AMP') || (isQuoteName && CheckedAGIds[j].substring(0, 3)=='QUN') || (isGroupContract && CheckedAGIds[j].substring(0, 3)=='GRC'))
                                CheckedAGIds.remove(j);
                }
                for(QuoteAoGwrapper AGQwrapper : AGQuoteList) 
                { 
                    if(AGQwrapper.selected == true)
                    { 
                        selectedFlag = true;
                        if (isAMPID)
                        {
                            tempStr = AGQwrapper.AG.AMPID_TS__c;
                            if (tempStr == null || tempStr == '')
                            {
                                SearchAMValue.add(''); 
                                CheckedAGIds.add('AMP');
                            }
                            else if(setOfAmporGroupId.add(tempStr.toUpperCase()))
                            {
                                CheckedAGIds.add('AMP'+tempStr); 
                                SearchAMValue.add(tempStr);
                            }
                            retAmp = retAmp + tempStr + ', ';
                        }
                        if (isGroupContract)
                        {
                            tempStr = AGQwrapper.AG.Group_Contract_SW__c;
                            if (tempStr== null || tempStr == '')
                            {
                                SearchGCValue.add(''); 
                                CheckedAGIds.add('GRC');
                            }
                            else if(setOfAmporGroupId.add(tempStr.toUpperCase()))
                            {
                                SearchGCValue.add(tempStr); 
                                CheckedAGIds.add('GRC'+tempStr);
                            }
                            retGC = retGC + tempStr + ', ';   
                        }
                        if (isQuoteName)
                        {
                            tempStr = AGQwrapper.AG.Name;
                            if (tempStr == null || tempStr == '')
                            {
                                SearchQNValue.add(''); 
                                CheckedAGIds.add('QUN');
                            }
                            else if(setOfAmporGroupId.add(tempStr.toUpperCase()))
                            {
                                SearchQNValue.add(tempStr); 
                                CheckedAGIds.add('QUN'+tempStr);
                            }
                            retQN = retQN + tempStr+ ', ';   
                        }
                    }
                }
                if (Searchorder.length()<=12)
                {
                    if (isQuoteName && Searchorder=='b' && (!Searchorder.contains('QUN:'))) 
                        Searchorder = 'QUN:';
                    else if (isQuoteName && (!Searchorder.contains('QUN:'))) 
                        Searchorder = Searchorder+'QUN:';
            
                    if (isAMPID && Searchorder=='b' && (!Searchorder.contains('AMP:'))) 
                        Searchorder = 'AMP:';
                    else if (isAMPID && (!Searchorder.contains('AMP:'))) 
                        Searchorder = Searchorder+'AMP:';
            
                    if (isGroupContract && Searchorder=='b' && (!Searchorder.contains('GRC:')))  
                        Searchorder = 'GRC:';
                    else if (isGroupContract && (!Searchorder.contains('GRC:'))) 
                        Searchorder = Searchorder + 'GRC:';
                }
                if(!selectedFlag)
                {
                    if (isAMPID) 
                        Searchorder = Searchorder.replace('AMP:','');
                    if (isQuoteName) 
                        Searchorder = Searchorder.replace('QUN:','');
                    if (isGroupContract) 
                        Searchorder = Searchorder.replace('GRC:','');
                    Searchorder.trim();
                }
                retAMPLabel = 'AMP ID';
                retGCPLabel='Group Contract';
                retQNLabel='Functional Location';
    
                if(Searchorder.lastIndexOf('AMP:')==0) 
                    retAMPLabel = 'AMP ID^1';
                if(Searchorder.lastIndexOf('AMP:')==4) 
                    retAMPLabel = 'AMP ID^2';
                if(Searchorder.lastIndexOf('AMP:')==8) 
                    retAMPLabel = 'AMP ID^3';
    
                if(Searchorder.lastIndexOf('GRC:')==0) 
                    retGCPLabel = 'Group Contract^1';
                if(Searchorder.lastIndexOf('GRC:')==4) 
                    retGCPLabel = 'Group Contract^2';
                if(Searchorder.lastIndexOf('GRC:')==8) 
                    retGCPLabel = 'Group Contract^3';
    
                if(Searchorder.lastIndexOf('QUN:')==0) 
                    retQNLabel = 'Functional Location^1';
                if(Searchorder.lastIndexOf('QUN:')==4) 
                    retQNLabel = 'Functional Location^2';
                if(Searchorder.lastIndexOf('QUN:')==8) 
                    retQNLabel = 'Functional Location^3';
    
                if(Searchorder.length()==0) 
                    Searchorder = 'b';      
                if (retAmp!=null && isAMPID) 
                    retAmp = retAmp.substring(4,retAmp.length()-2);
                if(retGC!=null && isGroupContract) 
                    retGC = retGC.substring(4,retGC.length()-2);
                if(retQN!=null && isQuoteName) 
                    retQN = retQN.substring(4,retQN.length()-2);
                if(retQNLabel=='Functional Location' && retAMPLabel == 'AMP ID' && retGCPLabel=='Group Contract')
                    isQuoteCheckAll = false;
                for (i=0;i<CheckedAGIds.size();i++) 
                    SearchRetSring = SearchRetSring + CheckedAGIds[i]+':';
                if(SearchRetSring != null) 
                    SearchRetSring = SearchRetSring.substring(4, SearchRetSring.length()-1);
        
                for (i=0;i<SearchAMValue.size();i++) 
                    AMSearchRetSring = AMSearchRetSring + SearchAMValue[i]+':';
                if(AMSearchRetSring != null) 
                    AMSearchRetSring = AMSearchRetSring.substring(4, AMSearchRetSring.length()-1);
        
                for (i=0;i<SearchGCValue.size();i++)
                    GCSearchRetSring = GCSearchRetSring + SearchGCValue[i]+':';
                if(GCSearchRetSring != null)
                    GCSearchRetSring = GCSearchRetSring.substring(4, GCSearchRetSring.length()-1);
        
                for (i=0;i<SearchQNValue.size();i++) 
                    QNSearchRetSring = QNSearchRetSring + SearchQNValue[i]+':';
                if(QNSearchRetSring != null) 
                    QNSearchRetSring = QNSearchRetSring.substring(4, QNSearchRetSring.length()-1);        
                IntiateQuoteList();
                getHPQuotes();     
        }
        Catch(exception e){ 
            CreateApexErrorLog.insertHandledExceptions(e, null, 'HPQuoteController', 'closePopup', 'Class');
        }   
    }
    public void cancelPopup() { 
        displayPopup = false;    
    }     
    public class QuoteAoGwrapper  
    {  
        public HP_Quote__c AG{get; set;}  
        public Boolean selected {get; set;}   
        public QuoteAoGwrapper(HP_Quote__c a)  
        {  
            AG = a; 
            selected = false; 
        }  
    }
    public List<QuoteAoGwrapper> getAmpORGroupValues()  
    { 
        try{
                boolean flag = true; 
                boolean addflag = false;  
                integer temp = 0;
                integer i; 
                integer j; 
                string tempStr;
                AGQuoteList.clear(); 
                oSearchListMap.Clear();
            if(displayPopUp)//for(HP_Quote__c AGList : oSearchList)
            for(HP_Quote__c AGList : [select AMPID_TS__c,Group_Contract_SW__c,Name from HP_Quote__c where Opportunity_Name__c =:objOpportunity.id and Hide_Record__c=false])
            { 
                flag = true; 
                addflag = false;
                if (Searchorder == 'AMP:')
                {
                    for (i=0;i<SearchAMValue.size();i++)
                    {
                            if (!isAMPID)
                            if((AGList.AMPID_TS__c == SearchAMValue[i]) || (SearchAMValue[i]=='' && AGList.AMPID_TS__c==null))
                            {
                                addflag = true; 
                                break;
                            }
                    }
                }
                else if ((Searchorder == 'AMP:GRC:' || Searchorder == 'AMP:GRC:QUN:') && !isAMPID)
                {
                    for (i=0;i<SearchAMValue.size();i++)
                    {
                        if((AGList.AMPID_TS__c == SearchAMValue[i] || (SearchAMValue[i]=='' && AGList.AMPID_TS__c==null)) && !isGroupContract)
                        {
                            for (j=0;j<SearchGCValue.size();j++)
                            {
                                if((AGList.Group_Contract_SW__c == SearchGCValue[j]) || (SearchGCValue[j]=='' && AGList.Group_Contract_SW__c==null))
                                {
                                    addflag = true; 
                                    break;
                                }
                            }
                        }
                        if(((AGList.AMPID_TS__c == SearchAMValue[i]) || (SearchAMValue[i]=='' && AGList.AMPID_TS__c==null)) && isGroupContract)
                        {
                            addflag = true; 
                            break;
                        }
                    }
                }                           
                else if ((Searchorder == 'AMP:QUN:' || Searchorder == 'AMP:QUN:GRC:') && !isAMPID)
                {
                    for (i=0;i<SearchAMValue.size();i++)
                    {
                        if(((AGList.AMPID_TS__c == SearchAMValue[i]) || (SearchAMValue[i]=='' && AGList.AMPID_TS__c==null)) && !isQuoteName)
                        {
                            for (j=0;j<SearchQNValue.size();j++)
                            {
                                if((AGList.Name == SearchQNValue[j]) || (SearchQNValue[j]=='' && AGList.Name==null))
                                {
                                    addflag = true;  
                                    break;
                                }
                            }
                        }
                        if(((AGList.AMPID_TS__c == SearchAMValue[i]) || (SearchAMValue[i]=='' && AGList.AMPID_TS__c==null)) && isQuoteName)
                        {
                            addflag = true;  
                            break;
                        }
                    }
                }       
                if (Searchorder == 'QUN:')
                {
                    for (i=0;i<SearchQNValue.size();i++)
                    {
                        if (!isQuoteName)
                        if((AGList.Name == SearchQNValue[i]) || (SearchQNValue[i]=='' && AGList.Name==null))
                        {
                            addflag = true; 
                            break;
                        }
                    }
                }
                else if ((Searchorder == 'QUN:AMP:' || Searchorder == 'QUN:AMP:GRC:') && !isQuoteName)
                {
                    for (i=0;i<SearchQNValue.size();i++)
                    {
                        if(((AGList.Name == SearchQNValue[i]) || (SearchQNValue[i]=='' && AGList.Name==null)) && !isAMPID)
                        {
                            for (j=0;j<SearchAMValue.size();j++)
                            {
                                if((AGList.AMPID_TS__c == SearchAMValue[j]) || (SearchAMValue[j]=='' && AGList.AMPID_TS__c==null))
                                {
                                    addflag = true;  
                                    break;
                                }
                            }
                        }
                        if(((AGList.Name == SearchQNValue[i]) || (SearchQNValue[i]=='' && AGList.Name==null)) && isAMPID)
                        {
                            addflag = true;  
                            break;
                        }
                    }
                }                       
                else if ((Searchorder == 'QUN:GRC:' || Searchorder == 'QUN:GRC:AMP:') && !isQuoteName)
                {
                    for (i=0;i<SearchQNValue.size();i++)
                    {
                        if(((AGList.Name == SearchQNValue[i]) || (SearchQNValue[i]=='' && AGList.Name==null)) && !isGroupContract)
                        {
                            for (j=0;j<SearchGCValue.size();j++)
                            {
                                if((AGList.Group_Contract_SW__c== SearchGCValue[j]) || (SearchGCValue[j]=='' && AGList.Group_Contract_SW__c==null))
                                {
                                    addflag = true; 
                                    break;
                                }
                            }
                        }
                        if(((AGList.Name== SearchQNValue[i]) || (SearchQNValue[i]=='' && AGList.Name==null)) && isGroupContract)
                        {
                            addflag = true; 
                            break;
                        }
                    }
                }
                if (Searchorder == 'GRC:')
                {
                    for (i=0;i<SearchGCValue.size();i++)
                    {
                            if (!isGroupContract)
                            if((AGList.Group_Contract_SW__c == SearchGCValue[i]) || (SearchGCValue[i]=='' && AGList.Group_Contract_SW__c==null))
                            {
                                addflag = true; 
                                break;
                            }
                    }
                }
                else if ((Searchorder == 'GRC:QUN:'||Searchorder == 'GRC:QUN:AMP:') && !isGroupContract)
                {
                    for (i=0;i<SearchGCValue.size();i++)
                    {
                        if(((AGList.Group_Contract_SW__c == SearchGCValue[i]) || (SearchGCValue[i]=='' && AGList.Group_Contract_SW__c==null)) && !isQuoteName)
                        {
                            for (j=0;j<SearchQNValue.size();j++)
                            {
                                if((AGList.Name == SearchQNValue[j]) || (SearchQNValue[j]=='' && AGList.Name==null))
                                {
                                    addflag = true; 
                                    break;
                                }
                            }
                        }
                        if(((AGList.Group_Contract_SW__c == SearchGCValue[i]) || (SearchGCValue[i]=='' && AGList.Group_Contract_SW__c==null)) && isQuoteName)
                        {
                            addflag = true; 
                            break;
                        }
                    }
                }                               
                else if ((Searchorder == 'GRC:AMP:' || Searchorder == 'GRC:AMP:QUN:') && !isGroupContract)
                {
                    for (i=0;i<SearchGCValue.size();i++)
                    {
                        if(((AGList.Group_Contract_SW__c == SearchGCValue[i]) || (SearchGCValue[i]=='' && AGList.Group_Contract_SW__c==null)) && !isAMPID)
                        {
                            for (j=0;j<SearchAMValue.size();j++)
                            {
                                if((AGList.AMPID_TS__c == SearchAMValue[j]) || (SearchAMValue[j]=='' && AGList.AMPID_TS__c==null))
                                {
                                    addflag = true; 
                                    break;
                                }
                            }
                        }
                        if(((AGList.Group_Contract_SW__c == SearchGCValue[i]) || (SearchGCValue[i]=='' && AGList.Group_Contract_SW__c==null)) && isAMPID)
                        {
                            addflag = true; break;
                        }
                    }
                }
                if((Searchorder == 'b')||((Searchorder == 'AMP:'||Searchorder == 'AMP:QUN:'||Searchorder == 'AMP:GRC:' ||Searchorder == 'AMP:QUN:GRC:'||Searchorder == 'AMP:GRC:QUN:') && isAMPID))
                    addflag = true; 
                else if((Searchorder == 'b')||((Searchorder == 'GRC:'||Searchorder == 'GRC:QUN:'||Searchorder == 'GRC:AMP:'||Searchorder == 'GRC:QUN:AMP:'||Searchorder == 'GRC:AMP:QUN:') && isGroupContract))
                    addflag = true; 
                else if((Searchorder == 'b')||((Searchorder == 'QUN:'||Searchorder == 'QUN:AMP:'||Searchorder == 'QUN:GRC:'||Searchorder == 'QUN:AMP:GRC:'||Searchorder == 'QUN:GRC:AMP:') && isQuoteName))
                    addflag = true;     
                if (oSearchListMap.size() < ampsPageSize && addflag)
                { 
                        if(isAMPID)
                        {
                                if(AGList.AMPID_TS__c != null && AGList.AMPID_TS__c != '')
                                        AGList.AMPID_TS__c = (AGList.AMPID_TS__c).toUpperCase();
                                        oSearchListMap.put(AGList.AMPID_TS__c,AGList);
                        }
                                if(isGroupContract)
                                {
                                        if(AGList.Group_Contract_SW__c != null && AGList.Group_Contract_SW__c != '')                            
                                        AGList.Group_Contract_SW__c=(AGList.Group_Contract_SW__c).toUpperCase();
                                        oSearchListMap.put(AGList.Group_Contract_SW__c,AGList);
                                }
                                if(isQuoteName)
                                {
                                        if(AGList.Name != null && AGList.Name != '')
                                        AGList.Name = (AGList.Name).toUpperCase();
                                        oSearchListMap.put(AGList.Name,AGList);
                                }
                    temp = temp +1;
                }
            }
            for (string x : oSearchListMap.keySet())
                AGQuoteList.add(new QuoteAoGwrapper(oSearchListMap.get(x)));
        }
        Catch(exception e){ 
            CreateApexErrorLog.insertHandledExceptions(e, null, 'HPQuoteController', 'getAmpORGroupValues', 'Class');
        }
        return AGQuoteList; 
    }
    public Pagereference showMoreAMPS(){
        ampsPageSize +=5;
        getAmpORGroupValues();
        return null;
    }
    // Shaijan Thomas 5th March 13 for R5
    public String sortExpression 
    {    
        get { return sortExp; }     
        set     
        {       
            //if the column is clicked on then switch between Ascending and Descending modes       
            if (value == sortExp )         
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';       
            else         
                sortDirection = 'ASC';       
            sortExp = value;    
        }   
    }
    public String getSortDirection() 
    {    
        //if not column is selected     
        if (sortExpression == null || sortExpression == '')      
            return 'ASC';   
        else     
            return sortDirection; 
    } 
    public void setSortDirection(String value) 
    {     
        sortDirection = value; 
    }  
    public void IntiateQuoteList(){
        
        if((!isShowAll && !isPreviousVersionClicked) || isHideClicked || isShowMore){
            sWhereClause='WHERE Opportunity_Name__C =\''+objOpportunity.id+'\' AND (Synced_To_Opportunity__c=true OR Hide_Record__c=false) order by Last_Synced_to_Opportunity__c DESC NULLS LAST, lastModifiedDate DESC Limit '+sPageSize;
        }
        if(isShowAll){
            sWhereClause='WHERE Opportunity_Name__C =\''+objOpportunity.id+'\' order by Last_Synced_to_Opportunity__c DESC NULLS LAST, lastModifiedDate DESC Limit '+sPageSize;
        }
        if(isPreviousVersionClicked){
            sWhereClause='WHERE Opportunity_Name__C =\''+objOpportunity.id+'\' AND Quote_IDS_ID__c IN '+listQuoteIDSId + 'order by Last_Synced_to_Opportunity__c DESC NULLS LAST, lastModifiedDate DESC Limit '+sPageSize;
        }
        if(isAlphaSorting){
            String qt = '\''+Alpha + '%' +'\'';
            sWhereClause='WHERE Opportunity_Name__C =\''+objOpportunity.id+'\' AND (Synced_To_Opportunity__c=true OR Hide_Record__c=false) AND Name Like '+qt+' order by Last_Synced_to_Opportunity__c DESC NULLS LAST, lastModifiedDate DESC';
        }
        if(isPagination){
            system.debug('******sWhereClause****'+sWhereClause);
            if(sWhereClause.contains('Limit')){
                //sPageSize =200;
                string whereCondition = sWhereClause; 
                whereCondition=whereCondition.replace('Limit','');
                whereCondition=whereCondition.replace('200','');
                system.debug('******size******'+whereCondition.length());
                //integer orderbyIndex = whereCondition.indexOf('order by');
                whereCondition=whereCondition.replace(whereCondition.substring(whereCondition.indexOf('order by'),whereCondition.length()),'');
                //system.debug('****orderbyIndex*******'+orderbyIndex);
                system.debug('+++++whereCondition+++++'+whereCondition);
                total_size =Database.countQuery('select count() from HP_Quote__c '+ whereCondition);
                system.debug('******total_size******'+total_size);
            }
            sWhereClause+=' offset '+counter;
               
        }
        sQueryString= 'SELECT '+sFieldList+ ' From HP_Quote__c '+sWhereClause;
        system.debug('********sQueryString******'+sQueryString);
        if(sortDirection<> null && sortExpression <> null)
        {
            if (sortDirection == 'ASC')
                sQueryString = sQueryString.replace('order by','order by '+sortExpression +' '+ sortDirection+' NULLS FIRST,');
            else if (sortDirection == 'DESC')
                sQueryString = sQueryString.replace('order by','order by '+sortExpression +' '+ sortDirection+' NULLS LAST,');
        }
        // Shaijan Thomas 5th March 13 for R5   
        if(!(CheckedAGIds.isEmpty()))
        {
            string tempstr='a'; 
            string tempstr1='a'; 
            string tempstr2='a'; 
            string tempstr3='a'; 
            string temp;
            for(String aorgIDs : CheckedAGIds)
            {
                temp = aorgIDs.substring(3,aorgIDs.length());
                if (aorgIDs.substring(0,3)== 'AMP')
                    tempstr1 = tempstr1 + 'AMPID_TS__c =\''+ temp + '\' OR ';
                if (aorgIDs.substring(0,3)== 'GRC')
                    tempstr2 = tempstr2 + 'Group_Contract_SW__c =\''+ temp + '\' OR '; 
                if (aorgIDs.substring(0,3)== 'QUN')
                    tempstr3 = tempstr3 + 'Name =\''+ temp + '\' OR '; 
            }
            if (tempstr1.length()>5)
            {
                tempstr1 = tempstr1.substring(1,tempstr1.length()-4);
                tempstr1 = '(' + tempstr1 +') AND ';
                tempstr = tempstr + tempstr1;                               
            }
            if (tempstr2.length()>5)
            {
                tempstr2 = tempstr2.substring(1,tempstr2.length()-4);
                tempstr2 = '(' + tempstr2 +') AND ';
                tempstr = tempstr + tempstr2;   
            }
            if (tempstr3.length()>5)
            {
                tempstr3 = tempstr3.substring(1,tempstr3.length()-4);
                tempstr3 = '(' + tempstr3 +') AND ';    
                tempstr = tempstr + tempstr3;
            }   
            tempstr = tempstr.substring(1,tempstr.length()-5);
            tempstr = '(' + tempstr +')';
            sQueryString = sQueryString.replace('order by','AND '+ tempstr +' order by ');
        }
        // Shaijan Thomas 5th March 13 for R5
        system.debug('********sQueryString******'+sQueryString);
        this.oQuoteList= new ApexPages.StandardSetController(Database.Query(sQueryString));
        this.oQuoteList.setPageSize(sPageSize);
    }
    public HPQuoteController(ApexPages.StandardController controller) {
        objOpportunity = (Opportunity)controller.getRecord();
        retAMPLabel = 'AMP ID';
        retQNLabel='Functional Location';
        retGCPLabel='Group Contract';
        isQuoteCheckAll = false;
        isPagination=false;
        total_size= 5;
        SearchRetSring = null;
        AMSearchRetSring = null;
        QNSearchRetSring = null;
        GCSearchRetSring = null;
        isQuoteName=false;
        isAMPID=false;
        isGroupContract=false;
        isPreviousVersionClicked = false;
        showSyncButton = true;
        showNewQuoteButton = true;
        Searchorder = 'b';
        isClearAll = false;
        displayPopUp = false;
        showBMIQuoteButton = true;
        objUser = [select Business_Group__c,Country,Region__c,BigMachines__Provisioned__c from user where id=:userinfo.getuserid()];
        if(objUser.Business_Group__c == 'ES'){
            sortDirection = 'DESC';
            sortExp = 'Originating_System_Quote_ID__c';
        }
       // oSearchList = [select AMPID_TS__c,Group_Contract_SW__c,Name from HP_Quote__c where Opportunity_Name__c =:objOpportunity.id and Hide_Record__c=false];
        if(SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',System.Label.Restrict_Sync_Functionality).contains(objUser.Business_Group__c+':'+objUser.Region__c)){
            showSyncButton = false;
        }
        if(SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',System.Label.Restrict_Quote_Functionality).contains(objUser.Business_Group__c+':'+objUser.Region__c)){
            showNewQuoteButton = false;
        }
        if(SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',System.Label.CPQRestrictBMIQuote).contains(objUser.Business_Group__c)){
            showBMIQuoteButton =false;
        }
        viewMode = ApexPages.currentPage().getParameters().get('viewMode');
        clickedFrom = ApexPages.currentPage().getParameters().get('clickedFrom');
        if(viewMode =='List' || clickedFrom =='showPrevious'){
            sPageSize = integer.valueof(label.CPQListPageSize);
            isPagination = true;
            sortExpression = ApexPages.currentPage().getParameters().get('sortExpression');
            sortDirection = ApexPages.currentPage().getParameters().get('sortDirection');
            //SearchRetSring = ApexPages.currentPage().getParameters().get('SearchRetSring');
            retAMPLabel = ApexPages.currentPage().getParameters().get('retAMPLabel');
            retQNLabel = ApexPages.currentPage().getParameters().get('retQNLabel');
            retGCPLabel = ApexPages.currentPage().getParameters().get('retGCPLabel');
            retAmp = ApexPages.currentPage().getParameters().get('retAmp');
            retGC = ApexPages.currentPage().getParameters().get('retGC');
            retQN = ApexPages.currentPage().getParameters().get('retQN');
            Searchorder= ApexPages.currentPage().getParameters().get('Searchorder');
            if(ApexPages.currentPage().getParameters().get('SearchRetSring').length()>=3)
                CheckedAGIds = ApexPages.currentPage().getParameters().get('SearchRetSring').split(':');
            SearchAMValue = ApexPages.currentPage().getParameters().get('AMSearchRetSring').split(':');
            SearchGCValue = ApexPages.currentPage().getParameters().get('GCSearchRetSring').split(':');
            SearchQNValue = ApexPages.currentPage().getParameters().get('QNSearchRetSring').split(':');
            if(!CheckedAGIds.isEmpty())
                isQuoteCheckAll= true;
        }
        if(viewMode == 'showPrevious'){
            selectedIdsForPreviousVersion = ApexPages.currentPage().getParameters().get('selectedIds');
            sortExpression = ApexPages.currentPage().getParameters().get('sortExpression');
            sortDirection = ApexPages.currentPage().getParameters().get('sortDirection');
            showPreviousVersionQuotes();
        }
        else{
            IntiateQuoteList();
        }
    }
    public List<QuoteWrapperClass> getHPQuotes()
    {
        if(oQuoteWrapperList == null || isClearAll || isShowAll || isPopup || isHideClicked || isPreviousVersionClicked || isShowMore || isAlphaSorting || isCustomSort || isCustomSearch || isPagination){
            oQuoteWrapperList = new List<QuoteWrapperClass>();
            for(sObject oQuote: oQuoteList.getRecords()){
                if(!CheckedAGIds.isEmpty()){
                    oQuoteWrapperList.add(new QuoteWrapperClass((HP_Quote__c)oQuote,true));
                }
                else{
                    oQuoteWrapperList.add(new QuoteWrapperClass((HP_Quote__c)oQuote,false));
                }
                
            }
            isHideClicked = false;
            isShowAll= false;
            isShowMore= false;
            isPreviousVersionClicked = false;
            isAlphaSorting = false;
            isCustomSort = false;
            isCustomSearch = false;
            isPopup = false;
            isClearAll = false;
        }
        return(oQuoteWrapperList);
    }

    public Pagereference showAllRecords(){
        sPageSize +=20;
        isShowMore = true;
        IntiateQuoteList();
        //closePopup();
        return null;
    }
   
    public Pagereference ShowAllHiddenRecords(){
        try{
            isShowAll = true;
            List<HP_Quote__c> listHPQuotes = new List<HP_Quote__c>();
            for(HP_Quote__c objHpQuote : [select id,Hide_Record__c from HP_Quote__c where Opportunity_Name__C =: objOpportunity.Id]){
                objHpQuote.Hide_Record__c = false;
                listHPQuotes.add(objHpQuote);
            }
            if(!listHPQuotes.isEmpty()){
                HPUtils.byPassHPQuoteBeforeTriggers = true;
                Database.SaveResult[] updateResult = Database.update(listHPQuotes,false);
            }
            isHideClicked = false;
            isShowMore= false;
            isPreviousVersionClicked = false;
            isAlphaSorting = false;
            IntiateQuoteList();
        }
        Catch(exception e){ 
            CreateApexErrorLog.insertHandledExceptions(e, null, 'HPQuoteController', 'ShowAllHiddenRecords', 'Class');
        }
        return null;
    }
    public Pagereference hideSelectedQuotes(){
        try{
            List<HP_Quote__c> listHideQuote = new List<HP_Quote__c>();
            for(QuoteWrapperClass objWrapperClass : getHPQuotes()){
                if(objWrapperClass.isSelected == true && !objWrapperClass.oQuoteObj.Synced_To_Opportunity__c){
                    objWrapperClass.oQuoteObj.Hide_Record__c = true;
                    listHideQuote.add(objWrapperClass.oQuoteObj);
                }
            }
            if(!listHideQuote.isEmpty()){
                HPUtils.byPassHPQuoteBeforeTriggers = true;
                Database.SaveResult[] updateResult = Database.update(listHideQuote,false);
            }
            else{
                List<String> listHPQuoteIdsId = new List<String>();
                for(HP_Quote__c objHpQuote : [select id,Hide_Record__c,Quote_IDS_ID__c from HP_Quote__c where Opportunity_Name__C =: objOpportunity.Id]){
                    listHPQuoteIdsId.add(objHpQuote.Quote_IDS_ID__c);
                }
                if(!listHPQuoteIdsId.isEmpty()){
                    HPQuoteUtils.HideQuotes(listHPQuoteIdsId);
                }
            }
            isHideClicked = true;
            isShowAll= false;
            isShowMore= false;
            isPreviousVersionClicked = false;
            isAlphaSorting = false;
            IntiateQuoteList();
        }
        Catch(exception e){ 
            CreateApexErrorLog.insertHandledExceptions(e, null, 'HPQuoteController', 'hideSelectedQuotes', 'Class');
        }
        return null;
    }
    
    public Pagereference showPreviousVersionQuotes(){
        try{
            listQuoteIDSId = new List<String>();
            List<String> selectedQuotes = selectedIdsForPreviousVersion.split(',');
            for(String QuoteId : selectedQuotes){
                String temp = '\''+QuoteId+'\'';
                listQuoteIDSId.add(temp);
            }
            if(!listQuoteIDSId.isEmpty()){
                isPreviousVersionClicked = true;
                IntiateQuoteList();
            }
        }
        Catch(exception e){ 
            CreateApexErrorLog.insertHandledExceptions(e, null, 'HPQuoteController', 'showPreviousVersionQuotes', 'Class');
        }
        
        return null;
    }
    
    /*This method is used for all Alphabets default it will take "A"*/
    public Pagereference Albetsresults(){
        Alpha =  ApexPages.currentPage().getParameters().get('Alpha'); 
        if ((Alpha == null)||(Alpha == ''))
            Alpha = 'A';
        if(Alpha == 'ALL'){
            isAlphaSorting = false;
            isHideClicked = true;
        }
        else
            isAlphaSorting = true;
        sPageSize =integer.valueof(label.CPQListPageSize);
        IntiateQuoteList();
        return null;
    }
    public PageReference ViewData() 
    {
        //string sortQString;
        if(viewMode == 'showPrevious')
            isPreviousVersionClicked = true;
        isCustomSort = true;
        IntiateQuoteList();
        return null;        
    }
    public Pagereference requestNewQuote(){
        try{
            sRequestFieldSetCSMap = Support_Request_FS_CS__c.getAll();
            redirectURL = '';
            String recordTypeName = null;
            String redirectVFPageName='';
            Support_Request__c sRequest = new Support_Request__c();
            for(Support_Request_FS_CS__c requestType : sRequestFieldSetCSMap.values()){
                if((requestType.SupportReqType__c.equals('Quote-to-Order') && requestType.Request_SubType__c.equals('Config / Price / Quote'))&&SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',requestType.Eligible_BG__c).contains(objUser.Business_Group__c)){
                    if(requestType.isBG_Specific_RecordType__c && objUser.Business_Group__c!=null)
                        recordTypeName = objUser.Business_Group__c+'-'+requestType.RecordType_Name__c;
                    else
                        recordTypeName = requestType.RecordType_Name__c;
                    if(requestType.isVisualforce__c && requestType.Visualforce_Page_Name__c != null && !SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',requestType.Non_Eligible_Countries__c).contains(objUser.Country)){
                        sRequest.Request_Submitted_From__c = requestType.View_VF_Page_Name__c;
                        redirectVFPageName = requestType.Visualforce_Page_Name__c;
                        sRequest.RecordTypeId = SupportRequestRoutingRulesTriggerUtil.getRecordTypeIDByName(recordTypeName);
                        sRequest.Support_Type__c = requestType.SupportReqType__c;
                        sRequest.Sub_Type__c = requestType.Request_SubType__c;
                    }
                    if((requestType.punchOut_BG__c!=null && !requestType.isVisualforce__c)|| (requestType.isVisualforce__c && SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',requestType.Non_Eligible_Countries__c).contains(objUser.Country))){
                        if(requestType.punchOut_BG__c.contains(objUser.Business_Group__c)){
                            sRequest.recordTypeId=SupportRequestRoutingRulesTriggerUtil.getRecordTypeIDByName(recordTypeName);
                            sRequest.Request_Description__c =Label.SupportRequest_PunchOutDescription;
                            sRequest.Support_Type__c = requestType.SupportReqType__c;
                            sRequest.Sub_Type__c = requestType.Request_SubType__c;
                        }
                    }
                }
            }
            if(sRequest.RecordTypeId != null){
                sRequest.Opportunity__c = objOpportunity.Id;
                insert sRequest;
                if(redirectVFPageName == ''){
                    redirectURL = '/'+sRequest.id;
                }
                else{
                    redirectURL = '/apex/'+redirectVFPageName+'?id='+sRequest.id;
                }
                
            }
            else{  
                redirectURL = '/apex/CreateSupportRequest?&OpptyId='+objOpportunity.Id+'&retURL='+objOpportunity.Id;
            }
        }
        Catch(exception e){ 
            CreateApexErrorLog.insertHandledExceptions(e, null, 'HPQuoteController', 'requestNewQuote', 'Class');
        } 
        return null;
    }
    public Pagereference redirctToSelectedQuoteType(){
        typeOfQuote = ApexPages.currentPage().getParameters().get('buttonClicked');
        If(typeOfQuote == 'SelfService'){
            Opportunity tempOpty=[select Id,AccountId from Opportunity where Id=:objOpportunity.Id];
            PageReference Page;
            if(objUser.BigMachines__Provisioned__c)
                Page=new PageReference('/apex/BigMachines__QuoteEdit?oppId='+objOpportunity.Id+'&actId='+tempOpty.AccountId);
            else
                Page=new PageReference('/apex/CPQBMINotSyncErrorPage?oppId='+objOpportunity.Id+'&actId='+tempOpty.AccountId);
            page.setRedirect(true);
            return page;
        }
        else if(typeOfQuote == 'NotSure'){
            PageReference Page=new PageReference('/apex/CPQHPQuoteSelectionPage?id='+objOpportunity.Id);
            page.setRedirect(true);
            return page;
        }
        else if(typeOfQuote == 'cancel'){
            PageReference Page=new PageReference('/'+objOpportunity.Id);
            page.setRedirect(true);
            return page;
        }
        else{
            requestNewQuote();
            PageReference Page=new PageReference(redirectURL);
            page.setRedirect(true);
            return page;
        }
        return null;
    }
    
    public Pagereference redirctToNewRequestPage(){
        if((System.Label.CPQTSorSWLabel).contains(objUser.Business_Group__c))
        {
            redirectURL = '/apex/CPQSAPSelectionPage?id='+objOpportunity.Id+'&pageMode=CreateQuote&I_ACC_NAME='+objOpportunity.account.Name+ '&I_OPP_ID='+objOpportunity.Opportunity_ID__c + '&I_OPP_NAME='+objOpportunity.Name + '&i_rpl_status='+objOpportunity.Account.RPL_Status__c+ '&I_COUNTRY='+objOpportunity.account.World_Region1__r.Name;
        }
        else if(SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',System.Label.CPQRestrictBMIQuote).contains(objUser.Business_Group__c)){
            requestNewQuote();
        }
        else{
            redirectURL = '/apex/CPQHPQuoteSelectionPage?id='+objOpportunity.Id;
        }
        /*PageReference Page=new PageReference(redirectURL);
        page.setRedirect(true);
        return page;*/
        return null;
    }
    
    public Pagereference redirctToNewRequestPageBasedonBG(){
        if(SupportRequestRoutingRulesTriggerUtil.splitNconvertToSet(';',System.Label.CPQRestrictBMIQuote).contains(objUser.Business_Group__c)){
            requestNewQuote();
        }
        else{
            redirectURL = '/apex/CPQHPQuoteSelectionPage?id='+objOpportunity.Id;
        }
        PageReference Page=new PageReference(redirectURL);
        page.setRedirect(true);
        return page;
    }
}