global class UpdateFileNumberBatch implements Database.Batchable<Policy__c> {

List<Policy__c> polList;

	// start Method
	global Iterable<Policy__c> start(Database.BatchableContext BC) {	
	
		polList = new List<Policy__c>([SELECT Id, Name, Policy_Status__c,
								Company_File_Number__c, TestUpdate__c, Quote_Number__c, 
								Insured__r.Account.Name, Endorsement_Date__c,
								Insured__r.Account.Parent.Type_of_Company__c,
								Insured__r.Account.Parent.TestUpdate__c
								FROM Policy__c
								WHERE Policy_Status__c = 'Active'
								AND Insured__r.Account.Name = 'Networked Insurance Agents']);
		return polList;
	}

	// Execute Logic
   	global void execute(Database.BatchableContext BC, List<Policy__c> scope) {

   		// get a list of policies
		List<Policy__c> policies = new List<Policy__c>();

		// update the company file number value in the record
		for( Policy__c myPol : scope) {
			myPol.Company_File_Number__c = myPol.Insured__r.Account.Parent.Type_of_Company__c;
			myPol.TestUpdate__c = myPol.Insured__r.Account.Parent.TestUpdate__c;
			policies.add(myPol);
		}
		update scope;
	}
	
	// finish Method
	global void finish(Database.BatchableContext BC) {

		// gather the Id of the AsyncApexJob that represents the batch
		// from Database.BatchableContext.
		// Query the AsyncApexJob object to retrieve the current job information
		AsyncApexJob async = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
							TotalJobItems, CreatedBy.Email
							FROM AsyncApexJob
							WHERE Id =: BC.getJobId()];

		// Send an email to the person who submitted the job that it's complete.
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {async.CreatedBy.Email};
		mail.setToAddresses(toAddresses);
		mail.setSubject('Apex Sharing Recalculation ' +async.Status);
		mail.setPlainTextBody
		('The batch Apex job processed ' + async.TotalJobItems +
			' batches with '+ async.NumberOfErrors + ' failures.');
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		
	}
	
}