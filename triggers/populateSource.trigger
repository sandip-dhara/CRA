Trigger populateSource on Channel_Partner__c (before update, after insert)
{
    if(OpportunitySourceHandler.getCurrentExecution() == true )
    return ;
    
    OpportunitySourceHandler.setCurrentExecution(true);
    
    Set<ID> stRecIds = new Set<ID>();
    Set<ID> stRecOppIds = new Set<ID>();
    
    for(Channel_Partner__c objCP : Trigger.new)
    {
     try
    {
        if(objCP.Sourced__c != Trigger.oldMap.get(objCP.Id).Sourced__c && objCP.Sourced__c == true )
        {
            stRecIds.add(objCP.Id);
            stRecOppIds.add(objCP.Opportunity__c);
        }
    }catch(Exception e){
    }
    }
    
    
    List<Channel_Partner__c> lstCAS = [ Select ID ,Sourced__c , Opportunity__c from Channel_Partner__c Where Opportunity__c IN : stRecOppIds and ID NOT IN : stRecIds ] ;
    
    for(Channel_Partner__c objCPP :lstCAS)
    {
        objCPP.Sourced__c = false ;
    }
    
    try
    {
        if(lstCAS != null && lstCAS.isEmpty() == false )
        update lstCAS ;
    }catch(exception ex)
    {
        system.debug('Err---------' + ex );
    }
}