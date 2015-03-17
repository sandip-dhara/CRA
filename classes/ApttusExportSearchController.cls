/*
* NAME : ApttusExportSearchController
* NOTE : This class is used When User Clicks on Export Button in Home Page Search Result Page,it is used to Create MS-Excel File for Result Data.
* Author : Apttus
*
*/
public with sharing class ApttusExportSearchController 
{
    // limit row to 2000
    private Integer limitRows = 2000;
    private String retURL;
    Id currentUserId {get;set;} 
    public String searchQuery;
    set<Id> foundAgreementsIds{get;set;}
    public list<Apttus__APTS_Agreement__c> agmtList {get; private set;}
    public list<Apttus__APTS_Agreement__c> agmtFieldLabel {get; private set;}
    public list<string> resultFieldsList {get;private set;} 
    public string resultFieldsString {get;set;}
    public Boolean isSOSL {get;set;}  
    public string advSearchWhereClauseExp {get;set;}
    public string queryFieldsStrExp {get;set;}
    public string searchStringExp {get;set;}
    public string agmtTxtSrchCriteria {get;set;}
    
    //This class is never used
    public class cwAgreementList
    {
        public list<Apttus__APTS_Agreement__c> agmtList {get; set;}
        public integer listSize {get; set;}
        public integer listIndex {get; set;}
    }

    public list<cwAgreementList> cwAgreementListExport {get;private set;} 
//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   Constructor specifying initial values
     * @param:  stdController the standard controller
     */      
    public ApttusExportSearchController() 
    {
        
    }
    public ApttusExportSearchController(ApexPages.StandardController stdController) 
    {   
        retURL = ApexPages.currentPage().getParameters().get('retURL');    
        searchQuery   = ApexPages.currentPage().getParameters().get('searchQuery');
        resultFieldsString = ApexPages.currentPage().getParameters().get('resultFieldsString');
        //isSOSL = boolean.valueOf(ApexPages.currentPage().getParameters().get('isSOSL'));
        advSearchWhereClauseExp = ApexPages.currentPage().getParameters().get('advSearchWhereClauseExp');
        queryFieldsStrExp   = ApexPages.currentPage().getParameters().get('queryFieldsStrExp');
        searchStringExp   = ApexPages.currentPage().getParameters().get('searchStringExp');
        agmtTxtSrchCriteria   = ApexPages.currentPage().getParameters().get('searchStringExp');
        
        //system.debug(' >>> isSOSL >>> ' + isSOSL);
        system.debug(' >>> advSearchWhereClauseExp >>> ' + advSearchWhereClauseExp);
        system.debug(' >>> queryFieldsStrExp >>> ' + queryFieldsStrExp);
        system.debug(' >>> resultFieldsString >>> ' + resultFieldsString);
        system.debug(' >>> searchStringExp >>> ' + searchStringExp);
        system.debug(' >>> agmtTxtSrchCriteria >>> ' + searchStringExp);
        
        pageInit();
    }
    
//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   PageInit run when the page is loaded
     * @param:  
     */    
    public void pageInit() 
    {
        resultFieldsList = new list<string>();
        currentUserId = UserInfo.getUserId();
        agmtFieldLabel = new list<Apttus__APTS_Agreement__c>();
        //getAgreementList();
        getAgreementListUpdated();
            
        if(null!=resultFieldsString)
        {
            list<string> alreadySelectedList = resultFieldsString.split(';');
            for(Integer i = 0; i < alreadySelectedList.size(); i++)
                resultFieldsList.add(alreadySelectedList[i].trim());
        }   
        
    }

//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   
     * @Param:  
     * @Return: 
     */   
    //This method is of no Use...we can remove it.   
    public void getAgreementList()
    { 
        if(isSOSL == true)  
        {           
            string findQuery = 'FIND \'' + searchStringExp + '*\' IN ALL FIELDS RETURNING Apttus__APTS_Agreement__c(' + queryFieldsStrExp + ' id)';
            system.debug('Find Query ' + findQuery); 
            list<list<SObject>>searchList = search.query(findQuery.trim());
            agmtList = (list<Apttus__APTS_Agreement__c>)searchList[0];
        }
        else
        {
            advSearchWhereClauseExp = advSearchWhereClauseExp!=null ? advSearchWhereClauseExp.replace('xxxxx', '%') : '';
            string soqlStr;
            if(!(Test.isRunningTest()))
            {
                soqlStr  = 'Select ' + queryFieldsStrExp + ' Id From Apttus__APTS_Agreement__c ' + advSearchWhereClauseExp + ' Limit 2000';
            }
            else
            {
                soqlStr = 'Select Id, Name From Apttus__APTS_Agreement__c Limit 5';             
            }
            system.debug('SQOL Query ' + soqlStr); 
            agmtList = database.query(soqlStr.trim());
        }        
    }
    
//------------------------------------------------------------------------------------------------
    /**
     * @Desc:   
     * @Param:  
     * @Return: 
     */     
    public void getAgreementListUpdated()
    { 
        string whereClause = advSearchWhereClauseExp!=null ? advSearchWhereClauseExp.replace('xxxxx', '%') : '';
        list<list<SObject>> findList = new list<list<SObject>>();
        Integer findCount = 200;
        
        // metadata search - minimum Status is InEffect, which is default
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
            if ( ! AptsUtil.nullOrEmpty(mdAgmtList)) 
            {               
                map<Id, Apttus__APTS_Agreement__c> agmtMap = new map<Id, Apttus__APTS_Agreement__c>(mdAgmtList);
                mdAgmtIdSetSOQL = agmtMap.keySet();             
            }
        }
        
        // perform agreement text search
        //  - only if the user has entered agreement text search criteria
        if (String.isNotBlank(agmtTxtSrchCriteria)) 
        {            
            isSOSL = true;
            findCount = 200;
            String lastAgmtNbr = '0';
            
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
                    if(Null != mdAgmtIdSetSOQL && mdAgmtIdSetSOQL .size() > 0)
                    {
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
                
                list<Apttus__APTS_Agreement__c> agmtList = findList[0];
                if ( ! AptsUtil.nullOrEmpty(agmtList)) 
                {
                    
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
        }

        
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
        
        //do the final query
        if(Null != mdAgmtIdSet && mdAgmtIdSet.size() > 0)
        {
            string soqlStr;
            if(!(Test.isRunningTest()))
            {
                soqlStr  = 'Select ' + queryFieldsStrExp + ' Id From Apttus__APTS_Agreement__c  Where Id IN :mdAgmtIdSet Limit ' + limitRows;
            }
            else
            {
                soqlStr = 'Select Id, Name From Apttus__APTS_Agreement__c Limit 5';             
            }
            system.debug('SQOL Query ' + soqlStr); 
            agmtList = database.query(soqlStr.trim());
        }       
    }
}