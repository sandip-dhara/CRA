public with sharing class cspExtensionController {
    
    public String cspName;
    public String oppPlanId {get;set;}
    public String id;
    public List<csp_offensive_strategy__c> relatedOffensiveStrategies;
    public List<csp_defensive_strategy__c> relatedDefensiveStrategies;
    public ApexPages.StandardController std; 
    public Id chosenOffId {get; set;}
    public Id chosenDefId {get; set;}
    public Integer off_count {get;set;}
    public Integer def_count {get;set;}
    public Integer rows {get;set;}
    public String idcount {get;set;}
    public String printView {get;set;}
    public Competitive_Sales_Plan__c compsaleplan;
    public cspExtensionController(ApexPages.StandardController controller) {
    std=controller;
    
    this.compsaleplan=(Competitive_Sales_Plan__c)std.getRecord();
        
        
        this.cspName = ApexPages.currentPage().getParameters().get('cspName');
        this.id = ApexPages.currentPage().getParameters().get('id');
        this.oppPlanId = ApexPages.currentPage().getParameters().get('oppPlanId');
        this.printView = ApexPages.currentPage().getParameters().get('printView');
        
    }
    
    public List<csp_offensive_strategy__c> getRelatedOffensiveStrategies()
    {
        relatedOffensiveStrategies = [SELECT csp__c,Id,Name,strength_customer_validated__c,strength_leveraged__c,strength_text__c,their_weakness_customer_validated__c,their_weakness_exploited__c,their_weakness_text__c, tactic_timing__c, tactic_text__c, tactic_owner__c  FROM csp_offensive_strategy__c where csp__c = :cspName ORDER BY CreatedDate asc];
        off_count = [SELECT count() FROM csp_offensive_strategy__c where csp__c =:cspName];
        return relatedOffensiveStrategies;
    }
    
    public List<csp_defensive_strategy__c> getRelatedDefensiveStrategies()
    {
        relatedDefensiveStrategies = [SELECT csp__c,Id,Name,our_weakness_countered__c,our_weakness_customer_validated__c,our_weakness_text__c,their_strength_countered__c,their_strength_customer_validated__c,their_strength_text__c, ct_countertactic__c, ct_owner__c, ct_timing__c FROM csp_defensive_strategy__c where csp__c = :cspName ORDER BY CreatedDate asc];
        def_count = [SELECT count() FROM csp_defensive_strategy__c where csp__c =:cspName];
        return relatedDefensiveStrategies;
    }
    
    public void addOffRow(){
    try{
        update relatedOffensiveStrategies;
        update relatedDefensiveStrategies;
        //std.save();
        upsert compsaleplan;
        for (Integer i=0; i<rows;i++){
            csp_offensive_strategy__c new_strategy = new csp_offensive_strategy__c();
            new_strategy.csp__c = cspName;
            insert new_strategy;
        }
    
        }catch(Exception e){
            ApexPages.addMessages(e);
           
        }
        
    }
    
    public void addDefRow(){
      try{
        update relatedOffensiveStrategies;
        update relatedDefensiveStrategies;
        //std.save();
        upsert compsaleplan;
        for (Integer i=0; i<rows;i++){
            csp_defensive_strategy__c new_strategy = new csp_defensive_strategy__c();
            new_strategy.csp__c = cspName;
            insert new_strategy;
        }
       }catch(Exception e){
        ApexPages.addMessages(e);
       }
        
    }
    
    public void removeOffRow(){
        
       try{
        update relatedOffensiveStrategies;
        update relatedDefensiveStrategies;
        //std.save();
        upsert compsaleplan;
        csp_offensive_strategy__c delrow = new csp_offensive_strategy__c(Id=chosenOffId);
        delete delrow;
       }catch(Exception e){
       
       }
    }
    
    public void removeDefRow(){
    try{
        update relatedOffensiveStrategies;
        update relatedDefensiveStrategies;
        //std.save();
        upsert compsaleplan;
        csp_defensive_strategy__c delrow = new csp_defensive_strategy__c(Id=chosenDefId);
        delete delrow;
      }catch(Exception e){
      
      }
    }

    public PageReference customSave(){
        
      try{
        update relatedOffensiveStrategies;
        update relatedDefensiveStrategies;
        //std.save();
        upsert compsaleplan;
        PageReference pr = new PageReference('/apex/CSP_List?id='+oppPlanId);
        pr.setRedirect(true);
        return pr;
       }catch(Exception e){
           
           ApexPages.addMessages(e);
           return null;
       
       }
    }
    
    public PageReference customCancel(){
        
        std.cancel();
        PageReference pr = new PageReference('/apex/CSP_List?id='+oppPlanId);
        pr.setRedirect(true);
        return pr;
    
    }
    
    public List<Decision__c> getBuyingCriteria(){
        List<Decision__c> qlist = new List<Decision__c>([SELECT Criteria__c FROM Decision__c WHERE Opportunity_Plan__c = :oppPlanId]);
        List<Decision__c> result = new List<Decision__c>();
        for (Decision__c d : qlist) {
            if (d.Criteria__c != null) {
                result.add(d);
            }
        }
        return result;
    }
    
    public List<Relationship_Suite__c> getDecisionMakers(){
        
        List<Relationship_Suite__c> rs = new List<Relationship_Suite__c>([SELECT Contact__r.Name,Contact__r.Title, Relationship_map__c FROM Relationship_Suite__c WHERE Opportunity_Plan__c = :oppPlanId ]);
        List<Relationship_Suite__c> result = new List<Relationship_Suite__c>();
        String compareme; 
        for (Relationship_Suite__c r : rs){
            compareme = String.valueOf(r.Relationship_map__c);
            if (compareme == null){
                compareme = '_';
            }
            if (compareme.indexOf('Decision Maker',0) > -1){
                result.add(r);
            }
        }
        return result;
    }
    
    public Integer getDecisionCount(){
        List<Decision__c> decisions = new List<Decision__c>([SELECT Who__c FROM Decision__c WHERE Opportunity_Plan__c = :oppPlanId]);
        Integer decision_count = 0;
        String compareme;
        for (Decision__c d : decisions){
            compareme = String.valueOf(d.Who__c);
            if (compareme == null){
                compareme = '_';
            }
            if (compareme.indexOf(idcount,0)>-1){
                decision_count = decision_count + 1;
            }
        }
        
        return decision_count;
        
    }
    
    public PageReference goBack(){
        PageReference pr = new PageReference('/apex/CSP_List?id='+oppPlanId);
        pr.setRedirect(true);
        return pr;
    
    }
    
    
    
    public List<csp_offensive_strategy__c> getRelatedOffensiveStrategiesT()
    {
        relatedOffensiveStrategies = [SELECT csp__c,Id,Name,Activity_Created_On__c, tactic_timing__c, tactic_text__c, tactic_owner__c  FROM csp_offensive_strategy__c where csp__c = :cspName and tactic_text__c <>null ORDER BY CreatedDate asc];
        off_count = [SELECT count() FROM csp_offensive_strategy__c where csp__c =:cspName ];
        return relatedOffensiveStrategies;
    }
     public List<csp_defensive_strategy__c> getRelatedDefensiveStrategiesT()
    {
        relatedDefensiveStrategies = [SELECT csp__c,Id,Name, Activity_Created_On__c, ct_countertactic__c, ct_owner__c, ct_timing__c FROM csp_defensive_strategy__c where csp__c = :cspName and ct_countertactic__c <>null ORDER BY CreatedDate asc];
        def_count = [SELECT count() FROM csp_defensive_strategy__c where csp__c =:cspName];
        return relatedDefensiveStrategies;
    }  
  
    public void CreateOffActivities(){
//        csp_offensive_strategy__c currow = new csp_offensive_strategy__c(Id='a0ZJ0000000EzgnMAC');
         csp_offensive_strategy__c currow = [SELECT csp__c,Id,Activity_Created_On__c,Name,csp__r.Opportunity_Plan__r.Opportunity__r.Id,csp__r.name, tactic_timing__c, tactic_text__c, tactic_owner__c  FROM csp_offensive_strategy__c where Id=:chosenOffId];
        
        // Instanciate Object
        Task tskNew = new Task();
        
        // Pre-populate Fields
//        tskNew.WhoId = currow.tactic_owner__c; 
        tskNew.WhatId = currow.csp__r.Opportunity_Plan__r.Opportunity__r.Id; 
        tskNew.Subject = currow.tactic_text__c; // Pull CS Subject
        tskNew.ActivityDate = currow.tactic_timing__c; 
        tskNew.Description = currow.csp__r.name; 
        tskNew.OwnerId = currow.tactic_owner__c;                
            System.debug('INSERTING OFF' + currow.tactic_text__c + ':' + chosenOffId ) ;
        try {
            insert tskNew;
            } 
            catch(DMLException e) {
            tskNew.addError(e.getMessage());
            System.debug('ERRORING OFF') ;
            System.debug(e.getMessage()) ;
            }
        currow.Activity_Created_On__c =date.today();
        update currow;
            
    }
    
    public void CreateDefActivities(){
//        csp_defensive_strategy__c currow = new csp_defensive_strategy__c(Id=chosenDefId);
         csp_defensive_strategy__c currow = [SELECT csp__c,Id,csp__r.competitor__c,Name,Activity_Created_On__c,csp__r.Opportunity_Plan__r.Opportunity__r.Id,csp__r.name, ct_timing__c, ct_countertactic__c, ct_owner__c  FROM csp_defensive_strategy__c where Id=:chosenDefId];

        // Instanciate Object
        Task tskNew = new Task();
        
        // Pre-populate Fields
//        tskNew.WhoId = currow.ct_owner__c; 
        tskNew.WhatId = currow.csp__r.Opportunity_Plan__r.Opportunity__r.Id; 
        tskNew.Subject = currow.ct_countertactic__c; // Pull CS Subject
        tskNew.ActivityDate = currow.ct_timing__c; 
        tskNew.Description = currow.csp__r.competitor__c; 
        tskNew.OwnerId = currow.ct_owner__c;                
            System.debug('INSERTING DEF') ;
        try {
            insert tskNew;
            } 
            catch(DMLException e) {
            tskNew.addError(e.getMessage());
            System.debug('ERRORING DEF') ;
            System.debug(e.getMessage());  
            }
            
        currow.Activity_Created_On__c =date.today();
        update currow;
              
    }
    
    
}