public with sharing class ContactHandler {

    @InvocableMethod(label = 'Handles the automation for Contacts when specific criteria is met.')
	public static void addSpouseAsDriver() {

    List<Contact> contacts = new List<Contact>();
	List<Drivers__c> driverList = new List<Drivers__c>();

    for (Contact newCon : contacts) {    
        if (newCon.Marital_Status__c == 'Married') {
            driverList.add(new Drivers__c(
            RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Spouse' and SobjectType = 'Drivers__c'].Id,
            Insured__c = newCon.Id,
            First_Name__c = newCon.Spouse_First_Name__c,
            Last_Name__c = newCon.Spouse_Last_Name__c,
            Name = newCon.Spouse_First_Name__c + ' ' + newCon.Spouse_Last_Name__c,
            License_Status__c = TCIStatics.LICENSE_STATUS,
            Active__c = TCIStatics.STATUS_ACTIVE,
            Driver_Status__c = TCIStatics.DRIVER_STATUS_RATED));
        }
    }
        if(driverList.size()>0)
        insert driverList;

	}

    public static List<String> getContactNamesAndAddSpouse(List<Id> ids) {
        
    List<Drivers__c> driverList = new List<Drivers__c>();
    List<String> contactNames = new List<String>();
    List<Contact> contacts = [SELECT Id, Name, Marital_Status__c, Spouse_First_Name__c, Spouse_Last_Name__c 
                                    FROM Contact WHERE Id in :ids];
    // add spouse to new contact inserted
    for (Contact contact : contacts) {
        if (contact.Marital_Status__c == 'Married' && contact.Spouse_First_Name__c != null) {
            driverList.add(new Drivers__c(
            RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Spouse' and SobjectType = 'Drivers__c'].Id,
            Insured__c = contact.Id,
            First_Name__c = contact.Spouse_First_Name__c,
            Last_Name__c = contact.Spouse_Last_Name__c,
            Name = contact.Spouse_First_Name__c + ' ' + contact.Spouse_Last_Name__c,
            License_Status__c = TCIStatics.LICENSE_STATUS,
            Active__c = TCIStatics.STATUS_ACTIVE,
            Driver_Status__c = TCIStatics.DRIVER_STATUS_RATED));
        }
        contactNames.add(contact.Name);
    }
    
        if (driverList.size()>0)
        insert driverList;

    return contactNames;

    }

    public static void addLocation() {

    List<Contact> contacts = new List<Contact>();
    List<Location__c> locList = new List<Location__c>();

    for( Contact newCon : contacts){    
        if(newCon.MobilePhone != '') {
            locList.add(new Location__c(
            RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Physical' and SobjectType = 'Location__c'].Id,
            Name = newCon.MailingStreet + ' ' + newCon.MailingCity + ' ' + newCon.MailingState + ' ' + newCon.MailingPostalCode,
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

    public void updateStatusOnContact(List<Policy__c> newTrigger) {

        // Create a Map of Id's from Contact object
        Map<Id, Contact> contactMap = new Map<Id, Contact>();

        // Create a list of Id's from Policy object
        List<Id> listIds = new List<Id>();

        // Iterate through all Policy records
        for( Policy__c polSetups : newTrigger) {
            listIds.add(polSetups.Policy_Status__c);
        }

        // Populate the Map with the fields needed from the Policies and Contact object to 
        // complete the next step
        contactMap = new Map<Id, Contact>([SELECT Id, Name, Status__c,
                                        (SELECT Id, Contact__c,
                                        Policy_Status__c
                                        FROM Policies1__r)
                                        FROM Contact
                                        WHERE Id IN :listIds]);

        // Search Policies related to the Contact record just created.
        // Check to see if any of the Policies are Active.
        // Get the last known related Policy record that is Active.
        // Update the <Status__c> on the matching Contact record.
        for( Policy__c polSetup : newTrigger) {
            if ( polSetup.Policy_Status__c.equals(TCIStatics.STATUS_ACTIVE)) {
            Contact theContact = contactMap.get( polSetup.Contact__c);
            theContact.Status__c = TCIStatics.STATUS_ACTIVE;
                }else {
                Contact theContact = contactMap.get( polSetup.Contact__c);
                theContact.Status__c = TCIStatics.STATUS_PENDING;
            }
            // No need to continue through the inner loop since we found a record to update the
            // Contact record.
            break;
        }
        update contactMap.values();
    }

}