/*
 * ContactQueryService
 * Contact Query Service
 */

public class QueryService {

	// Constructors
	public QueryService() {
	}

	// Return a single
	public Contact queryById( Id setupId) {
		return [select Id, Name, Status__c
		from Contact
		where Id = :setupId];
	}

	// Return a list 
	// ToDo: (add the remainder of the fields from the bject)
	public List<Contact> queryByIds( Set<Id> setupids) {
		return [select Id, Name 
				from Contact
				where Id in :setupids
				order
					by SystemModStamp desc];
	}

	// Query for only fields which are copied in the cloning process
	public Contact queryByIdForCloning( Id setupId) {
		return [select Id, Name
				from Contact
				where Id = :setupId];
	}

	// Query by Owner
	public List<Contact> queryByOwner( Id ownerId) {
		return [select Id, Name, Status__c
				from Contact
				where OwnerId = :ownerId
				order
					by SystemModStamp desc];
	}

	// Query by Status
	public List<Contact> queryByStatus( String status) {
		return [select Id, Name, Status__c
				from Contact
				where Status__c = :status
				order
					by SystemModStamp desc];
	}

	// Query by Status and Ineligible
	public List<Contact> queryByStatusAndIneligible( String status, Boolean ineligibleId) {
		return [select Id, Name, Status__c
				from Contact
				where Status__c = :status
				and TCI_Ineligible__c = :ineligibleId
				order
					by SystemModStamp desc];
	}

	/*// Query by single id
	public Contact queryContactById( Id contactId) {
		return queryContactByIds new Set<id> { contactId })[0];
	} */

	// Query Contacts of Setups
	public List<Contact> queryContactByIds( Set<Id> contactIds) {
		return [select Id, FirstName, LastName, Occupation__c, Marital_Status__c, Work_Email__c
			from Contact
			where Id = :contactIds];
	}

	public Map<Id,Contact> queryContactsByIdsMap( Set<Id> contactIds) {
		Map<Id, Contact> resultMap = new Map<Id,Contact>(
			[SELECT Id, FirstName, LastName, Occupation__c, Marital_Status__c, Work_Email__c, Name
			FROM Contact
			WHERE Id in :contactIds] );
		return resultMap;
	}

	// Query Contacts for an Account
	public List<Contact> queryContactByAcocuntId( Id accountId) {
		return [ SELECT Id, FirstName, LastName, Occupation__c, Marital_Status__c, Name
				FROM Contact
				WHERE AccountId = :accountId
				order
					by LastName, FirstName];
	}

	// Query Data Import Tracker to refresh Bulk Page
	/*public static Data_Import_Tracker__c queryTracker( Id importTrackerId) {
		return [ SELECT Id, Name, Status__c, Result__c, Error__c, Row_Results__c, Total_Rows__c,
				Valid_Rows__c, Invalid_Rows__c, Submission_Error_Rows__c, 
				Validation_Start_Time__c, Validation_End_Time__c, 
				Callout_Start_Time__c, Callot_End_Time__c,
				Processing_Start_Time__c, Processing_End_Time__c,
				Data_Import_Configuration__r.Application__c
			FROM Data_Import_Tracker__c
			WHERE Id = :importTrackerId];
	}*/

	/* public static List<Account_Setup__c> queryContactsByTracker( Id importTrackerId) {
		return [SELECT Id, Name, Status__c, Row_Number__c, Validation_Result__c, Error_Field__c
				FROM Account_Setup__c
				WHERE Data_Import_Tracker__c = :importTrackerId
				ORDER BY Row_Number__c ASC ];
	} */

	public static Opportunity getOpportunityById( Id opptyId) {
		return [select Name, AccountId, StageName
				from Opportunity
				where Id = :opptyId];
	}

	public static Account getAccountById( Id acctId) {
		return [select Name, Phone
			from Account
			where Id = :acctId];
	}

	public static List<Contract__c> getContractByOpportunity( Id opptyId) {
		return [select Id, Name, Opportunity__c, Contact__c, Account__c
			from Contract__c
			where Opportunity__c = :opptyId
			and Status__c = 'Signed'
			order by LastModifiedDate desc
			Limit 1 ];
	}

	// Get Tracker History
	public static List<Data_Import_Tracker__c> queryTrackerByUserId( Id userId, Integer rowLimit) {
		return [SELECT Name, Upload_File__c, Status__c, Processing_Start_Time__c, Processing_End_Time__c, Total_Rows__c, Successful_Row_Count__c
				FROM Data_Import_Tracker__c
				WHERE CreatedById = :userId
				ORDER BY CreatedDate desc
				Limit :rowLimit];
	}

}