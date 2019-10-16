trigger UpdateCaseValues on Case (before insert, before update) {

    List<Account> acctList = [SELECT Id, TestUpdate__c FROM Account WHERE TestUpdate__c != null 
                            AND Active__c = 'Yes'];
    
    for ( Account acct : acctList) {
        
    Case prevCaseRec = [SELECT Id, TestUpdate__c, Policy_Number__c, Account.TestUpdate__c
                            FROM Case
                            ORDER BY CreatedDate desc Limit 1];

        for ( Case c : Trigger.new) {
            if ( c.TestUpdate__c == acct.TestUpdate__c) {
            c.Policy_Number__c = prevCaseRec.TestUpdate__c;
            }
        }
    }
}