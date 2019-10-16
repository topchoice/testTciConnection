public class AutoCreateOppOnRelatedAccount {

	@InvocableMethod(label='AutoCreateOppOnRelatedAccount' description='Insert Opportunity to related Account')
	public static void RelateOpportunity (List<Lead> leadsList) {
		//TODO: update method return type and input parameters (they do need to be List)

		String str = 'searchValue';

		//get the MappedID's and store it in a set.
    	set<Id> opptyStringSet = new set<Id>();
    	for(Lead acctLeadSet : leadsList){
        	if(acctLeadSet.Merge_Account__c != null || acctLeadSet.Merge_Account__c <> '') {
            opptyStringSet.add(acctLeadSet.Merge_Account__c);
        	}
    	}
    
    	//query the opportunity records and get the associated accounts.
    	map<String, Opportunity> opptyMap = new map<String, opportunity>([SELECT id, accountId from Opportunity where Id IN: opptyStringSet]);

    	//update the account value on the lead based on the opportunity in the record. @TODO: update my code to reflect inserting Opp on found Account
    	for(Lead acctLead : leadsList){
        	if(opptyMap.containsKey(acctLead.Merge_Account__c)) {
            acctLead.Merge_Account__c = opptyMap.get(acctLead.Merge_Account__c).accountId;

        	}       
    	}

    	List<Lead> results = new List<Lead>();

    	System.assertEquals(false,String.isBlank(str)); // returns false since string is not blank
	}
}