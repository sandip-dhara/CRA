/**
* Class Name: HPUtils
* Author: HP - Mohit
* Date: 07-Nov-2012 
* Description: Used for static Variables
*/
public class HPUtils{

    public static boolean alreadyCreatedTasks = false;
    public static boolean byPassHPQuoteBeforeTriggers = false;
    public static boolean OpportunityBlacklisting = false;
    public static boolean BGSpecificWorkflows = false;
    public static boolean OpportunityAfterUpdate = false;
    public static boolean OpportunityLineItemAfterInsert = false;
    public static boolean OpportunityLineItemAfterUpdate = false;
    public static boolean OpportunityLineItemBeforeUpdate = false;
    public static boolean OpportunityPartnerFileds = false;
    public static User partnerUser=[select id, name,IsportalEnabled,Location_Record_Id__c,Contact.Account.Channel_Partner_Flag__c,AccountId,Business_Group__c, User_Type_Text__c from user where id=:UserInfo.getUserId()]; 
    Public Static Boolean CaseAfterInsert = False;
    Public Static Boolean AgreementUpdate = False;
    Public Static Boolean AgreementInsertForAtta = False;
    Public Static Boolean AgreementInsertForNote = False;
    Public Static Boolean AgreementInsertForMail = False;
    Public Static Boolean AgreementUpdateOwner = False;
    Public Static Boolean CampaignInfluenceFlag= False;
    Public Static Boolean updateBookshipDateFlag= False;
    Public Static Boolean insertProductsToAgreementFlag= False;
    Public Static Boolean updateSRFlag= False;
    Public Static Boolean insertAgreementFlag= False;
    Public Static Boolean byPassCampaignInfluenceTriggerFlag= False;
    Public Static Boolean globalAccountFlag= False;
    Public Static Boolean contactRoleFlag= False;
    Public Static Integer counter=0;
    }