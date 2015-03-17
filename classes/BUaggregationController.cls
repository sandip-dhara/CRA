/**********************************************************
* Class Name: ABPQualityScoreCardController
* Author: HP
* Date:07/Jul/2013
* Requirement # Request Id: 8403
* Description: BU Plan Aggregation Results.
* Release: R6
***********************************************************/
public class BUaggregationController {

    class Butotals{  
        public String buName{get;set;}
        public decimal fy11Sum{get;set;}
        public string fy11format{get;set;}
        public decimal fy12Sum{get;set;}
        public string fy12format{get;set;}
        public decimal fy13Sum{get;set;}
        public string fy13format{get;set;}
        public decimal fy14Sum{get;set;}
        public string fy14format{get;set;}
        public decimal fy15Sum{get;set;}
        public string fy15format{get;set;} 
        public decimal fy16Sum{get;set;}
        public string fy16format{get;set;}
        public decimal fy11Avg{get;set;}
        public String fy11AvgFormat{get;set;}
        public decimal fy12Avg{get;set;}
        public String fy12AvgFormat{get;set;}
        public decimal fy13Avg{get;set;}
        public String fy13AvgFormat{get;set;}
        public decimal fy14Avg{get;set;} 
        public String fy14AvgFormat{get;set;}
        public decimal fy15Avg{get;set;} 
        public String fy15AvgFormat{get;set;}
    }
    public Id abpId{get;set;}
    public Decimal totalValue{get;set;}
    public decimal fy11Sum{get;set;}
    public decimal fy12Sum{get;set;}
    public decimal fy13Sum{get;set;}
    public decimal fy14Sum{get;set;}
    public decimal fy15Sum{get;set;}
    public decimal fy11Avg{get;set;}
    public decimal fy12Avg{get;set;}
    public decimal fy13Avg{get;set;}
    public decimal fy14Avg{get;set;}
    public decimal fy15Avg{get;set;}
    Double fy11AvgSum=0;
    Double fy12AvgSum=0;
    Double fy13AvgSum=0;
    Double fy14AvgSum=0;
    Double fy15AvgSum=0;
    Double fy11Total=0;
    Double fy12Total=0;
    Double fy13Total=0;
    Double fy14Total=0;
    Double fy15Total=0;
    Double fy16Total=0;
    public List<AggregateResult> results = new List<AggregateResult>();
    
    public BUaggregationController(ApexPages.StandardController controller) {    
     abpId = Apexpages.currentPage().getParameters().get('abpId');
    }
         
      public  List<Butotals> getResults()
      {
          Id abp = ApexPages.currentPage().getParameters().get('abpId'); 
             List<Butotals> burecords = new List<Butotals>();
             if(Test.isRunningTest()){}
             else{
                 results= [SELECT BU_Name__c red,SUM(FY11_Revenue_actuals__c) totalfy11, SUM(FY12_Revenue_YTD__c) fy12Sum, SUM(FY13_Projected_Revenue__c) totalfy13, SUM(FY14_Projected_Revenue__c) totalfy14, SUM(FY15_Projected_Revenue__c) totalfy15, SUM(FY16_Projected_Revenue__c) totalfy16, AVG(Year_over_Year_1__c) YOY1,AVG(Year_over_Year_2__c)YOY2,AVG(Year_over_Year_3__c) YOY3,AVG(Year_over_Year_4__c) YOY4 FROM Business_Unit_Plan__c where Account_Plan__c =:ApexPages.currentPage().getParameters().get('abpId') group by BU_Name__c ];  //and BU_Name__c != 'HPFS'  
             }
             integer count = results.size();
             if(count>0){
                      for (AggregateResult ar : results){
                          Butotals ob = new Butotals();
                          ob.buName=(String)ar.get('red');
                          if(ar.get('totalfy11')!=null){
                          ob.fy11Sum=double.ValueOf(ar.get('totalfy11')).longValue();
                          ob.fy11format=ob.fy11Sum.format();
                          }
                          else{ob.fy11Sum=0;
                          ob.fy11format=ob.fy11Sum.format();
                          } 
                          if(ar.get('fy12Sum')!=null){
                          ob.fy12Sum=double.ValueOf(ar.get('fy12Sum')).longValue();
                          ob.fy12format=ob.fy12Sum.format();
                          }
                          else{ob.fy12Sum=0;
                          ob.fy12format=ob.fy12Sum.format();
                          } 
                          if(ar.get('totalfy13')!=null){
                          ob.fy13Sum=double.ValueOf(ar.get('totalfy13')).longValue();
                          ob.fy13format=ob.fy13Sum.format();
                          }
                          else{ob.fy13Sum=0;
                          ob.fy13format=ob.fy13Sum.format();
                          }
                          if(ar.get('totalfy14')!=null){
                          ob.fy14Sum=double.ValueOf(ar.get('totalfy14')).longValue();
                          ob.fy14format=ob.fy14Sum.format();
                          }
                          else{ob.fy14Sum=0;
                          ob.fy14format=ob.fy14Sum.format();
                          }
                          if(ar.get('totalfy15')!=null){
                          ob.fy15Sum=double.ValueOf(ar.get('totalfy15')).longValue();
                          ob.fy15format=ob.fy15Sum.format();
                          }
                          else{ob.fy15Sum=0;
                          ob.fy15format=ob.fy15Sum.format();
                          }
                          if(ar.get('totalfy16')!=null){                          
                          ob.fy16Sum=double.ValueOf(ar.get('totalfy16')).longValue();
                          ob.fy16format=ob.fy16Sum.format();
                          }
                          else{
                          ob.fy16Sum=0;
                          ob.fy16format=ob.fy16Sum.format();
                          }
                          
                          if(ob.fy11Sum!=0)
                          ob.fy11Avg=(((ob.fy12Sum-ob.fy11Sum)/ob.fy11Sum)*100).setScale(2);
                          if(ob.fy12Sum!=0)
                          ob.fy12Avg=(((ob.fy13Sum-ob.fy12Sum)/ob.fy12Sum)*100).setScale(2); 
                          if(ob.fy13Sum!=0)
                          ob.fy13Avg=(((ob.fy14Sum-ob.fy13Sum)/ob.fy13Sum)*100).setScale(2); 
                          if(ob.fy14Sum!=0)
                          ob.fy14Avg=(((ob.fy15Sum-ob.fy14Sum)/ob.fy14Sum)*100).setScale(2);
                          if(ob.fy15Sum!=0)
                          ob.fy15Avg=(((ob.fy16Sum-ob.fy15Sum)/ob.fy15Sum)*100).setScale(2);
                          
                          burecords.add(ob);
                          
                          if(ob.buName!=null){
                              if(!ob.buName.equals('HPFS')){
                              fy11Total += ob.fy11Sum;                                     
                              fy12Total += ob.fy12Sum;           
                              fy13Total += ob.fy13Sum;          
                              fy14Total += ob.fy14Sum;          
                              fy15Total += ob.fy15Sum; 
                              fy16Total += ob.fy16Sum;
                              } 
                         }                       
                      }
                  Butotals butot = new BuTotals();
                  butot.buName='Totals';
                  butot.fy11Sum=fy11Total.longValue();
                  butot.fy11format=butot.fy11Sum.format();
                  butot.fy12Sum=fy12Total.longValue();
                  butot.fy12format=butot.fy12Sum.format();
                  butot.fy13Sum=fy13Total.longValue();
                  butot.fy13format=butot.fy13Sum.format();
                  butot.fy14Sum=fy14Total.longValue();
                  butot.fy14format=butot.fy14Sum.format();
                  butot.fy15Sum=fy15Total.longValue();
                  butot.fy15format=butot.fy15Sum.format();
                  butot.fy16Sum=fy16Total.longValue();
                  butot.fy16format=butot.fy16Sum.format();
                  if(butot.fy11Sum!=0){
                      butot.fy11Avg=(((butot.fy12Sum-butot.fy11Sum)/butot.fy11Sum)*100).setScale(2);
                      butot.fy11AvgFormat=butot.fy11Avg.format();
                  }
                  if(butot.fy12Sum!=0){
                      butot.fy12Avg=(((butot.fy13Sum-butot.fy12Sum)/butot.fy12Sum)*100).setScale(2);
                      butot.fy12AvgFormat=butot.fy12Avg.format();
                  }
                  if(butot.fy13Sum!=0){
                      butot.fy13Avg=(((butot.fy14Sum-butot.fy13Sum)/butot.fy13Sum)*100).setScale(2);
                      butot.fy13AvgFormat=butot.fy13Avg.format();
                  }
                  if(butot.fy14Sum!=0){
                      butot.fy14Avg=(((butot.fy15Sum-butot.fy14Sum)/butot.fy14Sum)*100).setScale(2);
                      butot.fy14AvgFormat=butot.fy14Avg.format();
                  }
                  if(butot.fy15Sum!=0){
                      butot.fy15Avg=(((butot.fy16Sum-butot.fy15Sum)/butot.fy15Sum)*100).setScale(2);
                      butot.fy15AvgFormat=butot.fy15Avg.format();
                  }
                  burecords.add(butot);
                  System.debug('records :'+burecords);
              }
              return burecords;      
      }
      public pageReference back(){
        pageReference pr = new pageReference('/'+abpId);
        pr.setRedirect(true);
        return pr;
        
    }
}