/**********************************************************************************
Name:  Lineitemreportcontroller
Copyright © 2012  HP
===================================================================================
===================================================================================
Purpose:
-------
Controller to calculate subtotal of Lineitems of opportunity
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0 -   HP Dev Team          02/10/2012      INITIAL DEVELOPMENT
**********************************************************************************/

public class Lineitemreportcontroller {

 public String opportunityid;
 public List<opplineitemwrapper> opplineitemwrapperlist{get;set;}
 public string opportunitycurrencycode{get;set;}
 public string corporatecurrencycode{get;set;}
 public string usercurrencycode{get;set;}
 public Map<String,Double> conversionRatemap;
 public List<OpportunityDetails> opportunitydetailswrapper{get;set;}

 public Lineitemreportcontroller(){
  
     opportunityid=ApexPages.currentPage().getParameters().get('id');
     usercurrencycode=userinfo.getDefaultCurrency();
     opportunitydetailswrapper=new List<OpportunityDetails>();
      if(opportunityid!=null){
        
        Opportunity opportunityvalues=[select id,Opportunity_ID__c,CurrencyIsoCode,Name,Opportunity.Account.Name, StageName,Value__c from Opportunity where id=:opportunityid];
        Opportunity oppuservalue=[Select convertcurrency(Value__c) from Opportunity where id=:opportunityid];
               
        opportunitycurrencycode=opportunityvalues.CurrencyIsoCode;
          OpportunityDetails oppdetails=new OpportunityDetails();   
             oppdetails.opportunityname=opportunityvalues.Name;
             oppdetails.opportunityid=opportunityvalues.Opportunity_ID__c;
             oppdetails.accountname=opportunityvalues.Account.Name;
             oppdetails.totaloppvalue=opportunityvalues.Value__c;
             oppdetails.totaluseroppvalue=oppuservalue.Value__c;
             oppdetails.salesstage=opportunityvalues.StageName;
             opportunitydetailswrapper.add(oppdetails);
       }
     Aggregatemethod();
 }
 
 Public void Aggregatemethod(){
 
  List<currencytype> currencytypelist=[SELECT conversionrate,IsoCode,IsCorporate FROM currencytype];
      conversionRatemap=new Map<String,Double>();
      for(currencytype currencytypevalue: currencytypelist){   
          if(currencytypevalue.IsCorporate){
              corporatecurrencycode=currencytypevalue.IsoCode;
          }
          conversionRatemap.put(currencytypevalue.IsoCode,currencytypevalue.conversionrate);
      }
      
      
     List<AggregateResult> aggregatelist= [SELECT PricebookEntry.Product2.Business_Group__c bg,PricebookEntry.Product2.GBU__c gbu, 
                                          sum(subtotal) Total,sum(First_Fiscal_Year_Value__c) Ffyr,sum(Margin_Amount__c) pm FROM OpportunityLineItem WHERE  
                                          (OpportunityId =:opportunityid AND GBU__c!=null AND Business_Group__c!=null) 
                                          group by rollup (OpportunityId , PricebookEntry.Product2.Business_Group__c, PricebookEntry.Product2.GBU__c) 
                                          order by PricebookEntry.Product2.Business_Group__c ,PricebookEntry.Product2.GBU__c ];
 
     system.debug('aggregatelist****'+aggregatelist);
     opplineitemwrapperlist=new List<opplineitemwrapper>();
     for(AggregateResult aggregateresultvalue: aggregatelist){
     
         if(aggregateresultvalue.get('gbu')==null && aggregateresultvalue.get('bg')!=null){
         
                      opplineitemwrapper wrapper =new opplineitemwrapper();
                      
                      wrapper.businessgroup=String.valueof(aggregateresultvalue.get('bg'));
                      
                      if(corporatecurrencycode==opportunitycurrencycode){
                          wrapper.totalcurrency=Double.valueof(aggregateresultvalue.get('Total'));
                          wrapper.totalusercurrency=Double.valueof(aggregateresultvalue.get('Total'))*(conversionRatemap.get(usercurrencycode));
                          if(aggregateresultvalue.get('Ffyr')!= null){
                          wrapper.ffyrbg=Double.valueof(aggregateresultvalue.get('Ffyr'));
                          wrapper.ffyrusercurrencybg = Double.valueof(aggregateresultvalue.get('Ffyr'))*(conversionRatemap.get(usercurrencycode));
                          }
                          if(aggregateresultvalue.get('pm')!= null){
                          wrapper.pmbg=Double.valueof(aggregateresultvalue.get('pm'));
                          wrapper.pmusercurrencybg = Double.valueof(aggregateresultvalue.get('pm'))*(conversionRatemap.get(usercurrencycode));
                          }
                       }else if((usercurrencycode!=opportunitycurrencycode)&&(usercurrencycode!=corporatecurrencycode)){
                            wrapper.totalcurrency=Userbgcurrecy(String.valueof(aggregateresultvalue.get('bg')));
                            Double usercurrencyvalue=Userbgcurrecy(String.valueof(aggregateresultvalue.get('bg')))*(conversionRatemap.get(usercurrencycode));
                            wrapper.totalusercurrency=usercurrencyvalue/(conversionRatemap.get(opportunitycurrencycode));
                            if(aggregateresultvalue.get('Ffyr')!= null){
                            wrapper.ffyrbg=Userbgffyr(String.valueof(aggregateresultvalue.get('bg')));
                            Double ffyrvaluebg = Userbgffyr(String.valueof(aggregateresultvalue.get('bg')))*(conversionRatemap.get(usercurrencycode));
                            wrapper.ffyrusercurrencybg = ffyrvaluebg/(conversionRatemap.get(opportunitycurrencycode));
                            }
                            if(aggregateresultvalue.get('pm')!= null){
                            wrapper.pmbg=Userbgpm(String.valueof(aggregateresultvalue.get('bg')));
                            Double pmvaluebg = Userbgpm(String.valueof(aggregateresultvalue.get('bg')))*(conversionRatemap.get(usercurrencycode));
                            wrapper.pmusercurrencybg = pmvaluebg/(conversionRatemap.get(opportunitycurrencycode));
                            }
                       }
                       else if(usercurrencycode!=opportunitycurrencycode){
                          wrapper.totalcurrency=Userbgcurrecy(String.valueof(aggregateresultvalue.get('bg')));                        
                          Double usercurrencyvalue=Double.valueof(aggregateresultvalue.get('Total'))/(conversionRatemap.get(opportunitycurrencycode));
                          wrapper.totalusercurrency=Userbgcurrecy(String.valueof(aggregateresultvalue.get('bg')))/(conversionRatemap.get(opportunitycurrencycode));
                          if(aggregateresultvalue.get('Ffyr')!= null){
                          wrapper.ffyrbg=Userbgffyr(String.valueof(aggregateresultvalue.get('bg')));
                          Double ffyrvaluebg=Double.valueof(aggregateresultvalue.get('Ffyr'))/(conversionRatemap.get(opportunitycurrencycode));
                          wrapper.ffyrusercurrencybg=Userbgffyr(String.valueof(aggregateresultvalue.get('bg')))/(conversionRatemap.get(opportunitycurrencycode));
                          }
                          if(aggregateresultvalue.get('pm')!= null){
                          wrapper.pmbg=Userbgpm(String.valueof(aggregateresultvalue.get('bg')));
                          Double pmvaluebg=Double.valueof(aggregateresultvalue.get('pm'))/(conversionRatemap.get(opportunitycurrencycode));
                          wrapper.pmusercurrencybg=Userbgpm(String.valueof(aggregateresultvalue.get('bg')))/(conversionRatemap.get(opportunitycurrencycode));
                          }
                       }
                      else if(usercurrencycode==opportunitycurrencycode){
                          wrapper.totalcurrency=Userbgcurrecy(String.valueof(aggregateresultvalue.get('bg')));                       
                          wrapper.totalusercurrency=wrapper.totalcurrency;
                          if(aggregateresultvalue.get('Ffyr')!= null){
                          wrapper.ffyrbg=Userbgffyr(String.valueof(aggregateresultvalue.get('bg')));
                          wrapper.ffyrusercurrencybg=wrapper.ffyrbg;
                          }
                          if(aggregateresultvalue.get('pm')!= null){
                          wrapper.pmbg=Userbgpm(String.valueof(aggregateresultvalue.get('bg')));
                          wrapper.pmusercurrencybg=wrapper.pmbg;
                          }
                      }
                      wrapper.globalbunit=' ';
                      wrapper.oppcurrencyisocodebg=opportunitycurrencycode;
                      wrapper.usercurrencycodebg='('+usercurrencycode;   
                      wrapper.bgconcatenator=')';  
                      opplineitemwrapperlist.add(wrapper);
                      system.debug('&&opplineitemwrapperlist'+opplineitemwrapperlist);
         }
         
         if(aggregateresultvalue.get('gbu')!=null && aggregateresultvalue.get('bg')!=null){
         
              opplineitemwrapper wrapper1 =new opplineitemwrapper();
              wrapper1.businessgroup=' ';
              wrapper1.totalcurrency=null;
              wrapper1.ffyrbg=null;
              wrapper1.ffyrusercurrencybg=null;
              wrapper1.pmbg=null;
              wrapper1.pmusercurrencybg=null;
              
              if(corporatecurrencycode==opportunitycurrencycode){
                  wrapper1.opportunitycurrency=Double.valueof(aggregateresultvalue.get('Total'));
                  wrapper1.usercurrency=Double.valueof(aggregateresultvalue.get('Total'))*(conversionRatemap.get(usercurrencycode));
                  if(aggregateresultvalue.get('Ffyr')!= null){
                  wrapper1.ffyrgbu=Double.valueof(aggregateresultvalue.get('Ffyr'));
                  wrapper1.ffyrusercurrencygbu=Double.valueof(aggregateresultvalue.get('Ffyr'))*(conversionRatemap.get(usercurrencycode));
                  }
                  if(aggregateresultvalue.get('pm')!= null){
                    wrapper1.pmgbu=Double.valueof(aggregateresultvalue.get('pm'));
                    wrapper1.pmusercurrencygbu=Double.valueof(aggregateresultvalue.get('pm'))*(conversionRatemap.get(usercurrencycode));
                  }
                  
              }else if((usercurrencycode!=opportunitycurrencycode)&&(usercurrencycode!=corporatecurrencycode)){
                       wrapper1.opportunitycurrency=Usergbucurrecy(String.valueof(aggregateresultvalue.get('gbu')));
                       Double usercurrencyvalue=Usergbucurrecy(String.valueof(aggregateresultvalue.get('gbu')))*(conversionRatemap.get(usercurrencycode));
                       wrapper1.usercurrency=usercurrencyvalue/(conversionRatemap.get(opportunitycurrencycode));
                       if(aggregateresultvalue.get('Ffyr')!= null){
                       wrapper1.ffyrgbu=Usergbuffyr(String.valueof(aggregateresultvalue.get('gbu')));
                       Double ffyrvaluegbu=Usergbuffyr(String.valueof(aggregateresultvalue.get('gbu')))*(conversionRatemap.get(usercurrencycode));
                       wrapper1.ffyrusercurrencygbu=ffyrvaluegbu/(conversionRatemap.get(opportunitycurrencycode));
                       }
                       if(aggregateresultvalue.get('pm')!= null){
                       wrapper1.pmgbu=Usergbupm(String.valueof(aggregateresultvalue.get('gbu')));
                       Double pmvaluegbu=Usergbupm(String.valueof(aggregateresultvalue.get('gbu')))*(conversionRatemap.get(usercurrencycode));
                       wrapper1.pmusercurrencygbu=pmvaluegbu/(conversionRatemap.get(opportunitycurrencycode));
                       }
                  }
              
              else if(usercurrencycode!=opportunitycurrencycode){
                       wrapper1.opportunitycurrency=Usergbucurrecy(String.valueof(aggregateresultvalue.get('gbu')));
                       Double usercurrencyvalue=Double.valueof(aggregateresultvalue.get('Total'))/(conversionRatemap.get(opportunitycurrencycode));
                       wrapper1.usercurrency=Usergbucurrecy(String.valueof(aggregateresultvalue.get('gbu')))/(conversionRatemap.get(opportunitycurrencycode));
                       if(aggregateresultvalue.get('Ffyr')!= null){
                       wrapper1.ffyrgbu=Usergbuffyr(String.valueof(aggregateresultvalue.get('gbu')));
                       Double ffyrvaluegbu=Double.valueof(aggregateresultvalue.get('Ffyr'))/(conversionRatemap.get(opportunitycurrencycode));
                       wrapper1.ffyrusercurrencygbu=Usergbuffyr(String.valueof(aggregateresultvalue.get('gbu')))/(conversionRatemap.get(opportunitycurrencycode));
                       }
                       if(aggregateresultvalue.get('pm')!= null){
                       wrapper1.pmgbu=Usergbupm(String.valueof(aggregateresultvalue.get('gbu')));
                       Double pmvaluegbu=Double.valueof(aggregateresultvalue.get('pm'))/(conversionRatemap.get(opportunitycurrencycode));
                       wrapper1.pmusercurrencygbu=Usergbupm(String.valueof(aggregateresultvalue.get('gbu')))/(conversionRatemap.get(opportunitycurrencycode));
                       }
                  }
                  
                  
              else if(usercurrencycode==opportunitycurrencycode){
                       wrapper1.opportunitycurrency=Usergbucurrecy(String.valueof(aggregateresultvalue.get('gbu')));
                       wrapper1.usercurrency=wrapper1.opportunitycurrency;
                       if(aggregateresultvalue.get('Ffyr')!= null){
                          wrapper1.ffyrgbu=Usergbuffyr(String.valueof(aggregateresultvalue.get('gbu')));
                          wrapper1.ffyrusercurrencygbu=wrapper1.ffyrgbu;
                       }
                       if(aggregateresultvalue.get('pm')!= null){
                          wrapper1.pmgbu=Usergbupm(String.valueof(aggregateresultvalue.get('gbu')));
                          wrapper1.pmusercurrencygbu=wrapper1.pmgbu;
                       }
                  }
              wrapper1.globalbunit=String.valueof(aggregateresultvalue.get('gbu'));
              wrapper1.oppucurrencyisocodegbu=opportunitycurrencycode;
              wrapper1.usercurrencycodegbu='('+usercurrencycode;
              wrapper1.gbuconcatenator=')';
              opplineitemwrapperlist.add(wrapper1);
         }
     
     }
 }
 
     public Double Usergbucurrecy(String gbuvalue){
     Double usercurrency=0;
     
     LIST <OpportunityLineItem> opplineitemlist = [SELECT subtotal,CurrencyIsoCode FROM OpportunityLineItem WHERE  OpportunityId =:opportunityid AND PricebookEntry.Product2.GBU__c = :gbuvalue];

           for(OpportunityLineItem opplineitem: opplineitemlist){
           usercurrency=usercurrency+(opplineitem.subtotal);           
           }     
     return usercurrency;
     
     }
    public Double Userbgcurrecy(String businessgroup){
     Double usercurrency=0;     
     LIST <OpportunityLineItem> opplineitemlist = [SELECT subtotal,CurrencyIsoCode FROM OpportunityLineItem WHERE  OpportunityId =:opportunityid AND PricebookEntry.Product2.Business_Group__c = :businessgroup];
           for(OpportunityLineItem opplineitem: opplineitemlist){
           usercurrency=usercurrency+(opplineitem.subtotal);           
           }     
     return usercurrency;
     
     }
     
     public Double Usergbuffyr(String gbuvalue){
     Double usercurrencyffyr=0;
     
     LIST <OpportunityLineItem> opplineitemlist = [SELECT subtotal,CurrencyIsoCode,First_Fiscal_Year_Value__c,Margin_Amount__c FROM OpportunityLineItem WHERE  OpportunityId =:opportunityid AND PricebookEntry.Product2.GBU__c = :gbuvalue];

           for(OpportunityLineItem opplineitem: opplineitemlist){
           usercurrencyffyr=usercurrencyffyr+(opplineitem.First_Fiscal_Year_Value__c);           
           }     
     return usercurrencyffyr;
     
     }
     public Double Userbgffyr(String businessgroup){
     Double usercurrencyffyr=0;     
     LIST <OpportunityLineItem> opplineitemlist = [SELECT subtotal,CurrencyIsoCode,First_Fiscal_Year_Value__c,Margin_Amount__c FROM OpportunityLineItem WHERE  OpportunityId =:opportunityid AND PricebookEntry.Product2.Business_Group__c = :businessgroup];
           for(OpportunityLineItem opplineitem: opplineitemlist){
           usercurrencyffyr=usercurrencyffyr+(opplineitem.First_Fiscal_Year_Value__c);           
           }     
     return usercurrencyffyr;
     
     }
     
      public Double Usergbupm(String gbuvalue){
     Double usercurrencypm=0;
     
     LIST <OpportunityLineItem> opplineitemlist = [SELECT subtotal,CurrencyIsoCode,First_Fiscal_Year_Value__c,Margin_Amount__c FROM OpportunityLineItem WHERE  OpportunityId =:opportunityid AND PricebookEntry.Product2.GBU__c = :gbuvalue];

           for(OpportunityLineItem opplineitem: opplineitemlist){
           usercurrencypm=usercurrencypm+(opplineitem.Margin_Amount__c);           
           }     
     return usercurrencypm;
     
     }
     public Double Userbgpm(String businessgroup){
     Double usercurrencypm=0;     
     LIST <OpportunityLineItem> opplineitemlist = [SELECT subtotal,CurrencyIsoCode,First_Fiscal_Year_Value__c,Margin_Amount__c FROM OpportunityLineItem WHERE  OpportunityId =:opportunityid AND PricebookEntry.Product2.Business_Group__c = :businessgroup];
           for(OpportunityLineItem opplineitem: opplineitemlist){
           usercurrencypm=usercurrencypm+(opplineitem.Margin_Amount__c);           
           }     
     return usercurrencypm;
     
     }
     
       public class opplineitemwrapper{
        public string businessgroup{get;set;}
        public string globalbunit{get;set;}
        public Double totalcurrency{get;set;} 
        public Double totalusercurrency{get;set;} 
        public Double opportunitycurrency{get;set;} 
        public Double usercurrency{get;set;}
        public string usercurrencycodegbu{get;set;}
        public string usercurrencycodebg{get;set;}
        public string oppcurrencyisocodebg{get;set;}
        public string oppucurrencyisocodegbu{get;set;}
        public string bgconcatenator{get;set;}
        public string gbuconcatenator{get;set;}
        public Double ffyrbg{get;set;}
        public Double ffyrusercurrencybg{get;set;}
        public Double ffyrgbu{get;set;}
        public Double ffyrusercurrencygbu{get;set;}
        public Double pmbg{get;set;}
        public Double pmusercurrencybg{get;set;}
        public Double pmgbu{get;set;}
        public Double pmusercurrencygbu{get;set;}
        
       
    }
   public class OpportunityDetails{
        public string opportunityname{get;set;}
        public string opportunityid{get;set;}
        public string accountname{get;set;}
        public Double totaloppvalue{get;set;}
        public Double totaluseroppvalue{get;set;}
        public string salesstage{get;set;}
    }

    


/************************************************************************
        Purpose     : Test Class                  
        Parameters  : None
        Returns     : None
***********************************************************************/
   static testmethod void testlineitemreportcontroller(){
       
       Account acc=new Account();
       acc.Name='test';
       acc.Source_System_Account_ID__c='0987';
       acc.ShippingCountry='India';
       //insert acc;
       
       Opportunity opp=new Opportunity();
       opp.AccountId=acc.id;
       opp.Name='test';
       opp.closedate=system.today();
       opp.StageName='01 - Understand Customer';
       opp.ForecastCategoryName='Test';
       opp.CurrencyIsoCode='USD - U.S. Dollar';
       //insert opp;
       system.currentPageReference().getParameters().put('id',opp.id);
       Lineitemreportcontroller lineitem=new Lineitemreportcontroller();
            
   
   } 
    
}