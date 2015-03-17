public with sharing class CurrencyConversionUtil {

 public static double GetCoversionRate(String sfromCurrency ,String toCurrency, Date sExchangeDate)
 {
    Double conversionRate=0.0;
    Double FromCurr_to_orgCon=1.0;
    Double FromTocurr_to_orgCon=1.0;
    
    if(sfromCurrency==toCurrency)
    {
        conversionRate=1.0;
    }
    else
    {
        List<String> CurrencyList= new List<String>{sfromCurrency,toCurrency};
        List<DatedConversionRate> oConversionList=[SELECT ConversionRate,NextStartDate,StartDate,IsoCode 
                                                FROM DatedConversionRate
                                                 where IsoCode in :CurrencyList and StartDate<=:sExchangeDate and NextStartDate>:sExchangeDate];
        System.debug('*****************Conversion List**************'+oConversionList);
        if(oConversionList.isEmpty())
        {
         conversionRate=1.0;    
        }
        else
        {
           
           for(DatedConversionRate oCurrCon:oConversionList)
           {
             if(sfromCurrency==oCurrCon.IsoCode)
             {
                FromCurr_to_orgCon=oCurrCon.ConversionRate;
             }
             
             if(toCurrency==oCurrCon.IsoCode)
             {
                FromTocurr_to_orgCon=oCurrCon.ConversionRate;
             }
           }
        }                                        
        conversionRate= FromTocurr_to_orgCon/FromCurr_to_orgCon;                                    
    }
    System.debug('*****************************FromCurr_to_orgCon:'+FromCurr_to_orgCon+'\n**FromTocurr_to_orgCon****'+FromTocurr_to_orgCon);
    System.debug('*****************Conversion Rate**************'+conversionRate);
    return(conversionRate);                                          
 }
}