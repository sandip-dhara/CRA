public class RetrieveObjectURL {

    private String sObjectName;
    private String sObjectUniqueReferenceAPIName;
    private String SOQLStatement;
    private String sObjectNameParamValue = '';
    private String sUniqueIdValue = '';
    public string redirectPageUrl{get;set;}

    public RetrieveObjectURL() {
        sObjectNameParamValue = ApexPages.currentPage().getParameters().get('Object');
        sUniqueIdValue = ApexPages.currentPage().getParameters().get('ID');
        redirectPageUrl = '';
    }
    public PageReference RedirectURL() {

        System.debug('*************Object Name: ' + sObjectNameParamValue + ' Id Value: ' + sUniqueIdValue + '******************');
        ObjectURLMapping__c oObjectMapping = ObjectURLMapping__c.getInstance(sObjectNameParamValue);
        SObject oObjectRef;
        try {
            if (oObjectMapping != null) {
                sObjectName = oObjectMapping.ObjectName__c;
                sObjectUniqueReferenceAPIName = oObjectMapping.Searchable_Field__c;
                SOQLStatement = 'SELECT Id from ' + sObjectName + ' where ' + sObjectUniqueReferenceAPIName + '=\'' + sUniqueIdValue + '\' limit 1';
                System.debug('**************' + SOQLStatement);
                oObjectRef = Database.Query(SOQLStatement);
                redirectPageUrl = '/' + oObjectRef.Id;
                //return (new PageReference('/' + oObjectRef.Id+'?isdtp=vw'));
                return null;
            }
            else
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to find the Mapping for Object '+sObjectNameParamValue+'. Please contact Administrator' );
                ApexPages.addMessage(msg);
            }
        } 
        
        catch (System.QueryException e) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to Retrieve ' + sObjectNameParamValue + ' records <br/>'+'Reason: '+e.getMessage());
            ApexPages.addMessage(msg);
            return (null);
        }
        
        catch (Exception e) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg);
            return (null);
        }

        return null;
    }

}