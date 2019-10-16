@isTest
private class UpdateFileNumberBatchTest {
	
	@testSetup
	static void setup() {
		
		// ARRANGE
		List<Policy__c> policies = new List<Policy__c>();
		// insert 10 policies
		for ( Integer i=0;i<10;i++) {
			policies.add(new Policy__c(Name = 'AZ01234 '+i, 
				Insured__c = '003i000000sykfL', 
				TestUpdate__c = 'TU987654'));
		}
		insert policies;

		Consultant__c newTCITeam = new Consultant__c();
		newTCITeam.First_Name__c = 'Mike';
		newTCITeam.Last_Name__c = 'Test';
		newTCITeam.Cell__c = '6025555555';
		newTCITeam.Work__c = '4807777777';
		newTCITeam.TCI_Email__c = 'test@tciagency.info';
		newTCITeam.Hire_Date__c = system.today();
		newTCITeam.Apps_Username__c = 'testConsultant';
		try {
			insert newTCITeam;
		} catch(Exception e) {
			System.debug('DML Exception'+e.getMessage());
		}

		Contact newCon = new Contact();
		newCon.LastName = 'Jones';
		newCon.Homeowner__c = 'Yes';
		newCon.Marital_Status__c = 'Single';
		newCon.MobilePhone = '4801117777';
		newCon.Agent_Assigned__c = newCon.Id;
		newCon.Pay_Who__c = newTCITeam.Id;
		newCon.AAA_Member__c = 'Yes';
		newCon.AAA_Member_Number__c = '12343132';
		newCon.AARP_Member__c = 'No';
		newCon.AARP_Member_Number__c = '09982323';
		try {
			insert newCon;
		} catch(Exception e) {
			System.debug('DML Exception'+e.getMessage());
		}

		// insert location
		Location__c newLoc = new Location__c();
		newLoc.Address__c = '123 Test Street';
		newLoc.City__c = 'Phoenix';
		newLoc.State__c = 'AZ';
		newLoc.Zip__c = '85008';
		newLoc.Name = '123 Test Street, Phoenix, AZ 85008';
		newLoc.Performing_a_Home_Quote__c = 'Yes';
		newLoc.Insured__c = newCon.Id;
		try {
			insert newLoc;
		} catch(Exception e) {
			System.debug('DML Exception'+e.getMessage());
		}

	}

		// Act
	static testmethod void test() {
		Test.startTest();
		UpdateFileNumberBatch ufnb = new UpdateFileNumberBatch();
		Id batchId = Database.executeBatch(ufnb);
		Test.stopTest();

		// ASSERT
		// assert records updated correctly when the test stopped
		System.assertEquals(10, [select count() from Policy__c where Insured__c = '003i000000sykfL']);
	}
	
}