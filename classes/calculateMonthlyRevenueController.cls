public with sharing class calculateMonthlyRevenueController{
   
    /*
    * @Description: To calculate monthly revenue for reporting 
    * @Revised in R5
    * @param: List<OpportunityLineItem>, Boolean Flag
    */
   public static void calculateMonthlyRevenue(List<OpportunityLineItem> opptyLineItems){
        for (OpportunityLineItem oli : opptyLineItems) {
            Date contractStartDate;
            Date contractEndDate;
            Date QuoteEndDate;
            //use contract dates if oli from contract - use quote dates if quote oli have already been synced
            if(oli.Contract_Start_Date__c!=null && oli.Contract_End_Date__c!=null){
                contractStartDate = oli.Contract_Start_Date__c;
                contractEndDate = oli.Contract_End_Date__c;
            }else if(oli.Quote_Start_Date__c!=null && oli.Quote_End_Date__c!=null){
                contractStartDate = oli.Quote_Start_Date__c;
                contractEndDate = oli.ServiceDate;
                QuoteEndDate = oli.Quote_End_Date__c;
            }
            
            
            
            if (contractStartDate != null && contractEndDate != null) {
                Integer csdYear = contractStartDate.year();
                Integer csdMonth = contractStartDate.month();
                Integer csdDay = contractStartDate.day()-1;
                Integer daysInStartMonth = date.daysInMonth(csdYear, csdMonth) - csdDay;
                Integer cedYear = contractEndDate.year();
                Integer cedMonth = contractEndDate.month();
                Integer cedDay = contractEndDate.day();
                Integer totalContractDays = contractStartDate.daysBetween(contractEndDate);
                if (oli.RTS_Component__c == null){
                    oli.RTS_Component__c = 0;
                }
                
                if(totalContractDays!=0){
                    Decimal perDayRevenue = (oli.Subtotal - oli.RTS_Component__c) / totalContractDays;
                
                if (csdYear == cedYear && csdMonth == cedMonth) {
                    oli.Month_1_Revenue__c = (totalContractDays * perDayRevenue) + oli.RTS_Component__c;
                    oli.Month_2_Revenue__c = 0;
                    oli.Month_3_Revenue__c = 0;
                    oli.Month_4_Revenue__c = 0;
                    oli.Month_5_Revenue__c = 0;
                    oli.Month_6_Revenue__c = 0;
                    oli.Month_7_Revenue__c = 0;
                    oli.Month_8_Revenue__c = 0;
                    oli.Month_9_Revenue__c = 0;
                    oli.Month_10_Revenue__c = 0;
                    oli.Month_11_Revenue__c = 0;
                    oli.Month_12_Revenue__c = 0;
                } else {
                
                    oli.Month_1_Revenue__c = (daysInStartMonth * perDayRevenue) + oli.RTS_Component__c;
                    
                    Date secondMonthDate = contractStartDate.addMonths(1);
                    if (cedMonth == secondMonthDate.month() && cedYear == secondMonthDate.year()) {
                        oli.Month_2_Revenue__c = cedDay * perDayRevenue;
                        oli.Month_3_Revenue__c = 0;
                        oli.Month_4_Revenue__c = 0;
                        oli.Month_5_Revenue__c = 0;
                        oli.Month_6_Revenue__c = 0;
                        oli.Month_7_Revenue__c = 0;
                        oli.Month_8_Revenue__c = 0;
                        oli.Month_9_Revenue__c = 0;
                        oli.Month_10_Revenue__c = 0;
                        oli.Month_11_Revenue__c = 0;
                        oli.Month_12_Revenue__c = 0;
                    } else if ( secondMonthDate.year() < cedYear || (secondMonthDate.month() < cedMonth && secondMonthDate.year() == cedYear)){
                        oli.Month_2_Revenue__c = date.daysInMonth(secondMonthDate.year(), secondMonthDate.month()) * perDayRevenue;
                    }
                    Date thirdMonthDate = contractStartDate.addMonths(2);
                    if (cedMonth == thirdMonthDate.month() && cedYear == thirdMonthDate.year()) {
                        oli.Month_3_Revenue__c = cedDay * perDayRevenue;
                        oli.Month_4_Revenue__c = 0;
                        oli.Month_5_Revenue__c = 0;
                        oli.Month_6_Revenue__c = 0;
                        oli.Month_7_Revenue__c = 0;
                        oli.Month_8_Revenue__c = 0;
                        oli.Month_9_Revenue__c = 0;
                        oli.Month_10_Revenue__c = 0;
                        oli.Month_11_Revenue__c = 0;
                        oli.Month_12_Revenue__c = 0;
                    } else if ( (thirdMonthDate.month() < cedMonth && thirdMonthDate.year() == cedYear) || thirdMonthDate.year() < cedYear ){
                        oli.Month_3_Revenue__c = date.daysInMonth(thirdMonthDate.year(), thirdMonthDate.month()) * perDayRevenue;
                    }
                    Date forthMonthDate = contractStartDate.addMonths(3);
                    if (cedMonth == forthMonthDate.month() && cedYear == forthMonthDate.year()) {
                        oli.Month_4_Revenue__c = cedDay * perDayRevenue;
                        oli.Month_5_Revenue__c = 0;
                        oli.Month_6_Revenue__c = 0;
                        oli.Month_7_Revenue__c = 0;
                        oli.Month_8_Revenue__c = 0;
                        oli.Month_9_Revenue__c = 0;
                        oli.Month_10_Revenue__c = 0;
                        oli.Month_11_Revenue__c = 0;
                        oli.Month_12_Revenue__c = 0;
                    } else if ( (forthMonthDate.month() < cedMonth && forthMonthDate.year() == cedYear) || forthMonthDate.year() < cedYear ){
                        oli.Month_4_Revenue__c = date.daysInMonth(forthMonthDate.year(), forthMonthDate.month()) * perDayRevenue;
                    }
                    Date fifthMonthDate = contractStartDate.addMonths(4);
                    if (cedMonth == fifthMonthDate.month() && cedYear == fifthMonthDate.year()) {
                        oli.Month_5_Revenue__c = cedDay * perDayRevenue;
                        oli.Month_6_Revenue__c = 0;
                        oli.Month_7_Revenue__c = 0;
                        oli.Month_8_Revenue__c = 0;
                        oli.Month_9_Revenue__c = 0;
                        oli.Month_10_Revenue__c = 0;
                        oli.Month_11_Revenue__c = 0;
                        oli.Month_12_Revenue__c = 0;
                    } else if ( (fifthMonthDate.month() < cedMonth && fifthMonthDate.year() == cedYear) || fifthMonthDate.year() < cedYear ){
                        oli.Month_5_Revenue__c = date.daysInMonth(fifthMonthDate.year(), fifthMonthDate.month()) * perDayRevenue;
                    }
                    Date sixthMonthDate = contractStartDate.addMonths(5);
                    if (cedMonth == sixthMonthDate.month() && cedYear == sixthMonthDate.year()) {
                        oli.Month_6_Revenue__c = cedDay * perDayRevenue;
                        oli.Month_7_Revenue__c = 0;
                        oli.Month_8_Revenue__c = 0;
                        oli.Month_9_Revenue__c = 0;
                        oli.Month_10_Revenue__c = 0;
                        oli.Month_11_Revenue__c = 0;
                        oli.Month_12_Revenue__c = 0;
                    } else if ( (sixthMonthDate.month() < cedMonth && sixthMonthDate.year() == cedYear) || sixthMonthDate.year() < cedYear ){
                        oli.Month_6_Revenue__c = date.daysInMonth(sixthMonthDate.year(), sixthMonthDate.month()) * perDayRevenue;
                    }
                    Date seventhMonthDate = contractStartDate.addMonths(6);
                    if (cedMonth == seventhMonthDate.month() && cedYear == seventhMonthDate.year()) {
                        oli.Month_7_Revenue__c = cedDay * perDayRevenue;
                        oli.Month_8_Revenue__c = 0;
                        oli.Month_9_Revenue__c = 0;
                        oli.Month_10_Revenue__c = 0;
                        oli.Month_11_Revenue__c = 0;
                        oli.Month_12_Revenue__c = 0;
                    } else if ( (seventhMonthDate.month() < cedMonth && seventhMonthDate.year() == cedYear) || seventhMonthDate.year() < cedYear ){
                        oli.Month_7_Revenue__c = date.daysInMonth(seventhMonthDate.year(), seventhMonthDate.month()) * perDayRevenue;
                    }
                    Date eighthMonthDate = contractStartDate.addMonths(7);
                    if (cedMonth == eighthMonthDate.month() && cedYear == eighthMonthDate.year()) {
                        oli.Month_8_Revenue__c = cedDay * perDayRevenue;
                        oli.Month_9_Revenue__c = 0;
                        oli.Month_10_Revenue__c = 0;
                        oli.Month_11_Revenue__c = 0;
                        oli.Month_12_Revenue__c = 0;
                    } else if ( (eighthMonthDate.month() < cedMonth && eighthMonthDate.year() == cedYear) || eighthMonthDate.year() < cedYear ){
                        oli.Month_8_Revenue__c = date.daysInMonth(eighthMonthDate.year(), eighthMonthDate.month()) * perDayRevenue;
                    }
                    Date ninthMonthDate = contractStartDate.addMonths(8);
                    if (cedMonth == ninthMonthDate.month() && cedYear == ninthMonthDate.year()) {
                        oli.Month_9_Revenue__c = cedDay * perDayRevenue;
                        oli.Month_10_Revenue__c = 0;
                        oli.Month_11_Revenue__c = 0;
                        oli.Month_12_Revenue__c = 0;
                    } else if ( (ninthMonthDate.month() < cedMonth && ninthMonthDate.year() == cedYear) || ninthMonthDate.year() < cedYear ){
                        oli.Month_9_Revenue__c = date.daysInMonth(ninthMonthDate.year(), ninthMonthDate.month()) * perDayRevenue;
                    }
                    Date tenthMonthDate = contractStartDate.addMonths(9);
                    if (cedMonth == tenthMonthDate.month() && cedYear == tenthMonthDate.year()) {
                        oli.Month_10_Revenue__c = cedDay * perDayRevenue;
                        oli.Month_11_Revenue__c = 0;
                        oli.Month_12_Revenue__c = 0;
                    } else if ( (tenthMonthDate.month() < cedMonth && tenthMonthDate.year() == cedYear) || tenthMonthDate.year() < cedYear ){
                        oli.Month_10_Revenue__c = date.daysInMonth(tenthMonthDate.year(), tenthMonthDate.month()) * perDayRevenue;
                    }
                    Date eleventhMonthDate = contractStartDate.addMonths(10);
                    if (cedMonth == eleventhMonthDate.month() && cedYear == eleventhMonthDate.year()) {
                        oli.Month_11_Revenue__c = cedDay * perDayRevenue;
                        oli.Month_12_Revenue__c = 0;
                    } else if ( (eleventhMonthDate.month() < cedMonth && eleventhMonthDate.year() == cedYear) || eleventhMonthDate.year() < cedYear ){
                        oli.Month_11_Revenue__c = date.daysInMonth(eleventhMonthDate.year(), eleventhMonthDate.month()) * perDayRevenue;
                    }
                    Date twelthMonthDate = contractStartDate.addMonths(11);
                    if (cedMonth == twelthMonthDate.month() && cedYear == twelthMonthDate.year()) {
                        oli.Month_12_Revenue__c = cedDay * perDayRevenue;
                    } else if ( (twelthMonthDate.month() < cedMonth && twelthMonthDate.year() == cedYear) || twelthMonthDate.year() < cedYear ){
                        oli.Month_12_Revenue__c = date.daysInMonth(twelthMonthDate.year(), twelthMonthDate.month()) * perDayRevenue;
                    }
                    
                    
                }
                }
            }
        }
        
    }
    
    
    
}