/**********************************
Name        : EmailToLeadService
Created By  : cBates (Top Choice Insurance Agency, LLC)
Created Date: 10/18/2019
Description : Email Service to Create Lead when an email is recieved
Modification: N/A
***********************************/
global class EmailToLeadService Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
		
        // Create an InboundEmailResult object for returning the result of the  
        // Apex Email Service
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

        String myPlainText= '';

        // Add the email plain text into the local variable  
        myPlainText = email.plainTextBody;

        // Check for existing leads with this email address
        Lead leads = [SELECT Id, Name, Email FROM Lead WHERE Email = :email.fromAddress];

        if (leads.size() == 0) {
      
        String emailDomain = envelope.fromAddress.substring(envelope.fromAddress.indexOf('@')+1);
        // New Lead object to be created - set LastName and Company
        Lead newLead = new Lead(Email = email.fromAddress, 
            LastName = email.fromname.substring(0,email.fromname), 
            Company = emailDomain.substring(0,emailDomain));

        // Insert a new lead
        insert newLead;

        System.debug('New Lead record: ' + newLead );   
        } else {
        System.debug('Incoming email duplicates existing Lead record(s): ' + leads );    
        }

        // Set the result to true. No need to send an email back to the user      
        // with an error message   
        result.success = false;

        // Return the result for the Apex Email Service

        return result;
    }
}