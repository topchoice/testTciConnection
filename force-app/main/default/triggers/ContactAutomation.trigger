trigger ContactAutomation on Contact (after insert, after update) {

	// add Spouse if marital status value is 'married'
	for (Contact newCon : Trigger.new) {
		if (Trigger.isAfter) {
			if ( newCon.Marital_Status__c != trigger.oldMap.get(newCon.Id).Marital_Status__c && newCon.Spouse_First_Name__c != '') {
				ContactHandler.addSpouseAsDriver();
			}
		}
	}

	/*for (Contact newCon : Trigger.new) {
		if ( newCon.avfree__Mailing_Verified__c != trigger.oldMap.get(newCon.Id).avfree__Mailing_Verified__c && newCon.avfree__Mailing_Verified__c == true) {
			ContactHandler.addLocation();
		}
	}*/
}