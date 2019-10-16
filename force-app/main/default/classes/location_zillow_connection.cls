public virtual class location_zillow_connection {
	/* custom exception methods */
   // public class ZillowLimitException extends Exception{}
   
     /* class attributes */
   // private Map<ID, Location__c > locationMap = null;

  /* constructor */
  public location_zillow_connection() {}
  
  /* main method to get zillow record */  
  public void identifyHomeValues(List <Id> locationIds) {
    System.debug(LoggingLevel.DEBUG, '***********  zillow_connection.identifyHomeValues START');
      System.debug(LoggingLevel.DEBUG, '***********  received ' + locationIds.size() + ' records to process: ' + locationIds);
      List<Location__c> aLocationList = new List<Location__c>();  
      List<Location__c> locations = [SELECT Id, City__c, Address__c, State__c, Zip__c 
        FROM Location__c
        where Id in: locationIds];
      System.debug(LoggingLevel.DEBUG, '***********  locations ' + locations.size() + ' locations found: ' + locationIds);  
      for (Location__c aLocation: locations) {
        System.debug(LoggingLevel.DEBUG, '***********  Starting the call to zillow for each Location.');
        
        ZillowService p = new ZillowService();
        ZillowTypes.PropertySearchResponse r = null;
        try {   
          if ((aLocation.Zip__c == null) || (aLocation.Zip__c.trim().length() == 0)) {
          r = p.searchZillow( aLocation.Address__c, aLocation.City__c, aLocation.State__c) ;
          }
          else {
            r = p.searchZillow( aLocation.Address__c, aLocation.City__c, aLocation.State__c, aLocation.Zip__c) ;
          }
          if (r != null) {
          aLocation.Home_Value__c = r.getZEstimateAmount() ;
          aLocationList.add(aLocation) ;
          }     
        }
        catch (ZillowTypes.ZillowException e) {
          //Error in Zillow response - code = 508 Description : null means address  not found
          aLocation.Home_Value__c = 0;
          aLocationList.add(aLocation) ;
        }   
      }
      if (aLocationList.size() > 0) {
        upsert aLocationList;
      }
      System.debug(LoggingLevel.DEBUG, '***********  zillow_connection.identifyHomeValues END');
  }
}