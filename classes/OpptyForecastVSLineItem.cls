/**********************************************************
* Class Name: OpptyForecastVSLineItem
* Author: Debmalya, HP
* Date: 06-Aug-2013   
* Description: Class to get Revenues against GBU for Current Quarter
***********************************************************/


public without sharing class OpptyForecastVSLineItem {
    
    public class ForecaseData {
        public Decimal pipeline_Count{get; set;}
        public Decimal upside_Count{get; set;}
        public Decimal commit_Count{get; set;}
        public Decimal won_Count{get; set;}
        
        public ForecaseData(){
            pipeline_Count = 0;
            upside_Count = 0;
            commit_Count = 0;
            won_Count = 0;
        }
    }
    
    public Map<String,ForecaseData> mapBGVsForecast{get; set;}
    public Id userId;
    public Date quarterStartDate;
    public Date quarterEndDate;
    public Id reportId{get; set;}
    public String users_Currency{get; set;}
    
    public OpptyForecastVSLineItem(){
        Map<Id,Decimal> revFromOtherQuarter = new Map<Id,Decimal>();
        mapBGVsForecast = new Map<String,ForecaseData>();
        userId = UserInfo.getUserId();
        users_Currency = UserInfo.getDefaultCurrency();
        List<Id> opptyId = new List<Id>();
        
        calculateQuarterEndDate();                    //Get Quarter start and end Dates
        system.debug('startDate' + quarterStartDate);
        system.debug('EndDate' + quarterEndDate);
        
        List<OpportunityLineItem> listrecs = new List<OpportunityLineItem>();
        
        //Based on from which the Constructor is invoked, we either need to get My Opoortunities or My Team's Opportunities
        if(ApexPages.CurrentPage().getUrl().contains('VFPageforReport')){
            listrecs = getMyOptyLineItemList();
        }else if(ApexPages.CurrentPage().getUrl().contains('VFPageforTeamReport')){
            listrecs = getMyTeamOptyLineItemList();
        }
        
        //Get Revnenues from Opportunity Line Items where Scheduled date falls in different Quarter
        revFromOtherQuarter = remSchedItemInOtherQuar(listrecs);
        
        for(OpportunityLineItem rec : listrecs){
            ForecaseData getRecordValues = mapBGVsForecast.get(rec.GBU__c);
            if(getRecordValues == null){
                getRecordValues = new ForecaseData(); 
            }
            Decimal tempRev = rec.Subtotal.round();
            //If Revenues Scheduled outside Current Quarter exists, Subtract it from this Quarter's Revenue
            if(revFromOtherQuarter != null && revFromOtherQuarter.get(rec.Id) != null){
                tempRev = tempRev - revFromOtherQuarter.get(rec.Id);
            }
            if(rec.Opportunity.ForecastCategoryName == 'Pipeline'){
                getRecordValues.pipeline_Count = getRecordValues.pipeline_Count + tempRev;
            }else If(rec.Opportunity.ForecastCategoryName == 'Upside'){
                getRecordValues.upside_Count = getRecordValues.upside_Count + tempRev;
            }else If(rec.Opportunity.ForecastCategoryName == 'Commit'){
                getRecordValues.commit_Count = getRecordValues.commit_Count + tempRev;
            }else If(rec.Opportunity.ForecastCategoryName == 'Won'){
                getRecordValues.won_Count = getRecordValues.won_Count + tempRev;
            }
            mapBGVsForecast.put(rec.GBU__c,getRecordValues);
        }
    }
    
    /**
    * @description: Gets OpportunityLineitems from My Opportunites in this Quarter
    **/
    public List<OpportunityLineItem> getMyOptyLineItemList(){
        List<Report> repIdList = new List<Report>([SELECT Id FROM Report WHERE Name = 'MyOpptyForecastVsGBUONScheduleDate']);
        reportId = repIdList[0].Id;
        
        List<OpportunityLineItem> listrecs = [SELECT GBU__c,HasSchedule,convertCurrency(Subtotal),Opportunity.ForecastCategoryName,Opportunity.CurrencyISOCode FROM OpportunityLineItem where Opportunity.OwnerId = :userId AND Opportunity.ForecastCategoryName != 'Omitted' AND ServiceDate >= :quarterStartDate AND ServiceDate <= :quarterEndDate];
        return listrecs;
    }
    
    /**
    * @description: Gets OpportunityLineitems from My Team's Opportunites in this Quarter
    **/
    public List<OpportunityLineItem> getMyTeamOptyLineItemList(){
        List<Id> opptyId = new List<Id>();
        
        List<Report> repIdList = new List<Report>([SELECT Id FROM Report WHERE Name = 'MyTeamOpptyForecastVsGBUOnScheduleDate']);
        reportId = repIdList[0].Id;
        
        for(OpportunityTeamMember otmrec: [SELECT OpportunityId FROM OpportunityTeamMember where UserId =: userId]){
            opptyId.add(otmrec.OpportunityId);
        }
        
        List<OpportunityLineItem> listrecs = [SELECT GBU__c,convertCurrency(Subtotal),HasSchedule,Opportunity.ForecastCategoryName,Opportunity.CurrencyISOCode FROM OpportunityLineItem where OpportunityId In :opptyId AND Opportunity.ForecastCategoryName != 'Omitted' AND ServiceDate >= :quarterStartDate AND ServiceDate <= :quarterEndDate];
        return listrecs;
    }
    
    /**
    * @description: Gets revenues for Scheduled Line items Scheduled in different Quarter
    **/
    public Map<Id,Decimal> remSchedItemInOtherQuar(List<OpportunityLineItem> listOppLineItem){
        Set<Id> setIdOppLineItems = new Set<Id>();
        Map<Id,Decimal> oppLineItemIdRev = new Map<Id,Decimal>();
        
        for(OpportunityLineItem oltrec: listOppLineItem){
            if(oltrec.HasSchedule){
                setIdOppLineItems.add(oltrec.Id);
            }
        }
        
        for(OpportunityLineItemSchedule oltSchrec : [Select OpportunityLineItemId,convertCurrency(Revenue) from OpportunityLineItemSchedule where OpportunityLineItemId In: setIdOppLineItems AND (ScheduleDate < :quarterStartDate OR ScheduleDate > :quarterEndDate) AND Revenue != null]){
            Decimal rev = oppLineItemIdRev.get(oltSchrec.OpportunityLineItemId);
            if(rev == null){
                rev = oltSchrec.Revenue.round();
            }else{
                rev = rev + oltSchrec.Revenue.round();
            }
            oppLineItemIdRev.put(oltSchrec.OpportunityLineItemId,rev);
        }
        
        return oppLineItemIdRev;
    }
    
    /**
    * @description: Calculates Quarter Start and End Dates
    **/
    public void calculateQuarterEndDate(){
        Integer FiscalYearStartMonth = [select FiscalYearStartMonth from Organization where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;

        Date fiscalYearStartDate;
        Integer quarter;
        
        if(system.today().month() >= FiscalYearStartMonth)
        {
            fiscalYearStartDate = date.newinstance(system.today().year(), FiscalYearStartMonth, 1);
            quarter = ((system.today().month() - FiscalYearStartMonth) / 3) + 1;
        }
        else
        {
            fiscalYearStartDate = date.newinstance(system.today().year() - 1, FiscalYearStartMonth, 1);
            quarter = ((12 + system.today().month() - FiscalYearStartMonth) / 3) + 1;
        }    
        
        Integer addMonths = quarter * 3;
        
        Date lastDateOfThisQuarter = fiscalYearStartDate;
        
        // this is the last date of the current quarter
        quarterEndDate = lastDateOfThisQuarter.addMonths(addMonths).addDays(-1);
        Date startDateOfThisQuarter = quarterEndDate.addMonths(-2);
        quarterStartDate = startDateOfThisQuarter.addDays(-date.daysInMonth(startDateOfThisQuarter.year(),startDateOfThisQuarter.month())+1);
    }
}