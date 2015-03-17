global class CPQConvertTimeZone
{
    Webservice static String ConvertTimeZoneValue(String TimeZoneParameter)
    {
        string RetTimeZoneValue;
        Schema.DescribeFieldResult fieldResult = Case.Requestor_s_TimeZone__c.getDescribe();
        List<Schema.PicklistEntry> TimeZoneListofVaues = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry timeZoneVlaue: TimeZoneListofVaues)
        {
            if(timeZoneVlaue.getValue().contains(TimeZoneParameter))
            {
                RetTimeZoneValue = timeZoneVlaue.getValue();
                break;
            }
        }
        return RetTimeZoneValue;
    }
}