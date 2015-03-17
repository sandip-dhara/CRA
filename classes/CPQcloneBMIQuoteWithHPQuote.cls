/**
* Class Name: CPQcloneBMIQuoteWithHPQuote 
* Author: HP - Mohit
* Date: 16-Feb-2013
* Description: This class is calling from After insert trigger,copy all the BMI quotes into HP Quote Custom Object for Custom Functionality
*/
public class CPQcloneBMIQuoteWithHPQuote {
    //Insert all BMI Quotes into HP Quote
    public static void insertBMIQuoteIntoHPQuote(List<BigMachines__Quote__c > newBMIQuoteList){
    
        if(!newBMIQuoteList.isEmpty()){
            Map<String,CPQHPQuoteWithBMIQuoteMapping__c> mapHPQuoteAndBMIQuoteAPIName = CPQHPQuoteWithBMIQuoteMapping__c.getAll();
            if(!mapHPQuoteAndBMIQuoteAPIName.isEmpty()){
                List<HP_Quote__c> listHPQuote = new List<HP_Quote__c>();
                for(BigMachines__Quote__c  objBMIQuote : newBMIQuoteList){
                    HP_Quote__c objHpQuote = new HP_Quote__c();
                    for(CPQHPQuoteWithBMIQuoteMapping__c objHPQuoteWithBMIQuoteAPIName : mapHPQuoteAndBMIQuoteAPIName.values()){
                        if(objHPQuoteWithBMIQuoteAPIName.Object_Type__c == 'Quote')
                            objHpQuote.put(objHPQuoteWithBMIQuoteAPIName.HP_Quote_API_Name__c,objBMIQuote.get(objHPQuoteWithBMIQuoteAPIName.BMI_API_Name__c));
                    }
                    objHpQuote.Originating_Quote_System__c = 'BMI';
                    listHPQuote.add(objHpQuote);
                    system.debug('*************listHPQuote***'+listHPQuote);
                }
                if(!listHPQuote.isEmpty()){
                    insert listHPQuote;
                }
            }
        }
    }
    
    //Update all BMI Quotes into HP Quote
    public static void updateBMIQuoteIntoHPQuote(Map<Id,BigMachines__Quote__c > newMapBMIQuote,String sOperation){
        if(!newMapBMIQuote.isEmpty()){
            Map<String,CPQHPQuoteWithBMIQuoteMapping__c> mapHPQuoteAndBMIQuoteAPIName = CPQHPQuoteWithBMIQuoteMapping__c.getAll();
            if(!mapHPQuoteAndBMIQuoteAPIName.isEmpty()){
                List<HP_Quote__c> listHPQuote = new List<HP_Quote__c>();
                List<BigMachines__Quote__c> listBMIQuotesForInsert = new List<BigMachines__Quote__c>();
                Map<String,HP_Quote__c> mapHPQuoteNameWithObject = new Map<String,HP_Quote__c>();
                string BMIQuoteName = '';
                for(BigMachines__Quote__c  objBMIQuotes : newMapBMIQuote.values()){
                    BMIQuoteName += '\''+objBMIQuotes.Name+'\',';
                }
                BMIQuoteName = BMIQuoteName.removeEnd(',');
                string queryFields = 'select ';
                for(CPQHPQuoteWithBMIQuoteMapping__c objHPQuoteWithBMIQuoteAPIName : mapHPQuoteAndBMIQuoteAPIName.values()){
                    if(objHPQuoteWithBMIQuoteAPIName.Object_Type__c == 'Quote')
                        queryFields += objHPQuoteWithBMIQuoteAPIName.HP_Quote_API_Name__c+',';
                }
                queryFields = queryFields.removeEnd(',');
                queryFields += ' From HP_Quote__c where Originating_Quote_System__c = \'BMI\' and BMI_Id__c In ('+BMIQuoteName+')';
                system.debug('******queryFields********'+queryFields);
                for(HP_Quote__c objHPQuote : Database.query(queryFields)){
                    mapHPQuoteNameWithObject.put(objHPQuote.BMI_Id__c ,objHPQuote);
                }
                system.debug('*****mapHPQuoteNameWithObject*****'+mapHPQuoteNameWithObject);
                for(BigMachines__Quote__c  objBMIQuote : newMapBMIQuote.values()){
                    HP_Quote__c objHpQuote = mapHPQuoteNameWithObject.get(objBMIQuote.Name);
                    if(objHpQuote != null){
                        for(CPQHPQuoteWithBMIQuoteMapping__c objHPQuoteWithBMIQuoteAPIName : mapHPQuoteAndBMIQuoteAPIName.values()){
                            if(objHPQuoteWithBMIQuoteAPIName.Object_Type__c == 'Quote')
                                objHpQuote.put(objHPQuoteWithBMIQuoteAPIName.HP_Quote_API_Name__c,objBMIQuote.get(objHPQuoteWithBMIQuoteAPIName.BMI_API_Name__c));
                        }
                        listHPQuote.add(objHpQuote);
                    }
                    else{
                        listBMIQuotesForInsert.add(objBMIQuote);
                    }
                    
                }
                system.debug('*******listHPQuote*****'+listHPQuote);
                if(!listHPQuote.isEmpty()){
                    update listHPQuote;
                }
                if(!listBMIQuotesForInsert.isEmpty() && sOperation=='INSERT'){
                    insertBMIQuoteIntoHPQuote(listBMIQuotesForInsert);
                }
            }
        }
    }
}