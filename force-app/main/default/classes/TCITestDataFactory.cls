@isTest
public class TCITestDataFactory {
	
	public static Boolean staticsloaded = false;

	// Create Account
	public static List<Account> createAccount( Integer numberOfAccounts) {
		List<Account> accts = new List<Account>();
		for ( Integer i = 0 ; i <numberOfAccounts ; i++) {
			Account a = new Account();
			a.Name = 'Name206';
			a.avfree__Billing_Do_Not_Verify__c = false; 
			a.avfree__Billing_Verified__c = false; 
			a.avfree__Shipping_Do_Not_Verify__c = false; 
			a.avfree__Shipping_Verified__c = false; 
			a.bz_elink__Master_Account__c = false; 
			a.bz_elink__Send_to_Lexis_Nexis_Automatically__c = false; 
			a.Active__c = 'Yes'; 
			a.Team_Login__c = false; 
			a.TestUpdate__c = 'TestU620';
			accts.add(a);
		}
		return accts;
	}

	// Create Accounts
	public static List<Account> createAccounts( Integer numberOfAccounts) {
		List<Account> accts = new List<Account>();
		for ( Integer i = 0 ; i <numberofAccounts ; i++) {
			Account a = new Account(Name='Test Account' + i);
			accts.add(a);
		}
		return accts;
	}

	// Create Account with Opportunities
	public static List<Account> createAccountsWithOpps( Integer numAccts, Integer numOppsPerAcct) {
		List<Account> accts = new List<Account>();
		for(Integer i=0;i<numAccts;i++) {
			Account a = new Account(Name='Test Account With Opp' + i);
			accts.add(a);
		}
		insert accts;

		List<Opportunity> opps = new List<Opportunity>();
		for (Integer j=0;j<numAccts;j++) {
			Account acct = accts[j];
			// For each account just inserted, add opportunities
			for (Integer k=0;k<numOppsPerAcct;k++) {
				opps.add(new Opportunity(Name=acct.name + ' Opportunity ' + k,
					StageName = 'Prospecting',
					CloseDate = System.today().addMonths(1),
					AccountId = acct.Id));
			}
		}
		// Insert all opportunities for all accounts.
		insert opps;

		return accts;
	}

	// Create Contacts
	public static List<Contact> createContacts(Integer numberOfContacts, String recordTypeDeveloperName) {
		List<Contact> contacts = new List<Contact>();
		for( Integer i = 0 ; i < numberOfContacts ; i++) {
			Contact contact = new Contact();
			contact.FirstName = 'Jason';
			contact.LastName = 'Marks';
			contact.Homeowner__c = 'Yes';
			contact.Marital_Status__c = 'Single';
			contact.MobilePhone = '(480) 111-3333';
			contact.AAA_Member__c = 'No';
			contact.AARP_Member_Number__c = 'No';
			contact.RecordTypeId = RecordTypeUtil.getIdByName('Contact', recordTypeDeveloperName);
			contacts.add(contact);
		}
		return contacts;
	}

	// insert Consultants
	public static List<Consultant__c> createConsultants(Integer numberOfConsultants) {
		List<Consultant__c> consultants = new List<Consultant__c>();
		for( Integer i = 0 ; i < numberOfConsultants ; i++) {
			Consultant__c newTCITeam = new Consultant__c();
			newTCITeam.First_Name__c = 'Mike';
			newTCITeam.Last_Name__c = 'Test';
			newTCITeam.Cell__c = '6025555555';
			newTCITeam.Work__c = '4807777777';
			newTCITeam.TCI_Email__c = 'test@tciagency.info';
			newTCITeam.Hire_Date__c = system.today();
			newTCITeam.Apps_Username__c = 'testConsultant';
			consultants.add(newTCITeam);
		}
		return consultants;
	}

	// Create Users
	public static List<User> createUsers( Integer numberOfUsers, String profileName) {
		Profile profile = [SELECT Id FROM Profile WHERE Name = :profileName];
		User manager = [SELECT Id FROM User WHERE IsActive = true limit 1];
		List<User> users = new List<User>();

		for( Integer i = 0 ; i < numberOfUsers ; i++) {
			String uniq = '' + Math.random();
			User u = new User(
				Username = 'Testing.User' + uniq + 'tciagency.info',
				Email = 'Testing.User' + uniq + 'tciagency.info',
				FirstName = 'Test First' + uniq,
				LastName = 'Test Last' + uniq,
				ProfileId = profile.Id,
				Country = 'United States',
				TimeZoneSidKey = 'en_US',
				Alias = 't' + uniq.substring(0, 5),
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'ISO-8859-1',
				LanguageLocaleKey = 'en_US');
			users.add(u);
		}
		return users;
	}

	// Create Tasks
	public static List<Task> createTask(Integer numberOfRecords, Id whatId, Id whoId) {
		List<Task> tasks = new List<Task>();
		for ( Integer count = 0 ; count < numberOfRecords ; count++) {
			Task task = new Task();
			task.WhatId = whatId;
			task.WhoId = whoId;
			task.Type = 'Phone Call';
			tasks.add(task);
		}
		return tasks;
	}
	public static List<Task> createTask(Integer numberOfRecords) {
		List<Task> tasks = new List<Task>();
		for ( Integer count = 0 ; count < numberOfRecords ; count++) {
			Task task = new Task();
			task.Type = 'Phone Call';
			tasks.add(task);
		}
		return tasks;
	}
}