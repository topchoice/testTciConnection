global class CaseUpdateBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
	
	// Start Method	
	global Database.QueryLocator start(Database.BatchableContext BC) 
	{
		String query = 'select TestUpdate__c, Policy_Number__c, Account.TestUpdate__c from Case';
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Case> scope) 
   	{
   		for ( Case o : scope) 
   		{
	
   		List<Account> acctList = [SELECT Id, TestUpdate__c FROM Account WHERE TestUpdate__c != null AND Active__c = 'Yes'];
	
		for ( Account acct : acctList) 
		{
		
		Case prevCaseRec = [SELECT Id, TestUpdate__c, Policy_Number__c, Account.TestUpdate__c
							FROM Case
							WHERE TestUpdate__c =: acct.TestUpdate__c
							ORDER BY CreatedDate desc Limit 1];

			for ( Case c : scope) 
			{
				if ( c.TestUpdate__c == acct.TestUpdate__c) 
				{
				c.Policy_Number__c = prevCaseRec.TestUpdate__c;
				}
			}
		}
		update scope;
		}
	}
	
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