trigger WorldRegionAfterUpdate on World_Region__c (after Update) {
    Map<Id,World_Region__c> newMap = Trigger.newmap;
    Map<Id,World_Region__c> oldMap = Trigger.oldmap;
    Set<String> countryNames = new Set<String>();
    Set<String> regionNames = new Set<String>();
    If(Trigger.isAfter){
        for(Id worldRegionId : newMap.keySet()){
            String accsqr;
            if(oldMap.get(worldRegionId).ParentId__c != newMap.get(worldRegionId).ParentId__c){
                system.debug(newMap.get(worldRegionId).Country_Name__c);
                If(newMap.get(worldRegionId).Country_Name__c !=null){
                    countryNames.add(newMap.get(worldRegionId).Country_Name__c);
                    //accsqr = 'Select Id, EvaluateTerritory__c from Account where ShippingCountry =\'' + newMap.get(worldRegionId).Country_Name__c + '\'';
                }else{
                    regionNames.add(newMap.get(worldRegionId).Name);
                    /*accsqr = 'Select Id, EvaluateTerritory__c from Account where WorldRegion_SubRegion1__c =\'' + newMap.get(worldRegionId).Name + '\''+
                             'OR WorldRegion_SubRegion2__c =\'' + newMap.get(worldRegionId).Name + '\''+
                             'OR WorldRegion_SubRegion3__c =\'' + newMap.get(worldRegionId).Name + '\'';*/
                }
                //Id batchId = Database.executeBatch(new TurnEvalTerrFlagTrueBatch(accsqr));
            }
        }
        if(countryNames.size() > 0 || regionNames.size() > 0){
            Id batchId = Database.executeBatch(new TurnEvalTerrFlagTrueBatch(countryNames,regionNames));
        }
    }
}