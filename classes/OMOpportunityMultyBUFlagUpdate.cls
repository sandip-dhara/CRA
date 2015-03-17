public class OMOpportunityMultyBUFlagUpdate
{
    public static void hasBGGlobalUpdate(List<OpportunityLineItem> ollist)
    {    
        set<Id> setOpptyID = new Set<ID>();
        Map<ID,List<OpportunityLineItem>> mapOppLineItem=new Map<ID,List<OpportunityLineItem>>();
        List<Opportunity> listOpptyToUpdate=new List<Opportunity>();
        set<String> setGBUName = new set<String>(); 
        for (OpportunityLineItem opplineitem1: ollist) 
        {
            setOpptyID.add(opplineitem1.OpportunityID);
        }

        for(OpportunityLineItem opplineitem2 : [Select ID , GBU__c,Business_Group__c,opportunityID from OpportunityLineItem where OpportunityID in :setOpptyID ])
        {
            if(mapOppLineItem.containsKey(opplineitem2.OpportunityID)){
                List<OpportunityLineItem> tempcList=new List<OpportunityLineItem>();
                tempcList=mapOppLineItem.get(opplineitem2.OpportunityID);
                tempcList.add(opplineitem2);
                mapOppLineItem.put(opplineitem2.OpportunityID, tempcList);
            }
            else{
                List<OpportunityLineItem> tempcList=new List<OpportunityLineItem>();
                tempcList.add(opplineitem2);
                mapOppLineItem.put(opplineitem2.OpportunityID, tempcList);
            }
        }

        for(ID OptyId : setOpptyID)
        {
            system.debug('^^OPtyId'+OptyId);
            boolean bIsMultiBU=false;
            if(mapOppLineItem.containsKey(OptyId))
            {
            system.debug('^^Map'+mapOppLineItem);
                for( OpportunityLineItem opln : mapOppLineItem.get(OptyId))
                    {
                    system.debug('^^opln'+opln);
                    system.debug('^^opln'+opln.GBU__c);
                        setGBUName.add(opln.GBU__c); 
                        if(setGBUName.Size() > 1)
                        {
                            bIsMultiBU=true;
                            break;
                        }
                        else
                        {
                        bIsMultiBU=false;
                        }
                    }
            }
            if(setGBUName.Size() > 0){
                setGBUName.clear();
            }
            
            Opportunity ObjOppty = new Opportunity(id=OptyId);            
            if(bIsMultiBU==true)
            {
                ObjOppty.MultiGBU__c=true;
                listOpptyToUpdate.add(ObjOppty);
            }
            else if(bIsMultiBU==false)
            {                
                ObjOppty.MultiGBU__c=false;
                listOpptyToUpdate.add(ObjOppty);                
            }
        }   

        if(listOpptyToUpdate.size()>0)
        {
            try
            {
                update listOpptyToUpdate;
            }
            catch(Exception e)
            {               
            }
        }
    }
}