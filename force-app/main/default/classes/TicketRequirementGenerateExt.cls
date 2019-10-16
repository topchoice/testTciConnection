/**************************************************************************************************
 * Name: TicketRequirementGenerateExt
 * Object: Ticket (Ticket__c)
 * Purpose: Copy the subject and description from ticket to requirement, then update ticket status as "Closed"
 *          and Resolution as Requirement Generated
 * Author: Allen Zhang
 * Create Date: 2012-05-23
 * Modify History: 
 * Allen   2012-07-12    Adds field level permission check before DML
***************************************************************************************************/
public with sharing class TicketRequirementGenerateExt {

    public Ticket__c ticket { get; set; }

    // Constructor, gets current ticket record
    public TicketRequirementGenerateExt (ApexPages.StandardController controller) {
        ticket = [select Id, Name, Iteration__c, Summary__c, Description__c, Status__c, Resolution__c
                  from Ticket__c 
                  where Id=: controller.getId()];

    }

    public PageReference generateRequirement () {

        // Checks if the user has create access on the each fields
        String[] requirementCreatFields = new String[]{'Subject__c', 'Iteration__c', 'Description__c'};

        // Obtains the field name/token map for the requirement object
        Map<String, Schema.Sobjectfield> requirementFieldMap = Schema.Sobjecttype.Requirement__c.fields.getMap();

        for (String fieldToCheck : requirementCreatFields) {
            if(!requirementFieldMap.get(fieldToCheck).getDescribe().isCreateable()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient Access' + 
                                     requirementFieldMap.get(fieldToCheck).getDescribe().getLabel()));
                return null;
            }
        }

        // Ticket fields that will be updated
        String[] ticketUpdateFields = new String[]{'Status__c', 'Resolution__c'};

        // Obtains the field name/token map for the ticket object
        Map<String, Schema.Sobjectfield> ticketFieldMap = Schema.Sobjecttype.Ticket__c.fields.getMap();
        for (String fieldToCheck : ticketUpdateFields){

            // Checks if user has update access on the each field
            if(!ticketFieldMap.get(fieldToCheck).getDescribe().isUpdateable()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient Access' +
                                     ticketFieldMap.get(fieldToCheck).getDescribe().getLabel()));
				return null;
            }
        }

        Requirement__c req = new Requirement__c(Subject__c = ticket.Summary__c,
                                                Iteration__c = ticket.Iteration__c,
                                                Description__c = ticket.Description__c);

        insert req;

        // Updates ticket status to close the ticket
        ticket.Status__c = 'Closed';
        ticket.Resolution__c = 'Requirement Generated';
        update ticket;

        // Return requirement detail page
        PageReference pageRef = new PageReference('/' + req.Id);

        return pageRef.setRedirect(true);
    }
}