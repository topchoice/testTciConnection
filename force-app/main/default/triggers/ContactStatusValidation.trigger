trigger ContactStatusValidation on Contact (before insert, before update) {

    // separate before and after
    	if(Trigger.isBefore) {
        
    // separate events
        if(Trigger.isInsert) {
                		System.debug('BEFORE INSERT');

        }
    	}
    
}