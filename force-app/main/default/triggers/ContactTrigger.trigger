trigger ContactTrigger on Contact (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            ContactHandler.addSpouseAsDriver() ;
        }
        
        if(Trigger.isInsert) {
            ContactHandler.addSpouseAsDriver() ;
        }
    } 
}