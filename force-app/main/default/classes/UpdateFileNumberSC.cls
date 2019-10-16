global class UpdateFileNumberSC implements Schedulable {

	global void execute(SchedulableContext sc) {
		//MyBatchClass b = new MyBatchClass();
		//database.executebatch(b);

		// create a list of active policies
		List<Policy__c> polList = new List<Policy__c>([
			SELECT Id, Policy_Status__c, Insured__r.Account.Name
			FROM Policy__c
			WHERE Policy_Status__c = 'Active' 
			AND Insured__r.Account.Name = 'Networked Insurance Agents']);

		// get a list of contacts
		List<Contact> conIdSet = new List<Contact>();
	
		// set the contact Ids and store in a set if Account name is Networked.
		for( Policy__c myPol1 : polList) {
			if( myPol1.Insured__r.Account.Name == 'Networked Insurance Agents') {

		// query the contact records and get the associate Parent Accounts
		Map<Id, Contact> conMap = new Map<Id, Contact>([
							SELECT Id, Name, Marital_Status__c, Account.Parent.Type_of_Company__c, 
							Account.Parent.TestUpdate__c
							FROM Contact
							WHERE Id IN: conIdSet]);

		// update the company file number value in the record
		for( Policy__c myPol : polList) {
			if( conMap.containsKey(myPol.Insured__c) 
					&& myPol.Policy_Status__c == 'Active' 
					&& myPol.Insured__r.Account.Name == 'Networked Insurance Agents') {
				myPol.Company_File_Number__c = conMap.get(myPol.Insured__c).Account.Parent.Type_of_Company__c;
				myPol.TestUpdate__c = conMap.get(myPol.Insured__c).Account.Parent.TestUpdate__c;
				if( myPol.Policy_Type__c == 'Endorsement' && myPol.Endorsement_Date__c == null) {
					myPol.Endorsement_Date__c = system.today();
				}
			}
		}
			}
		}
	}
}