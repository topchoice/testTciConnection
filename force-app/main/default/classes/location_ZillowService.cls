public with sharing class location_ZillowService {
	public static void InitIncompleteAddress(list<Location__c> newRecs) {
    System.debug(LoggingLevel.DEBUG, '***********  blogic_ZillowService.InitIncompleteAddress START');
    for (Location__c aLocation : newRecs) {
    if (((aLocation.Address__c == null) || (aLocation.Address__c.trim().length() == 0)) ||
          ((aLocation.City__c == null) || (aLocation.City__c.trim().length() == 0)) ||
          ((aLocation.State__c == null) || (aLocation.State__c.trim().length() == 0))) {
          System.debug(LoggingLevel.DEBUG, '***********  Incomplete Address for company: '+ aLocation.Address__c);
          aLocation.Home_Value__c = 0.00;
        }
    }
      System.debug(LoggingLevel.DEBUG, '***********  blogic_ZillowService.InitIncompleteAddress START');
  }
    
  public static void HomeValue(list<Location__c> oldRecs, list<Location__c> newRecs) {
    System.debug(LoggingLevel.DEBUG, '***********  blogic_ZillowService.HomeValue START');
     
    List<Id> locationIds = new List<Id>();
    if (oldRecs == null) {
      for (integer cnt=0; cnt < newRecs.size(); cnt++) {
        if (hasAllFields(newRecs[cnt])) { 
          locationIds.add(newRecs[cnt].Id);
        }
      }
    }
    else { // test if an address has changed if old was null then update address, test was already made that new not null
      for (integer cnt=0; cnt < newRecs.size(); cnt++) {
        boolean doZillow = false;  
        System.debug(LoggingLevel.DEBUG, '***********  blogic_ZillowService.HomeValue Initial doZillow: ' + doZillow);
        if (hasAllFields(newRecs[cnt])) { 
          if (((oldRecs[cnt].Address__c == null) || (oldRecs[cnt].Address__c.trim().length() == 0)) || (oldRecs[cnt].Address__c != newRecs[cnt].Address__c)) {
            doZillow = true;
          }
          System.debug(LoggingLevel.DEBUG, '***********  blogic_ZillowService.HomeValue After Address__c doZillow: ' + doZillow);
        
            if (doZillow == false) {
               
              if (((oldRecs[cnt].City__c == null) || (oldRecs[cnt].City__c.trim().length() == 0)) || (oldRecs[cnt].City__c != newRecs[cnt].City__c)) {
              doZillow = true;
            }
            }  
            System.debug(LoggingLevel.DEBUG, '***********  blogic_ZillowService.HomeValue After City__c doZillow: ' + doZillow);
        
            if (doZillow == false) {
   
              if (((oldRecs[cnt].State__c == null) || (oldRecs[cnt].State__c.trim().length() == 0)) || (oldRecs[cnt].State__c != newRecs[cnt].State__c)) {
              doZillow = true;
            }
            }  
            System.debug(LoggingLevel.DEBUG, '***********  blogic_ZillowService.HomeValue After State__c doZillow: ' + doZillow);
        
            if (doZillow == true) {
            locationIds.add(newRecs[cnt].Id);
          }
        }
        
      }
    }
     
    if (locationIds.size() > 0) {
      location_future_Zillow.ZillowValue(locationIds); 
    }
    System.debug(LoggingLevel.DEBUG, '***********  blogic_ZillowService.HomeValue END');
 
  }
  
  private static Boolean hasAllFields(Location__c aLocation) {
    Boolean result = true;
    // don't send incomplete addresses to Zillow
        if (((aLocation.Address__c == null) || (aLocation.Address__c.trim().length() == 0)) ||
          ((aLocation.City__c == null) || (aLocation.City__c.trim().length() == 0)) ||
          ((aLocation.State__c == null) || (aLocation.State__c.trim().length() == 0))) {
          System.debug(LoggingLevel.DEBUG, '***********  Incomplete Address for company: '+ aLocation.Address__c);
          result = false;
        }
      return result;
  }
}