@isTest(SeeAllData = false)
private class AddressValidationController_Test {
    //Create common test data
    @testSetup static void loadTestData(){
        /*TestClassUtil.createZipcodeForBranch(); */
        /*TestClassUtil.createAddress(2); */
    }
    @isTest static void testValidAddressCallout() {
        Test.startTest();
        List<Address__c> addressList = [SELECT name,State__c,Street__c,city__c,County__c,Zip_code__c FROM Address__c];
        PageReference pageRef = Page.AddressValidation_VF; 
        Test.setCurrentPage(pageRef);
        AddressValidationController controller = new AddressValidationController(new ApexPages.StandardController(addressList[0]));
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockAddressValidationResponseGenerator()); 
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.         
        controller.Validate();  
        controller.save();
        Test.stopTest();
        //Verify that validate address is inserted.
        System.assert([SELECT name,State__c,Street__c,city__c,County__c,Zip_code__c FROM Address__c WHERE City__c = 'Tempe'].size() > 0); 
    }
    @isTest static void testValidAddressIgnoreByUserlCallout() {
        Test.startTest();
        List<Address__c> addressList = [SELECT name,State__c,Street__c,city__c,County__c,Zip_code__c FROM Address__c];
        PageReference pageRef = Page.AddressValidation_VF; 
        Test.setCurrentPage(pageRef);
        AddressValidationController controller = new AddressValidationController(new ApexPages.StandardController(addressList[0]));
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockAddressValidationResponseGenerator());
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.         
        controller.Validate();
        controller.confirmCancel();
        Test.stopTest();
        //Verify that validate address is ingnored by User.
        System.assert([SELECT name,State__c,Street__c,city__c,County__c,Zip_code__c FROM Address__c WHERE City__c = 'Tempe'].size() == 0);        
    }
    @isTest static void testInValidAddressCallout() {
        List<Address__c> addressList = [SELECT name,State__c,Street__c,city__c,County__c,Zip_code__c FROM Address__c];
        //Update invalid street
        addressList[0].Street__c = 'Test';
        update addressList[0];
        Test.startTest();
        PageReference pageRef = Page.AddressValidation_VF; 
        Test.setCurrentPage(pageRef);
        AddressValidationController controller = new AddressValidationController(new ApexPages.StandardController(addressList[0]));
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockAddressValidationResponseGenerator());
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.         
        controller.Validate();    
        Test.stopTest();
        //Verify that validate address is not created.
        System.assert([SELECT name,State__c,Street__c,city__c,County__c,Zip_code__c FROM Address__c WHERE City__c = 'Tempe'].size() == 0);         
    }
  @isTest static void testBadRequestCallout() {
        List<Address__c> addressList = [SELECT name,State__c,Street__c,city__c,County__c,Zip_code__c FROM Address__c];
        //Update invalid street
        addressList[0].Street__c = null;
        update addressList[0];
        Test.startTest();
        PageReference pageRef = Page.AddressValidation_VF; 
        Test.setCurrentPage(pageRef);
        AddressValidationController controller = new AddressValidationController(new ApexPages.StandardController(addressList[0]));
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockAddressValidationResponseGenerator());
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.         
        controller.Validate(); 
        Test.stopTest();
        //Verify that validate address is not created.
        System.assert([SELECT name,State__c,Street__c,city__c,County__c,Zip_code__c FROM Address__c WHERE City__c = 'Tempe'].size() == 0);                
    }
    @isTest static void testCalloutException() {
        Test.startTest();
        List<Address__c> addressList = [SELECT name,State__c,Street__c,city__c,County__c,Zip_code__c FROM Address__c];
        //Update invalid street
        addressList[0].Street__c = null;
        update addressList[0];
        PageReference pageRef = Page.AddressValidation_VF; 
        Test.setCurrentPage(pageRef);
        AddressValidationController controller = new AddressValidationController(new ApexPages.StandardController(addressList[0]));
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockAddressValidationResponseGenerator());
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.         
        controller.Validate(); 
        Test.stopTest();
        //Verify that validate address is not created.
        System.assert([SELECT name,State__c,Street__c,city__c,County__c,Zip_code__c FROM Address__c WHERE City__c = 'Tempe'].size() == 0);                
    }
}