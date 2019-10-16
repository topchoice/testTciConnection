/***********************************************************************************
* Class Name   : AddressTriggerHandler
* Created By   : Calvin Bates Jr  
* Created Date : 05/25/2016
* Author       : TCI Developer
* Description  : This class will prevent insertion of the duplicate address based on
the Unique key field by throwing an error.

Note :The unique key field will be inserted (or) updated with the combination of 
Street, City and Zipcode. 

****************************************************************************************/
public class AddressTriggerHandler{
    
    public static void duplicateAddressValidation(Set<String> addressUniqueKeys,List<Address__c> currentAddress){
        Set<String> existingAddress = new Set<String>();
        if(addressUniqueKeys.size() > 0){
            for(Address__c addr : [SELECT Unique_Key__c FROM Address__c WHERE Unique_Key__c IN:addressUniqueKeys]){
                existingAddress.add(addr.Unique_Key__c);
            }
        }
        // If duplicate address is found then the error would be thrown
        if(!existingAddress.isEmpty()){
            for(Address__c address : currentAddress){
                if(existingAddress.contains(address.Unique_Key__c)){
                    address.addError('Address already exists');
                }
            }
        }
    }
    /*property name update
    public static void updatePropertyName(Map<Id,Address__c> addressMap){
        List<Property__c> toUpdateProperties = [SELECT Id,Name,Address__c FROM Property__c WHERE Address__c IN : addressMap.keyset()];
        if(!toUpdateProperties.isEmpty()){
            for(Property__c property : toUpdateProperties){
                if(addressMap.containskey(property.Address__c)){
                    property.Name = addressMap.get(property.Address__c).Name;
                }
            }
        }    
        try {
            if(!toUpdateProperties.isEmpty()){
                update toUpdateProperties;
            }
        }
        catch(Exception e){
            System.debug('Error occured while updating the property'+e.getMessage());
        }
    }
    // If the zip code field has the value then update the related Branch,MSA and Region code 
    public static void updateRelatedBranch(Set<String> zipCodes,List<Address__c> addressList){
        Map<String,ZipCode__c> zipCodeMap = new Map<String,ZipCode__c>();
        //Get the list of zipcodes and branch names from the Custom object.
        for(ZipCode__c zipCode : [SELECT Id,Name,Branch__c,MSA__c,Region_Code__c,ZipCode__c FROM ZipCode__c WHERE Name IN : zipCodes]){
            if(!zipCodeMap.containsKey(zipCode.Name)){
                zipCodeMap.put(zipCode.Name,zipCode);
            }
        }     
        for(Address__c address : addressList){
            //Branch field population
            if(address.Zip_Code__c == null){
                address.Branch__c = null;
                address.MSA__c = '';
                address.Region_Code__c = '';
            }
            //if the address get inserted with zipcode then,
            //we auto populate Branch , MSA & Region Code based on the zipcode from Zipcode__c Custom Obj
            else if(zipCodeMap.containsKey(address.Zip_Code__c)){
                ZipCode__c zip = zipCodeMap.get(address.Zip_Code__c);
                address.Branch__c = zip.branch__c;
                address.MSA__c = zip.MSA__c;
                address.Region_Code__c = zip.Region_Code__c;
            }
            //if the address zipcode not match in the Zipcode__c custom obj then, set to Invalid Zip Code
            else{
                address.Branch__c = UtilClass.getBranchId('Invalid Zip Code');
                address.MSA__c = 'Invalid Zip Code';
                address.Region_Code__c = 'Invalid Zip Code';
            }
            //branch population end
        }
    }*/
}