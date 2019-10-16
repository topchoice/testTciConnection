public with sharing class stackExchangeAPI {
    public static String BASE_URL = 'https://api.stackexchange.com/2.2/';

    //Method to perform a callout and return an httpResponse
    Public static httpResponse callout(String httpMethod, String endpoint, String body){

    //Instantiate an httpRequest and set the required attributes
    httpRequest req = new httpRequest();
    
    //Set the http verb being used (REQUIRED) (GET, POST, PUT, DELETE, HEAD, TRACE)
    req.setMethod(httpMethod);
    
    //Set the URI of the 3rd party service (REQUIRED)
    req.setEndpoint(endpoint);
    
    //Set the body of the message (OPTIONAL)
    if(String.isNotBlank(body) ){
        req.setBody(body);
        req.setHeader('Content-Length', string.valueOf(body.length()));
    }
    
    //You can set the timeout duration (in milliseconds) to deal with the slow servers or large payloads
    req.setTimeout(120000);

    //Attributes are often required to conform to the 3rd party Web Service Requirements (OPTIONAL)
    req.setHeader('Accept-Endcoding','gzip, deflate');

    //Tell Apex to compress the body prior to delivery (OPTIONAL)
    req.setCompressed(true);

    //Use the HTTP Class to send the httpRequest and receive an httpResponse
    /*If you are not using an HttpCalloutMock:
    if(!test.isRunningTest){
    */
    httpResponse res = new http().send(req);
    /*if you are not using an HttpCalloutMock:
    }
    */
    system.debug(res.toString());
    system.debug(res.getBody());
    return res;
    }
}