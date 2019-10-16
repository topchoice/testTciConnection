/********************************************************************************************
* Class Name : AddressTriggerHandler_Test
* Created By : Calvin Bates Jr
* Created Date : 05/25/2016
* Author : cb
* Description: Test Classes for the Address Trigger , AddressTriggerHandler and as well AccountZipCodeMapper_Batch
**********************************************************************************************/
@isTest(SeeAllData = false)
private class AddressTriggerHandler_Test{
     //Create common test data
    @testSetup static void setup() {
        /*TestClassUtil.createZipcodeForBranch();*/      
        /*TestClassUtil.createAddress(3);*/
        /*TestClassUtil.createProperty(2);*/
    }    
    static testMethod void testAutoFieldPopulation(){
        for(Address__c address : [SELECT Id,name,State__c,Unique_Key__c,Full_Zip_Code__c,City__c,Street__c,Zip_code__c,Zip_plus_four__c FROM Address__c]){
            //Verify auto population of field values
            /*System.assert(addres.Branch__c != null);
            System.assert(addres.Region_Code__c != null);
            System.assert(addres.MSA__c != null);*/
            //Verify address name field auto population
            System.assertEquals(address.Name,address.Street__c + ':' + address.City__c + ':' + address.State__c);
            //Verify Unique_Key field auto population
            System.assertEquals(address.Unique_Key__c,address.Street__c + ':' +address.Zip_Code__c);
            //Verify full zipcode field auto population
            System.assertEquals(address.Full_Zip_Code__c,address.Zip_Code__c + '-' + address.Zip_Plus_Four__c);
        }       
    }
    static testMethod void testAutoFieldPopulationOnUpdate(){
        List<Address__c> toBeUpdateAddress = [SELECT Id,name,State__c,City__c,Street__c,Zip_code__c,Zip_plus_four__c FROM Address__c];   
        if(!toBeUpdateAddress.isEmpty()){
            for(Address__c addr : toBeUpdateAddress){
                addr.State__c = 'DE';
                addr.City__c = 'Test City';
                addr.Street__c = 'Test Street';
                addr.Zip_Code__c = '27007';
            }
        }
        //Update invalid zipcode
        toBeUpdateAddress[0].Zip_Code__c = null;
        toBeUpdateAddress[1].Zip_Code__c = '12345';
        update toBeUpdateAddress;
        for(Address__c address : [SELECT Id,name,State__c,Unique_Key__c,Full_Zip_Code__c,City__c,Street__c,Zip_code__c,Zip_plus_four__c FROM Address__c WHERE Zip_Code__c != null]){
            //Verify auto population of field values
            /*System.assert(address.Branch__c != null);
            System.assert(address.Region_Code__c != null);
            System.assert(address.MSA__c != null);*/
            //Verify address name field auto population
            System.assertEquals(address.Name,address.Street__c + ':' + address.City__c + ':' + address.State__c);
            //Verify Unique_Key field auto population
            System.assertEquals(address.Unique_Key__c,address.Street__c + ':' +address.Zip_Code__c);
            //Verify full zipcode field auto population
            System.assertEquals(address.Full_Zip_Code__c,address.Zip_Code__c + '-' + address.Zip_Plus_Four__c);
        }        
    }
    static testMethod void testAddressDuplicationCreation(){    
        //Create address with same unique key then it will throw error like duplicate address 
        Address__c dupAddress = new Address__c(Name = 'DupAddress',City__c = 'Test',County__c = 'Polk County',
                                            Country__c = 'US',State__c = 'IN',Street__c = 'Test Street1',
                                            Zip_code__c = '27006',Zip_Plus_Four__c = '1111');
        try{
            insert dupAddress;
        }
        catch(Exception e){
            System.debug('Error Occured while updating the address'+e.getMessage());
        }
        system.assert([SELECT Id FROM Address__c WHERE Name = 'DupAddress'].size() == 0);
            
    }    
    /*This method is used to cover the Zip code based field population through batch    
    static testMethod void testZipCodeMatcherBatch(){
        Branch__c branch = [SELECT Id from Branch__c limit 1];
        //Create address with invalid zipcode 
        insert new Address__c(Name = 'Address1',City__c = 'Test',County__c = 'Polk County',
                                            Country__c = 'US',State__c = 'IN',Street__c = 'Test Street1',
                                            Zip_code__c = '27001',Zip_Plus_Four__c = '1111');
        //Create a record for the above zipcode in the Zipcode custom obj
        insert new zipcode__c(Name = '27001',ZipCode__c = '27001', branch__c = branch.id,MSA__c = 'Winston-Salem, NC MSA',Region_Code__c = 'SE3',State__c = 'NC');
        Test.startTest();
        Database.ExecuteBatch(new accountZipCodeMApper_Batch(),200);
        Test.stopTest(); 
        System.assertEquals([SELECT Id,Region_Code__c FROM Address__c WHERE zip_code__c ='27001'].Region_Code__c,'SE3');
    }*/
}