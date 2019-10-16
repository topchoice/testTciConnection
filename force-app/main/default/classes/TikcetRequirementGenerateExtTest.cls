/**************************************************************************************************
 * Name: RequirementGenerateExtTest
 * Covered Class: RequirementGenerateExt
 * Covered Trigger: N / A
 * Author: Allen Zhang
 * Create Date: 2012-06-06
 * Modify History: 
 * 
***************************************************************************************************/
@isTest
private class TikcetRequirementGenerateExtTest{

    static testMethod void TestGenerateRequirement() {
        Release__c re = new Release__c(Name = 'Olive', Release_Date__c = system.today());
        insert re;

        Iteration__c it = new Iteration__c(Release__c = re.Id,
                                           Start_Date__c = system.today(),
                                           End_Date__c = system.today() + 10);
        insert it;

        Ticket__c t = new Ticket__c(Severity__c = 'High',
                                    Status__c = 'New',
                                    Capture_Date__c = system.today(),
                                    Summary__c = 'Subject',
                                    Description__c = 'Description',
                                    Iteration__c = it.Id);
        insert t;

        // Initalizes controller
        ApexPages.StandardController con = new ApexPages.StandardController(t);
        TicketRequirementGenerateExt ext = new TicketRequirementGenerateExt(con);

        // Sets GenerateRequirement as current page
        PageReference pageRef = Page.TicketRequirementGenerate;
        Test.setCurrentPage(pageRef);
        ext.generateRequirement();

        // Ensures the ticket subject and description was inserts into the requirement
        system.assertEquals('Closed', [select Status__c from Ticket__c where Id =: t.Id][0].Status__c);
        system.assertEquals('Requirement Generated', [select Resolution__c from Ticket__c where Id =: t.Id][0].Resolution__c);
    }
}