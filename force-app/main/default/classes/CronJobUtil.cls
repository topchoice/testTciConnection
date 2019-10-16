public class CronJobUtil {
	
	public static string GetCRONExpression(Datetime dt) {
		return ('' + dt.second() + ' ' + dt.minute() + ' ' + dt.hour() + ' ' + dt.day() + ' ' +
			dt.month() + ' ? ' + dt.year());		
	}

	public static final Integer MAX_SCHEDULED_JOBS = 10;

	// Determine whether the maximum number of Scheduled Jobs has been reached
	public static Boolean MaxScheduledJobsReached() {
		return (GetScheduledJobs().size() >= MAX_SCHEDULED_JOBS);
	}

	// Returns all Scheduled Apex jobs that have not been started yet
	public static List<CronTrigger>GetScheduledJobs() {
		return [select Id, NextFireTime 
		from CronTrigger
		where State in('WAITING','ACQUIRED','EXECUTING')
		or NextFireTime != NULL];
	}

}