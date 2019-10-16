@isTest
private class VehicleNameUpdateTest {
	
	@isTest static void validateVehicleInfo() {
		// Arrange
		Vehicle__c veh = new Vehicle__c();
		veh.Year__c = '2010';
		veh.Make__r.Name = 'Toyota';
		veh.Model__r.Name = 'Camry';
		veh.VIN__c = 'KNDMB5C1XF6075761';
		insert veh;
	
		// Act

	
		// Assert
		System.assert(veh.Name != null, 'Name should show vehicle information');
	}

	@isTest static void validateNoVehicleInfo() {
		// Arrange
		Vehicle__c veh = new Vehicle__c();
		veh.Year__c = '2010';
		veh.Make__r.Name = 'Toyota';
		veh.Model__r.Name = 'Camry';
		veh.VIN__c = 'KNDMB5C1XF6075761';
		insert veh;
	
		// Act

	
		// Assert
		System.assert(veh.Name == null, 'Should get an error message');
	}

}