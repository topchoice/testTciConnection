trigger AddLocationWhenAddressVerified on Contact (after update) {

    AddLocationWhenAddressVerified.AddLocation(Trigger.new,Trigger.oldMap);
    
}