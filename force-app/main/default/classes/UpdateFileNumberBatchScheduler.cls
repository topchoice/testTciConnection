global class UpdateFileNumberBatchScheduler implements Schedulable {
	global void execute(SchedulableContext sc) {
		
		UpdateFileNumberBatch batchScheduler = new UpdateFileNumberBatch();
		database.executebatch(batchScheduler);
	}
}