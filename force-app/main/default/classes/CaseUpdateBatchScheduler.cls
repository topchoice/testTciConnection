global class CaseUpdateBatchScheduler implements Schedulable {
	global void execute(SchedulableContext sc) {
		
		CaseUpdateBatch batchScheduler = new CaseUpdateBatch();
		database.executebatch(batchScheduler,10);
	}
}