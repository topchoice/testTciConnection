public class AddLocationWhenAddressVerified {

    public static void AddLocation(List<Contact> cons, Map<Id, Contact> oldCons) {
        
        List<Location__c> locList = new List<Location__c>();
        Set<Contact> consSet = new Set<Contact>();
        
        //loop for contacts from a set of contacts
        for(Contact newCon : consSet) {
            //checks for previous value
            if(newCon.avfree__Mailing_Verified__c == true) {
            
            		//add a new locations list to insert
                   locList.add(new Location__c(
                   Insured__c = newCon.Id,
                   Address__c = newCon.MailingStreet,
                   City__c = newCon.MailingCity,
                   State__c = newCon.MailingState,
                   Zip__c = newCon.MailingPostalCode,
                   Performing_a_Home_Quote__c = 'No'));
            }
        }
        	if(locList.size()>0)
                insert locList;
    }
    
}