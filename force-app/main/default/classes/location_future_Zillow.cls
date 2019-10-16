global class location_future_Zillow {
	@future (callout=true)
 	public static void ZillowValue(List<Id> locationIds) {
    	System.debug(LoggingLevel.DEBUG, '***********  future_Zillow.ZillowValue START');
    	// declare local vars
    	zillow_connection zillow  = new zillow_connection();
    
    	//  Make Query
    	zillow.identifyHomeValues(locationIds);
    	System.debug(LoggingLevel.DEBUG, '***********  future_Zillow.ZillowValue End');
  	}
}