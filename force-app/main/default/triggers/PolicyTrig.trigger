trigger PolicyTrig on Policy__c (after update, after insert) {

    ContactHandler polStatusUpdate = new ContactHandler();
    if ( Trigger.isAfter ) {
        if ( Trigger.isUpdate ) {
            polStatusUpdate.updateStatusOnContact(Trigger.new);
            polStatusUpdate.addLocation();
        }
        if ( Trigger.isInsert ) {
            polStatusUpdate.updateStatusOnContact(Trigger.new);
        }
    }
}