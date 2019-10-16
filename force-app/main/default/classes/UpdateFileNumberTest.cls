@isTest
private class UpdateFileNumberTest {
	
	@isTest static void UpdateFileNumber() {
		
		// Policy object test code
		Policy__c newPol = new Policy__c();
		newPol.Company_File_Number__c = '123456';
		try{
			insert newPol;
		}
		catch(exception e) {
			system.assert(newPol.Company_File_Number__c == null, 'Failed to populate Company File Number' 
				+e.getMessage());
		}

		// Contact object test code
		Contact newC = new Contact();
		newC.Spouse_Last_Name__c = 'Test';
		try{
			insert newC;
		}
		catch(exception e) {
			system.assert(false, 'Failed to insert the newC' +e.getMessage());
		}

		set<Policy__c> polSet = new set<Policy__c>();
		List<Contact> conIdSet = ([select Id from Contact]); 
		
		// Update the Policy record to invoke the trigger.
		// query the contact records and get the associated Parent Accounts.
    	Map<Id, Contact> conMap = new Map<Id, Contact>([
        SELECT Id, Name, Account.Industry, Account.Parent.Type_of_Company__c
        FROM Contact
        WHERE Id=: conIdSet]);

    	// update the company file number value based on the contacts marital status in the record
    	for( Policy__c polList : polSet) {
        	if( conMap.containsKey(polList.Insured__c)) {
            	polList.Company_File_Number__c = conMap.get(polList.Insured__c).Account.Parent.Type_of_Company__c;

			}
		}
	}
}