public class AP_SortHelper1 {     // <ID, Position>
    private Map<String, Integer> listPosition = null;    // <FieldName, <FieldValues>>
    private Map<String, List<String>> sortedFieldValuesPerFieldName = null;     // <FieldName, <FieldValue, <IDs>>>
    private Map<String, Map<String, List<String>>> sObjectIDsPerFieldNames = null;
    
// Properties
    public List<sObject> originalList {get; set;}
    
// Constructor
    public AP_SortHelper1() {
        originalList = null;
    }// Public Method
    public List<sObject> getSortedList(String fieldName, Boolean ascending) {
        if (originalList == null) {
            // Assume that originalList has a not NULL value.
            // If the class who uses this method has not assigned a value it will get an Exception which
            //    needs to be handled by the calling class.            // Force the exception...
            originalList.clear();
        }        // Make field name uppercase
        fieldName = fieldName.toUpperCase();        // Get sorted list
        return makeSortedList(fieldName, ascending);
    }
    public List<sObject> getSortedList(List<sObject> originalList, String fieldName, Boolean ascending) {
        this.originalList = originalList;
        sortedFieldValuesPerFieldName = null;
        return getSortedList(fieldName, ascending);
    }
    
// Private Methods
    private void InitializeFieldName(String fieldName) {
        String sObjectID;
        Integer position;
        String fieldValue;
        List<String> sObjectIDs = null;
        Set<String> valuesForFieldSet = null;    // Sets automatically omit duplicate values 
        List<String> valuesForFieldList = null;
        Map<String, List<String>> sObjectIDsPerFieldValues = null;
        
        // Make sortedFieldValuesPerFieldName
        if (sortedFieldValuesPerFieldName == null) {
            listPosition = new Map<String, Integer>();
            sortedFieldValuesPerFieldName = new Map<String, List<String>>();
            sObjectIDsPerFieldNames = new Map<String, Map<String, List<String>>>();
        }
        
        // Get (or create) map of sObjectIDsPerFieldValues
        sObjectIDsPerFieldValues = sObjectIDsPerFieldNames.get(fieldName);
        if (sObjectIDsPerFieldValues == null) {
            sObjectIDsPerFieldValues = new Map<String, List<String>>();
            sObjectIDsPerFieldNames.put(fieldName, sObjectIDsPerFieldValues);
        }
        if (!sortedFieldValuesPerFieldName.keySet().contains(fieldName)) {
            // Objects need to be initialized
            position = 0;
            valuesForFieldSet = new Set<String>();
            listPosition = new Map<String, Integer>();
            
            for (sObject sObj : originalList) {
                sObjectID = sObj.ID;
                fieldValue = getValue(sObj, fieldName);
                
                // Add position to list
                listPosition.put(sObjectID, position++);
                
                // Add the value to the set (sets rather than lists to prevent duplicates)
                valuesForFieldSet.add(fieldValue);
                
                // Get (or create) map of sObjectIDs
                sObjectIDs = sObjectIDsPerFieldValues.get(fieldValue);
                if (sObjectIDs == null) {
                    sObjectIDs = new List<String>();
                    sObjectIDsPerFieldValues.put(fieldValue, sObjectIDs);
                }
                
                // Add ID to sObjectIDs
                sObjectIDs.add(sObjectID);
            }
            
            // Sort set items (Need to convert to list)
            valuesForFieldList = new List<String>();
            valuesForFieldList.addAll(valuesForFieldSet);
            valuesForFieldList.sort();
            
            // Now add it to the map.
            sortedFieldValuesPerFieldName.put(fieldName, valuesForFieldList);
        }
    }
    private List<sObject> makeSortedList(String fieldName, Boolean ascending) {
        Integer position;
        List<String> sObjectIDs = null;
        List<String> valuesForFieldList = null;        // Initialize objects
        InitializeFieldName(fieldName);        // Get a list of the same type as the "originalList"
        List<sObject> outputList = originalList.clone();
        outputList.clear();        // Get a list of sorted values
        valuesForFieldList = sortedFieldValuesPerFieldName.get(fieldName);
        
        // for each sorted value
        for (String fieldValue : valuesForFieldList) {
            // Get lisft of IDs
            sObjectIDs = sObjectIDsPerFieldNames.get(fieldName).get(fieldValue);
            
            // for each ID
            for (String ID : sObjectIDs) {
                // Get position in originalList
                position = listPosition.get(ID);                // Add each sObject to the list.
                if ((ascending) || (outputList.size()==0)) {
                    outputList.add(originalList[position]);
                } else {
                    outputList.add(0, originalList[position]);
                }
            }
        }
        return outputList;
    }
    private static String getValue(sObject sObj, String fieldName) {
        // This returns the sObject desired in case the fieldName refers to a linked object.
        Integer pieceCount;
        String[] fieldNamePieces;
        
        fieldNamePieces = fieldName.split('\\.');
        pieceCount = fieldNamePieces.size();
        for (Integer i = 0; i < (pieceCount-1); i++) {
            sObj = sObj.getSObject(fieldNamePieces[i]);
        }
        return String.valueOf(sObj.get(fieldNamePieces[pieceCount-1]));
    }
}   
// Unit testing
/*
    static testMethod void testSortCustomObject() {
        List<TPValue__c> TPValues;
        AP_SortHelper sorter = new AP_SortHelper();
        String fieldName;
        
        TPValues = [SELECT TPName__r.TPName__c, Value__c FROM TPValue__c LIMIT 50];
        fieldName = 'Value__c';
        testOrderedList(sorter.getSortedList(TPValues, fieldName, true), fieldName, true);
        
        fieldName = 'TPName__r.TPName__c';
        testOrderedList(sorter.getSortedList(TPValues, fieldName, true), fieldName, true);
    }
*/
   /* static testMethod void testSimpleField_Ascending() {
        testSortingContacts('Name', true);
    }
    static testMethod void testSimpleField_Descending() {
        testSortingContacts('Name', False);
    }
    static testMethod void testLookupField_Ascending() {
        testSortingContacts('Account.Name', True);
    }
    static testMethod void testLookupField_Decending() {
        testSortingContacts('Account.Name', False);
    }
    static testMethod void testMultipleCalls() {
        AP_SortHelper sorter;
        sorter = testSortingContacts(null, 'Name', true);
        testSortingContacts(sorter, 'Name', False);
        testSortingContacts(sorter, 'Account.Name', True);
        testSortingContacts(sorter, 'Account.Name', False);
    }
    static testMethod void testForgotOriginalList() {
        Boolean exceptionDetected = false;
        AP_SortHelper sorter = new AP_SortHelper();
        try {
            sorter.getSortedList('Name', true);
        } catch (NullPointerException e) {
            exceptionDetected = true;
        }
        System.assert(exceptionDetected);
    }
    static testMethod void testPassingList() {
        AP_SortHelper sorter = new AP_SortHelper();
        List<Contact> contacts = [SELECT Name, Phone, Account.Name FROM Contact LIMIT 50];
        List<Contact> sortedList = (List<Contact>) sorter.getSortedList(contacts, 'Name', true);
        testOrderedList(sortedList, 'Name', true);
    }
    private static void testSortingContacts(string fieldName, Boolean isAscending) {
        testSortingContacts(null, fieldName, isAscending);
    }
    private static AP_SortHelper testSortingContacts(AP_SortHelper sorter, string fieldName, Boolean isAscending) {
        // If sorted is null,create it.        
        if (sorter == null) {
            sorter = new AP_SortHelper();
            sorter.originalList = [SELECT Name, Phone, Account.Name FROM Contact LIMIT 50];
        }
        
        // Sort list
        List<Contact> sortedList = (List<Contact>) sorter.getSortedList(fieldName, isAscending);        // Test sort order
        testOrderedList(sortedList, fieldName, isAscending);
        
        return sorter;        
    }
    private static void testOrderedList(List<sObject> sortedList, string fieldName, Boolean isAscending) {
        String lastValue = null;
        String currentValue = null;        for (sObject sObj : sortedList) {
            currentValue = getValue(sObj, fieldName);
            if ((lastValue != null) && (currentValue != null)) {                String strDebug = '';
                strDebug += '\n--------------------------------------------------------------';
                strDebug += '\nSTART';
                strDebug += '\n--------------------------------------------------------------';
                strDebug += '\n[Ascending:'+isAscending+']';
                strDebug += '\n[Previous:'+lastValue+'] [IsNull():'+(lastValue==null)+']';
                strDebug += '\n[Current:'+currentValue+'] [IsNull():'+(currentValue==null)+']';
                strDebug += '\n[CompareTo:'+(currentValue.compareTo(lastValue))+']';
                strDebug += '\n--------------------------------------------------------------';
                strDebug += '\nEND';
                strDebug += '\n--------------------------------------------------------------';
                System.debug(strDebug);                if (isAscending) {
                    System.assertEquals(currentValue.compareTo(lastValue)>=0, true);
                } else {
                    System.assertEquals(currentValue.compareTo(lastValue)<=0, true);
                }
            }
            lastValue = currentValue;
        }
    }
}*/