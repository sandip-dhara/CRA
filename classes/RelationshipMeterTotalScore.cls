/**********************************************************
* Class Name: RelationshipMeterTotalScore
* Author: HP/Mousumi Panda
* Date: 14th Aug 2012 
* Requirement # Request Id: 
* Description: This class has methods called from Trigger.
              
***********************************************************/
Public Class RelationshipMeterTotalScore{

  public static void RelationshipMeter (List<Relationship_Suite__c> relationship){
     String SrtingPP1,SrtingPP2,SrtingPP3,SrtingPP4,SrtingPP5,SrtingPP6,SrtingPP7,SrtingPP8,SrtingPP9,SrtingPP10,SrtingPP11,SrtingPP12;
     Integer result=0;
     String SrtingRM1,SrtingRM2,SrtingRM3,SrtingRM4,SrtingRM5,SrtingRM6,SrtingRM7,SrtingRM8,SrtingRM9,SrtingRM10;
     Integer resultRM=0;
        //Set<id> optyIdSet = new Set<id>();
      for(Relationship_Suite__c RelationshipSuite : relationship){
             system.debug('Value for check: '+RelationshipSuite.PP_S1__c);
            If(RelationshipSuite.PP_S1__c!=null){
               SrtingPP1=(String)RelationshipSuite.PP_S1__c;
               system.debug('SrtingPP1:'+SrtingPP1);
               result+=Integer.valueOf(SrtingPP1.substring(0, 1));
               system.debug('result1:'+result);
             }
            If(RelationshipSuite.PP_S2__c!=null){
               SrtingPP2=(String)RelationshipSuite.PP_S2__c;
               system.debug('SrtingPP2:'+SrtingPP2);
               result+=Integer.valueOf(SrtingPP2.substring(0, 1));
               system.debug('result2:'+result);
            }
            
            If(RelationshipSuite.PP_S3__c!=null){
               SrtingPP3=(String)RelationshipSuite.PP_S3__c;
               system.debug('SrtingPP3:'+SrtingPP3);
               result+=Integer.valueOf(SrtingPP3.substring(0, 1));
               system.debug('result3:'+result);
            }
            
            If(RelationshipSuite.PP_S4__c!=null){
               SrtingPP4=RelationshipSuite.PP_S4__c;
               system.debug('SrtingPP4:'+SrtingPP4);
               result+=Integer.valueOf(SrtingPP4.substring(0, 1));
               system.debug('result4:'+result);
            }
            
            If(RelationshipSuite.PP_S5__c!=null){
               SrtingPP5=RelationshipSuite.PP_S5__c;
               system.debug('SrtingPP5:'+SrtingPP5);
               result+=Integer.valueOf(SrtingPP5.substring(0, 1));
               system.debug('result5:'+result);
            }
            
            If(RelationshipSuite.PP_S6__c!=null){
               SrtingPP6=RelationshipSuite.PP_S6__c;
               system.debug('SrtingPP6:'+SrtingPP6);
               result+=Integer.valueOf(SrtingPP6.substring(0, 1));
               system.debug('result6:'+result);
            }
            
            If(RelationshipSuite.PP_S7__c!=null){
               SrtingPP7=RelationshipSuite.PP_S7__c;
               system.debug('SrtingPP7:'+SrtingPP7);
               result+=Integer.valueOf(SrtingPP7.substring(0, 1));
               system.debug('result7:'+result);
            }
            
            If(RelationshipSuite.PP_S8__c!=null){
               SrtingPP8=RelationshipSuite.PP_S8__c;
               system.debug('SrtingPP8:'+SrtingPP8);
               result+=Integer.valueOf(SrtingPP8.substring(0, 1));
               system.debug('result8:'+result);
            }
            
            If(RelationshipSuite.PP_S9__c!=null){
               SrtingPP9=RelationshipSuite.PP_S9__c;
               system.debug('SrtingPP9:'+SrtingPP9);
               result+=Integer.valueOf(SrtingPP9.substring(0, 1));
               system.debug('result9:'+result);
            }
            
            If(RelationshipSuite.PP_S10__c!=null){
               SrtingPP10=RelationshipSuite.PP_S10__c;
               system.debug('SrtingPP10:'+SrtingPP10);
               result+=Integer.valueOf(SrtingPP10.substring(0, 1));
               system.debug('result10:'+result);
            }
            
            If(RelationshipSuite.PP_S11__c!=null){
               SrtingPP11=RelationshipSuite.PP_S11__c;
               system.debug('SrtingPP11:'+SrtingPP11);
               result+=Integer.valueOf(SrtingPP11.substring(0, 1));
               system.debug('result11:'+result);
            }
            
            If(RelationshipSuite.PP_S12__c!=null){
               SrtingPP12=RelationshipSuite.PP_S12__c;
               system.debug('SrtingPP12:'+SrtingPP12);
               result+=Integer.valueOf(SrtingPP12.substring(0, 1));
               system.debug('result12:'+result);
            }
            
            
          RelationshipSuite.PP_S__c=result;  
        
        
        
        
            If(RelationshipSuite.RM_S1__c!=null){
               SrtingRM1=(String)RelationshipSuite.RM_S1__c;
               system.debug('SrtingRM1:'+SrtingRM1);
               resultRM+=Integer.valueOf(SrtingRM1.substring(0, 1));
               system.debug('resultRM1:'+resultRM);
             }
            If(RelationshipSuite.RM_S2__c!=null){
               SrtingRM2=(String)RelationshipSuite.RM_S2__c;
               system.debug('SrtingRM2:'+SrtingRM2);
               resultRM+=Integer.valueOf(SrtingRM2.substring(0, 1));
               system.debug('resultRM2:'+resultRM);
            }
            
            If(RelationshipSuite.RM_S3__c!=null){
               SrtingRM3=(String)RelationshipSuite.RM_S3__c;
               system.debug('SrtingRM3:'+SrtingRM3);
               resultRM+=Integer.valueOf(SrtingRM3.substring(0, 1));
               system.debug('resultRM3:'+resultRM);
            }
            
            If(RelationshipSuite.RM_S4__c!=null){
               SrtingRM4=(String)RelationshipSuite.RM_S4__c;
               system.debug('SrtingRM4:'+SrtingRM4);
               resultRM+=Integer.valueOf(SrtingRM4.substring(0, 1));
               system.debug('resultRM4:'+resultRM);
            }
            
            If(RelationshipSuite.RM_S5__c!=null){
               SrtingRM5=(String)RelationshipSuite.RM_S5__c;
               system.debug('SrtingRM5:'+SrtingRM5);
               resultRM+=Integer.valueOf(SrtingRM5.substring(0, 1));
               system.debug('resultRM5:'+resultRM);
            }
            
            If(RelationshipSuite.RM_S6__c!=null){
               SrtingRM6=(String)RelationshipSuite.RM_S6__c;
               system.debug('SrtingRM6:'+SrtingRM6);
               resultRM+=Integer.valueOf(SrtingRM6.substring(0, 1));
               system.debug('resultRM6:'+resultRM);
            }
            
            If(RelationshipSuite.RM_S7__c!=null){
               SrtingRM7=(String)RelationshipSuite.RM_S7__c;
               system.debug('SrtingRM7:'+SrtingRM7);
               resultRM+=Integer.valueOf(SrtingRM7.substring(0, 1));
               system.debug('resultRM7:'+resultRM);
            }
            
            If(RelationshipSuite.RM_S8__c!=null){
               SrtingRM8=(String)RelationshipSuite.RM_S8__c;
               system.debug('SrtingRM8:'+SrtingRM8);
               resultRM+=Integer.valueOf(SrtingRM8.substring(0, 1));
               system.debug('resultRM8:'+resultRM);
            }
            
            If(RelationshipSuite.RM_S9__c!=null){
               SrtingRM9=(String)RelationshipSuite.RM_S9__c;
               system.debug('SrtingRM9:'+SrtingRM9);
               resultRM+=Integer.valueOf(SrtingRM9.substring(0, 1));
               system.debug('resultRM9:'+resultRM);
            }
            
            If(RelationshipSuite.RM_S10__c!=null){
               SrtingRM10=(String)RelationshipSuite.RM_S10__c;
               system.debug('SrtingRM10:'+SrtingRM10);
               resultRM+=Integer.valueOf(SrtingRM10.substring(0, 1));
               system.debug('resultRM10:'+resultRM);
            }
            
            
            
             RelationshipSuite.RM_S__c=resultRM;      
       
      }
        
           
        
        //Relationship_Suite__c.Total__c=result;
  }
        
}