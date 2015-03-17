public class AthenaUtility1
{

    public string ApplicationSettingValue(string Name)
    {
    Application_Setting__c appSetng=[SELECT Name__c,Value__c FROM Application_Setting__c where Name__c=:Name];
    return appSetng.Value__c;
    }

    public List<Tag__c> getTags(){
    List<Tag__c> tags=[SELECT Value__c FROM Tag__c];
    return tags;
    }
}