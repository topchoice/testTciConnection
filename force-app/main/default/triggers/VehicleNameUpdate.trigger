trigger VehicleNameUpdate on Vehicle__c (before insert, after insert, before update, after update) {

	List<Vehicle__c> vList = new List<Vehicle__c>();

	for( Vehicle__c newVeh : vList) {
		if( newVeh.Year__c != null 
			&& newVeh.Make__r.Name != null 
			&& newVeh.Model__r.Name != null 
			&& newVeh.VIN__c != null) {
		vList.add(new Vehicle__c(
			Name = newVeh.Year__c + ' ' + 
			newVeh.Make__r.Name + ' ' + 
			newVeh.Model__r.Name + ' - ' + 
			newVeh.VIN__c));
		}
		else {
			for( Vehicle__c uVeh : vList) {
				if( uVeh.Year__c == null || uVeh.VIN__c == null) {
					uVeh.addError('Verify vehicle information');
				}
			}
		}
	}
	if(vList.size()>0)
		try{
			update vList;
			System.debug('Update successful');
		}
		catch(Exception e)
		{
			for( Vehicle__c v : Trigger.new) {
				v.addError('There was a problem updating the vehicle');
			}
			System.debug('The following error occured' + e);
		}
		/*
	// CRON Expression corresponding to 1 second from now
	Datetime executeTime = (System.Now()).addSeconds(1);
	String cronExpression = CronJobUtil.GetCRONExpression(executeTime);

	System.debug('Cron Expression: ' + cronExpression);

	// Instantiate a new Scheduled Apex class
	schedule1 scheduledJob = new schedule1();

	// Schedule the class to run at the given execute time naming executeTime so that,
	// the Schedule name will be Unique
	System.schedule('scheduledJob' + executeTime.getTime(),cronExpression,scheduledJob);
	*/
}