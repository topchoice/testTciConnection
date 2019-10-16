@isTest
private class CaseUpdateBatchTest {
	
	@testSetup
	static void setupData() {
		
		// insert Consultant
		List<Consultant__c> consultantList = TCITestDataFactory.createConsultants(1);
		Consultant__c newTCITeam = new Consultant__c();
		newTCITeam.First_Name__c = 'Mike';
		newTCITeam.Last_Name__c = 'Test';
		insert newTCITeam;

		// insert Contact
		List<Contact> contactList = TCITestDataFactory.createContacts(1,'Insureds');
		contactList[1].Agent_Assigned__c = contactList[1].Id;
		contactList[1].Pay_Who__c = newTCITeam.Id;
		insert contactList[1];

		RecordType acctRecType = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' limit 1];

		// insert 1 account
		Account theAcct = new Account();
		theAcct.Name = 'Test Account';
		theAcct.RecordType = acctRecType;
		insert theAcct;

		// insert 10 case
		List<Case> cases = new List<Case>();
		for ( Integer i=0;i<10;i++) {
			cases.add(new Case(Policy_Number__c = 'OI121212'+i,
				AccountId = theAcct.Id,
				ContactId = contactList[1].Id, 
				TestUpdate__c = 'TU987654'));
		}
		insert cases;

			// insert location
		Location__c newLoc = new Location__c();
		newLoc.Address__c = '123 Test Street';
		newLoc.City__c = 'Phoenix';
		newLoc.State__c = 'AZ';
		newLoc.Zip__c = '85008';
		newLoc.Name = '123 Test Street, Phoenix, AZ 85008';
		newLoc.Performing_a_Home_Quote__c = 'Yes';
		newLoc.Insured__c = contactList[1].Id;
		try {
			insert newLoc;
		} catch(Exception e) {
			System.debug('DML Exception'+e.getMessage());
		}

		// Act
		Test.startTest();
		CaseUpdateBatch cub = new CaseUpdateBatch();
		Id batchId = Database.executeBatch(cub);
		Test.stopTest();
   
		// ASSERT
			// assert records updated correctly when the test stopped
		System.assertEquals(0, [select count() from Case where Account.Id != null]);
		System.assertEquals( newLoc.Insured__c = contactList[1].Id, 'Should populate the Contacts Id');

	}
}