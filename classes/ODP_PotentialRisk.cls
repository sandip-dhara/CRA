public class ODP_PotentialRisk {

//TS
public List<wrapperclass> lstobjfields
        {
          get;
          set;
        }   
     
   public ODP_PotentialRisk ()
        {
            lstobjfields = new List<wrapperclass>();
        }
        
        public PageReference addfields()
        {
            try
                {
                    lstobjfields.add(new wrapperclass(new Potential_Risk__c(),new Process_Control__c()));   // Adding fields toVfpage when user click on Add Button.
                }
            catch(Exception e)
                {
                    ApexPages.addMessages(e);
                }
            return ApexPages.currentPage();
        }
 public class wrapperclass
         {
             public Potential_Risk__c potentialRisk{get;set;} 
            
             public Process_Control__c processControl{get;set;}
            
             public wrapperclass(Potential_Risk__c pr,Process_Control__c pc)
             {
                 this.potentialRisk = pr;
                 this.processControl = pc;
             }
         }

public PageReference save() // this method for inserting records into multiple objects.
        {
            try
                {
                    List<Potential_Risk__c> prlist = new List<Potential_Risk__c>();
                    List<Process_Control__c> pclist = new List<Process_Control__c>();
                   for(wrapperclass item : lstobjfields)
                    {
                            prlist.add(item.potentialRisk);
                            pclist.add(item.processControl);   
                    }
                      if(prlist.size() >  0 && pclist.size() > 0)
                      {
                      insert prlist; 
                      
                        insert pclist;    // Inserting records in to multiple objects
                       }         
                }
            catch(Exception e)
                {
                    ApexPages.addMessages(e);
                }
            return ApexPages.currentPage();
        }
}