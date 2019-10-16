trigger LinkConsultant on Consultant__c (before insert, before update) {
	Consultants_AccountTriggerHelper.linkTheConsultantAndAccount(Trigger.new);
}