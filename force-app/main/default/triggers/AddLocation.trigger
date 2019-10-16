trigger AddLocation on Contact (after update) {

    List<Location__c> locList = new List<Location__c>();

    for ( Contact newCon : Trigger.new){    
        if ( newCon.avfree__Mailing_Verified__c != trigger.oldMap.get(newCon.Id).avfree__Mailing_Verified__c && newCon.avfree__Mailing_Verified__c == true) {
            locList.add(new Location__c(
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