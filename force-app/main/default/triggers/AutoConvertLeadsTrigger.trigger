trigger AutoConvertLeadsTrigger on Lead (after update) {

    if (Trigger.isAfter && Trigger.isUpdate) {
        
        Map<Id,Lead> accountIdToConvertedLead = new Map<Id,Lead>(); // This will associate the ACCOUNT Id to the Lead



        for (Lead myLead : Trigger.newMap.values()) {

            if (myLead.convertedAccountId != Trigger.oldMap.get(myLead.Id).convertedAccountId) {

                if (!accountIdToConvertedLead.containsKey(myLead.convertedAccountId)) {
                accountIdToConvertedLead.put(myLead.convertedAccountId, myLead);
                }
            }
        }

        if (accountIdToConvertedLead.size() > 0)
        updateAccounts(accountIdToConvertedLead);
    }

    public static void updateAccounts(Map<Id,Lead> accountIdToLead) {
    
        Map<Id,Account> updatedAccounts = new Map<Id,Account>([SELECT Id from Account WHERE Id IN : accountIdToLead.keySet()]);
        List<Account> toUpdate = new List<Account>();

        for (Id accountId : accountIdToLead.keySet()) {

        Account thisAccount = updatedAccounts.get(accountId);
        thisAccount.Id = accountIdToLead.get(accountId).Merge_Account__c; // @TODO Change "Merge_Account__c" to the API name of your parent Account field on Lead here
        toUpdate.add(thisAccount);
        }
        update toUpdate;
    }
}