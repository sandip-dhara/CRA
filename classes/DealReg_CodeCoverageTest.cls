/**
 * Class Name: DealReg_CodeCoverageTest
 * Author: HP
 * Date: 21-Sep-2013
 * Requirement # Request Id: 
 * Description: Test Class which Covers
 * Classses that have been commented as Part of R6
 */
@IsTest
private class DealReg_CodeCoverageTest{
    static testMethod void testDuplicate(){
//        CampaignObjectTriggerController TCampaignObjectTriggerController = new CampaignObjectTriggerController ();
//        CampaignTriggerUtil TCampaignTriggerUtil = new CampaignTriggerUtil();
        DealReg_PermissionPartnerTrgController TDealReg_PermissionPartnerTrgController = new DealReg_PermissionPartnerTrgController();
//        PartnerCollabUserUtil TPartnerCollabUserUtil = new PartnerCollabUserUtil();
//        DealReg_ProgLocTrgController TDealReg_ProgLocTrgController = new DealReg_ProgLocTrgController();
        DealReg_ProgPartTrgController TDealReg_ProgPartTrgController = new DealReg_ProgPartTrgController();
        DealReg_DuplicatePartnerAssoCheck TDealReg_DuplicatePartnerAssoCheck = new DealReg_DuplicatePartnerAssoCheck();
        DealReg_ProgPermController deal =new DealReg_ProgPermController();

        TDealReg_PermissionPartnerTrgController.sampleMethod();
        TDealReg_ProgPartTrgController.sampleMethod();
        TDealReg_DuplicatePartnerAssoCheck.sampleMethod();
        deal.sampleMethod();
    }
}