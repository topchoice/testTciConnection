trigger UpdateFileNumber on Policy__c (before insert, before update) {

    // get the contacts Id's and store it in a set.
    set<Id> conIdSet = new set<Id>();
    for( Policy__c polList : Trigger.new) {
        if(polList.Insured__c != Null) {
            conIdSet.add(polList.Insured__c);
        }
    }

    // query the contact records and get the associated Parent Accounts.
    Map<Id, Contact> conMap = new Map<Id, Contact>([
        SELECT Id, Name, Account.Parent.Type_of_Company__c, Account.Parent.TestUpdate__c
        FROM Contact
        WHERE Id IN: conIdSet]);

    // update the company file number value based on the contacts marital status in the record
    for( Policy__c polList : Trigger.new) {
        if( conMap.containsKey(polList.Insured__c)) {
            polList.Company_File_Number__c = conMap.get(polList.Insured__c).Account.Parent.Type_of_Company__c;
            polList.TestUpdate__c = conMap.get(polList.Insured__c).Account.Parent.TestUpdate__c;
        }
    }
}