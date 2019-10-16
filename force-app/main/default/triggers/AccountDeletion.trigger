trigger AccountDeletion on Account (before delete) {

    // Prevent the deletion of accounts if they have
    // related contacts.
    for (Account a : [SELECT Id FROM Account
                     WHERE Id in (SELECT AccountId FROM
                                 Opportunity) AND
                      Id IN:TRigger.old]) {
        Trigger.oldMap.get(a.Id).addError(
        'Cannot delete account with related opportunities.');
        
    }
    
}