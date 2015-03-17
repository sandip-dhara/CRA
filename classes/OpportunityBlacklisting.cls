/******************
Author: Abrar
Date: 27-09-2012
Description: Class for 
Blacklisting of Words for UKPS oppties
 ******************/
Public class OpportunityBlacklisting
{
    public static List<PatternHelper> patterns {set; get;} 
    public static Map<Id, PatternHelper> matchedPosts {set; get;}
    String FieldDes = null;
    String OpName = null;
    String OpUpdate = null;
    String strOld;
    String strName;
    String strUpdate;
    Boolean PreventPost=False;
    //public Opportunity op;
    List<Opportunity> UpdatedOpty= new List<Opportunity>();

    public OpportunityBlacklisting()
    {
        system.debug('inside the constructor');
        patterns = new List<PatternHelper>();
        matchedPosts = new Map<Id, PatternHelper>();
        /*map<Id, Account> AccountInfo=new Map<Id, Account>();
        List<Id> AccountIds = new List<Id>();
        List<Blacklisted_Word__c> bwWordsUKPS;
        List<Blacklisted_Word__c> bwWordsUSPS;
        List<Blacklisted_Word__c> bwWordsGeneral; */
        preparePatterns();
    }
    public void preparePatterns()
    {
        //fetch the blacklisted words
        /*For(Opportunity o: trigger.new)
        {
         AccountIds.Add(o.AccountId);
         }
        AccounInfo=[select Id,Confidential_Account__c, BillingCountry from Account where Id In :AccountIds];

        for(Opportunity)*/

        List<Blacklisted_Word__c> bwWords = [select Word__c, RegexValue__c, Substitution__c,
                                             Add_to_Compliance_Audit__c, Custom_Expression__c,
                                             Prevent_Post_on_Breach__c, Type__c
                                             from Blacklisted_Word__c where is_Active__c = true
                                             ];




        for(Blacklisted_Word__c bwc : bwWords)
        {
            patterns.add(new PatternHelper(bwc));
            system.debug('PatternValue'+patterns[0].blacklistedWord);
        }
    }

    Public void BlacklistingLogic(Opportunity op, String country)
    {
        string varcountry = country;

        for(PatternHelper ph : patterns)
        {
            if(ph.RecType==varcountry || ph.RecType==null)
            {                       
                Boolean foundMatch = false;

                if(FieldDes==Null)
                    FieldDes='';
                strOld = FieldDes;
                strName = OpName;
                if(OpUpdate==Null)
                    OpUpdate='';
                strUpdate = OpUpdate;
                if(FieldDes!=Null)
                    FieldDes = FieldDes.replaceAll(ph.regexValue, ph.substitutionValue);
                system.debug('Oppty Description'+FieldDes);
                OpName = OpName.replaceAll(ph.regexValue, ph.substitutionValue);
                system.debug('Oppoty Name'+OpName);
                if(opUpdate!=Null)
                    OpUpdate = OpUpdate.replaceAll(ph.regexValue, ph.substitutionValue);
                system.debug('Oppoty update'+OpUpdate);
                if(strOld.compareTo(FieldDes) != 0 || strName.compareTo(OpName) != 0 || strUpdate.compareTo(OpUpdate) != 0)
                    foundMatch = true;

                if(foundMatch)
                {
                    if(!matchedPosts.containsKey(ph.blacklistedWord.id))
                    {

                        ph.origPostBody = FieldDes;
                        ph.postCreatedById = Op.createdById;
                        matchedPosts.put(ph.blacklistedWord.id, ph);
                    }
                    if(ph.preventPostOnMatch)
                        preventPost = true;
                    system.debug('PreventPostOnMatch'+ph.preventPostOnMatch);
                    Id hpfsId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('HPFS').getRecordTypeId();
                    if (op.recordtypeid == hpfsId)
                        preventPost = false;
                    system.debug('PreventPostOnMatch cancelled for HPFS opportunities.');    
                }
                if(preventPost)   //note: should we display the blacklisted word to inform user of what they did?
                        op.addError('Save prevented due to use of a blacklisted word.');
                else
                {

                    Opportunity opty = op;
                    op.Description = FieldDes;
                    op.Name = OpName;
                    op.Opportunity_Update__c = OpUpdate;
                    UpdatedOpty.add(op);
                }
            }
        }

    }


    public void filterwords(List<Opportunity> Oplist)
    {
        system.debug('OptyList'+Oplist);
        Matcher m;
        List<Id> accIds= new List<Id>();
        for(Opportunity o : OpList)
            accIds.add(o.AccountId);
        
        Map<Id,Account> accMap = new Map<Id,Account>([select Id,Confidential_Account__c from Account where Id IN :accIds ]);
        for(Opportunity op : opList)
        {
            FieldDes = op.Description;
            OpName = op.Name;
            OpUpdate = op.Opportunity_Update__c;
            //Account Acinfo = [select Id,Confidential_Account__c from Account where Id = :op.AccountId ];
            Account Acinfo = accMap.get(op.AccountId);
            system.debug('opty update in filterwords'+op.Opportunity_Update__c);
            system.debug('opty update in filterwords private '+acinfo.Confidential_Account__c);
            If(acinfo.Confidential_Account__c == false)
            BlacklistingLogic(Op, null);
            Else
            BlacklistingLogic(Op, op.account_blacklist__c); 

        }
    }
}