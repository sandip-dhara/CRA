public class DGPreRoutingLogic {


Public boolean Submit{get;set;}
public string GBU{get;set;}
public Double WGBU{get;set;}
public string PL{get;set;}
public Double WPL{get;set;}
public string SPL{get;set;}
public Double WSPL{get;set;}
public string opptyid{get;set;}
public boolean GBUNAValue{get;set;}
Public Boolean PLNAValue{get;set;}
Public Boolean SPLNAValue{get;set;}

/*Public DGPreRoutingLogic(){
    //this OpptyId should be the input parameter for this method.
        Opptyid= '006Z0000003rZOJ';
        Submit = false;
        GBUNAValue = False;
        PLNAValue = False;
        SPLNAValue = False;
        
}*/

public void ProductPriorityRouting(string opptyId,String ApprovalId) {

String BGList;         
List<String> NamePlList = new List<String>();
List<String> NameSplList = new List<String>();
List<String> NameGbuList = new List<String>();

List<String> ValuePlList = new List<String>();
List<String> ValueSplList = new List<String>();
List<String> ValueGbuList = new List<String>();

Map<string,Decimal> IntialplMap = new Map<string,Decimal>();
Map<string,Decimal>  IntialsplMap = new Map<string,Decimal>();
Map<string,Decimal>  IntialgbuMap = new Map<string,Decimal>();

Map<Double,String> DectoStrPlMap = new Map<Double,String>();
Map<Double,String> DectoStrSplMap = new Map<Double,String>();
Map<Double,String> DectoStrGbuMap = new Map<Double,String>();

Map<string,Decimal> plMap = new Map<string,Decimal>();
Map<string,Decimal> GbuMap = new Map<string,Decimal>();      
Map<string,Decimal> SplMap = new Map<string,Decimal>();

Decimal IntialPLValue = 0;
Decimal IntialSPLValue = 0;
Decimal IntialGBUValue = 0;
Decimal GBUValue = 0;  
Decimal SPLValue = 0;
Decimal PLValue = 0;
GBUNAValue = False;
PLNAValue = False;
SPLNAValue = False;
  
   //Get all the Products corresponding to the Opportunity   
    List<opportunity> oppList = new List<opportunity>([select id,Business_Group2__c,(select id,Business_Group__c,GBU__c,subtotal,Product_Line__c,Sub_Product_Line__c from opportunitylineitems) from opportunity where id =:opptyid]);
      
    for (opportunity opp: oppList) {
        BGList = opp.Business_Group2__c;
        for (OpportunityLineItem oli: opp.OpportunityLineItems) {
    
           /* if (IntialplMap.containskey(oli.product_line__c)) {
                IntialPLValue = IntialplMap.get(oli.product_line__c) + oli.Subtotal;
                System.debug('IntialPLValue----' + IntialPLValue);
                System.debug('oli.product_line__c----' + oli.product_line__c);
    
                IntialplMap.put(oli.product_line__c, IntialPLValue);
            } else {
                IntialplMap.put(oli.product_line__c, oli.Subtotal);
            }
            if (IntialsplMap.containskey(oli.Sub_product_line__c)) {
                IntialSPLValue = IntialsplMap.get(oli.sub_product_line__c) + oli.Subtotal;
                IntialsplMap.put(oli.sub_product_line__c, IntialSPLValue);
            } else {
                IntialsplMap.put(oli.sub_product_line__c, oli.Subtotal);
            }*/
            //Map contains GBU as the key and Subtotal as the value.
             if (IntialgbuMap.containskey(oli.GBU__c)) {
                IntialGBUValue = IntialgbuMap.get(oli.gbu__c) + oli.Subtotal;
                IntialgbuMap.put(oli.gbu__c, IntialGBUValue);
            } else {
                IntialgbuMap.put(oli.gbu__c, oli.Subtotal);
            }
        }
    }
            
        system.debug('bgList----'+bgList);
       //Querying Approval Product Classification based on  Opportunity Business Group.
        List<Approval_Product_Classification_item__c> ApprovalProducItemList = new List<Approval_Product_Classification_item__c>([select id,Approval_Product_Classification__c,Approval_Product_Classification__r.BG_Name__c,Approval_Product_Classification__r.Prod_Level__c,Approval_Product_Classification__r.Ranking_Type__c,Value__c,Weight__c from Approval_Product_Classification_Item__c  where Approval_Product_Classification__r.BG_Name__c Includes (:BGlist)]);
        
         for(Approval_Product_Classification_item__c app :ApprovalProducItemList){
             
              if(app.Approval_Product_Classification__r.Ranking_Type__c =='Name'){
                   
                       if(app.Approval_Product_Classification__r.Prod_Level__c == 'Product Line' ){
                                NamePlList.add(app.id);
                                PLNAValue = True;
                        }                        
                       else if(app.Approval_Product_Classification__r.Prod_Level__c == 'Sub Product Line' ){
                                 NameSplList.add(app.id);
                                 SPLNAValue = True;
                       }
                       else if(app.Approval_Product_Classification__r.Prod_Level__c == 'GBU'){
                                NameGbuList.add(app.id);
                                GBUNAValue = True;
                       }
               }
               else if(app.Approval_Product_Classification__r.Ranking_Type__c =='Value'){
                       if(app.Approval_Product_Classification__r.Prod_Level__c == 'Product Line' ){                            
                             ValuePlList.add(app.Value__c);
                             PLNAValue = True;
                       }
                       else if(app.Approval_Product_Classification__r.Prod_Level__c == 'Sub Product Line' ){                            
                             ValueSplList.add(app.Value__c);
                             SPLNAValue = True;
                       }
                       else if(app.Approval_Product_Classification__r.Prod_Level__c == 'GBU'){                            
                             ValueGbuList.add(app.Value__c);
                             GBUNAValue = True;
              }        }
         }
         system.debug('124-----'+GBUNAValue);
         system.debug('125-----'+PLNAValue);
         system.debug('126-----'+sPLNAValue);
          if(GBUNAValue == False){
           GBU = 'N/A';
           wGBU = 0.0;         
         }
         if(PLNAValue == False){
           PL = 'N/A';
           wPL = 0.0;         
         }
         if(SPLNAValue == False){
           sPL = 'N/A';
           wsPL = 0.0;         
         }
        
        //if GBU is value based Ranking 
         if(ValueGbuList.size()>0){
           
           
            List<opportunitylineitem> opptyGbu= new List<opportunitylineitem>([select gbu__c,id,subtotal,sub_product_line__c from opportunitylineitem where opportunityid =:opptyid and GBU__c IN:ValueGbuList ]);
            if(opptyGbu.size()>0){
                for(opportunitylineitem oli :opptyGbu){
                      if(GbuMap.containskey(oli.gbu__c)){
                            GBUValue  = GbuMap.get(oli.gbu__c) + oli.Subtotal;
                            GbuMap.put(oli.gbu__c,GBUValue);
                      }
                      else{
                         GbuMap.put(oli.gbu__c,oli.Subtotal); 
                      }
                }
                //In order to Determine the Highest GBU form gbuMap
                set<string> MapValues = gbuMap.keyset();
                for (string a : MapValues){
                    DectoStrGbuMap.put(IntialgbuMap.get(a),a);
                }
                
                List<Decimal> ListOfValues = IntialgbuMap.values();
                ListOfValues.sort();                
                WGbu = ListOfValues.get(ListOfValues.size()-1);               
                GBU = DectoStrGbuMap.get(wGbu);
                
             }
         }
         
         //if GBU is Name based Ranking
         if(NameGbuList.size()>0){
              List<Approval_Product_Classification_item__c> RevenueLines = new List<Approval_Product_Classification_item__c>([select  value__c,weight__C from  Approval_Product_Classification_item__c where Approval_Product_Classification__r.BG_Name__c Includes (:BGlist) and Approval_Product_Classification__r.Prod_Level__c ='GBU' ORDER BY weight__c Desc ]);
             
              
             For (Approval_Product_Classification_item__c ar : revenuelines)
             {
              
                    if(IntialgbuMap.containskey(string.valueof(ar.value__c))){
                          GBU  = ar.value__c;
                          wGBU = IntialgbuMap.get(string.valueof(ar.value__c));
                         break;
                    }               
              }         
         }
         
         
         List<opportunity> OppProdutlist;
         If(GBU !='N/A')
             OppProdutlist = new List<opportunity>([select id,Business_Group2__c,(select id,Business_Group__c,GBU__c,subtotal,Product_Line__c,Sub_Product_Line__c from opportunitylineitems where GBU__c =:GBU) from opportunity where id =:opptyid]);
         else
               OppProdutlist = new List<opportunity>([select id,Business_Group2__c,(select id,Business_Group__c,GBU__c,subtotal,Product_Line__c,Sub_Product_Line__c from opportunitylineitems) from opportunity where id =:opptyid]);
         for (opportunity opp: OppProdutlist) {
        
          for (OpportunityLineItem oli: opp.OpportunityLineItems) {
    
            if (IntialplMap.containskey(oli.product_line__c)) {
                IntialPLValue = IntialplMap.get(oli.product_line__c) + oli.Subtotal;
                
                IntialplMap.put(oli.product_line__c, IntialPLValue);
            } else {
                IntialplMap.put(oli.product_line__c, oli.Subtotal);
            }
            if (IntialsplMap.containskey(oli.Sub_product_line__c)) {
                IntialSPLValue = IntialsplMap.get(oli.sub_product_line__c) + oli.Subtotal;
                IntialsplMap.put(oli.sub_product_line__c, IntialSPLValue);
            } else {
                IntialsplMap.put(oli.sub_product_line__c, oli.Subtotal);
            }
            
        }
    }
         
         //if Product Line  is Value based Ranking
         if(ValuePlList.size()>0){
          List<opportunitylineitem> opptypl;
          if(GBU !='N/A') 
          opptypl = new List<opportunitylineitem>([select id,subtotal,sub_product_line__c from opportunitylineitem where opportunityid =:opptyid and GBU__C =:GBU and product_line__c IN:ValuePlList ]);
          Else
          opptypl = new List<opportunitylineitem>([select id,subtotal,sub_product_line__c from opportunitylineitem where opportunityid =:opptyid  and product_line__c IN:ValuePlList ]);
         if(opptypl.size()>0){   
                 for(opportunitylineitem oli :opptypl){
                     if(plMap.containskey(oli.product_line__c)){
                         PLValue  = plMap.get(oli.product_line__c) + oli.Subtotal;
                         plMap.put(oli.product_line__c,PLValue);
                      }
                      else
                      {
                         plMap.put(oli.product_line__c,oli.Subtotal); 
                      }
                }
                //In order to Determine the Highest Product line form plMap 
                set<string> MapValues = plMap.keyset();
                for (string a : MapValues){
                     DectoStrPlMap.put(IntialplMap.get(a),a);
                }
                    
                List<Decimal> ListOfValues = IntialplMap.values();
                ListOfValues.sort();
                wpl = ListOfValues.get(ListOfValues.size()-1);
                pl = DectoStrPlMap.get(wpl);
          } 
         }
         //if Sub Product Line  is value based Ranking
          if(ValueSplList.size()>0){
            List<opportunitylineitem> opptylineitem;
            If(GBU !='N/A')
            opptylineitem = new List<opportunitylineitem>([select id,subtotal,sub_product_line__c from opportunitylineitem where opportunityid =:opptyid and GBU__C =:GBU and sub_Product_Line__c IN:ValueSplList ]);
            Else
            opptylineitem = new List<opportunitylineitem>([select id,subtotal,sub_product_line__c from opportunitylineitem where opportunityid =:opptyid  and sub_Product_Line__c IN:ValueSplList ]);
            if(opptylineitem.size()>0){
                    for(opportunitylineitem oli :opptylineitem){
                          if(SplMap.containskey(oli.Sub_product_line__c)){
                                SPLValue  = splMap.get(oli.sub_product_line__c) + oli.Subtotal;
                                SplMap.put(oli.sub_product_line__c,SPLValue);
                          }
                          else{
                             SplMap.put(oli.sub_product_line__c,oli.Subtotal); 
                          }
                    }
                   //In order to Determine the Highest Sub Product line form splMap
                   
                    set<string> MapValues = SplMap.keyset();
                    
                    for (string a : MapValues){
                        
                        DectoStrSplMap.put(SplMap.get(a).setscale(1),a);
                        
                    }
                    
                    List<Decimal> ListOfValues = SplMap.values();
                    ListOfValues.sort();     
                          
                    wspl = ListOfValues.get(ListOfValues.size()-1).setscale(1);            
                    spl = DectoStrSplMap.get(wspl);
            
            }
         }
        //if Product Line  is Name based Ranking  
         if(NamePlList.size()>0){
              List<Approval_Product_Classification_item__c> RevenueLines = new List<Approval_Product_Classification_item__c>([select  value__c,weight__C from  Approval_Product_Classification_item__c where Approval_Product_Classification__r.BG_Name__c Includes (:BGlist) and Approval_Product_Classification__r.Prod_Level__c ='Product Line' ORDER BY weight__c Desc ]);
          
            system.debug('Intialplmap-------'+IntialplMap);
             For (Approval_Product_Classification_item__c ar : revenuelines)
             {
               
                    if(IntialplMap.containskey(string.valueof(ar.value__c))){
                          PL = ar.value__c;
                          wPL = IntialplMap.get(string.valueof(ar.value__c));
                         break;
                    }
               
              }
         
         }
         //if Sub Product Line  is Name based Ranking
          if(NameSplList.size()>0){
              List<Approval_Product_Classification_item__c> RevenueLines = new List<Approval_Product_Classification_item__c>([select  value__c,weight__C from  Approval_Product_Classification_item__c where Approval_Product_Classification__r.BG_Name__c Includes (:BGlist) and Approval_Product_Classification__r.Prod_Level__c ='Sub Product Line' ORDER BY weight__c Desc ]);
            
             For (Approval_Product_Classification_item__c ar : revenuelines)
             {
               
                    if(IntialsplMap.containskey(string.valueof(ar.value__c))){
                          sPL = ar.value__c;
                          wsPL = IntialsplMap.get(string.valueof(ar.value__c));
                         break;
                    }               
              }         
         }
          
        
          // Approval = new Approval__c();
      Approval__c  Approval = [select id,Winning_Gbu__c,Winning_PL__c,Winning_SPL__c,Winning_GBU_Value__c,Winning_PL_Value__c,Winning_SPL_Value__c,Approver1__c ,Approver2__c,
            Approver3__c,Approver4__c,Approver5__c,Approver6__c ,Approver7__c ,Approver8__c,Queue_Level_1__c,Queue_Level_2__c,Queue_Level_3__c,Queue_Level_4__c,Queue_Level_5__c,Queue_Level_6__c,Queue_Level_7__c,Queue_Level_8__c,submitter__c,Approval_Flow_Type__c,Approval_Routing_Note__c from Approval__c where id =:ApprovalId]; 
      
      system.debug('spl----'+spl);
      system.debug('wspl----'+wspl);
          Approval.Winning_Gbu__c = GBU;
          Approval.Winning_PL__c = PL;
          Approval.Winning_SPL__c = SPL;
          Approval.Winning_GBU_Value__c =wGBU;          
          Approval.Winning_PL_Value__c =wPL;          
          Approval.Winning_spl_Value__c =wSPL;
          
          
         
         try{
                update Approval;
            }catch(Exception e){ }
      
        //return void;
    }
    
   

}