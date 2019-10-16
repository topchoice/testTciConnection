/*
 * RecordTypeUtil
 * @Description:	Gets Id by Name (Developer Name), or Name by Id
 * @Date:			07/05/2017
 *
 * reason: 			Id myRecTypeId = RecordTypeUtil.getIdByName( 'Poo__c', 'Sample_Record_Type_Name');
 */

public abstract class RecordTypeUtil {
	
	// Containers for different object types, accessors by name and id
	public static Map<String, Map<String,Id>> byName = new Map<String,Map<String,Id>>();
	public static Map<String, Map<Id, String>> byId = new Map<String, Map<Id, String>>();

	// Load for Object
	private static void load( String objectName) {
		// Don't load the same object's info twice
		if ( !byName.containsKey( objectName)) {
			// Load both maps for reference.  Unless there are hundreds of record Types this should be too memory intensive
			Map<String,Id> nameMap = new Map<String,Id>();
			Map<Id,String> idMap = new Map<Id,String>();
			for ( RecordType recordType : [select Id, DeveloperName
											from RecordType
											where SObjectType = :objectName]) {
				nameMap.put( recordType.DeveloperName, recordType.Id);
				idMap.put( recordType.Id, recordType.DeveloperName);
			}
			byName.put( objectName, nameMap);
			byId.put( objectName, idMap);
		}
	}

	// Load, then get by Name
	public static String getIdByName( String objectName, String recordTypeName) {
		load( objectName);
		return byName.get( objectName).get( recordTypeName);
	}

	// Load, then get by Id
	public static String getNameById( String objectName, String recordTypeId) {
		load( objectName);
		return byId.get( objectName).get( recordTypeId);
	}
}