public class VehicleNameUpdateBatch implements Database.Batchable<sObject> {
	String Query;
	String Field;
	String Value;

	public VehicleNameUpdateBatch(String q, String f, String v) {
		Query = q; Field = f; Value = v;
	}

	public Database.QueryLocator start(Database.BatchableContext ins) {
		return Database.getQueryLocator('select Name, BatchUpdate__c Insured__c');
	}

	public void execute(Database.BatchableContext ins, List<sObject> scope) {
		for( sObject i : scope) {
		i.put(Field, Value);
		}
		update scope;
	}

	public void finish(Database.BatchableContext ins) {
	}

}