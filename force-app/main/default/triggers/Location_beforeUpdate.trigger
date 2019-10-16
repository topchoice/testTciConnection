trigger Location_beforeUpdate on Location__c (before update, after insert, after update) {

    if (Trigger.isUpdate) { 
        location_ZillowService.InitIncompleteAddress(trigger.new);
    }

    if(Trigger.isInsert) {
        location_ZillowService.HomeValue(null, trigger.new);
    }

    if(Trigger.isUpdate) {
        location_ZillowService.HomeValue(trigger.old, trigger.new);
    }

}