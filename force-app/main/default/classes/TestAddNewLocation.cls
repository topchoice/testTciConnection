@IsTest
public class TestAddNewLocation {

    static testmethod void insertLocation() {
    
        Location__c loc = new Location__c();
        
        loc.Insured__c = '003i000002sbFOWAA2';
        loc.Address__c = '123 w test';
        loc.City__c = 'Phoenix';
        loc.State__c = 'AZ';
        loc.Zip__c = '12345';
        loc.Performing_a_Home_Quote__c = 'No';
        
        insert loc;
    }
}