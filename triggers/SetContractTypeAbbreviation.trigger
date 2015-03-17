/*
* NAME : SetContractTypeAbbreviation
* NOTE : Trigger is fired every time before insert, it will autopopulate the Customer legal name to account name & Agreement name to Acount name + Record type abbriviation
*		 also it will populate Primary Country Queue Group Field to specific Queue based on the Customer country(mapped with) Triage Queue Group Cusom Settingd
* Author : Apttus (Nilesh) last modified by Shabbir & Axay
*/
trigger SetContractTypeAbbreviation on Apttus__APTS_Agreement__c (before insert) {
    
    
    Map<String,String> mapRecrdTypeAbbreviation = new Map<String,String>();
    
    /*Skip this hard code values -- added These values to custom settings and fetch from them using below function - getRecordTypeAbbrivations()
    
    mapRecrdTypeAbbreviation.put('Addendum/Amendment/Modification','ADD');
    mapRecrdTypeAbbreviation.put('Bailment','BLMT');
    mapRecrdTypeAbbreviation.put('Change Order','CO');
    mapRecrdTypeAbbreviation.put('Consent Agreement/Consent Letter','CACL');
    mapRecrdTypeAbbreviation.put('Country Participate/Local Services Agmt','CPA');
    mapRecrdTypeAbbreviation.put('EU Model Agmt Transfer of Personal Data','EUPD');
    mapRecrdTypeAbbreviation.put('Education Services Agmt','EDS');
    mapRecrdTypeAbbreviation.put('Enterprise Cloud Services Agreement','ECLS');
    mapRecrdTypeAbbreviation.put('Enterprise License Agmt','ELA');
    mapRecrdTypeAbbreviation.put('Evaluation/Trial/Proof of Concept Agmt','EVL');
    mapRecrdTypeAbbreviation.put('Facilities Management Agmt','FM');
    mapRecrdTypeAbbreviation.put('Frame/Master - Consulting','FMC');
    mapRecrdTypeAbbreviation.put('Frame/Master - Support','FSP');
    mapRecrdTypeAbbreviation.put('Frame/Master Outsourcing/MSA','FOUT');
    mapRecrdTypeAbbreviation.put('Frame/Master – HW, SW & Support','FHSS');
    mapRecrdTypeAbbreviation.put('Frame/Master – HW, SW, Support & Conslt','FSSC');
    mapRecrdTypeAbbreviation.put('Frame/Master – SW, Support & Consulting','FSWC');
    mapRecrdTypeAbbreviation.put('Frame/Master – SW-as-a-Service','FSAS');
    mapRecrdTypeAbbreviation.put('Frame/Master – Software & SW Support','FSWS');
    mapRecrdTypeAbbreviation.put('GSA BPA','GSAB');
    mapRecrdTypeAbbreviation.put('GSA Teaming Arrangement','GSAT');
    mapRecrdTypeAbbreviation.put('Advice Only','Advice Only');
    mapRecrdTypeAbbreviation.put('IDIQ – Agency Specific','IDIQ');
    mapRecrdTypeAbbreviation.put('IDIQ – Government-wide','GWAC');
    mapRecrdTypeAbbreviation.put('Infrastructure -as-a-Service Agmt','ISaS');
    mapRecrdTypeAbbreviation.put('Issue/Dispute Support','DISP');
    mapRecrdTypeAbbreviation.put('Letter Agreement','LTRA');
    mapRecrdTypeAbbreviation.put('Letter of Intent/MOU','MOU');
    mapRecrdTypeAbbreviation.put('Managed Print Services Agmt','MPS');
    mapRecrdTypeAbbreviation.put('Non-Disclosure Agreement','NDA');
    mapRecrdTypeAbbreviation.put('Not yet selected','Not Yet Selected');
    mapRecrdTypeAbbreviation.put('Novation Agreement','NOVA');
    mapRecrdTypeAbbreviation.put('Parent Corporate Guaranty','PARG');
    mapRecrdTypeAbbreviation.put('Partner Agreement','PART');
    mapRecrdTypeAbbreviation.put('Platform-as-a-Service Agmt','PSaS');
    mapRecrdTypeAbbreviation.put('Product Order Schedule (Software)','POS');
    mapRecrdTypeAbbreviation.put('Public Cloud Services Agmt','PCLS');
    mapRecrdTypeAbbreviation.put('Purchase Order','PO');
    mapRecrdTypeAbbreviation.put('RFI, RFP, RFQ and Invitation to Bid','RFX');
    mapRecrdTypeAbbreviation.put('Relocation Agreement','RELO');
    mapRecrdTypeAbbreviation.put('Representations - Certifications','RCS');
    mapRecrdTypeAbbreviation.put('Research & Development Agreement','RNDA');
    mapRecrdTypeAbbreviation.put('SOW/Service Request','SOW');
    mapRecrdTypeAbbreviation.put('Settlement Agreement','SETL');
    mapRecrdTypeAbbreviation.put('Single Ord - Support','SOSP');
    mapRecrdTypeAbbreviation.put('Single Ord – HW, SW & Support','SHSS');
    mapRecrdTypeAbbreviation.put('Single Ord – HW, SW, Support&Consulting','SHSC');
    mapRecrdTypeAbbreviation.put('Single Ord – SW, SW Support & Consulting','SSSC');
    mapRecrdTypeAbbreviation.put('Single Ord – Software & SW Support','SSWS');
    mapRecrdTypeAbbreviation.put('Single Ord – Software-as-a-Service','SSaS');
    mapRecrdTypeAbbreviation.put('Single Order – Consulting','SOC');
    mapRecrdTypeAbbreviation.put('Source Code Escrow/License','ESCW');
    mapRecrdTypeAbbreviation.put('Sources Sought/Market Research','SSMR');
    mapRecrdTypeAbbreviation.put('Subcontract – HP as a subcontractor','SUBS');
    mapRecrdTypeAbbreviation.put('Subcontractor Agmt -HP as Prime','SUBP');
    mapRecrdTypeAbbreviation.put('Task Order/Delivery Order','TODO');
    mapRecrdTypeAbbreviation.put('Teaming Agreement','TMGA');
    mapRecrdTypeAbbreviation.put('Third Party Financing Agmt','TPFA');
    mapRecrdTypeAbbreviation.put('Work Order / Service Request','WOSR');
	*/
	mapRecrdTypeAbbreviation = getRecordTypeAbbrivations(); // get all record type abbriviations map
	
    List<RecordType> lstRecordType = [Select Id,Name From RecordType where sObjectType = 'Apttus__APTS_Agreement__c'];
    Set<String> CustomerLocationCountry = new Set<String>();
    Map<Id,String> mapRecordTypeIdName = new Map<Id,String>();
    
    for(RecordType rt : lstRecordType){
        mapRecordTypeIdName.put(rt.Id,rt.Name);
    }
    
    for(Apttus__APTS_Agreement__c agmt : trigger.new){
        if(mapRecrdTypeAbbreviation.get(mapRecordTypeIdName.get(agmt.RecordTypeId)) != null){
            agmt.Contract_Type_Abbreviation__c = mapRecrdTypeAbbreviation.get(mapRecordTypeIdName.get(agmt.RecordTypeId));
            
            if(agmt.Apttus__Account__c != null)
            {
                System.debug('Selecting account info'+agmt.Apttus__Account__c);
                Account acc = [SELECT ID,NAME FROM Account WHERE ID = :agmt.Apttus__Account__c ];
                agmt.Customer_Legal_Name__c = acc.NAME;
                agmt.NAME = getAbbrAccountName(acc.NAME) +' - '+ agmt.Contract_Type_Abbreviation__c;
            }
                
                if(agmt.Apttus__Related_Opportunity__c != null)
                {
                    Opportunity opp = [SELECT ID,AccountID FROM Opportunity WHERE ID = :agmt.Apttus__Related_Opportunity__c];
                    Account acc = [SELECT ID,NAME FROM Account WHERE ID = :opp.AccountID];
                    agmt.NAME = getAbbrAccountName(acc.NAME) +' - '+ agmt.Contract_Type_Abbreviation__c;
                    agmt.Customer_Legal_Name__c = acc.NAME;
                }
        }
        CustomerLocationCountry.add(agmt.Customer_Location_Country__c);

    }
    
    Map<String, String> CountryGroupMap = getCountryGroupCustomSetting(customerLocationCountry);
    
    for(Apttus__APTS_Agreement__c agmt : trigger.new){
    	agmt.Primary_Country_Country_Queue_Group__c = countryGroupMap.get(agmt.Customer_Location_Country__c);
    }    
    
    //get Abbrivated Account Name
    private String getAbbrAccountName(String acName){
	        if(acName != null && acName.length() > 60){
	            	acName = acName.subString(0,60);
	        }
	       return acName;
    }
    
    //method will return Customer Location Country & Queue Group Mapping
    private Map<String, String> getCountryGroupCustomSetting(Set<String> countries) {
    	List<TriageQueueGroup__c> qGroups = [select Customer_Location_Country__c, Queue_Group__c 
    											from TriageQueueGroup__c 
    											where Customer_Location_Country__c in :customerLocationCountry];
    	Map<String, String> countryGroup = new Map<String, String> ();
    	for(TriageQueueGroup__c qgroup : qGroups) {
    		countryGroup.put(qGroup.Customer_Location_Country__c, qGroup.Queue_Group__c);
    	}
    	return countryGroup;
    }
    
    //method will return Map of Record type & its relative abbriviation
    private Map<String, String> getRecordTypeAbbrivations() {
    	List<Apttus_Record_Type_Abbrivations__c> abbrivations = [SELECT Record_Type_Abbrivation__c,Record_Type_Name__c 
    															 FROM Apttus_Record_Type_Abbrivations__c];
    	Map<String, String> myAbbrivatoins = new Map<String, String> ();
    	for(Apttus_Record_Type_Abbrivations__c rAbbrivations : abbrivations) {
    		myAbbrivatoins.put(rAbbrivations.Record_Type_Name__c, rAbbrivations.Record_Type_Abbrivation__c);
    	}
    	return myAbbrivatoins;
    }
}