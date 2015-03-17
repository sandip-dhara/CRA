@IsTest(seealldata=true)
public Class RelationshipExtnControllerTest{

static testmethod void testRelationshipExtnController(){   
     List<Relationship_Suite__c> rslist=new List<Relationship_Suite__c>();
        Account acc=TestingSetupDataUtil.createAccount('Test','test@abc.com','Customer');
        insert acc;
        Opportunity opp = new Opportunity(AccountId = acc.id, StageName = '01 - Understand Customer', Name = 'abc', CloseDate = system.today(),CurrencyIsoCode='USD');
        insert opp;
        Opportunity_Plan__c opplan=new Opportunity_Plan__c(Opportunity__c=opp.id);
        insert opplan;
        
        Relationship_Suite__c rs =new Relationship_Suite__c ();
        rs.Opportunity_Plan__c=opplan.Id;
        rs.PowerMatrix__c='Analytical';
        rs.Relationship_map__c='Authorizer - Executive;Justifier-SME';
        rs.Parent_Contact__c='Test';
        rs.PP_S__c=5;
        rslist.add(rs);
        
        Relationship_Suite__c rs11 =new Relationship_Suite__c ();
        rs11.Opportunity_Plan__c=opplan.Id;
        rs11.PowerMatrix__c='Analytical';
        rs11.Relationship_map__c='Authorizer - Executive;Justifier-SME';
        rs11.Parent_Contact__c='Test';
        rs11.PP_S__c=6;
        rslist.add(rs11);
        
        Relationship_Suite__c rs21 =new Relationship_Suite__c ();
        rs21.Opportunity_Plan__c=opplan.Id;
        rs21.PowerMatrix__c='Analytical';
        rs21.Relationship_map__c='Authorizer - Executive;Justifier-SME';
        rs21.Parent_Contact__c='Test';
        rs21.PP_S__c=7;
        rslist.add(rs21);
        
        Relationship_Suite__c rs31 =new Relationship_Suite__c ();
        rs31.Opportunity_Plan__c=opplan.Id;
        rs31.PowerMatrix__c='Analytical';
        rs31.Relationship_map__c='Authorizer - Executive;Justifier-SME';
        rs31.Parent_Contact__c='Test';
        rs31.PP_S__c=9;
        rslist.add(rs31);
        
       
        insert rslist;
        
        
        ApexPages.StandardController controller= new ApexPages.StandardController(opplan);   
        RelationshipExtnController relationshipcon=new RelationshipExtnController(controller);
        //relationshipcon.OppPlanId=opplan.Id;
        
        List<RelationshipExtnController.rsCustom> rscustominstance=new List<RelationshipExtnController.rsCustom>();
        
        RelationshipExtnController.rsCustom wrapper=new RelationshipExtnController.rsCustom();
        rscustominstance.add(wrapper);
        
        relationshipcon.getContactdata();
        relationshipcon.RelSuite=rslist;
        relationshipcon.RelStyle1=rslist;
        relationshipcon.RelSuiteCount=1;
        //relationshipcon.RelSuiteMax=1;
        //relationshipcon.RelSuiteSMax=1;
        relationshipcon.RelSuiteQ1=1;
        relationshipcon.RelSuiteMin=1;
        relationshipcon.addRemaingContacts();
        relationshipcon.getcontactcolorcodestr();
        
        Integer getRelSuiteCount=relationshipcon.RelSuiteCount;
        Integer getRelSuiteQ1=relationshipcon.RelSuiteQ1;
        //Integer getRelSuiteMax=relationshipcon.RelSuiteMax;
        //Integer getRelSuiteSMax=relationshipcon.RelSuiteSMax;
        Integer getRelSuiteMin=relationshipcon.RelSuiteMin;
        
        relationshipcon.RelSuite2=rscustominstance;
        List<Relationship_Suite__c> getRelSuite=relationshipcon.RelSuite;
        List<Relationship_Suite__c> getRelStyle1=relationshipcon.RelStyle1;
        
        List<RelationshipExtnController.rsCustom> getRelSuite2=relationshipcon.RelSuite2;
        
       
       system.debug('&&&&'+getRelStyle1); 
        
        Relationship_Suite__c rs1=new Relationship_Suite__c ();
        rs1.Opportunity_Plan__c=opplan.Id;
        rs1.PowerMatrix__c='Amiable';
        rs1.Relationship_map__c='Authorizer - Executive;Justifier-SME';
        insert rs1;
        List<Relationship_Suite__c> rslist1=new List<Relationship_Suite__c>();
        rslist1.add(rs1);
        ApexPages.StandardController controller1= new ApexPages.StandardController(opplan);   
        RelationshipExtnController relationshipcon1=new RelationshipExtnController(controller1);
        //relationshipcon1.OppPlanId=opplan.Id;
        relationshipcon1.RelStyle2=rslist1;
        relationshipcon1.RelSuiteQ2=1;
        Integer getRelSuiteQ2=relationshipcon1.RelSuiteQ2;
        List<Relationship_Suite__c> getRelStyle2=relationshipcon1.RelStyle2;
        
        
        Relationship_Suite__c rs2=new Relationship_Suite__c ();
        rs2.Opportunity_Plan__c=opplan.Id;
        rs2.PowerMatrix__c='Expressive';
        rs2.Relationship_map__c='Authorizer - Executive;Justifier-SME';
        insert rs2;
        List<Relationship_Suite__c> rslist2=new List<Relationship_Suite__c>();
        rslist2.add(rs2);
        ApexPages.StandardController controller2= new ApexPages.StandardController(opplan);   
        RelationshipExtnController relationshipcon2=new RelationshipExtnController(controller2);
        //relationshipcon2.OppPlanId=opplan.Id;
        relationshipcon2.RelStyle3=rslist2;
        relationshipcon2.RelSuiteQ3=1;
        Integer getRelSuiteQ3=relationshipcon2.RelSuiteQ3;
        List<Relationship_Suite__c> getRelStyle3=relationshipcon2.RelStyle3;
        
        Relationship_Suite__c rs3=new Relationship_Suite__c ();
        rs3.Opportunity_Plan__c=opplan.Id;
        rs3.PowerMatrix__c='Driving';
        rs3.Relationship_map__c='Authorizer - Executive;Justifier-SME';
        insert rs3;
        List<Relationship_Suite__c> rslist3=new List<Relationship_Suite__c>();
        rslist3.add(rs3);
        ApexPages.StandardController controller3= new ApexPages.StandardController(opplan);   
        RelationshipExtnController relationshipcon3=new RelationshipExtnController(controller3);
        //relationshipcon3.OppPlanId=opplan.Id;
        relationshipcon3.RelStyle4=rslist3;
        relationshipcon3.RelSuiteQ4=1;
        Integer getRelSuiteQ4=relationshipcon3.RelSuiteQ4;
        List<Relationship_Suite__c> getRelStyle4=relationshipcon3.RelStyle4;
        

    }
  }