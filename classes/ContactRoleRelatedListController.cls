/********************************
* Class Name: ContactRoleRelatedListController
* Author: Accenture
* Date: 13-JULY-2012 
* Description: ContactRole's Related List section
*********************************/


/*
* Author: Accenture
* Modified: 09-AUG-2012
* Update: Added links for contact name, account name and email instead of keeping read only
* CR#: CR-0124
*/

public class ContactRoleRelatedListController {
    public Id opptyId;
    public list<OpportunityContactRole> list_cont{get;set;}
    public ContactRoleRelatedListController(){}
    public ContactRoleRelatedListController(ApexPages.StandardController stdController) {
        this.opptyId = stdController.getId();
        list_cont = new list<OpportunityContactRole>([Select Id,ContactId,Contact.Name,Contact.AccountId,Contact.Account.Name,Contact.Email,Contact.Phone,IsPrimary,Role from
                  OpportunityContactRole where OpportunityId =:opptyId]);
    }
}