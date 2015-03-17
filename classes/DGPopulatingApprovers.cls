/**********************************************************
* Class Name: DGPopulatingApprovers
* Author: Praveen Kumar Reddy/Venky
* Date: 25-Mar-2013
* Requirement # Request Id:
* Description: Controller class for populating approvers for Deal Governance for Opportunity.
***********************************************************/

public Class DGPopulatingApprovers{

    public String ApprovalId;
    public String OpportunityId;
    public String HPApprovalId;
    public boolean recall{set;get;}
    public boolean submit{set;get;}
    public List<AttachWrapper> AttachList;
    public Approval__c approvalRec;
    public boolean isSubmit{set;get;}
    public user activeUser {get;set;}
    public Opportunity oppty {get; set;}
    public Approval__c appr{get; set;}
    public String id;
    public Id attId{set; get;}
    public boolean block{set; get;}
    public String filename{set;get;}
    Public approval__c approvaldetails;
    public String loggedInUserName{set;get;}
    public decimal optyAmount{set; get;}
    public decimal opAmount{set; get;}
    
    public DGPopulatingApprovers(ApexPages.StandardController controller) {
       approvalRec=(Approval__c )controller.getRecord();
       OpportunityId = approvalRec.Opportunity__c;
       loggedInUserName=userinfo.getName();
       if(approvalRec.status__c=='Submitted' || approvalRec.status__c=='Approved' )
       isSubmit=true;
       else
       isSubmit=false;
        this.id = ApexPages.currentPage().getParameters().get('id');
       oppty = opportunityInfo();
    }
    
    public Opportunity opportunityInfo() {
        Opportunity opptyrec;
        try{
       appr = [SELECT Opportunity__r.Id,Account_id__c,Account_Name__c,Account__c,AC_By_Additional_Approver__c,Additional_Language_to_include_on_Quote__c,Additional_Pursuit_BudgetUSD__c,Agreement_Name__c,Alliance_Markup__c,All_sides_in_agreement__c,Anticipated_Carve_Out_from_License__c,Approval_Comments__c,Approval_Description__c,Approval_Long_Name__c,Approval_Routing_Note__c,Approver__c,Billing_Model_TS__c,Billing_Model__c,Business_Justification__c,Case_Country_Time_Zone__c,Case_Origin__c,CA_eMail__c,CA_Name__c,Close_Date__c,Comments__c,Competitive__c,Competitors__c,Contract_Type__c,CreatedById,CreatedDate,CurrencyIsoCode,CurrencyIsoCode__c,Current_Approval_Level__c,Customer_Address__c,Customer_Contact_Name_Title__c,Customer_Contact_Name__c,Customer_Phone_No__c,Date_of_Response__c,Date_Time_bid_is_due_to_the_customer__c,Deal_Composition__c,Description_of_Price_Hold_Discount__c,Dis_on_the_Quote_Itemized__c,Education__c,ELA_Structure__c,ELA_Term_in_months__c,Email_of_BU_Contact_Responsible_for_Mult__c,Engagement_Margin__c,Future_License_Price_Hold_Discount__c,Geographic_License_Option__c,Governing_Terms__c,Gross_Margin__c,Header_or_Item_Discount__c,Id,Identifier__c,If_Other_Please_Specify_Type__c,If_yes_is_the_PM_in_the_region_ES_10pt__c,Inbound_regions_for_multi_region_deal__c,Installed_Base_SW_Relicensing__c,IsDeleted,Is_Deal_being_financed__c,Is_this_part_of_an_ES_deal__c,Language_on_Quote__c,LastActivityDate,LastModifiedById,LastModifiedDate,Lead_Org__c,Meeting_Review_Request_Date__c,Multi_Region_Deal__c,Name,Name_of_Channel_Partner__c,Name__c,Net_Education__c,Net_Hardware_0__c,Net_Packaged_Services__c,Net_Product__c,Net_Professional_Services__c,Net_PS_Net_Travel_Packaged_Services__c,Net_SaaS__c,Net_Support__c,Net_Travel_Expenses__c,Office_jet_ProSupplies_Pricing_Margin__c,Office_jet_Pro_HW_Pricing_Margin__c,Opportunity_Close_Date__c,Opportunity_Id__c,Opportunity_Name__c,Opportunity_Owner_Role__c,Opportunity_Owner__c,Opportunity_Request_Type__c,Opportunity_Start_Date__c,Opportunity_Structure__c,Opportunity_system_id__c,Opportunity_Total_Value__c,Opportunity_Type__c,Opportunity__c,Other__c,Overall_Risk_Rating__c,OwnerFullName__c,OwnerId,Owners_BG__c,Owner_Email__c,Partner_Involvement__c,Payment_Terms__c,Potential_Inter_region_250K_Revenue_Spl__c,Education_Discount__c,EM_via_SWIPER__c,SaaS_Discount__c,Upfront_Support__c,Highest_Individual_Packaged_Services_Dis__c,Premier_Support__c,Previous_Contract_Discounts__c,Previous_Contract_Gross_Value__c,Previous_Contract_Net_Value__c,Previous_Deal_Value__c,Previous_Discount_Percent__c,Pricing_Approach__c,Pricing_Margin__c,Primary_Services_Opportunity_Structure__c,Product_Discount_Pct__c,Promotion_being_used__c,Proposal_Center_Contact_Email__c,Proposal_Due_Date__c,Prosposal_Due_Date__c,Pursuit_Budget_USD__c,Quote_End_Date__c,Quote_Net_Value__c,Quote_Number__c,Quote_Proposal_Expiration_Date__c,Quote_Service_Level_s__c,Quote_Start_Date__c,Quote_Value__c,Reason_for_Carve_Out__c,RecordTypeId,Regions_Involved__c,Region_Account_Region__c,Requestor_Comments__c,Revenue_Splits__c,Risk_Rating__c,SaaS__c,SAID_of_Existing_SW_Installation__c,Sales_Stage__c,Search_Date_From__c,Search_Date_To__c,Services__c,SN_Discount__c,Software__c,Solution_Mix__c,Status__c,Submitted_Date__c,Submitter__c,Support_Duration__c,Support_Type__c,SystemModstamp,System_Pricing_Margin__c,Template_Id__c,Third_Party_Products__c,Total_Opportunity_Value__c,Upfront_Support_Pricing_Methodology__c,What_is_Being_Requested__c,X3P_Royalty_Products_with_HP_SKUs_Includ__c FROM Approval__c where id=:id];
        opptyrec = [Select Primary_Partner__r.Name,Name, Id, SW_Premier__c, Account.Name, Opportunity_ID__c, Deal_Registration_Status__c, CloseDate, StageName, Total_First_12_Month_Value__c,  CurrencyIsoCode, Total_First_Fiscal_Yr_Value__c, Total_Margin_Amount__c,Total_Margin_Percentage__c, Amount, RecordtypeId, SAP_Feed__c from Opportunity where id =: appr.Opportunity__r.Id];
        optyAmount = opptyrec.Amount;
        activeUser = [Select Name, Id, CurrencyIsoCode,Global_Business_Unit__c, DefaultCurrencyIsoCode from User where Id=: userinfo.getuserid()];
        if (activeUser.DefaultCurrencyIsoCode != opptyrec.CurrencyIsoCode){
                opptyrec = [Select Primary_Partner__r.Name,Name, Id, CloseDate, StageName, ConvertCurrency(Total_First_12_Month_Value__c),  CurrencyIsoCode, ConvertCurrency(Total_First_Fiscal_Yr_Value__c), ConvertCurrency(Total_Margin_Amount__c), Total_Margin_Percentage__c, ConvertCurrency(Amount), RecordtypeId, SAP_Feed__c from Opportunity where id =: appr.Opportunity__r.Id];
               appr=[Select Account_id__c,Account_Name__c,Account__c,AC_By_Additional_Approver__c,Additional_Language_to_include_on_Quote__c,Additional_Pursuit_BudgetUSD__c,Agreement_Name__c,Alliance_Markup__c,All_sides_in_agreement__c,Anticipated_Carve_Out_from_License__c,Approval_Comments__c,Approval_Description__c,Approval_Long_Name__c,Approval_Routing_Note__c,Approver__c,Billing_Model_TS__c,Billing_Model__c,Business_Justification__c,Case_Country_Time_Zone__c,Case_Origin__c,CA_eMail__c,CA_Name__c,Close_Date__c,Comments__c,Competitive__c,Competitors__c,Contract_Type__c,CreatedById,CreatedDate,CurrencyIsoCode,CurrencyIsoCode__c,Current_Approval_Level__c,Customer_Address__c,Customer_Contact_Name_Title__c,Customer_Contact_Name__c,Customer_Phone_No__c,Date_of_Response__c,Date_Time_bid_is_due_to_the_customer__c,Deal_Composition__c,Description_of_Price_Hold_Discount__c,Dis_on_the_Quote_Itemized__c,Education__c,ELA_Structure__c,ELA_Term_in_months__c,Email_of_BU_Contact_Responsible_for_Mult__c,Engagement_Margin__c,Future_License_Price_Hold_Discount__c,Geographic_License_Option__c,Governing_Terms__c,Gross_Margin__c,Header_or_Item_Discount__c,Id,Identifier__c,If_Other_Please_Specify_Type__c,If_yes_is_the_PM_in_the_region_ES_10pt__c,Inbound_regions_for_multi_region_deal__c,Installed_Base_SW_Relicensing__c,IsDeleted,Is_Deal_being_financed__c,Is_this_part_of_an_ES_deal__c,Language_on_Quote__c,LastActivityDate,LastModifiedById,LastModifiedDate,Lead_Org__c,Meeting_Review_Request_Date__c,Multi_Region_Deal__c,Name,Name_of_Channel_Partner__c,Name__c,Net_Education__c,Net_Hardware_0__c,Net_Packaged_Services__c,Net_Product__c,Net_Professional_Services__c,Net_PS_Net_Travel_Packaged_Services__c,Net_SaaS__c,Net_Support__c,Net_Travel_Expenses__c,Office_jet_ProSupplies_Pricing_Margin__c,Office_jet_Pro_HW_Pricing_Margin__c,Opportunity_Close_Date__c,Opportunity_Id__c,Opportunity_Name__c,Opportunity_Owner_Role__c,Opportunity_Owner__c,Opportunity_Request_Type__c,Opportunity_Start_Date__c,Opportunity_Structure__c,Opportunity_system_id__c,Opportunity_Total_Value__c,Opportunity_Type__c,Opportunity__c,Other__c,Overall_Risk_Rating__c,OwnerFullName__c,OwnerId,Owners_BG__c,Owner_Email__c,Partner_Involvement__c,Payment_Terms__c,Potential_Inter_region_250K_Revenue_Spl__c,Previous_Contract_Discounts__c,Previous_Contract_Gross_Value__c,Previous_Contract_Net_Value__c,Previous_Deal_Value__c,Education_Discount__c,EM_via_SWIPER__c,SaaS_Discount__c,Upfront_Support__c,Highest_Individual_Packaged_Services_Dis__c,Premier_Support__c,Previous_Discount_Percent__c,Pricing_Approach__c,Pricing_Margin__c,Primary_Services_Opportunity_Structure__c,Product_Discount_Pct__c,Promotion_being_used__c,Proposal_Center_Contact_Email__c,Proposal_Due_Date__c,Prosposal_Due_Date__c,Pursuit_Budget_USD__c,Quote_End_Date__c,Quote_Net_Value__c,Quote_Number__c,Quote_Proposal_Expiration_Date__c,Quote_Service_Level_s__c,Quote_Start_Date__c,Quote_Value__c,Reason_for_Carve_Out__c,RecordTypeId,Regions_Involved__c,Region_Account_Region__c,Requestor_Comments__c,Revenue_Splits__c,Risk_Rating__c,SaaS__c,SAID_of_Existing_SW_Installation__c,Sales_Stage__c,Search_Date_From__c,Search_Date_To__c,Services__c,SN_Discount__c,Software__c,Solution_Mix__c,Status__c,Submitted_Date__c,Submitter__c,Support_Duration__c,Support_Type__c,SystemModstamp,System_Pricing_Margin__c,Template_Id__c,Third_Party_Products__c,Upfront_Support_Pricing_Methodology__c,What_is_Being_Requested__c,X3P_Royalty_Products_with_HP_SKUs_Includ__c,ConvertCurrency(Total_Opportunity_Value__c)from Approval__c where id=:id];
                opAmount = opptyrec.Amount;
        }
         }Catch(Exception e){}
        return opptyrec;   
    }
        
    /* method for getting the attachments associated to the approval record
    public List<Attachment> getAttachments(){
        AttachList = [Select Description, Id, Name, CreatedDate, CreatedById from Attachment where ParentId = :approvalRec.Id ORDER BY CreatedDate DESC];
        return AttachList;
    } */
    /* code for displaying the list of Attachments and showing only latest version of the particulare attachment @R6 By Praveen Kumar Reddy*/
    public List<AttachWrapper> getAttachments(){
        AttachList=new List<AttachWrapper>();
        List<ID> attachmentIDList=new List<ID>();
        Map<ID,Attachment> attMap=new Map<ID,Attachment>();
        List<Attachment> sotedAttachmentList=new List<Attachment>();
        for(Attachment att: [Select Description,parentID, Id, Name,isPrivate, CreatedDate, CreatedById, lastmodifiedDate, lastmodifiedbyid from Attachment where ParentId = :Id ORDER BY LastModifiedDate DESC]){
            attachmentIDList.add(att.ID);
            attMap.put(att.id,att);
            sotedAttachmentList.add(att);
        }
        Map<String,List<Decimal>> attNameVersionMap=new Map<String,List<Decimal>>();
        Map<String,Attachment> nameIDAttMap=new Map<String,Attachment>();
        Map<String,AttachmentExtension__c> attExtMap=new Map<String,AttachmentExtension__c>();
        for(AttachmentExtension__c  ate: [select id,version_number__c,AttachmentReference__c,isChecked__c,CheckedOutBy__c from AttachmentExtension__c where AttachmentReference__c in :attachmentIDList]){
            attExtMap.put(ate.AttachmentReference__c,ate);
           nameIDAttMap.put(ate.version_number__c+ate.AttachmentReference__c ,attMap.get(ate.AttachmentReference__c));//attMap.get(ate.AttachmentReference__c).name
           if(attNameVersionMap.containsKey(attMap.get(ate.AttachmentReference__c).name)){//ate.AttachmentReference__c +
               List<Decimal> versionList=new List<Decimal>();
               versionList=attNameVersionMap.get(attMap.get(ate.AttachmentReference__c).name);
               versionList.add(ate.version_number__c);
               attNameVersionMap.put(attMap.get(ate.AttachmentReference__c).name,versionList);
           }
           else{
               List<Decimal> versionList=new List<Decimal>();
               versionList.add(ate.version_number__c);
               attNameVersionMap.put(attMap.get(ate.AttachmentReference__c).name,versionList);
           }
        }
        for(String fName : attNameVersionMap.keyset()){
            List<Decimal> versionlist=new List<Decimal>();
            versionlist=attNameVersionMap.get(fName);
            versionlist.sort();
            List<Decimal> newVersionList=new List<Decimal>();
            newVersionList.add(versionlist.get(versionlist.size()-1));
            attNameVersionMap.put(fname,newVersionList);
        }
        
        for(Attachment attach: sotedAttachmentList){
            if(attNameVersionMap.containsKey(attach.name)){                
               if(nameIDAttMap.containsKey(attNameVersionMap.get(attach.name)[0]+string.valueOf(attach.id))){                    
                    Attachment originalAtt=nameIDAttMap.get(attNameVersionMap.get(attach.name)[0]+string.valueOf(attach.id));
                    AttachList.add(new AttachWrapper(originalAtt,attExtMap.get(attach.id).isChecked__c,attExtMap.get(attach.id).CheckedOutBy__c,attExtMap.get(attach.id).version_number__c));
                }
            }
               
        }
        return AttachList;
    }


    /* code for deleting the Attachments @R6 By Praveen Kumar Reddy*/
    public pagereference DeleteAttachment()
    {
        //system.debug('##AttachId'+attId);
        if(attId == null){
            return null;
        }
        Attachment attach=new Attachment();
        attach.id=attID;
        
        if(Attach!= null){
            delete Attach;
        }
        AttachmentExtension__c attExt=[select id,isChecked__c,CheckedOutBy__c from AttachmentExtension__c where AttachmentReference__c = :attID];
        if(attExt!=null)
        delete attExt;
        return null;
    }
    
    /* when any user click the checkout version it won't allow other users to checkout or editing @R6 By Praveen Kumar Reddy */
    public pagereference LockAttachment()
    {
        if(attId == null){
            return null;
        }
        
        AttachmentExtension__c  attachCheck=[select id,isChecked__c,CheckedOutBy__c from AttachmentExtension__c where AttachmentReference__c = :attID];
        system.debug('last modified  '+attachCheck.CheckedOutBy__c + '  '+userinfo.getUserID() +' private ' +attachCheck.isChecked__c);
        if(attachCheck.CheckedOutBy__c!=userinfo.getName() && attachCheck.isChecked__c==true ){
             //&& userinfo.getprofileID()!=[select id from profile where name='IT Administrator'].id
            system.debug('*** checked out');
            ApexPages.message msg=new ApexPages.message(ApexPages.Severity.ERROR,'This file has been checked out by another user' );
            ApexPages.addMessage(msg);
            return null;
        }
        if(block == true)
        {
         attachCheck.isChecked__c= true;
        }
        else
        {
         attachCheck.isChecked__c = false;
        }
        attachCheck.AttachmentReference__c  = attID;
        attachCheck.CheckedOutBy__c =userInfo.getName();
        Update attachCheck;
        
        return null;
    }
    
    /* **********************
        when  clicked on the submit for approval button if the record is submitted to approval process successfully, PDF snapshot file with opportunity(including opportunity plan)
        details  will be attached to the approval record 
     ***************** */
    Public static String  AttachPDFFromPage(String ApprovalId,  String HPApprovalId, String OpportunityId){
        try
        {
            DateTime CurrentDate= DateTime.now();
            String FileName='Additional Opportunity Information-';
            FileName+=CurrentDate.format('ddMMyyyy');
            FileName+='-'+HPApprovalId;
            PageReference PDFPage= new PageReference('/apex/dg_Snapshot?id='+OpportunityId);
            Blob PDFContent= PDFPage.getContent();
           
            Attachment a = new Attachment(parentId = ApprovalId, description='System Generated Snapshot', name=FileName+'.pdf', body = PDFContent);
            insert a;
            AttachmentExtension__c   ate=new AttachmentExtension__c  ();
            ate.version_number__c=1;
            ate.AttachmentReference__c=a.id;
            insert ate;
            return 'Success';
        }
        catch(Exception e)
        {
            ApexPages.addMessages(e);
            return 'Fail';
        }
    }// AttachPDFFromPage method end
     
     public PageReference customAttachmentEdit(){

        PageReference pr = new PageReference('/apex/AttachmentEdit?Attachmentid='+attId+'&Approvalid='+appr.id+'&filename='+filename+'&Page=DGApprovalBusinessReviewDetail');
        pr.setRedirect(true);
        return pr;

    }
    /* *****************
        when clicked on the submit for approval button, if the approval record matches with approval flow record then it populates the related approver details to the apporval record 
        and also it submits the approval record to approval process. 
        **********  */
        
    public PageReference populateApprovers(){
        
        List<Approval_Matrix__c> approvalMatrixList=new List<Approval_Matrix__c>();
        Map<id,Approval_Matrix__c> approvalMatrixMap=new Map<id,Approval_Matrix__c>();
        List<Approval_Matrix_Element__c> approvalMatrixDetailsList=new List<Approval_Matrix_Element__c>();
        Map<id,List<Approval_Matrix_Element__c>> approvalMatrixDetailMap=new Map<id,List<Approval_Matrix_Element__c>>();
        Map<Integer,ID> approvalMatrixRankIDMap=new Map<Integer,ID>();
        Map<String,String> currencyFieldMap=new Map<String,String>();
        Double conversionRate=1.0;
                   
         approvaldetails=[select id,name,opportunity__r.id,opportunity__r.Business_Group2__c,opportunity__r.accountid,opportunity__r.account.WorldRegion_Region__c,Approver1__c ,Approver2__c,
                               Approver3__c,Approver4__c,Approver5__c,Approver6__c ,Approver7__c ,Approver8__c,Approver9__c ,Approver10__c,Approver11__c,Approver12__c,Approver13__c,Approver14__c ,Approver15__c ,Approver16__c,Approver17__c,Approver18__c ,Approver19__c ,Approver20__c,
                               Queue_Level_1__c,Queue_Level_2__c,Queue_Level_3__c,Queue_Level_4__c,Queue_Level_5__c,Queue_Level_6__c,Queue_Level_7__c,Queue_Level_8__c,Queue_Level_9__c,Queue_Level_10__c,Queue_Level_11__c,Queue_Level_12__c,Queue_Level_13__c,Queue_Level_14__c,Queue_Level_15__c,Queue_Level_16__c,
                               Queue_Level_17__c,Queue_Level_18__c,Queue_Level_19__c,Queue_Level_20__c,submitter__c,Approval_Flow_Type__c,Approval_Routing_Note__c,RecordType.name,CurrencyIsoCode     from Approval__c where id =:approvalRec.id];
        /* calling the prerouting logic to populate the winning GBU,PL and SPL.  */
        DGPreRoutingLogic prl=new DGPreRoutingLogic ();
        prl.ProductPriorityRouting(approvaldetails.opportunity__r.id,approvaldetails.id);
        
        //fetching the matrix records based on the oportunity region and opportunity owners BG and reivew type
        approvalMatrixList=[select id,name,Account_Region__c,Weight__c,Approver_Level_1__c,Approver_Level_2__c,Approver_Level_3__c,Approver_Level_4__c,Approver_Level_5__c,Approver_Level_6__c,Approver_Level_7__c,Approver_Level_8__c,Approver_Level_9__c,Approver_Level_10__c,Approver_Level_11__c,Approver_Level_12__c,Approver_Level_13__c,Approver_Level_14__c,Approver_Level_15__c,Approver_Level_16__c,
        Approver_Level_17__c,Approver_Level_18__c,Approver_Level_19__c,Approver_Level_20__c,
        Approver_Level_Type_1__c,Approver_Level_Type_2__c,Approver_Level_Type_3__c,Approver_Level_Type_4__c,Approver_Level_Type_5__c,Approver_Level_Type_6__c,Approver_Level_Type_7__c,Approver_Level_Type_8__c,Approver_Level_Type_9__c,Approver_Level_Type_10__c,Approver_Level_Type_11__c,Approver_Level_Type_12__c,Approver_Level_Type_13__c,Approver_Level_Type_14__c,Approver_Level_Type_15__c,Approver_Level_Type_16__c,
        Approver_Level_Type_17__c,Approver_Level_Type_18__c,Approver_Level_Type_19__c,Approver_Level_Type_20__c,
        Approval_Flow_Type__c,Approval_Matrix_Name__c from Approval_Matrix__c where Owner_BG__c includes (:approvaldetails.opportunity__r.Business_Group2__c) and  (Account_Region__c=:approvaldetails.opportunity__r.account.WorldRegion_Region__c OR Account_Region__c='ALL') and Active__c=true and Approval_Type__c= :approvaldetails.RecordType.name Order By Weight__c desc ]; //Owner_BG__c=:approvaldetails.opportunity__r.Business_Group2__c and 
        
        // creating map with weightage and matrix record for if any of the flow doesnt match with approval record based on the least rank populates the approvers info
        for(Approval_Matrix__c am: approvalMatrixList){
            
            approvalMatrixMap.put(am.id,am);
            approvalMatrixRankIDMap.put(integer.valueOf(am.Weight__c),am.id);
        }
        
        //getting the all matrix element records  related to above matrix records    
        approvalMatrixDetailsList=[select id,Field_API_Name__c,Field_Name__c,Match_Type__c,Value__c,Approval_Matrix__c,Object__c,value_min__c ,value_max__c,Approval_Matrix__r.Weight__c,Approval_matrix__r.Approval_Matrix_Name__c  from Approval_Matrix_Element__c where Approval_Matrix__c in :approvalMatrixMap.keySet() order by approval_matrix__r.name,Approval_Matrix__r.Weight__c Desc];
            
        Map<String,String> fieldNamesListMap=new Map<String,String>();
        // creating map with for each matrix record what are all the associated matrix element records
        for(Approval_Matrix_Element__c amd: approvalMatrixDetailsList){
            
            fieldNamesListMap.put(amd.Field_API_Name__c.trim(),amd.object__c);
            system.debug('!@-FieldList-'+fieldNamesListMap);
            if(approvalMatrixDetailMap.containsKey(amd.Approval_Matrix__c)){
                List<Approval_Matrix_Element__c> tempAmdList=new List<Approval_Matrix_Element__c>();
                tempAmdList=approvalMatrixDetailMap.get(amd.Approval_Matrix__c);
                tempAmdList.add(amd);
                approvalMatrixDetailMap.put(amd.Approval_Matrix__c, tempAmdList);
            
            }else{
                List<Approval_Matrix_Element__c> tempAmdList=new List<Approval_Matrix_Element__c>();
                tempAmdList.add(amd);
                approvalMatrixDetailMap.put(amd.Approval_Matrix__c, tempAmdList);
            }
        }
        
        String approvalQuery;
        Approval__c approvalObj=new Approval__c();
        if(fieldNamesListMap.size()>0){
            approvalQuery='Select ';
            
        }
        // creating the approval query dynamically based on the all the fields given in the matrix element and querying the approval record
        if(approvalQuery!=null){
            conversionRate=CurrencyConversionUtil.GetCoversionRate(approvaldetails.CurrencyIsoCode ,'USD',Date.Today());
            system.debug('@@@@@@conversionrate' +conversionRate);
            for(String field: fieldNamesListMap.keySet()){
                system.debug('F*******'+ field);
                Approval_Object_Relationships__c aor=Approval_Object_Relationships__c.getValues(fieldNamesListMap.get(field));
                String relationShip;
                relationShip=aor.Relationships__c;
                /* if(fieldNamesListMap.get(field)==aor.object__c){
                    relationShip=aor.Relationships__c;
                }else if(fieldNamesListMap.get(field)==aor.object__c){
                    relationShip=aor.Relationships__c;
                }  */
                if(Schema.getGlobalDescribe().get(fieldNamesListMap.get(field)).getDescribe().fields.getMap().get(field).getDescribe().getType().name()=='CURRENCY'){
                    currencyFieldMap.put(field,field);                    
                        
                    
                }
                    
                approvalQuery=approvalQuery+relationShip+'.'+field +',';
                
            }
            approvalQuery=approvalQuery.substring(0,(approvalQuery.length())-1) + ' from Approval__c where id=\''+approvalRec.id+'\'';
        
                
            try{
                system.debug('appp****  '+approvalQuery);
                approvalObj=database.query(approvalQuery);                  
                
            }catch(exception e){
                ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Please check the fields in approval matrix detail records');
                ApexPages.addMessage(msg);
                return null;
            }
        }
        //end of dynaminc generation of query 
        
        Map<Integer,ID> matchApprovalMatrixIDRankMap=new Map<Integer,ID>();
        String match;
         // checking the if any of the flow is matching with the approval record, if it matches with first one it will exit the loop 
         
        if(approvalMatrixList!=null){
            for(integer j=0;j<approvalMatrixList.size();j++){
               system.debug('!$'+approvalMatrixList[j].id);
                List<Approval_Matrix_Element__c> amdFieldDetailsList=new  List<Approval_Matrix_Element__c> ();
                if(approvalMatrixDetailMap.containsKey(approvalMatrixList[j].id)){
                    amdFieldDetailsList=approvalMatrixDetailMap.get(approvalMatrixList[j].id);
                    
                }
                
                //amdFieldDetailsList=approvalMatrixDetailMap.get(am.id);
                String whereCondition;
                
                match='No';
                for(Approval_Matrix_Element__c amd : amdFieldDetailsList){
                    String expression;
                   system.debug('rank*** '+amd.approval_matrix__r.weight__c);
                    // custom setting having the relation ship with  opportunity and account to approval object 
                    Approval_Object_Relationships__c aor1=Approval_Object_Relationships__c.getValues(amd.object__c);
                    String relationBwObjects=aor1.Relationships__c;
                    Sobject objectType;
                    List<String> stringSplitList=relationBwObjects.split('\\.');
                    if(stringSplitList.size()>0 && stringSplitList[0] != 'Approval__c'){
                        if(stringSplitList.size()==1){
                            objectType=approvalObj.getSObject(stringSplitList[0]);
                        }
                        if(stringSplitList.size()==2){
                            objectType=approvalObj.getSObject(stringSplitList[0]).getSObject(stringSplitList[1]);
                        }
                        if(stringSplitList.size()==3){
                            objectType=approvalObj.getSObject(stringSplitList[0]).getSObject(stringSplitList[1]).getSObject(stringSplitList[2]);
                        }
                        
                    }else{
                        objectType=(Sobject)approvalObj;
                    }
                    
                    
                    if(amd.Match_Type__c =='Equals'){
                     system.debug('!#equals'+objectType.get(amd.Field_API_Name__c)+amd.Value__c);   
                        
                        if(objectType.get(amd.Field_API_Name__c)!=null ){
                            string fieldVal;
                            if(objectType.get(amd.Field_API_Name__c)==true){
                               fieldVal='true'; 
                            }else if(objectType.get(amd.Field_API_Name__c)==false){
                                fieldVal='false';
                            }else{
                                if(currencyFieldMap.containsKey(amd.Field_API_Name__c) || amd.Field_API_Name__c.equalsIgnoreCase('Winning_GBU_Value__c') || amd.Field_API_Name__c.equalsIgnoreCase('Winning_PL_Value__c') || amd.Field_API_Name__c.equalsIgnoreCase('Winning_SPL_Value__c')){
                                    
                                    Double fval=Double.valueOf(objectType.get(amd.Field_API_Name__c));
                                    fieldVal=String.valueOf(fval*conversionRate);
                                    system.debug('in conversion after conversion '+fieldval);
                                }else{
                                    fieldVal=String.valueOf(objectType.get(amd.Field_API_Name__c));
                                }
                            }
                            if(fieldVal.equalsIgnoreCase(string.valueof(amd.Value__c).trim())){
                                match='Yes';
                            }
                            else{
                                match='No';
                                break;
                            }
                        }else{
                            match='No';
                            break;
                        }
                    }
                    
                    if(amd.Match_Type__c =='Contains'){
                        integer i=0;
                        for(String str: String.valueOf(amd.value__c).split(';')){
                        system.debug('!#contains'+objectType.get(amd.Field_API_Name__c)+'-'+str);
                            IF(objectType.get(amd.Field_API_Name__c)!=null){
                                IF(String.valueOf(objectType.get(amd.Field_API_Name__c)).containsIgnoreCase(str.trim())){
                                    i=i+1;
                                    break;
                                }
                            }
                        }
                        if(i>=1){
                                match='Yes';
                        }
                        else{
                            match='No';
                            break;
                        }  
                    }
            
                    if(amd.Match_Type__c =='Starts With'){ 
                        
                        if(amd.Field_API_Name__c=='Coverage_Segmentation__c'){
                            
                            if(objectType.get(amd.Field_API_Name__c)!=null){
                                for(String segmentVal: String.valueOf(objectType.get(amd.Field_API_Name__c)).split('\\|')){
                                    if(segmentVal.split('\\=')[1].equalsIgnoreCase(amd.value__c)){
                                        match='Yes';
                                        break;
                                    }
                                    else{
                                        match='No';
                                        
                                    }
                                }
                            }else{
                                match='No';
                                break;
                            }
                            if(match=='No')
                            break;
                        
                        }else{
                            if(objectType.get(amd.Field_API_Name__c)!=null){
                                if(String.valueOf(objectType.get(amd.Field_API_Name__c)).startsWithIgnoreCase(string.valueof(amd.value__c).trim())){
                                            match='Yes';
                                }
                                else{
                                    match='No';
                                    break;
                                }
                           }else{
                           
                               match='No';
                               break;
                           }
                        }
                        
                    }
                    
                    if(amd.Match_Type__c =='Range'){
                        Double fieldVal;
                        if(currencyFieldMap.containsKey(amd.Field_API_Name__c) || amd.Field_API_Name__c.equalsIgnoreCase('Winning_GBU_Value__c') || amd.Field_API_Name__c.equalsIgnoreCase('Winning_PL_Value__c') || amd.Field_API_Name__c.equalsIgnoreCase('Winning_SPL_Value__c')){
                                    
                                                                      if(objectType.get(amd.Field_API_Name__c) != null){
                                        fieldVal=Double.valueOf(objectType.get(amd.Field_API_Name__c))*conversionRate;
                                    }else{
                                        fieldVal=0.0;
                                    }
                                    
                        }else{
                            fieldVal=Double.valueOf(objectType.get(amd.Field_API_Name__c));
                        }
                        system.debug('@quang - '+fieldVal + ' min value: '+amd.value_min__c + ' max value: '+amd.value_max__c);
                            if( fieldVal >= amd.value_min__c && fieldVal < amd.value_max__c ){
                                match='Yes';
                            }
                            else{
                                match='No';
                                 break;
                            }
                    }
                
                }
                if(Match=='Yes'){
                    // if any one flow matches with approval record it will exit form the loop
                    matchApprovalMatrixIDRankMap.put(integer.valueOf(approvalMatrixMap.get(approvalMatrixList[j].id).Weight__c),approvalMatrixList[j].id);
                    system.debug('!@-Match'+Match+'-'+matchApprovalMatrixIDRankMap);
                    break;
                }
            
            }
        }
        //wiping out the approver details if already populated by previously matched flow.
        
        if(approvaldetails.approver1__c != null || approvaldetails.approver2__c != null || approvaldetails.approver3__c != null || approvaldetails.approver4__c != null || approvaldetails.approver5__c != null || approvaldetails.approver6__c != null || approvaldetails.approver7__c != null || approvaldetails.approver8__c != null || approvaldetails.approver9__c != null || approvaldetails.approver10__c != null || approvaldetails.approver11__c != null || approvaldetails.approver12__c != null || approvaldetails.approver13__c != null || approvaldetails.approver14__c != null || approvaldetails.approver15__c != null || approvaldetails.approver16__c != null || approvaldetails.approver17__c != null || approvaldetails.approver18__c != null || approvaldetails.approver19__c != null || approvaldetails.approver20__c != null){
            approvaldetails.approver1__c =null;
            approvaldetails.approver2__c =null;
            approvaldetails.approver3__c =null;
            approvaldetails.approver4__c =null;
            approvaldetails.approver5__c =null;
            approvaldetails.approver6__c =null;
            approvaldetails.approver7__c =null;
            approvaldetails.approver8__c =null;
            approvaldetails.approver9__c =null;
            approvaldetails.approver10__c =null;
            approvaldetails.approver11__c =null;
            approvaldetails.approver12__c =null;
            approvaldetails.approver13__c =null;
            approvaldetails.approver14__c =null;
            approvaldetails.approver15__c =null;
            approvaldetails.approver16__c =null;
            approvaldetails.approver17__c =null;
            approvaldetails.approver18__c =null;
            approvaldetails.approver19__c =null;
            approvaldetails.approver20__c =null;
            approvaldetails.Queue_Level_1__c=null;
            approvaldetails.Queue_Level_2__c=null;
            approvaldetails.Queue_Level_3__c=null;
            approvaldetails.Queue_Level_4__c=null;
            approvaldetails.Queue_Level_5__c=null;
            approvaldetails.Queue_Level_6__c=null;
            approvaldetails.Queue_Level_7__c=null;
            approvaldetails.Queue_Level_8__c=null;
            approvaldetails.Queue_Level_9__c=null;
            approvaldetails.Queue_Level_10__c=null;
            approvaldetails.Queue_Level_11__c=null;
            approvaldetails.Queue_Level_12__c=null;
            approvaldetails.Queue_Level_13__c=null;
            approvaldetails.Queue_Level_14__c=null;
            approvaldetails.Queue_Level_15__c=null;
            approvaldetails.Queue_Level_16__c=null;
            approvaldetails.Queue_Level_17__c=null;
            approvaldetails.Queue_Level_18__c=null;
            approvaldetails.Queue_Level_19__c=null;
            approvaldetails.Queue_Level_20__c=null;
            approvaldetails.approval_routing_note__c=null;
           
            
            /*try{
                update approvaldetails;
            }catch(Exception e){ }  */
        }  
        //End of wiping out the approver details
        
        // if approval reocord no match with any one of the flow based on the least weight popluting the approver details 
        if(approvalMatrixList.size()!=0){
            if(matchApprovalMatrixIDRankMap.size()==0){
                List<Integer> rankList=new List<Integer>();
                for(Integer rank: approvalMatrixRankIDMap.keySet()){
                    rankList.add(rank);             
                }
                Integer minRank;
                minRank=rankList[0];
                for(Integer i=0;i<rankList.size();i++){
                    if(rankList[i]<minRank)
                    minRank=rankList[i];                
                }
                if(!approvalMatrixDetailMap.containsKey(approvalMatrixRankIDMap.get(minRank))){
                    Approval_Matrix__c approvalMatrixMatchRec= approvalMatrixMap.get(approvalMatrixRankIDMap.get(minRank));
                    approvaldetails.submitter__c=userinfo.getUserID();
                    List<Approval_Matrix_Element__c> ameListForNote=new List<Approval_Matrix_Element__c>();
                    ameListForNote=approvalMatrixDetailMap.get(approvalMatrixMatchRec.id);
                    if(ameListForNote!=null)
                    approvaldetails.Approval_Routing_Note__c=debuggInformation(approvalMatrixDetailMap.get(approvalMatrixMatchRec.id),approvalQuery);
                    else 
                    approvaldetails.Approval_Routing_Note__c='No Detail Records match found. ApprovalMatrix Id :'+approvalMatrixMatchRec.id;
                    try{
                        update approvaldetails;
                    }catch(Exception e){ }
                    
                    Map<String,ID> pendingAssignUserMap=new Map<String,ID>();
                    for(User pendUser: [select id,name,Email_Address__c from user where Email_Address__c in ('dg.pendingassignment01@hp.com','dg.pendingassignment02@hp.com','dg.pendingassignment03@hp.com','dg.pendingassignment04@hp.com','dg.pendingassignment05@hp.com','dg.pendingassignment06@hp.com','dg.pendingassignment07@hp.com','dg.pendingassignment08@hp.com') ORDER By Name ASC]){
                        pendingAssignUserMap.put(pendUser.Email_Address__c,pendUser.id);
                    }
                    approvaldetails.Approval_Flow_Type__c =approvalMatrixMatchRec.Approval_Flow_Type__c ;
                    system.debug('*****approvalMatrixMatchRec.Approver_Level_1__c*****'+approvalMatrixMatchRec.Approver_Level_1__c);
                    if(approvalMatrixMatchRec.Approver_Level_1__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_1__c !=null){
                    
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_1__c,approvalMatrixMatchRec.Approver_Level_Type_1__c,pendingAssignUserMap,1);
                       if(retVal != null)
                       approvaldetails.Approver1__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_1__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_1__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_1__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_1__c == 'Queue')
                       approvaldetails.Queue_Level_1__c= approvalMatrixMatchRec.Approver_Level_1__c;
                    }
                   system.debug('approvaldetails.Approver1__c'+approvaldetails.Approver1__c);
                    if(approvalMatrixMatchRec.Approver_Level_2__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_2__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_2__c,approvalMatrixMatchRec.Approver_Level_Type_2__c,pendingAssignUserMap,2);
                       if(retVal != null)
                       approvaldetails.Approver2__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_2__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_2__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_2__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_2__c == 'Queue')
                       approvaldetails.Queue_Level_2__c= approvalMatrixMatchRec.Approver_Level_2__c;
                    }
                    
                    if((approvalMatrixMatchRec.Approver_Level_2__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_2__c ==null)&& (approvalMatrixMatchRec.Approver_Level_1__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_1__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_1__c,approvalMatrixMatchRec.Approver_Level_Type_1__c,pendingAssignUserMap,1);
                       if(retVal != null){
                       approvaldetails.Approver2__c =retVal;
                       
                       }
                    
                    }
                   system.debug('approvaldetails.Approver2__c'+approvaldetails.Approver2__c);
                    if(approvalMatrixMatchRec.Approver_Level_3__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_3__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_3__c,approvalMatrixMatchRec.Approver_Level_Type_3__c,pendingAssignUserMap,3);
                       if(retVal != null)
                       approvaldetails.Approver3__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_3__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_3__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_3__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_3__c == 'Queue')
                       approvaldetails.Queue_Level_3__c= approvalMatrixMatchRec.Approver_Level_3__c;
                    }
                     if((approvalMatrixMatchRec.Approver_Level_3__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_3__c ==null) && (approvalMatrixMatchRec.Approver_Level_1__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_1__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_1__c,approvalMatrixMatchRec.Approver_Level_Type_1__c,pendingAssignUserMap,1);
                       if(retVal != null){
                       approvaldetails.Approver3__c =retVal;
                      }
                      
                    }
                    system.debug('approvaldetails.Approver3__c'+approvaldetails.Approver3__c);
                    if(approvalMatrixMatchRec.Approver_Level_4__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_4__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_4__c,approvalMatrixMatchRec.Approver_Level_Type_4__c,pendingAssignUserMap,4);
                       if(retVal != null)
                       approvaldetails.Approver4__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_4__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_4__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_4__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_4__c == 'Queue')
                       approvaldetails.Queue_Level_4__c= approvalMatrixMatchRec.Approver_Level_4__c;
                    }
                     if((approvalMatrixMatchRec.Approver_Level_4__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_4__c ==null) && (approvalMatrixMatchRec.Approver_Level_1__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_1__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_1__c,approvalMatrixMatchRec.Approver_Level_Type_1__c,pendingAssignUserMap,1);
                       if(retVal != null){
                       approvaldetails.Approver4__c =retVal;
                        }
                     
                    }
                    system.debug('approvaldetails.Approver4__c'+approvaldetails.Approver4__c);
                    if(approvalMatrixMatchRec.Approver_Level_5__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_5__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_5__c,approvalMatrixMatchRec.Approver_Level_Type_5__c,pendingAssignUserMap,5);
                       if(retVal != null)
                       approvaldetails.Approver5__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_5__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_5__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_5__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_5__c == 'Queue')
                       approvaldetails.Queue_Level_5__c= approvalMatrixMatchRec.Approver_Level_5__c;
                    }
                    if(approvalMatrixMatchRec.Approver_Level_6__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_6__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_6__c,approvalMatrixMatchRec.Approver_Level_Type_6__c,pendingAssignUserMap,6);
                       if(retVal != null)
                       approvaldetails.Approver6__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_6__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_6__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_6__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_6__c == 'Queue')
                       approvaldetails.Queue_Level_6__c= approvalMatrixMatchRec.Approver_Level_6__c;
                    }
                    
                    if((approvalMatrixMatchRec.Approver_Level_6__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_6__c ==null) && (approvalMatrixMatchRec.Approver_Level_5__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_5__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_5__c,approvalMatrixMatchRec.Approver_Level_Type_5__c,pendingAssignUserMap,5);
                       if(retVal != null)
                       approvaldetails.Approver6__c =retVal;
                       
                    }
                    
                   
                    if(approvalMatrixMatchRec.Approver_Level_7__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_7__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_7__c,approvalMatrixMatchRec.Approver_Level_Type_7__c,pendingAssignUserMap,7);
                       if(retVal != null)
                       approvaldetails.Approver7__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_7__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_7__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_7__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_7__c == 'Queue')
                       approvaldetails.Queue_Level_7__c= approvalMatrixMatchRec.Approver_Level_7__c;
                    }
                    
                    if((approvalMatrixMatchRec.Approver_Level_7__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_7__c ==null) && (approvalMatrixMatchRec.Approver_Level_5__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_5__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_5__c,approvalMatrixMatchRec.Approver_Level_Type_5__c,pendingAssignUserMap,5);
                       if(retVal != null)
                       approvaldetails.Approver7__c =retVal;
                      
                    }
                   
                    if(approvalMatrixMatchRec.Approver_Level_8__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_8__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_8__c,approvalMatrixMatchRec.Approver_Level_Type_8__c,pendingAssignUserMap,8);
                       if(retVal != null)
                       approvaldetails.Approver8__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_8__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_8__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_8__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_8__c == 'Queue')
                       approvaldetails.Queue_Level_8__c= approvalMatrixMatchRec.Approver_Level_8__c;
                    }
                    
                    if((approvalMatrixMatchRec.Approver_Level_8__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_8__c ==null) && (approvalMatrixMatchRec.Approver_Level_5__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_5__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_5__c,approvalMatrixMatchRec.Approver_Level_Type_5__c,pendingAssignUserMap,5);
                       if(retVal != null)
                       approvaldetails.Approver8__c =retVal;
                       
                    }
                    if(approvalMatrixMatchRec.Approver_Level_9__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_9__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_9__c,approvalMatrixMatchRec.Approver_Level_Type_9__c,pendingAssignUserMap,9);
                       if(retVal != null)
                       approvaldetails.Approver9__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_9__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_9__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_9__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_9__c == 'Queue')
                       approvaldetails.Queue_Level_9__c= approvalMatrixMatchRec.Approver_Level_9__c;
                    }
                    if(approvalMatrixMatchRec.Approver_Level_10__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_10__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_10__c,approvalMatrixMatchRec.Approver_Level_Type_10__c,pendingAssignUserMap,10);
                       if(retVal != null)
                       approvaldetails.Approver10__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_10__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_10__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_10__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_10__c == 'Queue')
                       approvaldetails.Queue_Level_10__c= approvalMatrixMatchRec.Approver_Level_10__c;
                    }
                    
                    if((approvalMatrixMatchRec.Approver_Level_10__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_10__c ==null) && (approvalMatrixMatchRec.Approver_Level_9__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_9__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_9__c,approvalMatrixMatchRec.Approver_Level_Type_9__c,pendingAssignUserMap,9);
                       if(retVal != null)
                       approvaldetails.Approver10__c =retVal;
                      
                    }
                    
                    if(approvalMatrixMatchRec.Approver_Level_11__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_11__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_11__c,approvalMatrixMatchRec.Approver_Level_Type_11__c,pendingAssignUserMap,11);
                       if(retVal != null)
                       approvaldetails.Approver11__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_11__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_11__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_11__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_11__c == 'Queue')
                       approvaldetails.Queue_Level_11__c= approvalMatrixMatchRec.Approver_Level_11__c;
                    }
                    if((approvalMatrixMatchRec.Approver_Level_11__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_11__c ==null) && (approvalMatrixMatchRec.Approver_Level_9__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_9__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_9__c,approvalMatrixMatchRec.Approver_Level_Type_9__c,pendingAssignUserMap,9);
                       if(retVal != null)
                       approvaldetails.Approver11__c =retVal;
                       
                    }
                    
                    if(approvalMatrixMatchRec.Approver_Level_12__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_12__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_12__c,approvalMatrixMatchRec.Approver_Level_Type_12__c,pendingAssignUserMap,12);
                       if(retVal != null)
                       approvaldetails.Approver12__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_12__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_12__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_12__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_12__c == 'Queue')
                       approvaldetails.Queue_Level_12__c= approvalMatrixMatchRec.Approver_Level_12__c;
                    }
                    if((approvalMatrixMatchRec.Approver_Level_12__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_12__c ==null) && (approvalMatrixMatchRec.Approver_Level_9__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_9__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_9__c,approvalMatrixMatchRec.Approver_Level_Type_9__c,pendingAssignUserMap,9);
                       if(retVal != null)
                       approvaldetails.Approver12__c =retVal;
                       
                    }
                    if(approvalMatrixMatchRec.Approver_Level_13__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_13__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_13__c,approvalMatrixMatchRec.Approver_Level_Type_13__c,pendingAssignUserMap,13);
                       if(retVal != null)
                       approvaldetails.Approver13__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_13__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_13__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_13__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_13__c == 'Queue')
                       approvaldetails.Queue_Level_13__c= approvalMatrixMatchRec.Approver_Level_13__c;
                    }
                    if(approvalMatrixMatchRec.Approver_Level_14__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_14__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_14__c,approvalMatrixMatchRec.Approver_Level_Type_14__c,pendingAssignUserMap,14);
                       if(retVal != null)
                       approvaldetails.Approver14__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_14__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_14__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_14__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_14__c == 'Queue')
                       approvaldetails.Queue_Level_14__c= approvalMatrixMatchRec.Approver_Level_14__c;
                    }
                    if((approvalMatrixMatchRec.Approver_Level_14__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_14__c ==null) && (approvalMatrixMatchRec.Approver_Level_13__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_13__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_13__c,approvalMatrixMatchRec.Approver_Level_Type_13__c,pendingAssignUserMap,13);
                       if(retVal != null)
                       approvaldetails.Approver14__c =retVal;
                       
                    }
                    if(approvalMatrixMatchRec.Approver_Level_15__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_15__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_15__c,approvalMatrixMatchRec.Approver_Level_Type_15__c,pendingAssignUserMap,15);
                       if(retVal != null)
                       approvaldetails.Approver15__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_15__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_15__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_15__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_15__c == 'Queue')
                       approvaldetails.Queue_Level_15__c= approvalMatrixMatchRec.Approver_Level_15__c;
                    }
                    if((approvalMatrixMatchRec.Approver_Level_15__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_15__c ==null) && (approvalMatrixMatchRec.Approver_Level_13__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_13__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_13__c,approvalMatrixMatchRec.Approver_Level_Type_13__c,pendingAssignUserMap,13);
                       if(retVal != null)
                       approvaldetails.Approver15__c =retVal;
                      
                    }
                    
                    if(approvalMatrixMatchRec.Approver_Level_16__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_16__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_16__c,approvalMatrixMatchRec.Approver_Level_Type_16__c,pendingAssignUserMap,16);
                       if(retVal != null)
                       approvaldetails.Approver16__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_16__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_16__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_16__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_16__c == 'Queue')
                       approvaldetails.Queue_Level_16__c= approvalMatrixMatchRec.Approver_Level_16__c;
                    }
                    if((approvalMatrixMatchRec.Approver_Level_16__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_16__c ==null) && (approvalMatrixMatchRec.Approver_Level_13__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_13__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_13__c,approvalMatrixMatchRec.Approver_Level_Type_13__c,pendingAssignUserMap,13);
                       if(retVal != null)
                       approvaldetails.Approver16__c =retVal;
                      
                    }
                    if(approvalMatrixMatchRec.Approver_Level_17__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_17__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_17__c,approvalMatrixMatchRec.Approver_Level_Type_17__c,pendingAssignUserMap,17);
                       if(retVal != null)
                       approvaldetails.Approver17__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_17__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_17__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_17__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_17__c == 'Queue')
                       approvaldetails.Queue_Level_17__c= approvalMatrixMatchRec.Approver_Level_17__c;
                    }
            if(approvalMatrixMatchRec.Approver_Level_18__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_18__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_18__c,approvalMatrixMatchRec.Approver_Level_Type_18__c,pendingAssignUserMap,18);
                       if(retVal != null)
                       approvaldetails.Approver18__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_18__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_18__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_18__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_18__c == 'Queue')
                       approvaldetails.Queue_Level_18__c= approvalMatrixMatchRec.Approver_Level_18__c;
                    }       
                    if((approvalMatrixMatchRec.Approver_Level_18__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_18__c ==null) && (approvalMatrixMatchRec.Approver_Level_17__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_17__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_17__c,approvalMatrixMatchRec.Approver_Level_Type_17__c,pendingAssignUserMap,17);
                       if(retVal != null)
                       approvaldetails.Approver18__c =retVal;
                      
                    }
                    
                    if(approvalMatrixMatchRec.Approver_Level_19__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_19__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_19__c,approvalMatrixMatchRec.Approver_Level_Type_19__c,pendingAssignUserMap,19);
                       if(retVal != null)
                       approvaldetails.Approver19__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_19__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_19__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_19__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_19__c == 'Queue')
                       approvaldetails.Queue_Level_19__c= approvalMatrixMatchRec.Approver_Level_19__c;
                    }       
                    if((approvalMatrixMatchRec.Approver_Level_19__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_19__c ==null) && (approvalMatrixMatchRec.Approver_Level_17__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_17__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_17__c,approvalMatrixMatchRec.Approver_Level_Type_17__c,pendingAssignUserMap,17);
                       if(retVal != null)
                       approvaldetails.Approver19__c =retVal;
                      
                    }
                    
                    if(approvalMatrixMatchRec.Approver_Level_20__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_20__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_20__c,approvalMatrixMatchRec.Approver_Level_Type_20__c,pendingAssignUserMap,20);
                       if(retVal != null)
                       approvaldetails.Approver20__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_20__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_20__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_20__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_20__c == 'Queue')
                       approvaldetails.Queue_Level_20__c= approvalMatrixMatchRec.Approver_Level_20__c;
                    }       
                    if((approvalMatrixMatchRec.Approver_Level_20__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_20__c ==null) && (approvalMatrixMatchRec.Approver_Level_17__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_17__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_17__c,approvalMatrixMatchRec.Approver_Level_Type_17__c,pendingAssignUserMap,17);
                       if(retVal != null)
                       approvaldetails.Approver20__c =retVal;
                       
                    }
                    
                }else{
                    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'This request does not meet minimum required criteria for the Approval Process');
                    ApexPages.addMessage(msg);
                    return null;
                
                }
            } else if(matchApprovalMatrixIDRankMap.size()==1){  /* if approval reocord  match with any one of the flow  populating the related flow approver details to approval record */
                
                Approval_Matrix__c approvalMatrixMatchRec= approvalMatrixMap.get(matchApprovalMatrixIDRankMap.values()[0]);
                approvaldetails.submitter__c=userinfo.getUserID();
                approvaldetails.Approval_Routing_Note__c=debuggInformation(approvalMatrixDetailMap.get(approvalMatrixMatchRec.id),approvalQuery);
                approvaldetails.Approval_Flow_Type__c =approvalMatrixMatchRec.Approval_Flow_Type__c ;
                try{
                     update approvaldetails;
                    }catch(Exception e){ }
                Map<String,ID> pendingAssignUserMap=new Map<String,ID>();
                for(User pendUser: [select id,name,Email_Address__c from user where Email_Address__c in ('dg.pendingassignment01@hp.com','dg.pendingassignment02@hp.com','dg.pendingassignment03@hp.com','dg.pendingassignment04@hp.com','dg.pendingassignment05@hp.com','dg.pendingassignment06@hp.com','dg.pendingassignment07@hp.com','dg.pendingassignment08@hp.com') ORDER By Name ASC]){
                    pendingAssignUserMap.put(pendUser.Email_Address__c,pendUser.id);
                }
                 if(approvalMatrixMatchRec.Approver_Level_1__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_1__c !=null){
                    
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_1__c,approvalMatrixMatchRec.Approver_Level_Type_1__c,pendingAssignUserMap,1);
                       if(retVal != null)
                       approvaldetails.Approver1__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_1__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_1__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_1__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_1__c == 'Queue')
                       approvaldetails.Queue_Level_1__c= approvalMatrixMatchRec.Approver_Level_1__c;
                    }
                   system.debug('approvaldetails.Approver1__c'+approvaldetails.Approver1__c);
                    if(approvalMatrixMatchRec.Approver_Level_2__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_2__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_2__c,approvalMatrixMatchRec.Approver_Level_Type_2__c,pendingAssignUserMap,2);
                       if(retVal != null)
                       approvaldetails.Approver2__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_2__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_2__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_2__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_2__c == 'Queue')
                       approvaldetails.Queue_Level_2__c= approvalMatrixMatchRec.Approver_Level_2__c;
                    }
                    
                    if((approvalMatrixMatchRec.Approver_Level_2__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_2__c ==null)&& (approvalMatrixMatchRec.Approver_Level_1__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_1__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_1__c,approvalMatrixMatchRec.Approver_Level_Type_1__c,pendingAssignUserMap,1);
                       if(retVal != null){
                       approvaldetails.Approver2__c =retVal;
                       
                       }
                      
                    }
                   system.debug('approvaldetails.Approver2__c'+approvaldetails.Approver2__c);
                    if(approvalMatrixMatchRec.Approver_Level_3__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_3__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_3__c,approvalMatrixMatchRec.Approver_Level_Type_3__c,pendingAssignUserMap,3);
                       if(retVal != null)
                       approvaldetails.Approver3__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_3__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_3__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_3__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_3__c == 'Queue')
                       approvaldetails.Queue_Level_3__c= approvalMatrixMatchRec.Approver_Level_3__c;
                    }
                     if((approvalMatrixMatchRec.Approver_Level_3__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_3__c ==null) && (approvalMatrixMatchRec.Approver_Level_1__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_1__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_1__c,approvalMatrixMatchRec.Approver_Level_Type_1__c,pendingAssignUserMap,1);
                       if(retVal != null){
                       approvaldetails.Approver3__c =retVal;
                      }
                       
                    }
                    system.debug('approvaldetails.Approver3__c'+approvaldetails.Approver3__c);
                    if(approvalMatrixMatchRec.Approver_Level_4__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_4__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_4__c,approvalMatrixMatchRec.Approver_Level_Type_4__c,pendingAssignUserMap,4);
                       if(retVal != null)
                       approvaldetails.Approver4__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_4__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_4__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_4__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_4__c == 'Queue')
                       approvaldetails.Queue_Level_4__c= approvalMatrixMatchRec.Approver_Level_4__c;
                    }
                     if((approvalMatrixMatchRec.Approver_Level_4__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_4__c ==null) && (approvalMatrixMatchRec.Approver_Level_1__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_1__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_1__c,approvalMatrixMatchRec.Approver_Level_Type_1__c,pendingAssignUserMap,1);
                       if(retVal != null){
                       approvaldetails.Approver4__c =retVal;
                        }
                      
                    }
                    system.debug('approvaldetails.Approver4__c'+approvaldetails.Approver4__c);
                    if(approvalMatrixMatchRec.Approver_Level_5__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_5__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_5__c,approvalMatrixMatchRec.Approver_Level_Type_5__c,pendingAssignUserMap,5);
                       if(retVal != null)
                       approvaldetails.Approver5__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_5__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_5__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_5__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_5__c == 'Queue')
                       approvaldetails.Queue_Level_5__c= approvalMatrixMatchRec.Approver_Level_5__c;
                    }
                    if(approvalMatrixMatchRec.Approver_Level_6__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_6__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_6__c,approvalMatrixMatchRec.Approver_Level_Type_6__c,pendingAssignUserMap,6);
                       if(retVal != null)
                       approvaldetails.Approver6__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_6__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_6__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_6__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_6__c == 'Queue')
                       approvaldetails.Queue_Level_6__c= approvalMatrixMatchRec.Approver_Level_6__c;
                    }
                    
                    if((approvalMatrixMatchRec.Approver_Level_6__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_6__c ==null) && (approvalMatrixMatchRec.Approver_Level_5__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_5__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_5__c,approvalMatrixMatchRec.Approver_Level_Type_5__c,pendingAssignUserMap,5);
                       if(retVal != null)
                       approvaldetails.Approver6__c =retVal;
                      
                    }
                    
                   
                    if(approvalMatrixMatchRec.Approver_Level_7__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_7__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_7__c,approvalMatrixMatchRec.Approver_Level_Type_7__c,pendingAssignUserMap,7);
                       if(retVal != null)
                       approvaldetails.Approver7__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_7__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_7__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_7__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_7__c == 'Queue')
                       approvaldetails.Queue_Level_7__c= approvalMatrixMatchRec.Approver_Level_7__c;
                    }
                    
                    if((approvalMatrixMatchRec.Approver_Level_7__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_7__c ==null) && (approvalMatrixMatchRec.Approver_Level_5__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_5__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_5__c,approvalMatrixMatchRec.Approver_Level_Type_5__c,pendingAssignUserMap,5);
                       if(retVal != null)
                       approvaldetails.Approver7__c =retVal;
                      
                    }
                   
                    if(approvalMatrixMatchRec.Approver_Level_8__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_8__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_8__c,approvalMatrixMatchRec.Approver_Level_Type_8__c,pendingAssignUserMap,8);
                       if(retVal != null)
                       approvaldetails.Approver8__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_8__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_8__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_8__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_8__c == 'Queue')
                       approvaldetails.Queue_Level_8__c= approvalMatrixMatchRec.Approver_Level_8__c;
                    }
                    
                    if((approvalMatrixMatchRec.Approver_Level_8__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_8__c ==null) && (approvalMatrixMatchRec.Approver_Level_5__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_5__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_5__c,approvalMatrixMatchRec.Approver_Level_Type_5__c,pendingAssignUserMap,5);
                       if(retVal != null)
                       approvaldetails.Approver8__c =retVal;
                       
                    }
                    if(approvalMatrixMatchRec.Approver_Level_9__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_9__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_9__c,approvalMatrixMatchRec.Approver_Level_Type_9__c,pendingAssignUserMap,9);
                       if(retVal != null)
                       approvaldetails.Approver9__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_9__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_9__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_9__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_9__c == 'Queue')
                       approvaldetails.Queue_Level_9__c= approvalMatrixMatchRec.Approver_Level_9__c;
                    }
                    if(approvalMatrixMatchRec.Approver_Level_10__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_10__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_10__c,approvalMatrixMatchRec.Approver_Level_Type_10__c,pendingAssignUserMap,10);
                       if(retVal != null)
                       approvaldetails.Approver10__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_10__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_10__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_10__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_10__c == 'Queue')
                       approvaldetails.Queue_Level_10__c= approvalMatrixMatchRec.Approver_Level_10__c;
                    }
                    
                    if((approvalMatrixMatchRec.Approver_Level_10__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_10__c ==null) && (approvalMatrixMatchRec.Approver_Level_9__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_9__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_9__c,approvalMatrixMatchRec.Approver_Level_Type_9__c,pendingAssignUserMap,9);
                       if(retVal != null)
                       approvaldetails.Approver10__c =retVal;
                       
                    }
                    
                    if(approvalMatrixMatchRec.Approver_Level_11__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_11__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_11__c,approvalMatrixMatchRec.Approver_Level_Type_11__c,pendingAssignUserMap,11);
                       if(retVal != null)
                       approvaldetails.Approver11__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_11__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_11__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_11__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_11__c == 'Queue')
                       approvaldetails.Queue_Level_11__c= approvalMatrixMatchRec.Approver_Level_11__c;
                    }
                    if((approvalMatrixMatchRec.Approver_Level_11__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_11__c ==null) && (approvalMatrixMatchRec.Approver_Level_9__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_9__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_9__c,approvalMatrixMatchRec.Approver_Level_Type_9__c,pendingAssignUserMap,9);
                       if(retVal != null)
                       approvaldetails.Approver11__c =retVal;
                       
                    }
                    
                    if(approvalMatrixMatchRec.Approver_Level_12__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_12__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_12__c,approvalMatrixMatchRec.Approver_Level_Type_12__c,pendingAssignUserMap,12);
                       if(retVal != null)
                       approvaldetails.Approver12__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_12__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_12__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_12__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_12__c == 'Queue')
                       approvaldetails.Queue_Level_12__c= approvalMatrixMatchRec.Approver_Level_12__c;
                    }
                    if((approvalMatrixMatchRec.Approver_Level_12__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_12__c ==null) && (approvalMatrixMatchRec.Approver_Level_9__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_9__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_9__c,approvalMatrixMatchRec.Approver_Level_Type_9__c,pendingAssignUserMap,9);
                       if(retVal != null)
                       approvaldetails.Approver12__c =retVal;
                       
                    }
                    if(approvalMatrixMatchRec.Approver_Level_13__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_13__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_13__c,approvalMatrixMatchRec.Approver_Level_Type_13__c,pendingAssignUserMap,13);
                       if(retVal != null)
                       approvaldetails.Approver13__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_13__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_13__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_13__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_13__c == 'Queue')
                       approvaldetails.Queue_Level_13__c= approvalMatrixMatchRec.Approver_Level_13__c;
                    }
                    if(approvalMatrixMatchRec.Approver_Level_14__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_14__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_14__c,approvalMatrixMatchRec.Approver_Level_Type_14__c,pendingAssignUserMap,14);
                       if(retVal != null)
                       approvaldetails.Approver14__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_14__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_14__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_14__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_14__c == 'Queue')
                       approvaldetails.Queue_Level_14__c= approvalMatrixMatchRec.Approver_Level_14__c;
                    }
                    if((approvalMatrixMatchRec.Approver_Level_14__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_14__c ==null) && (approvalMatrixMatchRec.Approver_Level_13__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_13__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_13__c,approvalMatrixMatchRec.Approver_Level_Type_13__c,pendingAssignUserMap,13);
                       if(retVal != null)
                       approvaldetails.Approver14__c =retVal;
                       
                    }
                    if(approvalMatrixMatchRec.Approver_Level_15__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_15__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_15__c,approvalMatrixMatchRec.Approver_Level_Type_15__c,pendingAssignUserMap,15);
                       if(retVal != null)
                       approvaldetails.Approver15__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_15__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_15__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_15__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_15__c == 'Queue')
                       approvaldetails.Queue_Level_15__c= approvalMatrixMatchRec.Approver_Level_15__c;
                    }
                    if((approvalMatrixMatchRec.Approver_Level_15__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_15__c ==null) && (approvalMatrixMatchRec.Approver_Level_13__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_13__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_13__c,approvalMatrixMatchRec.Approver_Level_Type_13__c,pendingAssignUserMap,13);
                       if(retVal != null)
                       approvaldetails.Approver15__c =retVal;
                      
                    }
                    
                    if(approvalMatrixMatchRec.Approver_Level_16__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_16__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_16__c,approvalMatrixMatchRec.Approver_Level_Type_16__c,pendingAssignUserMap,16);
                       if(retVal != null)
                       approvaldetails.Approver16__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_16__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_16__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_16__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_16__c == 'Queue')
                       approvaldetails.Queue_Level_16__c= approvalMatrixMatchRec.Approver_Level_16__c;
                    }
                    if((approvalMatrixMatchRec.Approver_Level_16__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_16__c ==null) && (approvalMatrixMatchRec.Approver_Level_13__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_13__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_13__c,approvalMatrixMatchRec.Approver_Level_Type_13__c,pendingAssignUserMap,13);
                       if(retVal != null)
                       approvaldetails.Approver16__c =retVal;
                       
                    }
                    if(approvalMatrixMatchRec.Approver_Level_17__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_17__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_17__c,approvalMatrixMatchRec.Approver_Level_Type_17__c,pendingAssignUserMap,17);
                       if(retVal != null)
                       approvaldetails.Approver17__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_17__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_17__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_17__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_17__c == 'Queue')
                       approvaldetails.Queue_Level_17__c= approvalMatrixMatchRec.Approver_Level_17__c;
                    }
            if(approvalMatrixMatchRec.Approver_Level_18__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_18__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_18__c,approvalMatrixMatchRec.Approver_Level_Type_18__c,pendingAssignUserMap,18);
                       if(retVal != null)
                       approvaldetails.Approver18__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_18__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_18__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_18__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_18__c == 'Queue')
                       approvaldetails.Queue_Level_18__c= approvalMatrixMatchRec.Approver_Level_18__c;
                    }       
                    if((approvalMatrixMatchRec.Approver_Level_18__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_18__c ==null) && (approvalMatrixMatchRec.Approver_Level_17__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_17__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_17__c,approvalMatrixMatchRec.Approver_Level_Type_17__c,pendingAssignUserMap,17);
                       if(retVal != null)
                       approvaldetails.Approver18__c =retVal;
                       
                    }
                    
                    if(approvalMatrixMatchRec.Approver_Level_19__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_19__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_19__c,approvalMatrixMatchRec.Approver_Level_Type_19__c,pendingAssignUserMap,19);
                       if(retVal != null)
                       approvaldetails.Approver19__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_19__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_19__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_19__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_19__c == 'Queue')
                       approvaldetails.Queue_Level_19__c= approvalMatrixMatchRec.Approver_Level_19__c;
                    }       
                    if((approvalMatrixMatchRec.Approver_Level_19__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_19__c ==null) && (approvalMatrixMatchRec.Approver_Level_17__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_17__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_17__c,approvalMatrixMatchRec.Approver_Level_Type_17__c,pendingAssignUserMap,17);
                       if(retVal != null)
                       approvaldetails.Approver19__c =retVal;
                       
                    }
                    
                    if(approvalMatrixMatchRec.Approver_Level_20__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_20__c !=null){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_20__c,approvalMatrixMatchRec.Approver_Level_Type_20__c,pendingAssignUserMap,20);
                       if(retVal != null)
                       approvaldetails.Approver20__c =retVal;
                       else{
                            ApexPages.Message msg;
                            if(approvalMatrixMatchRec.Approver_Level_20__c  == Label.FLM)
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Manager is not populate for submitter or is inactive');
                            else if(approvalMatrixMatchRec.Approver_Level_Type_20__c=='Approver Role')
                            msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Could not find a user with the defined Approver role:'+approvalMatrixMatchRec.Approver_Level_20__c);
                            ApexPages.addMessage(msg);
                            return null;                    
                        }
                       if(approvalMatrixMatchRec.Approver_Level_Type_20__c == 'Queue')
                       approvaldetails.Queue_Level_20__c= approvalMatrixMatchRec.Approver_Level_20__c;
                    }       
                    if((approvalMatrixMatchRec.Approver_Level_20__c ==null  || approvalMatrixMatchRec.Approver_Level_Type_20__c ==null) && (approvalMatrixMatchRec.Approver_Level_17__c !=null  && approvalMatrixMatchRec.Approver_Level_Type_17__c !=null)){
                       ID retVal=decidingApprover(approvalMatrixMatchRec.Approver_Level_17__c,approvalMatrixMatchRec.Approver_Level_Type_17__c,pendingAssignUserMap,17);
                       if(retVal != null)
                       approvaldetails.Approver20__c =retVal;
                       
                 }
                  
            
            }else{ /* if there is no flow match with ApprovalMatrix trowing error message   */
                ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'This request does not meet minimum required criteria for the Approval Process');
                ApexPages.addMessage(msg);
                return null;
            }
            
           
        }else{  /* if there is no flow match with  opportunity region and opportunity owners BG trowing error message  */
                ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'This request does not meet minimum required criteria for the Approval Process');
                ApexPages.addMessage(msg);
                return null;
        }
        try{
            update approvaldetails;
        }catch(Exception e){
            
        }
        // Creating an approval request for the Approval Record
        Approval.ProcessSubmitRequest req1 = 
        new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(approvalRec.id);
        
        // Submit the approval request for the approval record
        try{
            Approval.ProcessResult result = Approval.process(req1);
            if(result.isSuccess()){
                isSubmit=true;
                OpportunityId = approvalRec.Opportunity__c;
                ApprovalId = approvalRec.id;
                HPApprovalId = approvalRec.Approval_Long_Name__c;
                AttachPDFFromPage(ApprovalId,HPApprovalId,OpportunityId); 
            
            }
            
        }catch(Exception e){
             ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'This request does not meet minimum required criteria for the Approval Process');
             ApexPages.addMessage(msg);
             return null;
         }
        //pagereference pg = new pagereference('/apex/DGApprovalOpportunityReviewDetail?id='+approvalRec.id);
        pagereference pg = new pagereference('/'+approvalRec.id);
        pg.setredirect(true);
        return pg; 
        //return null;
   }//populateApprovers Method End
     
    /*
        getting the approver id's bases on the approver level. 
        if approver level is FLM then we are getting first level manager id of submitter
        if the approver levle is Approver Role based on the role getting the user id 
        if the apporver level is Queue populating DG System User id 

        */
    public ID decidingApprover(String approverlevel,String ApproverLevelType,Map<String,ID> pendUserMap,Integer level)
    {
        if(ApproverLevelType=='Job Function' && approverlevel== Label.FLM){
            
            user u=[select id,managerID from User where id = :userinfo.getUserID()];
            User um;
             if(u.managerID !=null){
               um=[select id,isactive from User where id=:u.managerId];
            }
             if(u.managerID !=null && um.isactive==true)
              return u.managerID;
             else {
               return null;
            }
        }else if(ApproverLevelType=='Job Function' && approverlevel== 'Account Executive'){
            
            List<AccountTeamMember> listOptyAccExecUser = new List<AccountTeamMember>();
            listOptyAccExecUser = [Select UserId from AccountTeamMember where AccountId = :approvaldetails.opportunity__r.AccountId and User.Business_Group__c = :approvaldetails.opportunity__r.Business_Group2__c  limit 1];
            if(listOptyAccExecUser.size() > 0)
            return listOptyAccExecUser[0].UserId;
            else {
                
                return null;
            }
                
        }else if(ApproverLevelType=='Approver Role'){
                try{
                    user u =[select id,name from user where Approver_Role__c = : approverlevel];
                    if(u!=null)
                    return u.id;
                    else return null;
                 }catch(Exception e){
                     
                     return null;
                 }
            
        
        }else if(ApproverLevelType=='Queue'){
            //user u=[select id from user where name='DG System User'];
            if(level==1 || level==5 || level==9 || level==13 || level==17){
                if(pendUserMap.containsKey('dg.pendingassignment01@hp.com'))
                return pendUserMap.get('dg.pendingassignment01@hp.com');
                else return null;
            }
            else if(level==2 || level==6 || level==10 || level==14 || level==18){
                if(pendUserMap.containsKey('dg.pendingassignment02@hp.com'))
                return pendUserMap.get('dg.pendingassignment02@hp.com');
                else return null;
            }
            else if(level==3 || level==7 || level==11 || level==15 || level==19){
                if(pendUserMap.containsKey('dg.pendingassignment03@hp.com'))
                return pendUserMap.get('dg.pendingassignment03@hp.com');
                else return null;
            }
            else if(level==4 || level==8 || level==12 || level==16 || level==20){
                if(pendUserMap.containsKey('dg.pendingassignment04@hp.com'))
                return pendUserMap.get('dg.pendingassignment04@hp.com');
                else return null;
            }
            else {
                return null;
            }
        }else{
            return null;
        }
        
    }//End of decidingApprover method
    
    /*
        this method mainly for knowing the with which flow apporval record matced. populating which condition and what are the values of opportunity at the
        time of submission to the Approval Flow Note field.
    */
    public String debuggInformation(List<Approval_Matrix_Element__c> ameList,String approvalQuery){  
        String condition;
        Approval__c approvalObj=new Approval__c();
        try{
            system.debug('appp****  '+approvalQuery);
            approvalObj=database.query(approvalQuery);
        }catch(exception e){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,'Please check the fields in approval matrix detail records');
            ApexPages.addMessage(msg);
            return null;
        }
        condition='Approval Matrix id : '+ameList[0].Approval_Matrix__c+'| Approval Matrix Name : '+ ameList[0].Approval_matrix__r.Approval_Matrix_Name__c;
        for(Approval_Matrix_Element__c ame : ameList){
            Approval_Object_Relationships__c aor1=Approval_Object_Relationships__c.getValues(ame.object__c);
            String relationBwObjects=aor1.Relationships__c;
            Sobject objectType;
            List<String> stringSplitList=relationBwObjects.split('\\.');
            if(stringSplitList.size()>0 && stringSplitList[0] != 'Approval__c'){
                if(stringSplitList.size()==1){
                    objectType=approvalObj.getSObject(stringSplitList[0]);
                }
                if(stringSplitList.size()==2){
                    objectType=approvalObj.getSObject(stringSplitList[0]).getSObject(stringSplitList[1]);
                }
                if(stringSplitList.size()==3){
                    objectType=approvalObj.getSObject(stringSplitList[0]).getSObject(stringSplitList[1]).getSObject(stringSplitList[2]);
                }
                
            }else{              
                objectType=(Sobject)approvalObj;
            }
            if(ame.match_type__c=='Range')
            condition=condition+'| '+ ame.field_name__c + ' >= '+ame.value_min__c +' and '+ ame.field_name__c + ' <= '+ame.value_max__c +' opportunity: '+objectType.get(ame.Field_API_Name__c);    
            else
            condition=condition+'| '+ ame.field_name__c + ' '+ame.Match_Type__c +' '+ ame.value__c+' opportunity:'+objectType.get(ame.Field_API_Name__c);
        }
        return condition;
    }//End of debuggInformation method
        
     
    
     
    public PageReference customEdit(){ 
        try{
            PageReference pr = new PageReference('/apex/DGApprovalBusinessReview?Id='+OpportunityId+ '&AppID='+id);
            pr.setRedirect(true);
            return pr;
        }catch(Exception e){
            ApexPages.addmessages(e);
            return null;
        }
    }//customEdit method end
    
     public Class AttachWrapper{
        public Boolean isChecked{set;get;}
        public String checkedOutBy{set;get;}
        public Decimal versionNumber{set;get;}
        public Attachment at{set;get;}
        public AttachWrapper(Attachment att,Boolean checked,String checkedout,Decimal version){
            this.at=att;
            this.isChecked=checked;
            this.checkedOutBy=checkedout;
            this.versionNumber=version;
            
        
        }
        
    }

}//class end