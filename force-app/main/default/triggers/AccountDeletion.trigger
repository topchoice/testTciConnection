/**
 * @File Name          : AccountDeletion.trigger
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 3/1/2020, 11:33:32 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    3/1/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
trigger AccountDeletion on Account (before delete) {

    // Prevent the deletion of accounts if they have
    // related Opportunities.
    for (Account a : [SELECT Id FROM Account
                     WHERE Id in (SELECT AccountId FROM
                                 Opportunity) AND
                      Id IN:TRigger.old]) {
        Trigger.oldMap.get(a.Id).addError(
        'Cannot delete account with related opportunities.');
        
    }
    
}