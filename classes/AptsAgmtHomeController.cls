/**
 * This class is the controller for the custom visualforce page ApttusAgmtHome.page
 * which is the landing page for Agreements tab.
 * Author : Apttus 
 */
public with sharing class AptsAgmtHomeController {   
    
    private static final String CATEGORY_IN_EFFECT = 'In Effect';
    
    private String retURL;
    private String SQ = '\'';
    
    private ID currentUserId {get;set;} 
    // for query locator
    private ApexPages.StandardSetController agmtSet = null;
    public List<Apttus__APTS_Agreement__c> agmtList {get; private set;}
    
    
    // page size
    public Integer pageSize = 100;
    // limit row to 5000
    private Integer limitRows = 5000;
    public Integer totalColumns {get; private set;}
    // total pages
    public Integer totalPages {get; private set;}
    public Integer totalRowCount {get; private set;}
    
    // current page number
    private Integer currentPageNbr = 1;
    
    // agreement-docId wrapper list
    public list<AgmtDocWrapper> resultList {get; private set;}   
    public map<ID, ID> agmtIdDocIdMap = new map<ID, ID>();
    
    public string pagingMsg {get;set;}
    
    private set<string> defaultFields = new set<string>{'Apttus__FF_Agreement_Number__c', 'Name'};
    public string resultFieldsString {get;private set;} 
    private String advSearchWhereClause {get;private set;}
    public Boolean showFilters {get;private set;}
    public Boolean showRecentResult {get;private set;}
    public Boolean showSelectionFilter {get;private set;}  
    public Boolean showSelectionColumns {get;private set;} 
    
    // doc-text and agmt-text search criteria fields
    public String docTxtSrchCriteria {get; set;}
    public String agmtTxtSrchCriteria {get; set;}
    
    //public list<cwSelectedFields> SelectedFieldsList {get;set;}
    //public list<cwSelectedFields> ResultFieldsList {get;set;}
        
    public Apttus__APTS_Agreement__c agreement {get; set;}
    public Apttus__APTS_Agreement__c agreementToDate {get; set;}
    public Apttus__APTS_Agreement__c agreementFromDate {get; set;}
       
    public Boolean hasAllAgreements{get; private set;}
    public Boolean hasMyAgreements{get; private set;} 
    public list<Apttus__APTS_Agreement__c> existingAgreements {get; private set;}
    public list<Apttus__APTS_Agreement__c> myAgreements {get; private set;}
   
     
    public String title {get; private set;} 
    public String searchQuery {get; private set;}
    public String queryString {get; private set;}
     
    public boolean allAgreements {get; private set;}
    //Variables for export to Excel
    public string advSearchWhereClauseExport {get;private set;}
    public string queryFieldsStrExp {get;private set;}
    
//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Constructor specifying initial values
     * @param:  stdController the standard controller
     */   
    public AptsAgmtHomeController() {  
    
    }
    
    public AptsAgmtHomeController(ApexPages.StandardSetController controller) 
    {     
        pageInit();
    }
  
    public AptsAgmtHomeController(ApexPages.StandardController stdController) 
    {             
        pageInit();
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   PageInit run when the page is loaded
     * @param:  
     */       
    private void pageInit() 
    {
        retURL = ApexPages.currentPage().getParameters().get('retURL');

        agreement = new Apttus__APTS_Agreement__c();  
       // agreement.Apttus__Status_Category__c  = CATEGORY_IN_EFFECT; 
        agreement.RecordTypeId = getRecordTypeId(); 
        agreementToDate = new Apttus__APTS_Agreement__c();  
        agreementToDate.RecordTypeId = getRecordTypeId();
      //  agreementToDate.Apttus__Status_Category__c  = CATEGORY_IN_EFFECT; 
        agreementFromDate = new Apttus__APTS_Agreement__c();  
        agreementFromDate.RecordTypeId = getRecordTypeId();  
       // agreementFromDate.Apttus__Status_Category__c  = CATEGORY_IN_EFFECT;    
        
        docTxtSrchCriteria = '';
        agmtTxtSrchCriteria = '';
        
        title = 'My WIP Agreements';
        currentUserId = UserInfo.getUserId();

        showRecentResult = true;

        allAgreements = true;
        showFilters = false;
        showSelectionFilter = false;
        showSelectionColumns = false;

        selectedFieldsInit();    
        
        resultList = new list<AgmtDocWrapper>();
    }
    
//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   
     * @Param:  
     * @Return: 
     */  
       
    public Id getRecordTypeId ()  
    {
        list<RecordType> listRecTypes = [Select Id from RecordType where Name='Search Agreements' and SObjectType = 'Apttus__APTS_Agreement__c'];
        if(!listRecTypes.isEmpty()) {
            return listRecTypes[0].Id;
        } else {
            return null;
        }
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Gets string version of agreementId and documentId map to be passed as parameter to export routine
     * @Param:  
     * @Return: 
     */    

    public String getExpReqDocMapStr() 
    {
        system.debug(LoggingLevel.INFO,' >>> getExpReqDocMapStr() >>> ');
        String idsStr = '';
        if(null != agmtIdDocIdMap)
        {
            for (Id agmtId : agmtIdDocIdMap.keySet()) 
            {
                idsStr += agmtId + ',' + agmtIdDocIdMap.get(agmtId) + ';';
            }
        }
        system.debug(LoggingLevel.INFO,' >>> idsStr >>> ' + idsStr);
        return idsStr;
    }  

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Clear search criteria fields
     * @Param:  
     * @Return: 
     */     
/*
    public void doClearSearchCriteria() 
    {
        system.debug(LoggingLevel.INFO,' >>> doClearSearchCriteria >>> ' + agreementFromDate);
        docTxtSrchCriteria = ''; 
        agmtTxtSrchCriteria = '';
        agreement = new Apttus__APTS_Agreement__c();
        agreement.RecordTypeId = getRecordTypeId();
        agreementToDate = new Apttus__APTS_Agreement__c();  
        //agreementToDate.Apttus__Status_Category__c  = CATEGORY_IN_EFFECT; 
        
        agreementFromDate = new Apttus__APTS_Agreement__c();   
        agreementFromDate.Sub_Sub_Agreement_Type__c = null;
        //agreementFromDate.Apttus__Status_Category__c  = CATEGORY_IN_EFFECT; 
        
        for(cwSearchFields cwSearchEl : cwSearchFieldsList)
        {
            cwSearchEl.fieldValueInput = null;
        }
        system.debug(LoggingLevel.INFO,' >>> doClearSearchCriteria >>> ' + agreementFromDate);
    } 
    */
    
    public PageReference doClearSearchCriteria() 
    {
        system.debug(LoggingLevel.INFO,' >>> doClearSearchCriteria >>> ' + agreementFromDate);
        PageReference pageRef = new PageReference('/apex/AptsAgmtHome?sfdc.tabName=01rV00000004Vdt');
        pageRef.setRedirect(true);
        return pageRef;
        
    } 

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Build comma seperated list of fields from result field-set
     * @Param:  
     * @Return: 
     */ 

    public string buildQueryFieldsStr() 
    {  
        string selectField = '';
        resultFieldsString = '';
        list<string> fieldsListTemp = new list<string>(defaultFields);
        
        fieldsListTemp.addAll(searchResultFieldsList);

        for(string strTemp: fieldsListTemp) 
        { 
            selectField+=strTemp + ', ';
            resultFieldsString += strTemp + ';';
        }
        
        return selectField;
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Builds metadata SOQL where clause string
     * @Param:  
     * @Return: 
     */     

    public String buildAdvSearchWhereClause() 
    {
        String strFields = '';
        String whereClause = 'WHERE ';

        for(cwSearchFields cwSearchField : cwSearchFieldsList) 
        {
            //system.debug('Field Name is: ' + f.getFieldPath() + ' And Field Type is ' + f.getType());
            //If it is date field we need to chack values on both Agreement records: agreementFromDate && agreementToDate
            if(cwSearchField.isDate==true) 
            {
                system.debug(LoggingLevel.INFO, '\ncwSearchField.fieldName = ' + cwSearchField.fieldName + '\nagreementFromDate = ' + agreementFromDate.get(cwSearchField.fieldName) + '\n agreementToDate = ' + agreementToDate.get(cwSearchField.fieldName));
                
                //date fromDate = agreementFromDate.get(cwSearchField.fieldName);
                //date toDate = agreementToDate.get(cwSearchField.fieldName);
                
                
                if((agreementFromDate.get(cwSearchField.fieldName) != null 
                        && agreementFromDate.get(cwSearchField.fieldName) != '') 
                        && (agreementToDate.get(cwSearchField.fieldName) != null 
                        && agreementToDate.get(cwSearchField.fieldName) != '')) 
                        
                //if(Null != fromDate && Null != toDate)        
                {
                            
                    //fromDate =  string.valueOf(agreementFromDate.get(cwSearchField.fieldName)).left(10);
                    //toDate = string.valueOf(agreementToDate.get(cwSearchField.fieldName)).left(10);
                    //string fromDateStr = string.valueOf(fromDate).left(10);
                    //string toDateStr = string.valueOf(toDate).left(10);
                    
                    string fromDateStr = string.valueOf(agreementFromDate.get(cwSearchField.fieldName)).left(10);
                    string toDateStr = string.valueOf(agreementToDate.get(cwSearchField.fieldName)).left(10);
                    whereClause += ' (' + cwSearchField.fieldName + ' >=' + fromDateStr + ' AND ' + cwSearchField.fieldName + ' <=' + toDateStr + ') AND ';
                    
                } 
                //the code when the FROM date has a value and TO date is null or blank
                 
                else if((agreementFromDate.get(cwSearchField.fieldName) != null && agreementFromDate.get(cwSearchField.fieldName) != '') 
                        && (agreementToDate.get(cwSearchField.fieldName) == null || agreementToDate.get(cwSearchField.fieldName) == '')) 
                        
                //else if(Null != fromDate && Null == toDate)          
                {
                            
                    //fromDate =  string.valueOf(agreementFromDate.get(cwSearchField.fieldName)).left(10);
                    //toDate = string.valueOf(date.today());
                    //whereClause += ' (' + cwSearchField.fieldName + ' >=' + fromDate + ' AND ' + cwSearchField.fieldName + ' <=' + toDate + ') AND ';
                    //string fromDateStr = string.valueOf(fromDate).left(10);
                    string fromDateStr = string.valueOf(agreementFromDate.get(cwSearchField.fieldName)).left(10);
                    whereClause += ' (' + cwSearchField.fieldName + ' >=' + fromDateStr + ') AND ';
                }
                //the code when the FROM date is null or blank and TO date has a value
                
                else if((agreementFromDate.get(cwSearchField.fieldName) == null || agreementFromDate.get(cwSearchField.fieldName) == '') 
                        && (agreementToDate.get(cwSearchField.fieldName) != null && agreementToDate.get(cwSearchField.fieldName) != '')) 
                        
                //else if(Null == fromDate && Null != toDate) 
                {
                    
                    //toDate = string.valueOf(agreementToDate.get(cwSearchField.fieldName)).left(10);
                    
                    string toDateStr = string.valueOf(agreementToDate.get(cwSearchField.fieldName)).left(10);
                    system.debug(LoggingLevel.INFO, '\ncwSearchField.fieldName toDate = ' + toDateStr);
                    whereClause += ' (' + cwSearchField.fieldName + ' <=' + toDateStr + ') AND ';
                }                
            } 
            else if((cwSearchField.isDate != true 
                && agreementFromDate.get(cwSearchField.fieldName) != null 
                && agreementFromDate.get(cwSearchField.fieldName) != '') 
                || (String.isNotBlank(cwSearchField.fieldValueInput))) 
            {                        
                if(cwSearchField.fieldType.equalsIgnoreCase('String')) 
                {
                    whereClause += cwSearchField.fieldName + ' LIKE \'%' + agreementFromDate.get(cwSearchField.fieldName) + '%\' AND ';                   
                } 
                else if(cwSearchField.isReference==true) 
                {
                    whereClause += cwSearchField.fieldName.substring(0,cwSearchField.fieldName.length()-1) + 'r.Name LIKE \'%' + cwSearchField.fieldValueInput + '%\' AND ';
                } 
                else if(cwSearchField.isBoolean==true) 
                {
                    //Need to add code. For now just prevent the error
                    if('True'.equalsIgnoreCase(cwSearchField.fieldValueInput))
                        whereClause += cwSearchField.fieldName + ' = True AND ';
                    if('False'.equalsIgnoreCase(cwSearchField.fieldValueInput))
                        whereClause += cwSearchField.fieldName + ' = False AND ';
                }
                else 
                {
                    whereClause += cwSearchField.fieldName + ' = \'' + agreementFromDate.get(cwSearchField.fieldName) + '\' AND ';
                }
            }                
        }  
        
        system.debug(LoggingLevel.INFO, 'whereClause = ' + whereClause);
        Boolean boolWhereClause = false;
        if(whereClause.trim().endsWith('AND'))  
        {
            boolWhereClause = true;
            whereClause = whereClause.substring(0,whereClause.length()-4);
        }  
        else  
        {
            whereClause = '';
        }
        advSearchWhereClauseExport = whereClause.replace('%', 'xxxxx');   
          
        return whereClause;
    }  

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Builds query string using advanced search criteria
     * @Param:  
     * @Return: 
     */     

  /*  public String buildQueryStr() 
    {       

        string selectFieldsStr = buildQueryFieldsStr();
        
        String searchquery   = 'Select ' + selectFieldsStr +
        '(Select Id, Name, CreatedDate, LastModifiedDate, Apttus__URL__c, Apttus__Agreement__c, Apttus__Type__c, Apttus__Version__c From Apttus__Agreement_Document__r order by LastModifiedDate desc) ' +
                        ' Id From Apttus__APTS_Agreement__c ';
        
        String whereClause = buildAdvSearchWhereClause();
        
        searchquery += whereClause + ' limit 1000 ';

        return searchquery;
    } */ 

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   
     * @Param:  
     * @Return: 
     */ 
    public void doSearch() {
        
        // Create the where clause
        advSearchWhereClause = buildAdvSearchWhereClause();
        if (String.isBlank(agmtTxtSrchCriteria) && String.isBlank(docTxtSrchCriteria) && String.isBlank(advSearchWhereClause)) 
        {
            ApexPages.addMessage(new apexPages.Message(apexPages.Severity.Error,'Error: Please enter a search string at least 2 characters long or enter a field to search on the advanced search'));
        }
        else if ((String.isNotBlank(agmtTxtSrchCriteria) && agmtTxtSrchCriteria.length() < 2) || (String.isNotBlank(docTxtSrchCriteria) && docTxtSrchCriteria.length() < 2))
        { 
            ApexPages.addMessage(new apexPages.Message(apexPages.Severity.Error,'Error: Please enter a search string at least 2 characters long.'));
        }
        else if (String.isNotBlank(agmtTxtSrchCriteria) && String.isNotBlank(docTxtSrchCriteria))
        { 
            ApexPages.addMessage(new apexPages.Message(apexPages.Severity.Error,'Error: Please enter in only one of the Search box.'));
        }
        else
        {
            allAgreements = true;
            showRecentResult = false;
            currentPageNbr = 1;
            resultList.clear();
            
            getTotalCount();
            
            if ( ! agmtIdDocIdMap.isEmpty()) 
            {
                doSearchInternal();
            }
        }
    }  

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   
     * @Param:  
     * @Return: 
     */ 
     
    private void getTotalCount() 
    {
        agmtIdDocIdMap.clear();
        list<list<SObject>> findList = new list<list<SObject>>();
        Integer findCount = 200;
        list<ContentVersion> verList = new list<ContentVersion>();
        
        //string whereClause = buildAdvSearchWhereClause();
        string whereClause = advSearchWhereClause;
        Set<ID> mdAgmtIdList = new Set<ID>();
        Set<ID> mdAgmtIdSet = new Set<ID>();
        Set<ID> mdAgmtIdSetSOQL = new Set<ID>();
        Set<ID> mdAgmtIdSetSOSL = new Set<ID>();
        
        Boolean isSOQL = false;
        Boolean isSOSL = false;
        
        if (String.isNotBlank(whereClause)) 
        {
            isSOQL = true;
            String qryString = 'select Id from Apttus__APTS_Agreement__c ';
            qryString += whereClause;
            //qryString += ' limit 1000 ';          
            
            list<Apttus__APTS_Agreement__c> mdAgmtList = Database.query(qryString.trim());
            system.debug('############ mdAgmtList:'+mdAgmtList.size());
            if ( ! AptsUtil.nullOrEmpty(mdAgmtList)) 
            {
                /*
                for (Apttus__APTS_Agreement__c mdAgmt : mdAgmtList) 
                {
                    mdAgmtIdList.add(mdAgmt.Id);
                }
                */
                map<Id, Apttus__APTS_Agreement__c> agmtMap = new map<Id, Apttus__APTS_Agreement__c>(mdAgmtList);
                mdAgmtIdSetSOQL = agmtMap.keySet();
                system.debug('############ mdAgmtIdSetSOQL:'+mdAgmtIdSetSOQL);             
            }
        }
        
        // perform agreement text search
        //  - only if the user has entered agreement text search criteria
        if (String.isNotBlank(agmtTxtSrchCriteria)) 
        {            
            isSOSL = true;
            findCount = 200;
            String lastAgmtNbr = '0';
            system.debug('############ agmtTxtSrchCriteria :'+agmtTxtSrchCriteria);
            String tempString = agmtTxtSrchCriteria;
            if ( ! tempString.endsWith('*')) 
            {
                tempString += '*';
            }
            
            // search agreements
            while (findCount > 199) 
            {
                findList = null;
                if( isSOQL == true)
                {                   
                    if(Null != mdAgmtIdSetSOQL && mdAgmtIdSetSOQL.size() > 0)
                    {
                        system.debug('######### tempString:'+tempString); 
                        system.debug('######### lastAgmtNbr:'+lastAgmtNbr); 
                        findList = [FIND :tempString IN ALL FIELDS RETURNING 
                                    Apttus__APTS_Agreement__c(Id, Apttus__FF_Agreement_Number__c
                                    where Apttus__FF_Agreement_Number__c > :lastAgmtNbr  
                                    and Id IN :mdAgmtIdSetSOQL
                                    order by Apttus__FF_Agreement_Number__c)];                               
                    }
                    
                }
                else
                {
                   findList = [FIND :tempString IN ALL FIELDS RETURNING 
                                Apttus__APTS_Agreement__c(Id, Apttus__FF_Agreement_Number__c
                                where Apttus__FF_Agreement_Number__c > :lastAgmtNbr  
                                order by Apttus__FF_Agreement_Number__c)];
                }                   
                
                if(Null != findList && findList.size() > 0)
                {
                    list<Apttus__APTS_Agreement__c> agmtList = findList[0];
                    if ( ! AptsUtil.nullOrEmpty(agmtList)) 
                    {
                        /*
                        for (Apttus__APTS_Agreement__c agmt : agmtList) 
                        {
                            agmtIdDocIdMap.put(agmt.Id, null);
                        }
                        */
                        
                        findCount = agmtList.size();
                        lastAgmtNbr = agmtList[findCount-1].Apttus__FF_Agreement_Number__c;
                        
                        map<Id, Apttus__APTS_Agreement__c> agmtMap = new map<Id, Apttus__APTS_Agreement__c>(agmtList);
                        mdAgmtIdSetSOSL.addAll(agmtMap.keySet());
                        
                    } 
                    else 
                    {
                        findCount = 0;
                    }
                }
                else 
                {
                    findCount = 0;
                }
            }        
        }
        
        /* 
        else 
        {
            for (ID mdAgmtId : mdAgmtIdList) 
            {
                agmtIdDocIdMap.put(mdAgmtId, null);
            }
        }
        */
        
        //merge the result based on the updated logic
        
        if(isSOSL && isSOQL)
        {
            //merge two sets
            if(Null != mdAgmtIdSetSOSL && mdAgmtIdSetSOSL.size() > 0 && Null != mdAgmtIdSetSOQL && mdAgmtIdSetSOQL .size() > 0)
            {
                mdAgmtIdSet.addAll(mdAgmtIdSetSOSL);
                mdAgmtIdSet.retainAll(mdAgmtIdSetSOQL);
            }
        }
        else if(isSOSL == true && isSOQL == false)
        {
            //get only the SOSL result
            if(Null != mdAgmtIdSetSOSL && mdAgmtIdSetSOSL.size() > 0)
                mdAgmtIdSet.addAll(mdAgmtIdSetSOSL);            
        }        
        else if(isSOSL == false && isSOQL == true)
        {
            //get only the SOQL result
            if(Null != mdAgmtIdSetSOQL && mdAgmtIdSetSOQL.size() > 0)
                mdAgmtIdSet.addAll(mdAgmtIdSetSOQL);  
        }

        if(Null != mdAgmtIdSet && mdAgmtIdSet.size() > 0)
        {
            for (ID mdAgmtId : mdAgmtIdSet) 
            {
                agmtIdDocIdMap.put(mdAgmtId, null);
            }
        }
        
        
        // perform document text search
        //  - only if the user has entered document text search criteria
        if (String.isNotBlank(docTxtSrchCriteria)) 
        {
        
            map<ID, ID> verIdDocIdMap = new map<ID, ID>();
            Datetime lastCreateDate = Datetime.newInstance(1970, 1, 1);
            
            String tempString = docTxtSrchCriteria;
            if ( ! tempString.endsWith('*')) 
            {
                tempString += '*';
            }
    
            // search content
            findCount = 200;
            while (findCount > 199) 
            {
                if(isSOSL || isSOQL)
                {
                    if(Null != mdAgmtIdSet && mdAgmtIdSet .size() > 0)
                    {
                        findList = [FIND :tempString IN ALL FIELDS RETURNING 
                                        ContentVersion(id, ContentDocumentId, Agreement__c, CreatedDate
                                                where IsLatest = true 
                                                and Agreement__c IN :mdAgmtIdSet
                                                and CreatedDate > :lastCreateDate
                                                order by CreatedDate)];
                    }
                }
                else
                {
                    findList = [FIND :tempString IN ALL FIELDS RETURNING 
                                ContentVersion(id, ContentDocumentId, Agreement__c, CreatedDate
                                where IsLatest = true 
                                and CreatedDate > :lastCreateDate
                                order by CreatedDate)];                 
                }
                
                //list<ContentVersion> verList = findList[0];
                //verList = findList[0];
                verList = (findList != null && findList.size() > 0) ? findList[0] : null;
                if ( ! AptsUtil.nullOrEmpty(verList)) 
                {
                    for (ContentVersion ver : verList) 
                    {
                        verIdDocIdMap.put(ver.Id, ver.ContentDocumentId);
                        if(Null != ver.Agreement__c)
                        {
                            agmtIdDocIdMap.put(ver.Agreement__c, ver.ContentDocumentId);
                        }
                    }
                    
                    findCount = verList.size();
                    lastCreateDate = verList[findCount-1].CreatedDate;    
                } 
                else 
                {
                    findCount = 0;
                }
            }

           system.debug(' >>> verIdDocIdMap.size >>> ' + verIdDocIdMap.size());
           system.debug(' >>> agmtIdDocIdMap.size >>> ' + agmtIdDocIdMap.size());
                      
           // remove agreements which do not have associated document
            if(isSOSL || isSOQL)
            {           
                Set<ID> delKeyList = new Set<ID>();
                for (ID agmtId : agmtIdDocIdMap.keySet()) 
                {
                    if (agmtIdDocIdMap.get(agmtId) == null) 
                    {
                        delKeyList.add(agmtId);
                    }
                }
                // remove from map
                for (ID delKey : delKeyList) 
                {
                    agmtIdDocIdMap.remove(delKey);
                }
            }
           
           /* 
            // establish agreement to doc map
            
            list<FeedItem> itemList = [select RelatedRecordId, ParentId from FeedItem
                                            where ParentId IN :agmtIdDocIdMap.keySet()];
            if ( ! AptsUtil.nullOrEmpty(itemList)) 
            {

                Set<ID> verIdList = verIdDocIdMap.keySet();
                for (FeedItem item : itemList) 
                {
                    if (verIdList.contains(item.RelatedRecordId)) 
                    {
                        ID docId = verIdDocIdMap.get(item.RelatedRecordId);
                        agmtIdDocIdMap.put(item.ParentId, docId);
                    }
                }
                
                // remove agreements which do not have associated document
                Set<ID> delKeyList = new Set<ID>();
                for (ID agmtId : agmtIdDocIdMap.keySet()) 
                {
                    if (agmtIdDocIdMap.get(agmtId) == null) 
                    {
                        delKeyList.add(agmtId);
                    }
                }
                // remove from map
                for (ID delKey : delKeyList) 
                {
                    agmtIdDocIdMap.remove(delKey);
                }
            }
            */
        }
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Perform search
     * @Param:  
     * @Return: 
     */     
  
    public void doSearchInternal() 
    {
        String qryStr = null;
        
        system.debug(' >>> agmtIdDocIdMap.size >>> ' + agmtIdDocIdMap.size());
        // perfrom dynamic query
        string selectFieldsStr = buildQueryFieldsStr();
        queryFieldsStrExp = selectFieldsStr;
        
        qryStr = 'Select ' + selectFieldsStr + ' Id ';
        qryStr += ' ,(Select Id, Title From Content__r) ';                
        qryStr += ' From Apttus__APTS_Agreement__c ';
        
        Boolean isFirst = true;
        qryStr += ' where Id IN (';
        for (String agmtId : agmtIdDocIdMap.keySet()) 
        {
            if (isFirst) 
            {
                qryStr += SQ + agmtId + SQ;
                isFirst = false;
            } else 
            {
                qryStr += ',' + SQ + agmtId + SQ;
            }
        }
        qryStr += ')';
        
        // sort
        qryStr += ' order by Apttus__FF_Agreement_Number__c ';
        // limit
        qryStr += ' limit ' + limitRows;        
        
        // save query string to be passed to export routine.
        searchQuery = qryStr;
        System.debug('QUERY-STRING = ' + qryStr);
        
        // execute the query
        agmtSet = new ApexPages.StandardSetController(Database.getQueryLocator(qryStr));
                           
        if (agmtSet != null) 
        { 
            // set the page size
            agmtSet.setPageSize(pageSize);
            
            totalRowCount = agmtSet.getResultSize();
            
            totalPages = agmtSet.getResultSize()/agmtSet.getPageSize();
            Integer remainder = Math.mod(agmtSet.getResultSize(), agmtSet.getPageSize());
            if (remainder > 0) 
            {
                totalPages++;
            }
                        
            // build wrapper list
            buildResultList();            
        } 
        else 
        {
            totalPages = 0;
            currentPageNbr = 0;
        }
    } 

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Build asset wrapper list for UI
     * @Param:  
     * @Return: 
     */     

    private void buildResultList() 
    {
        system.debug('################ resultList :'+resultList.size());        
        resultList.clear();
        
        // set current page number
        system.debug('############# agmtSet:'+agmtSet);
        system.debug('############# currentPageNbr:'+currentPageNbr);
        if(agmtSet != null){
            agmtSet.setPageNumber(currentPageNbr);
                
            // read records from the current page in the recordset
            for (Apttus__APTS_Agreement__c agmt : (list<Apttus__APTS_Agreement__c>) agmtSet.getRecords()) 
            {            
                // get docId
                ID docId = agmtIdDocIdMap.get(agmt.Id);
                if(null == docId && agmt.Content__r != null && agmt.Content__r.size() > 0)
                    docId = agmt.Content__r[0].Id;
                resultList.add(new AgmtDocWrapper(agmt, docId));               
            }
        }
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Positions the cursor to the next page in the resultset
     * @Param:  
     * @Return: 
     */     

    public void loadCurrentPage() 
    {
        buildResultList();
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Checks if there are result to show
     * @Param:  
     * @Return: <code>true</code> if there are results, <code<false</code> otherwise
     */     

    public Boolean getHasResults() 
    {
        return ( !AptsUtil.nullOrEmpty(resultList));
    } 

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Checks if there are more records after the current page in the resultset
     * @Param:  
     * @Return: <code>true</code> if there are more records, <code>false</code> otherwise
     */     

    public Boolean getHasNextPage() 
    {
        system.debug('\ntotalPages = ' + totalPages +'\ncurrentPageNbr = ' + currentPageNbr);
        return (totalPages > currentPageNbr);
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Checks if there are more records before the current page in the resultset
     * @Param:  
     * @Return: <code>true</code> if there are more records, <code>false</code> otherwise
     */     
     
    public Boolean getHasPreviousPage() {
        return ((currentPageNbr != 1) && (currentPageNbr != 0));
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Gets the page number of the current page in the resultset
     * @Param:  
     * @Return: the page number
     */     

    public Integer getCurrentPageNumber() 
    {
        return currentPageNbr;
    }
    
//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Sets the page number into the resultset
     * @Param:  
     * @Return: 
     */ 
         
    public void setCurrentPageNumber(Integer pageNumber) 
    {
        if(pageNumber <= totalPages)
        {
            currentPageNbr = pageNumber;
            buildResultList();
        }
        
    }
//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Gets current page start asset count
     * @Param:  
     * @Return: 
     */ 
         
    public Integer getPageStartIndex() {
        if (currentPageNbr == 1) {
            return 1;
        } 
        if ( ! resultList.isEmpty()) {
            return ((pageSize * (currentPageNbr - 1)) + 1);
        }
        return 0;
    }
    
//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Gets current page end asset count
     * @Param:  
     * @Return: 
     */     
 
    public Integer getPageEndIndex() {
        if ( ! resultList.isEmpty()) {
            return (getPageStartIndex() + (resultList.size() - 1));
        }
        return 0;
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Gets the page size
     * @Param:  
     * @Return: the page size
     */         
 
    public Integer getPageSize() {
        return pageSize;
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Sets the page size
     * @Param:  pageSize the page size
     * @Return: 
     */     

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Positions the cursor to the first page in the resultset
     * @Param:  
     * @Return: 
     */     

    public void firstPage() {
        
        // reset current page
        currentPageNbr = 1;
        buildResultList();
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Positions the cursor to the last page in the resultset
     * @Param:  
     * @Return: 
     */     
    public void lastPage() {
        
        // reset current page
        currentPageNbr = totalPages;
        buildResultList();
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Positions the cursor to the previous page in the resultset
     * @Param:  
     * @Return: 
     */         

    public void previousPage() {

        // adjust current page
        currentPageNbr --;
        buildResultList();
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Positions the cursor to the next page in the resultset
     * @Param:  
     * @Return: 
     */         

    public void nextPage() {

        // adjust current page
        currentPageNbr ++;
        buildResultList();
    }
//*******************************************************************************************************    
     public list<Schema.FieldSetMember> getFields() 
     {
        // return SObjectType.Apttus__APTS_Agreement__c.FieldSets.Search_Fields.getFields();
        return Schema.SObjectType.Apttus__APTS_Agreement__c.fieldSets.getMap().get('Search_Fields').getFields();
     }

     public list<Schema.FieldSetMember> getSearchResultFields() 
     {
        return Schema.SObjectType.Apttus__APTS_Agreement__c.fieldSets.getMap().get('Search_Result_Fields').getFields();
     }
              
     public PageReference doShowFilters() 
     {
        showFilters = true;
        //showRecentResult = false;
        return null;
     }
    
     public PageReference doHideFilters() 
     {
        showFilters = false;
        return null;
     }

     public PageReference doShowRecent() 
     {
        showRecentResult = true;
        return null;
     }
      
     // Action call when the new list needs to be fetched
    public PageReference refreshSearchResult() 
    {
        return null;
    }
    
    public PageReference newRecord() 
    {
        //PageReference pageRef = new PageReference('/apex/ApttusAgmtWizard?retURL=%2Fa0Y%2Fo&save_new=1&sfdc.override=1');
        Schema.DescribeSObjectResult dsr = Apttus__APTS_Agreement__c.SObjectType.getDescribe();
        string KeyPrefix = dsr.getKeyPrefix();
        //PageReference pageRef = new PageReference('/apex/ApttusAgmtWizard?retURL=%2F/apex/ApttusAgmtHome&save_new=1&sfdc.override=1');
        //return pageRef;
        return new Pagereference('/setup/ui/recordtypeselect.jsp?ent=01IU0000000S6kv&retURL=%2Fa07%2Fo&save_new_url=%2Fa07%2Fe%3FretURL%3D%252Fa07%252Fo');
        
    }

    /**
     * 
     *  Handles selecting and de-selecting search fields form field-set
     */
    User_Custom_Setting__c theSearchFields{get;set;} 
    map<string,cwSelectedFields> searchFieldSetMap = new map<string,cwSelectedFields>();
    map<string,cwSelectedFields> searchResultFieldSetMap = new map<string,cwSelectedFields>();
            
    public list<SelectOption> selectedSearchValues {get;set;}
    public list<SelectOption> unSelectedSearchValues {get;set;}
    public list<SelectOption> selectedResultValues {get;set;}
    public list<SelectOption> unSelectedResultValues {get;set;}
    
    public list<string> leftSelectedSearchFields{get;set;}
    public list<string> rightSelectedSearchFields{get;set;}    

    public list<string> leftSelectedResultFields{get;set;}
    public list<string> rightSelectedResultFields{get;set;} 


    Set<string> selectedSearchFields = new Set<string>();
    Set<string> unSelectedSearchFields = new Set<string>();
    
    Set<string> selectedResultFields = new Set<string>();
    Set<string> unSelectedResultFields = new Set<string>();
    
    public list<string> searchFieldsList {get;set;} 
    public list<string> searchResultFieldsList {get;set;} 
    
    public list<cwSearchFields> cwSearchFieldsList {get;set;} 
        
//-----------------------------------------------------------------------------------------    
    
    public PageReference doshowHideSelectionFilter()
    {
        showSelectionFilter = !showSelectionFilter;
        //if(showSelectionFilter == true)
        //  selectedFieldsInit();
                    
        return null;        
    } 
//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   
     * @Param:  
     * @Return: 
     */       
    public PageReference doshowHideSelectionColumns()
    {
        showSelectionColumns = !showSelectionColumns;                   
        return null;        
    }   
    

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   
     * @Param:  
     * @Return: 
     */ 
    public boolean isFieldSelectedSearch(Schema.FieldSetMember f)
    {
        if(null==selectedSearchFields || selectedSearchFields.contains(f.getFieldPath()))
            return true;
        else
            return false;       
    } 
//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   
     * @Param:  
     * @Return: 
     */ 
    public boolean isFieldSelectedSearch()
    {
        if(null==selectedSearchFields || selectedSearchFields.contains(''))
            return true;
        else
            return false;       
    } 

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Handles selecting and de-selecting result fields form field-set
     * @Param:  
     * @Return: 
     */ 

    public void selectedFieldsInit()  
    {         
         list<cwSelectedFields> cwFieldsList = new list<cwSelectedFields>();

         list<User_Custom_Setting__c>  ASFList = [Select User__c, Search_Fields__c, Result_Fields__c, Name, Id From User_Custom_Setting__c Where User__c = :currentUserId limit 1];
         set<string> alreadySelectedSearchFields;
         set<string> alreadySelectedResultFields;
         system.debug(ASFList);
         
         if(null!=ASFList && ASFList.size()>0)
         {
            theSearchFields = ASFList[0];
            string selFields;
            list<string> alreadySelectedList;
            
            if(null!=theSearchFields.Search_Fields__c)
            {
                alreadySelectedList = theSearchFields.Search_Fields__c.split(';');
                for(Integer i = 0; i<alreadySelectedList.size(); i++)
                    alreadySelectedList[i] = alreadySelectedList[i].trim();
                alreadySelectedSearchFields = new set<string>(alreadySelectedList);
            }

            if(null!=theSearchFields.Result_Fields__c)
            {
                alreadySelectedList = theSearchFields.Result_Fields__c.split(';');
                for(Integer i = 0; i<alreadySelectedList.size(); i++)
                    alreadySelectedList[i] = alreadySelectedList[i].trim();
                    
                alreadySelectedResultFields = new set<string>(alreadySelectedList);
            }           
         }         
         
         for(Schema.FieldSetMember f : this.getFields()) 
         {
            searchFieldSetMap.put(f.getFieldPath(), new cwSelectedFields(f, false));
            if(null!=alreadySelectedSearchFields && alreadySelectedSearchFields.contains(f.getFieldPath()))
            {
                selectedSearchFields.add(f.getFieldPath());
            }
            else
            {               
                unSelectedSearchFields.add(f.getFieldPath());
            }

         }         
         
         for(Schema.FieldSetMember f : this.getSearchResultFields()) 
         {
            searchResultFieldSetMap.put(f.getFieldPath(), new cwSelectedFields(f, false));          
            if(null!=alreadySelectedResultFields && alreadySelectedResultFields.contains(f.getFieldPath()))
            {
                selectedResultFields.add(f.getFieldPath());
            }
            else
            {               
                unSelectedResultFields.add(f.getFieldPath());
            }           
         }
         
         system.debug('selectedSearchFields = ' + selectedSearchFields);
         system.debug('selectedResultFields = ' + selectedResultFields);
                    
         
         refreshSearchFields();
         refreshSearchResultFields();
         refreshOptionValues();
     }
      
//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   
     * @Param:  
     * @Return: 
     */ 
    public void refreshOptionValues()
    {
        selectedSearchValues = SelectOptionValues(selectedSearchFields, searchFieldSetMap);
        unSelectedSearchValues = SelectOptionValues(unSelectedSearchFields, searchFieldSetMap);
        selectedResultValues = SelectOptionValues(selectedResultFields, searchResultFieldSetMap);
        unSelectedResultValues = SelectOptionValues(unSelectedResultFields, searchResultFieldSetMap);               
    }

    //Set Refresh the search fields
    public void refreshSearchFields()
    {         
         searchFieldsList = new list<string>();
         if(null==selectedSearchFields || selectedSearchFields.size()==0)
         {
            selectedSearchFields.addAll(unSelectedSearchFields);
            unSelectedSearchFields.clear();
         }
         searchFieldsList.addAll(selectedSearchFields);
         
         searchFieldsList.sort();
         cwSearchFieldsList = new list<cwSearchFields>();
         set<string> searchFieldSet = new set<string>(searchFieldsList);

         for(Schema.FieldSetMember f : this.getFields()) 
         {
             if(searchFieldSet.contains(f.getFieldPath()))
                cwSearchFieldsList.add(new cwSearchFields(f));
         }  

         system.debug(searchFieldsList);
         system.debug(cwSearchFieldsList);
    }

    //Set Refresh the search Result fields
    public void refreshSearchResultFields() {         
         searchResultFieldsList = new list<string>();
         list<string> resultFieldsListTemp = new list<string>();
         /*
         if(null!=selectedResultFields && selectedResultFields.size()>0)
            resultFieldsListTemp.addAll(selectedResultFields);
         else
            resultFieldsListTemp.addAll(unSelectedResultFields);
         */
         
         if(null==selectedResultFields || selectedResultFields.size()==0)  {
            selectedResultFields.addAll(unSelectedResultFields);
            unSelectedResultFields.clear();
         }
         
         resultFieldsListTemp.addAll(selectedResultFields);     
         
         // include all fields    
         if ( ! unSelectedResultFields.isEmpty()) {
            //resultFieldsListTemp.addAll(unSelectedResultFields);
         }   
         
        for(string strTemp: resultFieldsListTemp)  {
            if(!defaultFields.contains(strTemp)) {
                searchResultFieldsList.add(strTemp);
            }  
        }           
        totalColumns = searchResultFieldsList.size() + 3;
    }
    
    //Save/update the changes with the selected Fields
    public void saveUpdateSelectedValues(set<string> fieldSelectedSet, string opType)
    {
        list<string> listTemp = new list<string>(fieldSelectedSet);
        
        if(null==theSearchFields)
            theSearchFields = new User_Custom_Setting__c(User__c =currentUserId, Object_API_Name__c = 'Apttus__APTS_Agreement__c');
        
        string selectedFields = '';
        for(string str : listTemp)
            selectedFields+= str + ';';
        if(opType.equalsIgnoreCase('Search'))
        {
            theSearchFields.Search_Fields__c = selectedFields;
            refreshSearchFields();
        }
        else
        {
            theSearchFields.Result_Fields__c = selectedFields;
            refreshSearchResultFields();
        }
        
        upsert theSearchFields;
        
    }

    //Adding fields in the Search Fields Set
    public PageReference selectSearchClick()
    {        
        if(null!=rightSelectedSearchFields)
            rightSelectedSearchFields.clear();
            
        if(null!=leftSelectedSearchFields)
        {           
            for(string s : leftSelectedSearchFields)
            {
                unSelectedSearchFields.remove(s);
                selectedSearchFields.add(s);
            }
            refreshOptionValues();
            leftSelectedSearchFields.clear();
            saveUpdateSelectedValues(selectedSearchFields, 'Search');           
        }
        return null;
    } 
      
    //Remove fields in the Search Fields Set    
    public PageReference unSelectSearchClick()
    {
        if(null!=leftSelectedSearchFields)
            leftSelectedSearchFields.clear();
            
        if(null!=rightSelectedSearchFields)
        {
            for(string s : rightSelectedSearchFields)
            {
                selectedSearchFields.remove(s);
                unSelectedSearchFields.add(s);
            }
            refreshOptionValues();
            rightSelectedSearchFields.clear();
            saveUpdateSelectedValues(selectedSearchFields, 'Search');
        }
        return null;
    }

    //Adding fields in the Result Fields Set
    public PageReference selectResultClick()
    {        
        if(null!=rightSelectedResultFields)
            rightSelectedResultFields.clear();
            
        if(null!=leftSelectedResultFields)
        {
            for(string s : leftSelectedResultFields)
            {
                unSelectedResultFields.remove(s);
                selectedResultFields.add(s);
            }
            refreshOptionValues();
            leftSelectedResultFields.clear();
            saveUpdateSelectedValues(selectedResultFields, 'Result');
            
            buildResultList();           
        }
        return null;
    } 

    //Removing fields in the Result Fields Set        
    public PageReference unSelectResultClick()
    {
        if(null!=leftSelectedResultFields)
            leftSelectedResultFields.clear();
            
        if(null!=rightSelectedResultFields)
        {
            for(string s : rightSelectedResultFields)
            {
                selectedResultFields.remove(s);
                unSelectedResultFields.add(s);
            }
            refreshOptionValues();
            rightSelectedResultFields.clear();
            saveUpdateSelectedValues(selectedResultFields, 'Result');
        }
        return null;
    }   

//------------------------------------------------------------------
// this is generic function to create a selectOption collection list based on the set of fields API names
 
    public list<SelectOption> SelectOptionValues(Set<string> fieldSetValues, map<string, cwSelectedFields> fieldSetMap )
    {
        list<string> tempStringList = new list<string>();
        tempStringList.addAll(fieldSetValues);
        tempStringList.sort();
        list<SelectOption> options = new list<SelectOption>();
        list<cwSelectedFields> tempCWList = new list<cwSelectedFields>();
        
        for(string str : tempStringList)        
            if(fieldSetMap.containsKey(str))
                tempCWList.add(fieldSetMap.get(str));        
        
        for(cwSelectedFields s : tempCWList)
            options.add(new SelectOption(s.fieldName,s.fieldLabel));
        return options;
    }   
   
//------------------------------------------------------------------------------------
    static string rid = ''; // change to match the record type for the tab
    boolean byCreatedDate = true; // which list are we showing, simple toggle


    public Apttus__APTS_Agreement__c[] getRecentAgreementsList() 
    {
        if(showRecentResult == true)
        {
            try
            {
                string selectFieldsStr = buildQueryFieldsStr();
                //The selectFieldsStr has the comma at the end, so we need to put the Id field at the end, 
                //before the From and no preceding comma
                string queryStr   = 'Select ' + selectFieldsStr + ' Id From Apttus__APTS_Agreement__c ';
                system.debug(queryStr);
                if (byCreatedDate)
                { 
                    queryStr += ' Where CreatedById = :currentUserId order by createddate desc limit 10';
                    return Database.query(queryStr);
                }
                else
                {
                    queryStr += ' Where LastModifiedById = :currentUserId order by lastmodifieddate desc limit 10';
                    return Database.query(queryStr);
                }
            }
            catch (Exception ex) 
            {
                ApexPages.addMessage(new apexPages.Message(apexPages.Severity.Error,'Error getting existing Agreements: ' + ex.getMessage())); 
            }   
        }
        return null;

    }

    
    public PageReference changeRt() 
    { // toggle a static var to flip between recent modified or created items
        byCreatedDate = ( ! byCreatedDate) ;
        return null;
    } 
    
//--------------------------------------------------------------------------------------------
    public void testPrivateMethods()
    {
     //This method can only be called from a test method.
     //This method allows calling a private method from test code to allow for faster test performance.
     
        if (test.isRunningTest())
        {
            pageInit();
        }
        else
            system.debug('This method can only be called from a test.'); 
    }   
    
//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Wrapper class Agreements with associated document Id    
     */     
    public class  cwSelectedFields
    {
        public string   fieldLabel {get;set;}
        public string   fieldName {get;set;}
        public string   fieldType {get;set;}
        public boolean  isSelected {get;set;}
        public boolean  isDate {get;set;}
        /*
        cwSelectedFields (string fName)
        {
            fieldName = fName;
            isSelected = false;
        }
        cwSelectedFields (string fName, boolean isSel)
        {
            fieldName = fName;
            isSelected = isSel;
        }*/
        cwSelectedFields (Schema.FieldSetMember f, boolean  isSel)
        {
            fieldLabel = f.getLabel();
            fieldName = f.getFieldPath();
            fieldType = string.valueOf(f.getType());
            isSelected = isSel;
            if(f.getType() == Schema.DisplayType.Date || f.getType() == Schema.DisplayType.datetime)
                isDate = true;
            else
                isDate = false;
        }
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Wrapper class for the search fields 
     */ 
    public class  cwSearchFields 
    {
        public string   fieldLabel {get;set;}
        public string   fieldName {get;set;}
        public string   fieldType {get;set;}
        public string   fieldValueInput {get;set;}
        public boolean  isDate {get;set;}
        public boolean  isReference {get;set;}
        public boolean  isBoolean {get;set;}
        public string   fromDate {get;set;}
        public string   toDate {get;set;}
        
        public cwSearchFields (Schema.FieldSetMember f) 
        {
            isBoolean = false;
            isDate = false;
            isReference = false;
            fieldLabel = f.getLabel();
            fieldName = f.getFieldPath();
            fieldType = string.valueOf(f.getType());
            if(f.getType() == Schema.DisplayType.Date || f.getType() == Schema.DisplayType.datetime)
                isDate = true;
                                
            if(f.getType() == Schema.DisplayType.REFERENCE)
                isReference = true;
            
            if(f.getType() == Schema.DisplayType.Boolean)
                isBoolean = true;
        }
    }
    
//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Wrapper class Agreements with associated document Id    
     */ 

    public class AgmtDocWrapper 
    {
        public Apttus__APTS_Agreement__c agmt {get; set;}
        public ID docId {get; set;}
        
        public AgmtDocWrapper (Apttus__APTS_Agreement__c agmt, ID docId) 
        {
            this.agmt = agmt;
            this.docId = docId;
        }
    }    
}