/***********************************************************************************
* Trigger Name : AddressTrigger
* Created By   : Calvin Bates Jr 
* Author       : TCI Developer
* Description  : This trigger will prevent insertion of the duplicate address based on
the Unique key field by throwing an error.
The unique key field will be inserted (or) updated with the combination of 
Street and Zipcode.. 

****************************************************************************************/
trigger AddressTrigger on Address__c (before insert,before update,after update) {
    
    Set<String> addressUniqueKeys = new Set<String>();
    Map<Id,Address__c> addressMap = new Map<Id,Address__c>();
    Set<String> zipCodes = new Set<String>();
    
    for(Address__c address : Trigger.New){
        if(Trigger.isBefore && Trigger.isInsert){
            //Address name field population which contains combination of street , city & state
            if(address.State__c != null && address.Street__c != null && address.City__c != null){
                address.Name = address.Street__c + ':' + address.City__c + ':' + address.State__c;
            }
            // Concatenate the values of Street and Zip_Code fields and store it in the
            // Unique_Key__c field upon address insertion.
            if(address.Street__c != null && address.Zip_Code__c != null ){
                address.Unique_Key__c = address.Street__c + ':' +address.Zip_Code__c;
                if(!addressUniqueKeys.contains(address.Unique_Key__c)){
                    addressUniqueKeys.add(address.Unique_Key__c);
                }
                else{
                    address.addError('Same address found in the incoming address records');
                }
            }
            //Concatenate the values of Zip code and Zip_Plus_Four__c fields and store it in the
            // full_zip_code__c field upon address insertion.
            if(address.Zip_Code__c != null){ 
                zipCodes.add(address.Zip_Code__c);
                if(address.Zip_Plus_Four__c != null){
                    address.Full_Zip_Code__c =  address.Zip_Code__c + '-' + address.Zip_Plus_Four__c;
                }
            }
        }
        if(Trigger.isBefore && Trigger.isUpdate){   
            if((Trigger.oldMap.get(address.Id).Street__c != address.Street__c
                || Trigger.oldMap.get(address.Id).Zip_Code__c != address.Zip_Code__c) && 
               address.Street__c != null && address.Zip_Code__c != null ){
                   address.Unique_Key__c = address.Street__c + ':' +address.Zip_Code__c;                          
               }
            if(address.Zip_Plus_Four__c != null && address.Zip_Code__c != null && (Trigger.oldMap.get(address.Id).Zip_Code__c != address.Zip_Code__c
                                                                                   || Trigger.oldMap.get(address.Id).Zip_Plus_Four__c != address.Zip_Plus_Four__c)){                                      
                                                                                       address.Full_Zip_code__c =  address.Zip_Code__c + '-' + address.Zip_Plus_Four__c;
                                                                                   }            
            if(address.State__c != null && address.Street__c != null && address.City__c != null &&
               (Trigger.oldMap.get(address.Id).State__c != address.State__c || Trigger.oldMap.get(address.Id).Street__c != address.Street__c
                || Trigger.oldMap.get(address.Id).City__c != address.City__c)){
                    address.Name = address.Street__c + ':' + address.City__c + ':' + address.State__c;
                }
            if(Trigger.OldMap.get(address.Id).Zip_code__c != address.Zip_code__c){
                zipCodes.add(address.Zip_Code__c);
            }  
            // Concatenate the values of Street and Zip_Code fields and store it in the
            // Unique_Key__c field upon address insertion.
            if((address.Street__c != null && address.Zip_Code__c != null) && (Trigger.oldMap.get(address.id).Street__c != address.Street__c  || Trigger.oldMap.get(address.id).Zip_Code__c != address.Zip_Code__c )){
                address.Unique_Key__c = address.Street__c + ':' +address.Zip_Code__c;
                if(!addressUniqueKeys.contains(address.Unique_Key__c)){
                    addressUniqueKeys.add(address.Unique_Key__c);
                }
                else{
                    address.addError('Same address found in the incoming address records');
                }
            }
        } 
        // Update the property name if the address name has changed 
        if(Trigger.isAfter && Trigger.isUpdate){
            if(Trigger.oldmap.get(address.Id).Name != address.Name){
                addressMap.put(address.Id,address);
            }
        }
    }
    /*
    if(addressMap.size() > 0){
        AddressTriggerHandler.updatePropertyName(addressMap);
    }*/
    // Check for the duplicate address
    if(addressUniqueKeys.size() > 0){
        AddressTriggerHandler.duplicateAddressValidation(addressUniqueKeys,Trigger.New);
    }
    /* update the Branch,MSA and Region Code based on the Zip code value
    if(zipCodes.size() > 0){
        AddressTriggerHandler.updateRelatedBranch(zipCodes,Trigger.New);
    }*/
}