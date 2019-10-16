public class LocationHandler {

	// public method
	public void updateLocationName() {
		
	List<Location__c> locList = new List<Location__c>();

    for(Location__c uLoc : locList) {
        if( uLoc.Address__c != null) {
            uLoc.Name = uLoc.Address__c + ' ' + 
            uLoc.City__c + ' ' + 
            uLoc.State__c + ' ' + 
            uLoc.Zip__c;
        }
        
    }
        if(locList.size()>0)
        update locList;
	}
}