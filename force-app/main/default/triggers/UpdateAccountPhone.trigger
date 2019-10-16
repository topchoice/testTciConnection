trigger UpdateAccountPhone on Account (before insert, before update, after insert, after update, after undelete) {


// updates the account phone number to TCI Corporate number if phone field left blank
    for (Account acct : Trigger.new) {
        if ( acct.Name != null && acct.Phone == null ) {
            acct.Phone = '(800) 613-2406';
        }
    }
}