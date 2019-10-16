public class UpdateFileNumber {

	public  void updateFileNumberOnActivePolicies(List<Policy__c> newTrigger) {

		// create a list of active policies
		List<Policy__c> polList = new List<Policy__c>([
			SELECT Id, Policy_Status__c, Insured__r.Account.Name
			FROM Policy__c
			WHERE Policy_Status__c = 'Active']);

		// get a list of contacts
		List<Contact> conIdSet = new List<Contact>();
	
		// set the contact Ids and store in a set.
		for( Policy__c myPol : polList) {
			if( myPol.Insured__r.Account.Name == 'Networked Insurance Agents') {
			}
		}

		// query the contact records and get the associate Parent Accounts
		Map<Id, Contact> conMap = new Map<Id, Contact>([
							SELECT Id, Name, Marital_Status__c, Account.Parent.Type_of_Company__c
							FROM Contact
							WHERE Id IN: conIdSet]);

		// update the company file number value based on the contact marital status in the record
		for( Policy__c myPol : polList) {
			if( conMap.containsKey(myPol.Insured__c)) {
				myPol.Company_File_Number__c = conMap.get(myPol.Insured__c).Account.Parent.Type_of_Company__c;
			}
		}
	}
}