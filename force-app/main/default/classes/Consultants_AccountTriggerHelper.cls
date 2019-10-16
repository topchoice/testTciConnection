public class Consultants_AccountTriggerHelper {
	public static void linkTheConsultantAndAccount(List<Consultant__c> newList) {
		
	// build a set of consultant names 
	Set<String> conNames = new Set <String>();

	for ( Consultant__c theConsultant : newList) 
	{
    	conNames.add(theConsultant.Name); 
	} 

	// Map the account Ids and the actual account records based on the consultant Ids
	Map <String, Account> matchingAccountsMap = new Map <String, Account>();

	for ( Account acct : [Select Id, TestUpdate__c, VLookUp_Code__c, Name From Account Where VLookUp_Code__c IN :conNames]) 
	{
		matchingAccountsMap.put(acct.VLookUp_Code__c, acct); 
	} 

	List<Account> accountsToUpdate = new List<Account>(); 

	// go through the records in the trigger again and check whether we have found a matching consultant and account 

	for ( Consultant__c theConsultant : newList) 
	{
  		if ( matchingAccountsMap.get(theConsultant.Name) != null)
    	{
    
    		// we found a matching one
    		matchingAccountsMap.get(theConsultant.Name).consultant__c = theConsultant.Id;

			// add it to a separate list and update it
			AccountsToUpdate.add(matchingAccountsMap.get(theConsultant.Name));
		}
	}  
	update accountsToUpdate;
	}
}